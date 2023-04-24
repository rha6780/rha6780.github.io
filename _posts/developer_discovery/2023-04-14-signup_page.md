---
title: "유저 회원가입, 로그인"
date: 2023-04-14

categories:
  - developer_discovery
tags:
  - developer_discovery
---


서비스의 시작을 위해서는 우선 유저 테이블과 회원가입, 로그인 기능이 필요하다. 유저 테이블 부터 구성해야하는데… Django에서는 기초로 제공하는 클래스가 있어 이것을 상속해서 사용하면 시간을 절약하면 된다. 아래와 같이 2가지 클래스가 있는데… 각각 차이점을 알아가자.

<br>

**AbstractBaseUser vs AbstractUser**

처음에는 모델을 AbstractBaseUser 로 두어서 `USERNAME_FIELD=”email”` 로 회원가입을 임의로 돌렸을 때, 잘 돌아갔다. 하지만, 굳이 이메일로 적용하지 않아도 될 것 같아서 AbstractUser 로 다시 설정해두었다. AbstractUser는 기본적으로 제공되는 User 모델에 필드만 추가해서 사용하는 경우에 사용한다. AbstractBaseUser 기본 모델에서 몇가지 수정해서 사용한다.

<br>

**AbstractBaseUser 를 이용하는 경우..마주친 에러들!**

일단 User 모델을 AbstractBaseUser 를 상속하는데.. 여러 이슈가 있었다. 해당 모델을 상속하는 경우, 몇가지 설정해주어야 하는 부분이 있다. 하나는 USERNAME_FIELD 이다. 해당 필드는 username이라는 필드 대신 우리가 정의한 필드로 설정하는 부분이다. 그리고 슈퍼유저(어드민)을 추가하기 위해서는 is_staff 와 is_admin 필드가 필요하다. 또한, Manager 부분에서 REQUIRED_FIELDS 에 따라 오버라이드를 해주어야 할 수 있다.

