---
title: "유저 모델 수정과 비밀번호 찾기 로직"
date: 2023-05-02
# toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - developer_discovery
tags:
  - developer_discovery
---


### AbstractBaseUser 로 복귀…

저번 [유저 회원가입, 로그인 글](https://rha6780.github.io/developer_discovery/signup_page/)에서 AbstractUser 로 작성을 했다고 했는데, AbstractBaseUser 로 다시 수정하게되었다. 바꾼 이유는 비밀번호 찾기에 있다. 비밀번호를 잊었을 때 사용자가 맞는지 인증과정이 있어야 비밀번호를 재설정할 수 있기 때문이다. 기존 테이블에도 email이라는 필드가 있었지만, 필수로 요구하는 게 아니었기 때문에 빈 값일때 비밀번호를 찾을 수 없다는 문제가 있다.

<br>

그래서 username이라는 유저 아이디 보다 이메일을 받도록 했다. 이러면 개인정보에 관련해서 정보를 어떻게 할 건지 약관 페이지도 개발해야한다. 토이 프로젝트이지만, 그래도 비밀번호 찾기 기능은 꼭 필요하기 때문에 이메일에 대한 약관 페이지도 추후 개발할 예정이다.

<br>

사실 롤백은 크게 어렵지 않았다. github에 push한 이력이 있어서 해당 커밋을 참고해 다시 복구 시켰다. 다만, DB에 기존 구조를 가지 데이터 들이 있었기 때문에 해당 데이터를 지우고, migration도 시켜두었다.

![Screen Shot 2023-04-26 at 11 38 46 AM](https://user-images.githubusercontent.com/47859845/235614903-1ff48e6c-2610-41d1-a674-48cf43b41686.png)


하지만, 실제 서비스 상태였다면… 상상만 해도 아찔하다… 문제가 되는 부분은 unique 하다라는 것인데, 서비스 상태라면 이름이 다른 필드를 생성하고, 비어있다면 해당 필드에 unique 한 임의 값 기존 값이 있다면 해당 값을 저장하도록 코드를 돌리고, 서비스 코드에서 기존 필드를 새 필드로 변경하고, 배포하고, 기존 필드를 지우고, 새로 생성한 필드의 이름을 바꾸고… 등 여러 할일이 많았을 것이다. 아직 로컬 개발 단계라 다행이다… 휴

<br>


이제 DB도 새로 수정해서 비밀번호 관련된 로직들을 추가할 예정이다. validation과 찾기 기능이다. 찾기의 경우 이메일로 찾기 링크를 보내고 해당 링크에서 버튼을 누르면 비밀번호 재설정 페이지로 입장하는 것이다. 우선 validation 부터 처리해보겠다.

<br>

### password validation

패스워드 validation 같은 경우, 기존에 제공하는 validator 를 사용하거나 custom validator를 생성해서 사용하는 방식이 있다. 둘중 하나를 골라서 Settings에서 해당 validator를 설정해주면 끝이다. [참고 링크](https://docs.djangoproject.com/en/4.2/topics/auth/passwords/)

> Serializer에서 validate_password 를 작성해서 체크 할 수 있지 않나요..?


Serializer 에서 정의하는 것도 흐름상 문제가 없다. Serializer에서 validate 함수를 쓰는 목적은 직렬화와 업데이트 전에 유효성 검사를 하는 것이지만, 파일 관리에서는 큰 이점이 없다고 생각한다. password 유효성을 검사할 때 해당 Serializer 파일을 찾아가야 한다는 점이 좋지 않다고 생각한다. 또 validate_password는 이미 Django에서 제공하고 있기 때문에 설정 이후 `from django.contrib.auth.password_validation import validate_password` 로 import 해서 사용하면 된다. [참고 링크](https://stackoverflow.com/questions/48040007/django-password-validation-not-working)

<br>
<br>

**User.objects.create() vs User.objects.create_user()**

User.objects.create() 의 경우 DB에 password의 원문이 그대로 저장된다. 만약 암호화하려면, create() 대신 save()를 이용하고 save() 전에 패스워드 값을 set_password 로 지정해주어야 해시로 저장된다. User.objects.create_user() 를 사용하면 password가 암호화 되기 때문에 더 안전하다.

- [📍 Difference between User.objects.create_user() vs User.objects.create() vs User().save() in django](https://stackoverflow.com/questions/63054997/difference-between-user-objects-create-user-vs-user-objects-create-vs-user)


<br>
<br>
<br>

이제 한번 테스트 해보자…! 임의로 패스워드를 8자 아래로 지정하면 이렇게 400에러가 나오는 것을 볼 수 있다. 그런데 에러 문구가…


<br>


![Screen Shot 2023-04-26 at 4 50 17 PM](https://user-images.githubusercontent.com/47859845/235614889-8c3c6905-1b40-4854-af30-d9ef5986aa7d.png)


지금은 serializer.errors로 보내고 있는데… 위 사진을 보면 알다 싶이 `Request failed with status code 400` 라고만 나와 있어 모호하다고 생각된다. 조만간 에러 처리를 어떻게 할 건지 생각을 해봐야 할 것 같다.


![Screen Shot 2023-04-26 at 4 51 26 PM](https://user-images.githubusercontent.com/47859845/235614898-ca291f39-bb5d-4793-9501-15faaa9c7ea9.png)


<br>
<br>

### 비밀번호 찾기 기능

비밀번호 찾기 기능에서는 위에서 설명했듯이 아이디 → 이메일로 바꾸면서… 해당 이메일로 비밀번호 재설정 페이지로 리다이렉트하는 폼을 보내는 방식으로 구현할 것이다. 우선 [공식문서](https://docs.djangoproject.com/en/4.2/topics/email/)를 참고해서 아래와 같이 settings 파일에 설정했다.

```python
EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_HOST = env("EMAIL_HOST")
EMAIL_PORT = 465
EMAIL_HOST_USER = env("EMAIL_HOST_USER")
EMAIL_HOST_PASSWORD = env("EMAIL_HOST_PASSWORD")
ACCOUNT_EMAIL_VERIFICATION = 'none'
EMAIL_USE_TLS = False
EMAIL_USE_SSL = True
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER 
```

하지만 순탄하지 않았다…

<br>
<br>


**오류들…**

요건 host 이름이 [smtp.gmail.com](http://smtp.gmail.com) 인데 [stmp.gmail.com](http://stmp.gmail.com) 으로 되어있어서 생긴 문제였다.

![Screen Shot 2023-04-26 at 6 51 14 PM](https://user-images.githubusercontent.com/47859845/235614900-55679b98-cd9a-4cd9-8ae2-421a0cb27310.png)


[gaierror when trying to send email with Django using Google App Engine](https://stackoverflow.com/questions/40458405/gaierror-when-trying-to-send-email-with-django-using-google-app-engine/40458446#40458446)


<br>


SSL 포트가 465인데 잘못 넣어서 생긴 오류이다.

![Screen Shot 2023-04-27 at 7 39 35 PM](https://user-images.githubusercontent.com/47859845/235614905-9503c8b7-a3a5-44cb-a66b-579244e6f91f.png)


[How to fix ssl.SSLError: [SSL: WRONG_VERSION_NUMBER] wrong version number (_ssl.c:1056)?](https://stackoverflow.com/questions/57715289/how-to-fix-ssl-sslerror-ssl-wrong-version-number-wrong-version-number-ssl)


<br>

앱 비밀번호가 잘못되어서 생긴 오류이다. 찾아보니 앱 비밀번호를 따로 생성하고, 해당 비밀번호를 환경변수로 넣어주어야 한다. 머쓱해요… ;;


![Screen Shot 2023-04-27 at 7 41 42 PM](https://user-images.githubusercontent.com/47859845/235614906-79f5c892-a296-4596-8282-2c77bc829939.png)


[Sign in with App Passwords - Google Account Help](https://support.google.com/accounts/answer/185833?visit_id=638181881177075284-601987264&p=InvalidSecondFactor&rd=1)



<br>
<br>


위 사항들을 해결하고 테스트했을때...

<br>

<p align="center">
<img width="500"  alt="image" src="https://user-images.githubusercontent.com/47859845/235614907-e9203212-9481-4320-bb12-2ecb0a3cf9e5.png">
</p>

메일은 잘 온다!! 하지만 링크를 누르면… 아래 처럼 오기 때문에… 몇가지 수정을 해야할 것 같다. 우선 url이 이상한 것, api 쪽 웹 페이지가 나오는 점을 수정해야한다. 일단 url에 토큰값을 token_test 라고 두었는데, 토큰도 실제로 발급해서 일정 시간이 지나면 이용하지 못하게 해야할 것 같다.

<br>

<p align="center">
<img width="500"  alt="email-error" src="https://user-images.githubusercontent.com/47859845/235614909-7853765d-20b0-44f7-b3c3-00cee8a0a574.png">
</p>

그럼 정리하면… 이메일 전송 전에 유저 이메일 검사, 해당 이메일로 토큰 발급, url과 함께 이메일 전송, 이메일의 버튼을 누르면 이메일 설정 페이지로 가고, 해당 토큰이 유효하지 않으면 api를 보내지 못하게 한다. 그럼 가장 문제인 부분은 어디인가… 토큰이 유효하지 않을 때 api를 보내지 못하게 하는 부분이 클라이언트 쪽에 구현을 해야한다. 아니... 애초에 api를 보낼 때 토큰이 유효한지 체크해서 업데이트 해주면 되지 않을까?



<br>
<br>


내가 생각하는 과정은 다음과 같다.


<p align="center">
<img width="500"  alt="email-page" src="https://user-images.githubusercontent.com/47859845/235615496-68ecf261-0020-48db-9fa8-bec29cd69078.png">
</p>

이메일을 작성하면, 해당 이메일이 있는지 확인하고 이메일을 보낸다. 이메일을 보낼때 해당 이메일 유저에 대한 토큰을 발급하고 이메일에 해당 토큰을 넣어서 보낸다.

<p align="center">
<img width="500"  alt="reset-password-email" src="https://user-images.githubusercontent.com/47859845/235615500-c00360f9-37ac-4ff2-9113-07c1f11ad35d.png">
</p>


여기서 링크를 누르고… 아래 비밀번호 설정 페이지에서 비밀번호를 작성하고 제출하면 api를 통해서 토큰, 비밀번호가 전달된다. 토큰이 유효하지 않은 경우, 비밀번호가 유효하지 않은 경우 에러를 보여주고, 성공적으로 처리되면 비밀번호를 변경하고, 토큰을 제거한다. (이메일 폼도 수정을 해야겠다.)

<p align="center">
<img width="500"  alt="reset-password-page" src="https://user-images.githubusercontent.com/47859845/235615502-60cdac1c-58c2-4c7d-ada6-a2d25e8259f6.png">
</p>


이 방식으로 진행을 하였고, 이제 토큰, 패스워드만 valid하다면 비밀번호를 바꿀 수 있다… 문제는 아직까지도 에러처리를 하지 않고, try-catch 로 해당 alert를 보여주고 있기 때문에 수정이 필요하다. 이는 다음 TODO로 어떻게 할지 정해야할 것 같다.

<p align="center">
<img width="500"  alt="error-alert" src="https://user-images.githubusercontent.com/47859845/235615504-98ba12dc-f7ed-4b67-b28c-a4fb7f1aac0d.png">
</p>


<br>
<br>
