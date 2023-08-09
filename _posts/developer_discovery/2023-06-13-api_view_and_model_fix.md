---
title: "Post 모델, API 수정에 대하여"
date: 2023-06-13
# toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - developer_discovery
tags:
  - developer_discovery
---

# Django 모델 및 API 리빌딩


### Django 모델 변경

프로젝트를 하면서 뭔가 진전이 없는 듯한 느낌을 받았다. Video 라는 모델이 원래 있었고 해당 모델에서는 사용자가 유튜브 링크 등과 그에 대한 글을 작성하는 기능을 하는 것이 었는데, 작성하다보니 일반 글 (post)와 비슷한 성질을 가지고 있어 2번 일하는 기분이 들었다.

<br>

또한, Video 의 기능… 영상을 공유한다는 것이 큰 메리트도 없고, 일반 글에도 첨부할 수 있게 해두면 될 것 같아서 Posts라는 모델로만 작성하게 되었다. 그래서 최종적으로 아래와 같은 구조를 가지게 된다.

<img width="100%" alt="Developer_Discovery_ERD" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/9e50694b-e13f-4791-88d2-96e575f0bafd">


아직은 작성글에 tag 나 카테고리가 없는데 이는 추후 개발하는 것으로 하고, 일단 글에 해당하는 관련 모델만 추가할 예정이다.

<br>

이것과 관련해서 우선적으로 ListAPI 를 작성하게 되었는데…. 작성하면서 여러가지 메모한 것들을 정리하면 다음과 같다.

### Post List API

**ForeignKey 로 연결된 객체에서 다른 필드 가져오기.**

위에서 Posts 모델은 user_id 라는 외래키를 가진다. 여기서 우리가 실제 화면에 보여줄 것은 user_id가 아닌 작성자의 이름이기 때문에 user_id를 통한 User 객체의 이름을 가져와야하는 문제이다.

[🔗 Retrieving a Foreign Key value with django-rest-framework serializers](https://stackoverflow.com/questions/17280007/retrieving-a-foreign-key-value-with-django-rest-framework-serializers)

처음에는 RelatedField를 이용해서 가져와야지 생각했는데 아무리해도 name이 전달되지 않았다. 일단 ReadOnlyField를 이용 했더니 성공적으로 반환된다.

<br>

🤔 둘의 차이는 무엇일까?

[🔗 Serializer relations - Django REST framework](https://www.django-rest-framework.org/api-guide/relations/)

<br>

**RelatedField 는?**

RelatedField의 경우, `to_representation` 라는 메소드를 정의해야 사용할 수 있다. 해당 메소드가 필요한 이유는 해당 문서에도 잘 나타나 있는데… 위 예시를 잠깐 설명하면 다음과 같다.

<br>

User 모델의 id는 Post, Comment 등에서 사용된다. 이 경우 RelatedField를 사용하려면 Post 객체일때 어떻게 반환할지, Comment일때 어떻게 반환할지 작성을 해두어야 잘못된 값이 노출되지 않게 되는 것이다. 따라서 RelatedField를 사용하려면 다음과 같이 작성해야한다.

```python
from rest_framework import serializers

from ....model.posts.models import Post
from ....model.users.models import User
from ..users.serializers import CurrentUserSerializer

class UserRelatedField(serializers.RelatedField):
    def to_representation(self, value):
        if isinstance(value, User):
            serializer = CurrentUserSerializer(value)
        else:
            raise Exception('Unexpected type of user object')
        return serializer.data

class PostListSerializer(serializers.ModelSerializer):
    user_name = UserRelatedField(source="user", read_only=True)

    class Meta:
        model = Post
        fields = ("id", "title", "content", "thumbnail", "user_name")
```

이렇게 하면 user_name에 CurrentUserSerializer 내용이 들어가는 형식으로 되어있다.


<img width="317" alt="RelatedField" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/ed3b2589-f9a7-4554-a999-b2447c0d91b4">

<br>

**ReadOnlyField 는?**

[🔗 Serializer fields - Django REST framework](https://www.django-rest-framework.org/api-guide/fields/#readonlyfield)

ReadOnlyField는 말그대로 읽기 전용이다. 필드를 참조할때 수정 등을 방지하기 위해 작성된 것으로 source에 작성한 값 그대로 반환한다.

<img width="100%" alt="ReadOnlyField" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/6f63ddb0-73c4-4299-b843-f5ae477eec8a">


따라서 아래와 같이 작성할 수 있다.

```python
user_name = serializers.ReadOnlyField(source="user.name")
```

그렇다면 **RelatedField 과 ReadOnlyField** 중 뭘 사용하면 좋을까…? ReadOnlyField의 경우 별도 메소드를 사용하지 않아도 되지만, 필요한 필드를 일일히 작성해야한다. 하지만, RelatedField의 경우 재정의를 통해서 여러 필드를 관리할 수 있기 때문에 API에 필드가 몇개인지 수정이 필요한지 등에 따라서 맞는 것을 사용하면 될 것 같다.

<br>

내 경우 추후 작성자의 이름 등을 클릭하면 해당 작성자의 프로필로 이동하기 위해 id 도 필요하다. 우선 RelatedField를 이용하고 문제가 있다면 변경할 예정이다.

### API 구현 방법에 대한 고찰

<img width="540" alt="Views" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/786d65a7-eaf3-4fed-9d36-f19c7b742bbe">

PostListAPI의 경우 generic.views에 있는 ListAPIView를 이용했는데 생각해보니 ViewSet을 이용하면 되지 않을까 생각하게 되었다. View를 구현함에 있어 class-based 에는 3가지 방식이 있다.

- APIView
- generic.views
- Viewset

APIView의 경우 가장 기초가 되는 클래스로 상속을 통해 rest api를 구성할 수 있다. 구현방식은 APIView를 상속 받은 위 http 메소드를 이름으로 가진 함수를 작성하면 된다. (ex: def post, def get 등)

generic.views 를 이용한다면, 각각 기능에 맞는 클래스를 상속받은 뒤 queryset, model, 등 필요한 값만 정의하면 해당 값에 맞게 API가 구성된다. 

<br>

Viewset의 경우 해당 객체에 필요한 모든 list, create, update, delete 등 을 생성하는 장점이 있다. 하지만 세부적인 로직을 구현하기에는 어렵다는 단점이 있다.

<br>

개인적으로 generic.views를 통합한게 Viewset과 같기 때문에 generic을 많이 쓰는 것보다 Viewset을 사용하는 것이 url 관리에도 좋고 빠르게 설정할 수 있는 장점이 있다고 생각한다. Viewset이 일반적인 API에 대한 것이고 필요한 경우 APIView를 사용한 것이 좋다고 생각이 든다.

Viewset을 이용한다고 해도 get_serializer_class, get_permissions 등 필요한 값을 오버라이딩을 통해 변경할 수 있으니 유의하자.

<br>

### **마무리**

개발하면서 어려운 점은 어떤 결과를 목표로 구현할때 여러 방법이 있다는 것인데, 어떤걸 쓰면 좋은지 비교하면서 진행하는 것이 좋겠다고 생각한다.

<br>
<br>