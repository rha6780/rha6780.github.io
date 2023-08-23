---
title: "rest-framework method 정리"
date: 2022-02-06

categories:
  - python
tags:
  - python
  - django
---

## REST API 메소드 정리

<br>

[참고 : REST API 제대로 알고 사용하기 : NHN Cloud Meetup](https://meetup.toast.com/posts/92)

<br>

REST API 란, 자원의 정보를 이름과 함께 구분해서 해당 자원의 상태를 주고 받는 방식의 API 를 말한다. 즉, rest api에서 url은 HTTP_METHOD에 대한 정보는 따로 기제하지 않고, 자원의 대한 정보만 적는다.

<br>

해당하는 method는 아래와 같다. 이런 HTTP_METHOD를 기존 데이터 베이스의 CRUD와 매칭하여 정보를 관리하는게 REST 의 기본이 된다.

<br>

**C**reate : 데이터 생성 (POST)

**R**ead : 데이터 검색(읽기) (GET)

**U**pdate : 데이터 수정 (PUT, PATCH)

**D**elete : 데이터 삭제 (DELETE)

<br>

- URL 구성
    
    해당하는 메소드에 대해서 url은 다음과 같이 구성된다. delete라는 자원과 상관없는 것이 적혀있기 때문.
    
    ```html
    올바른 예 : "posts/<int:post_id>/comments/<int:comment_id>"
    틀린 예 : "posts/<int:post_id>/comments/<int:comment_id>/delete"
    ```
    
    반면, 장고에서 화면을 보여주는(html 뷰) url의 경우는 뒤에 해당 단어를 적는다. 화면을 보여주는 것은 REST 와 관계없음.
    
    ```html
    posts/<int:post_id>/comments/<int:comment_id>/edit
    ```
    
    > "? 화면을 보여주는 거랑 api랑 다른 거임?"
    
    <br>

    화면을 보여주는 요청은 기존 rest_api 와 다르고, 프론트 쪽에 더 가깝다. 벡엔드를 구성하는 입장에서 viewset, router 등 유용하게 사용할 수 있는 것도 많이 있으니 벡엔드를 중심으로 한다면 위 처럼 자원에 중심을 둔 url을 작성하자.

    <br><br>

- 필요성
    
     REST 를 쓰는 이유는 플랫폼의 다양성에 따라서 정보를 제공하는 편리성이 크기 때문이다. 
     
     <br>
    
    일반적인 웹 뿐만 아니라, 안드로이드 등 모바일 기기와 통신을 하기위해 자원을 어떤 방식으로 보낼 것인가 에 대한 방식이 중요해지고 REST 방식으로 이를 해결하게 되었다.

<br>
<br>

### Put vs Patch 의 차이

<br>

put과 patch는 기능적으로 수정이라는 점에서 공통점을 가지고 있지만, 인자에 따른 수정이 조금 다르다.

<br>

PUT의 경우 인자를 다 적지 않으면 default 값으로 지정된다. Patch의 경우, 다른 인자를 다 적지 않아도 입력한 인자의 값만 수정된다.

<br>

따라서 모델 뷰 셋에서 update, particial_update에 대해 각각 put, patch로 매칭된다. 특정 일부만 바꾸는 경우는 Patch를 전체를 초기화해서 다시 쓰는 경우 Put을 쓰는것이 좋아보인다.

<br>

**참고 (해당 링크의 restful url도 보면 좋다.)**

[[REST API] REST API 규칙/PUT과 POST 차이/PUT과 PATCH 차이](https://devuna.tistory.com/77)

<br>
<br>