[AttributeError: type object 'User' has no attribute 'USERNAME_FIELD' - Google Search](https://www.google.com/search?q=AttributeError:+type+object+'User'+has+no+attribute+'USERNAME_FIELD'&oq=AttributeError:+type+object+'User'+has+no+attribute+'USERNAME_FIELD'&aqs=chrome..69i57j69i58.458j0j7&sourceid=chrome&ie=UTF-8)

[Django](https://docs.djangoproject.com/ko/2.1/topics/auth/customizing/)

[django - username에 verbose_name 적용하기](https://kimdoky.github.io/django/2018/11/26/django-username-verbose/)

AbstractBaseUser 를 둘까 하다가 기존 모델을 사용해도 괜찮을 것 같아서 다시 롤백해서 적용해두었다. 그리고 회원가입 API를 generics.CreateAPIView 로 간단히 만들어 두었는데 현재 잘 작동한다…! 문제는 브라우저에서 password가 보인다는 점이다…(추후 클라이언트 쪽에서 수정해야겠다.)

![Screen Shot 2023-04-15 at 7 45 32 PM](https://user-images.githubusercontent.com/47859845/232233825-ff49a95c-e5ab-4587-a8f0-706117148ba8.png)

<br>

아무튼 최종적으로 아래와 같은 테이블이 구성된다. first_name, last_name 등은 필요가 없지만, 추후 다시AbstractBaseUser 로 구성해서 제거할지 고민이다. 나중에 추가될 비밀번호 찾기 등에서 이메일이 필요할 것 같은데, 별도로 username을 두지 않고, email로 통합해두면 좋지 않을까 생각된다. 또는 이 구조에서 가입 이후 인증 여부에 대한 필드를 추가해야할 수도 있을 것 같다.

![Screen Shot 2023-04-24 at 1 51 10 PM](https://user-images.githubusercontent.com/47859845/233910046-01a44f12-a1a1-4dd8-9ebc-1a62dde54cf1.png)

우선 프로젝트 초반이니깐 간단히 구조를 잡고 추후 기능에 따라 변경하는 것으로 목표를 잡았다.

<br>

### 회원가입

간단히 아래와 같이 페이지를 구성해두고…. form에 action으로 api 로 보내도록 일단 작성하였다.

![Screen Shot 2023-04-15 at 8 09 19 PM](https://user-images.githubusercontent.com/47859845/232233828-6f68103b-1290-4f7c-b5d6-7dddb97546e2.png)

<br>

**회원가입 시 오류**

위 페이지에서 간단히 값을 넣어서 회원가입을 하면… (클라이언트 코드는 해당 [링크](https://nextjs.org/docs/guides/building-forms)를 참고함)

![Screen Shot 2023-04-15 at 9 13 06 PM](https://user-images.githubusercontent.com/47859845/232233830-e4c3e18a-e0cc-470b-a225-b545203d71c3.png)

![Screen Shot 2023-04-15 at 9 14 46 PM](https://user-images.githubusercontent.com/47859845/232233833-03e14fd1-39d9-41fc-b18e-8039acd6c145.png)


아까와 달리 payload에 값이 있는데도 required 하다고 나온다. generics 에서 처리할 때 serializers가 is_valid 한지 체크하고 perform_create 하는 과정인데, 값이 invalid 하다고 판단해서 오류가 나오는 것 같다.

![Screen Shot 2023-04-15 at 9 30 32 PM](https://user-images.githubusercontent.com/47859845/232233835-b4261d81-a6b3-4757-b349-76129cbbade6.png)

<br>

다시보니 파라미터가 user로 감싸서 오류가 나오는 것 같다. 수정해서 다시 시도하니 성공했다…! `is_valid`를 수정할수도 있는데, 이것 대신 페이로드 형식을 간단하게 변경하는 것이 더 좋아보였다. user 라는 값이 있으면 페이로드 읽기에 좋을 것 같지만, 이미 코드상에서 위치나 `UserSignUpPayload`라고 정의하고 있어서 가독성에도 문제가 없을 것 같다.


![Screen Shot 2023-04-15 at 9 36 33 PM](https://user-images.githubusercontent.com/47859845/232233836-d683cff5-7562-4948-92ac-574ec8cc5fb3.png)

<br>

여기까지 View 로직은 아래가 끝이다.

```jsx
def post(self, request):			
	serializer = self.serializer_class(data=request.data)
	
	if serializer.is_valid():
	    user = serializer.save(request=request)
	return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
```

<br>

test를 간단히 작성해주자. 아직 username에 대한 유효성 검사 로직 같은게 없어서 간단히 3가지만 떠올렸다. 정상적으로 회원가입이 되는 경우, 이미 있는 유저 이름으로 회원가입을 하려는 경우, 유효하지 않은(빈 username)으로 회원가입하는 경우로 조금 중복된 내용이 있지만, 간단히 작성하였다.

```jsx
class AccountViewsTestCase(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.client = APIClient()

    def test_valid_data(self):
        valid_data = {"username": "test1", "password": "test-password", "name": "test"}
        response = self.client.post(reverse("sign-up"), valid_data, format="json")
        self.assertEqual(response.status_code, 200)

    def test_exist_user_data(self):
        valid_data = {"username": "test1", "password": "test-password", "name": "test"}
        response = self.client.post(reverse("sign-up"), valid_data, format="json")
        self.assertEqual(response.status_code, 200)
        valid_data = {"username": "test1", "password": "test-password", "name": "test"}
        error_response = self.client.post(reverse("sign-up"), valid_data, format="json")
        self.assertEqual(error_response.status_code, 400)

    def test_invalid_user_data(self):
        invalid_data = {"username": "", "password": "test-password", "name": "test"}
        response = self.client.post(reverse("sign-up"), invalid_data, format="json")
        self.assertEqual(response.status_code, 400)
```

<br>

다른 테스트들과 함께 성공적으로 통과했다.


![Screen Shot 2023-04-24 at 2 05 06 PM](https://user-images.githubusercontent.com/47859845/233910054-8354171c-7531-4aad-83b0-df6fa71a559a.png)
<br>
<br>

**JWT 설정**
![Screen Shot 2023-04-15 at 7 53 04 PM](https://user-images.githubusercontent.com/47859845/232233827-f54dc121-3705-4d6e-90d7-9dc05ef9450f.png)

이제 유저가 DB에 성공적으로 쌓이기 때문에 인증 문제만 해결하면 된다. 로그인, 회원가입 등 유저의 인증을 처리하는 방식으로는 크게 2가지가 있다. 하나는 세션방식이고, 다른 하나는 JWT 방식이다. 사실 고민을 상당히 많이 했다. 세션으로 하면 구현은 엄청 쉬울 것 같은데… JWT도 경험해보고 싶고…

![mark_think](https://user-images.githubusercontent.com/47859845/233910169-54db7eed-ab7b-4156-af8d-956d1750ac00.jpeg)

시스템 상 굳이 JWT는 필요 없다고 생각이 되는데… JWT를 사용했을 때 보안 이슈를 공부할겸 한번 적용해보기로 결정했다. 회사에서 이미 세션 방식으로 서비스되는 것도 경험해봤고, 구현상 이점은 있지만, 추후 서비스 확장(확장 될지는 모르겠지만…)에는 JWT가 좋을 것 같다는 생각이 들었다.

<br>

처음으로 구현하는 것이라서.. 구글에서 여러 코드를 참고한 결과 최종적으로 아래와 같은 코드로 작성했다.

```python
def post(self, request):			
	serializer = self.serializer_class(data=request.data)
	
	if serializer.is_valid():
	    user = serializer.save(request=request)
	    token = TokenObtainPairSerializer.get_token(user)
	    refresh_token = str(token)
	    access_token = str(token.access_token)
	    res = Response(
	        {
	            "user": serializer.data,
	            "message": "user register successs",
	            "token": {
	                "access": access_token,
	                "refresh": refresh_token,
	            },
	        },
	        status=status.HTTP_200_OK,
	    )
	    # res.set_cookie("access", access_token, httponly=True, secure=True)
	    res.set_cookie("refresh", refresh_token, httponly=True, secure=True)
	    return res
	return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
```

여기서 access_token은 주석처리해두었는데, 클라이언트쪽에서 해당 값을 private하게 저장하는 것이 좋다는 정보를 얻었기 때문이다. private하게 저장하는 이유는 토큰 탈취와 관련이 있는데 이것은 이론 쪽에서 따로 정리하겠다. 해당 코드에 대해서는 Django JWT 글의 설명을 참고하자.

<br>

간단히 요약하면 기존 simple-jwt 라이브러리를 이용해서 토큰을 생성하고 response에 각각 값을 넘겨주며, `httponly=True, secure=True` 헤더로 값을 넘기는 것으로 이해하면 된다. 클라이언트에서는 해당 헤더의 값을 토대로 토큰을 저장한다.

<br>

아직 고민 중인 부분은 Response에도 토큰값이 있고, 헤더로도 값을 포함하고 있는데, 뭔가 중복되는 느낌이라는 것이다. 클라이언트에서 헤더로 가져오고 있으니 추후 문제가 없다면 Response에 값을 제거하는 것이 좋을 것 같다. 일단, 기능이 잘 작동하는 것이 중요하기 때문에 최종적으로 로그인 개선 시 다시 소개(정리)를 하도록 하겠다.

<br>

### 로그인

로그인의 경우 회원가입과 마찬가지로 토큰값을 보내준다. 다른점이 있다면 회원가입에서는 serializer에서 valid 하다면 생성하지만, 로그인은 기존 DB에 있는 유저의 정보가 있는지를 체크하는 것이다.

```python
def post(self, request):
	params = request.data
	user = User.objects.filter(username=params["username"]).first()
	
	if user is not None:
	    if not check_password(params["password"], user.password):
	        return Response({ "message": "password invalid" }, status=status.HTTP_400_BAD_REQUEST)
	    serializer = UserSignInSerializer(user)
	    token = TokenObtainPairSerializer.get_token(user)
	    refresh_token = str(token)
	    access_token = str(token.access_token)
	    res = Response(
	        {
	            "user": serializer.data,
	            "message": "login success",
	            "token": {
	                "access": access_token,
	                "refresh": refresh_token,
	            },
	        },
	        status=status.HTTP_200_OK,
	    )
	    res.set_cookie("refresh", refresh_token, httponly=True, secure=True)
	    return res
	return Response({ "message": "user not found" }, status=status.HTTP_400_BAD_REQUEST) 
```

아래 토큰 부분은 에러 메세지 말고는 다른게 없으니 패스하고 위에 

```python
params = request.data
	user = User.objects.filter(username=params["username"]).first()
	
	if user is not None:
	    if not check_password(params["password"], user.password):
	        return Response({ "message": "password invalid" }, status=status.HTTP_400_BAD_REQUEST)
	    serializer = UserSignInSerializer(user)
	return Response({ "message": "user not found" }, status=status.HTTP_400_BAD_REQUEST) 
```

이 부분이 중요하다. 파라미터를 받고 user 를 찾는다 없는 경우 에러를 반환하고, 있는경우 password를 체크해서 각각 응답을 해주는 구조이다. serializer 에서는 username과 password만 받는다.

<br>

여기서 응답으로 password도 같이 전달해주기 때문에 이부분도 추후에 수정이 필요하다.

<br>

**클라이언트 수정**

여담으로… 최종적으로 몇가지 디자인을 수정하고 다음과 같이 페이지가 완성된다. 성공적으로 회원가입시 alert가 나오고 ok를 누르면 홈 화면으로 이동한다.

![Screen Shot 2023-04-15 at 11 21 55 PM](https://user-images.githubusercontent.com/47859845/232233837-8713ca51-e7ea-4dfe-aef6-cb1c0075d17a.png)

![Screen Shot 2023-04-15 at 11 22 35 PM](https://user-images.githubusercontent.com/47859845/232233838-95f2a53c-c983-4b00-a617-a8e626348cec.png)


<br><br>


