---
title: "회원가입 관련 처리"
date: 2023-04-14

categories:
  - developer_discovery
tags:
  - developer_discovery
---


### 회원가입

![Screen Shot 2023-04-15 at 8 09 19 PM](https://user-images.githubusercontent.com/47859845/232233828-6f68103b-1290-4f7c-b5d6-7dddb97546e2.png)

간단히 위와 같이 페이지를 구성해두고…. form에 action에 api 주소로 보내도록 일단 작성하였다. api 작성 전 유저 모델에 대해서 조금 고민을 하게 되었다.

<br>

**AbstractBaseUser vs AbstractUser**

처음에는 모델을 AbstractBaseUser 로 두어서 USERNAME_FIELD=”email” 로 두어서 회원가입을 임의로 돌렸을 때, 잘 돌아갔다. 하지만, 굳이 이메일로 적용하지 않아도 될 것 같아서 AbstractUser 로 다시 설정해두었다. 이 두가지의 차이는 기본적으로 제공되는 User 모델에 필드만 추가해서 사용하는 경우와 기본 모델에서 몇가지 수정하는 경우로 나뉜다. AbstractBaseUser 의 경우 유저를 식별하는 username 대신 email이나 다른 값을 지정할 수 있다. AbstractUser 로 두면 기본 모델에 몇가지 필드를 추가해서 사용한다.


![Screen Shot 2023-04-15 at 7 53 04 PM](https://user-images.githubusercontent.com/47859845/232233827-f54dc121-3705-4d6e-90d7-9dc05ef9450f.png)

<br>

**AbstractBaseUser 를 이용하는 경우..**

일단 User 모델을 AbstractBaseUser 를 상속하는데.. 여러 이슈가 있었다. 해당 모델을 상속하는 경우, 몇가지 설정해주어야 하는 부분이 있다. 하나는 USERNAME_FIELD 이다. 해당 필드는 username이라는 필드 대신 우리가 정의한 필드로 설정하는 부분이다. 그리고 슈퍼유저(어드민)을 추가하기 위해서는 is_staff 와 is_admin 필드가 필요하다. 또한, Manager 부분에서 REQUIRED_FIELDS 에 따라 메소드 오버라이드를 해주어야 할 수 있다. 자세한 사항은 아래를 참고하자.

<br>

**이슈 관련 참고 자료**  
[AttributeError: type object 'User' has no attribute 'USERNAME_FIELD' - Google Search](https://www.google.com/search?q=AttributeError:+type+object+'User'+has+no+attribute+'USERNAME_FIELD'&oq=AttributeError:+type+object+'User'+has+no+attribute+'USERNAME_FIELD'&aqs=chrome..69i57j69i58.458j0j7&sourceid=chrome&ie=UTF-8)

[Django](https://docs.djangoproject.com/ko/2.1/topics/auth/customizing/)

[django - username에 verbose_name 적용하기](https://kimdoky.github.io/django/2018/11/26/django-username-verbose/)


<br>

뭔가 이런 이슈를 해결하고 다시 보니까 기존 모델을 사용해도 괜찮을 것 같아서 다시 AbstractUser로 롤백해서 적용해두었다. 그리고 회원가입 API를 generics.CreateAPIView 로 간단히 만들어 두었는데 현재 잘 작동한다…! 문제는 브라우저에서 password가 보인다는 점이다…

![Screen Shot 2023-04-15 at 7 45 32 PM](https://user-images.githubusercontent.com/47859845/232233825-ff49a95c-e5ab-4587-a8f0-706117148ba8.png)

개인적으로 느끼는 점은… 프론트도 쉽지 않다는 점이다… 일단 DB에 유저 정보가 잘 담기는 상태이고, 본격적으로 회원가입 시 로그인 되도록 하고 홈으로 리다이렉트 하도록 해야하고, 로그인 API도 구성해야한다.



<br>

**회원가입 후 리다이렉트**

위에서 이야기한 것처럼 action에다 api 주소를 작성해서 값을 넘겨주었는데, action에다가 바로 적으면 성공, 실패 여부에 상관없이 작성한 주소로 이동한다. 그렇기 때문에 onSubmit에다가 리다이렉트 및 api 처리를 한 함수를 연결지어야 한다. [공식문서](https://nextjs.org/docs/guides/building-forms)를 참고해서 작성을 했는데… 어라? 🤔


![Screen Shot 2023-04-15 at 9 13 06 PM](https://user-images.githubusercontent.com/47859845/232233830-e4c3e18a-e0cc-470b-a225-b545203d71c3.png)

![Screen Shot 2023-04-15 at 9 14 46 PM](https://user-images.githubusercontent.com/47859845/232233833-03e14fd1-39d9-41fc-b18e-8039acd6c145.png)

아까와 달리 payload에 값이 있는데도 required 하다고 나온다. generics 에서 처리할 때 serializers가 is_valid 한지 체크하고 perform_create 하기 때문에 invalid 하다고 나온 것 같다.

![Screen Shot 2023-04-15 at 9 30 32 PM](https://user-images.githubusercontent.com/47859845/232233835-b4261d81-a6b3-4757-b349-76129cbbade6.png)


user로 감싸지 않고 바로 보내도록 수정하는 방식으로 진행하여서 성공했다…! `is_valid`를 수정할수도 있는데, 이것 대신 페이로드 형식을 간단하게 변경하는 것이 더 좋아보였다. user 라는 값이 있으면 페이로드 읽기에 좋을 것 같지만, 이미 코드상에서 위치나 `UserSignUpPayload`라고 정의하고 있어서 제거해도 괜찮다고 생각하고, 페이로드 데이터 값이 커지기 때문에 제거하는 방향으로 수정했다.


<br>

![Screen Shot 2023-04-15 at 9 36 33 PM](https://user-images.githubusercontent.com/47859845/232233836-d683cff5-7562-4948-92ac-574ec8cc5fb3.png)

최종적으로 몇가지 디자인을 수정하고 다음과 같이 페이지가 완성된다. 성공적으로 회원가입시 alert가 나오고 ok를 누르면 홈 화면으로 이동한다. 이제 이 페이지에서 할 것은… 비밀번호와 비밀번호 재확인이 같은지 체크하는 로직과 아이디가 unique 해야하기 때문에 이미 있는 경우를 체크하는 부분이다. 그 외 몇가지 디자인을 추가적으로 진행할 예정이다. (ex: 최소 8자 영문 포함 등)

![Screen Shot 2023-04-15 at 11 21 55 PM](https://user-images.githubusercontent.com/47859845/232233837-8713ca51-e7ea-4dfe-aef6-cb1c0075d17a.png)

![Screen Shot 2023-04-15 at 11 22 35 PM](https://user-images.githubusercontent.com/47859845/232233838-95f2a53c-c983-4b00-a617-a8e626348cec.png)


<br>

### +추가) 영상 관련 업데이트…는 어떻게?

추가로 강의 영상 관련된 모델을 간단히 작성하였다. 간단히 Video List api (DB에 있는 영상 관련 데이터를 전달해주는 api)를 구성한 상태이고 이를 확인하기 위해서는 데이터가 있어야 하는데, 처음에는 유튜브의 특정 키워드에 해당하는 영상을 DB에 업데이트 하는 크론을 돌릴까 고민을 했지만, 개인 프로젝트 특성상 수 많은 영상을 저장하기에는 무리가 있어서 해당 영상을 운영자(개발자)가 업데이트 시키는 것이 아니라, 웹 페이지 내부 기능으로 지원한다. 일단 아래와 같이 generics view 로 간단히 구현해둔다.


![Screen Shot 2023-04-14 at 9 51 55 PM](https://user-images.githubusercontent.com/47859845/232233823-8db25647-7cfb-4c8d-af9a-ec16c5cfc286.png)

<br>

어드민에서 데이터를 추가했을 때 아래와 같이 나온다. 쿼리를 우선 `Video.objects.all()`로 지정한 상태이고, 해당 값을 페이지네이션 해두었다.

![Screen Shot 2023-04-14 at 9 51 07 PM](https://user-images.githubusercontent.com/47859845/232234704-08de8ae2-72c9-4477-8880-976467565166.png)


이 부분을 먼저 진행했지만, 우선 로그인 부분부터 해결을 해야했다. 회원가입 처리가 다 끝나면 로그인, 이후 이부분을 진행할 것 같다.



<br><br>
