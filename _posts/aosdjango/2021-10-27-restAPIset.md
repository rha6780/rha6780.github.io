---
title: "post0"
date: 2021-10-27

categories:
  - aosdjango
tags:
  - django
---

### 장고를 활용한 rest_framework 구성

<br>

[5 linux에 파이썬 가상 개발 환경 구성하기(Virtual Environments)](https://jungeunlee95.github.io/linux/2019/06/30/5-%EB%A6%AC%EB%88%85%EC%8A%A4%EC%97%90-%ED%8C%8C%EC%9D%B4%EC%8D%AC-%EA%B0%80%EC%83%81-%EA%B0%9C%EB%B0%9C-%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%84%B1%ED%95%98%EA%B8%B0(Virtual-Environments)/)

<br>

---

vscode 에 ssh 연결로 리눅스 환경으로 들어간 뒤 장고 구현을 위해 가상환경을 구성한다.
파이썬 3이상의 버전으로 깔려있는 상태에서 원하는 폴더에서 아래 명령어로 가상환경을 구성한다.

<br>

```java
pip3 install virtualenv
virtualenv .venv
source .venv/bin/activate
```

해당 가상환경에 장고를 깔고, 프로젝트를 생성한다.

<br><br>

```java
pip install django

django-admin startproject "프로젝트 이름"
```

이렇게 프로젝트를 만들면 이 장고를 관리하는 슈퍼계정이 필요하다.

<br><br>

```java
python manage.py createsuperuser
```

이때 슈퍼계정을 만들 시 django.db.utils.IntegrityError: (1048, "Column 'last_login' cannot be null") 이라고 오류가 날 수도 있다. 이런 경우 아래 링크를 통해서 해결을 했다.

<br>

[CMS minibook](https://cms2580.pythonanywhere.com/78/)

<br><br>

```java
mysql 접속
select * from django-migrations;
truncate table django-migrations;

리눅스로 돌아와서
python manage.py migrate --fake-initial
```

<br>

---

<br>

**장고와 mysql 연동하기.**

<br><br>

```java
pip install mysqlclient
```

[mysqlclient-1.4.6-cp36-cp36m-win_amd64.whl is not a supported wheel on this platform. - Google Search](https://www.google.com/search?q=mysqlclient-1.4.6-cp36-cp36m-win_amd64.whl+is+not+a+supported+wheel+on+this+platform.&oq=mysqlclient-1.4.6-cp36-cp36m-win_amd64.whl+is+not+a+supported+wheel+on+this+platform.&aqs=chrome..69i57.410j0j7&sourceid=chrome&ie=UTF-8)

mysqlclient에 대해서 이런 오류가 나온다... 심지어 해당 파일을 다운로드 받아서 설치하려해도 안되기 때문에 pymysql를 사용하기로 했다.

둘다 기능적으로는 같기 때문에 호환성은 상관없을 듯 하다. 따라서...

<br>
<br>


```java
pip install pymysql
```

이후 DB 관련 데이터가 있는 settings.py에서 

<br><br>

```java
import pymysql
pymysql.install_as_MYSQLdb()

/...

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'django_locker', # DB명
        'USER': '', # 데이터베이스 계정
        'PASSWORD': '', # 계정 비밀번호
        'HOST': '', # 데이테베이스 주소(IP)
        'PORT': '', # 데이터베이스 포트(보통은 3306)
    }
}
```

을 통해서 데이터베이스와 연동이 가능하다.

<br><br>

```java
python manage.py makemigrations
python manage.py migrate
```

이떄 migrate가 안되고 django.db.utils.OperationalError: (1050, "Table 'django_admin_log' already exists") 등의 오류가 나올 수 있는데, 이런경우 아래와 같은 명령을 사용한다.

<br><br>

```java
python manage.py migrate --fake
```

---

<br><br>

### REST Framwork 로 api 배포하기.

<br>

[Django REST Framework로 API 만들기 & HTML 요소 수집하기](https://blog.nerdfactory.ai/2021/02/24/creating-an-api-&-collecting-html-elements-with-django-rest-framework.html)

<br>

```java
pip install djangorestframework
pip install django-filter

django-admin startapp "앱 이름"
```

만약 위 djangorestframework를 설치 했음에도 모듈을 찾지 못하는 경우

<br><br>

![Untitled](%E1%84%8C%E1%85%A1%E1%86%BC%E1%84%80%E1%85%A9%E1%84%85%E1%85%B3%E1%86%AF%20%E1%84%92%E1%85%AA%E1%86%AF%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A1%E1%86%AB%20rest_framework%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%204666ff90c8ab463181fb181c6b1f6173/Untitled.png)

이런 식으로 노란 줄이 쳐지는 경우는 해당 경로를 못찾기 때문에 발생하는 경우로,이 경로 설정을 따로 해주어야 정상적으로 작동된다.

<br>

일반적으로 django가 모듈을 import하는 경로는 sys.path를 이용해서 확인이 가능하다.

<br><br>

```java
import sys
print(sys.path)
```

혹은 PYTHONPATH 환경변수도 이와 같은 것이기 때문에 환경변수로 추가하면 확인이 된다.

<br>

[Django 예제를 이용한 python import 이해하기](https://cjh5414.github.io/understand-python-import-with-django-example/)

<br>
<br>

라고는 하지만.. 실제로 이걸 어떻게 해야할까... "python.jediEnabled": false 항목이 false면 true로 바꾸면 해결된다고 하는데 만약 없는 경우 아래 링크를 참고하자.

[[파이썬 에러] settings.json에 "python.jediEnabled" : false 가 존재하지 않습니다. (Unknown Configuration Setting : No quick fixes available)](https://0ver-grow.tistory.com/897)

<br>

이 경우 Unable to import 에러가 발생할 수 있다..

해결 방법.(아래 링크)

<br>

[VScode에서 import에러 해결한 이야기...](https://slowcode.tistory.com/97)

인터프리터가 기존 환경에 대해서 잡고 있어서 오류가 발생한다. 가상환경을 설치한 경우 인터프리터를 잡아줘야 이런 문제를 해결할 수 있다. .venv 폴더에 python 3.6 ... 으로 잡아주면 아래처럼 해결된다.

<br>

![Untitled](%E1%84%8C%E1%85%A1%E1%86%BC%E1%84%80%E1%85%A9%E1%84%85%E1%85%B3%E1%86%AF%20%E1%84%92%E1%85%AA%E1%86%AF%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A1%E1%86%AB%20rest_framework%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%204666ff90c8ab463181fb181c6b1f6173/Untitled%201.png)

- 인터프리터가 발견되지 않는 경우
    
    간혹 Select interpreter not found 와 같은 오류가 나오는 경우가 있는데, 이경우는 현재 vscode와 Extension 버전이 안맞기 때문이다. 따라서 해당 Extension 버전을 몇단계 낮추면 가능해 진다.!
    
    [Visual Studio Code for Python (VSCode Python 개발환경 만들기)](https://www.whatwant.com/entry/Visual-Studio-Code-for-Python-VSCode-Python-%EA%B0%9C%EB%B0%9C%ED%99%98%EA%B2%BD-%EB%A7%8C%EB%93%A4%EA%B8%B0)
    
<br><br>

---


<br>

결과

<br><br>

![Untitled](%E1%84%8C%E1%85%A1%E1%86%BC%E1%84%80%E1%85%A9%E1%84%85%E1%85%B3%E1%86%AF%20%E1%84%92%E1%85%AA%E1%86%AF%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A1%E1%86%AB%20rest_framework%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%204666ff90c8ab463181fb181c6b1f6173/Untitled%202.png)

아직 데이터베이스 내에 데이터가 없어서 [] 으로 나온다. 해당 테이블에 데이터를 추가하면 api로 받을 수 있다. 이 api를 이용해 데이터를 앱에서 출력하거나 활용할 수 있다. 어드민에서 해당 데이터를 추가할 수 있기 때문에 하나 넣으면...

<br><br>

![Untitled](%E1%84%8C%E1%85%A1%E1%86%BC%E1%84%80%E1%85%A9%E1%84%85%E1%85%B3%E1%86%AF%20%E1%84%92%E1%85%AA%E1%86%AF%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A1%E1%86%AB%20rest_framework%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%204666ff90c8ab463181fb181c6b1f6173/Untitled%203.png)

이런식으로 출력된다.

<br>

장고 초기설정이 아니라 개발환경 조성시에는 가상환경에서

```python
pip install -r requirements.txt
```

를 통해 라이브러리를 설치한다.

<br><br>