---
title: "죽은 github action 살리기"
date: 2023-04-26

categories:
  - developer_discovery
tags:
  - developer_discovery
---


그동안 죽어있던 action 들… 그동안 프로젝트 관련으로 작업을 하다보니 actions에서 나오는 이슈들을 신경쓰지 않았더니 꽤 많이 실패가 되어있었다. 대부분은 lint 오류였는데, 장고에서 생성하는 migrations 등 불필요한 파일도 검사하게 되어서 실패했다고 뜨는 것이었다.

<img width="1039" alt="Screen Shot 2023-04-26 at 2 54 18 PM" src="https://user-images.githubusercontent.com/47859845/234542286-21c047f8-1b27-4b5e-80e8-29337e6f79d9.png">

<br>

그래서 flake8, black 에서 exclude 옵션을 통해서 검사하지 않을 파일을 정의해주었다.

```python
# pyproject.toml

[tool.black]
line-length = 120
include = '\.pyi?$'
exclude = ''' 
/(
    \.git
  | \.venv
  | \.github
  | README.md
  | Pipfile
  | Pipfile.lock
  | settings
  | migrations
  | developer_discover/developer_discover/*
)/
''' 
```

<br><br>

> 오 성공?

<img width="985" alt="Screen Shot 2023-04-26 at 2 57 43 PM" src="https://user-images.githubusercontent.com/47859845/234542423-1728069e-7966-4ae3-b400-9bd160c2916e.png">

<img width="987" alt="Screen Shot 2023-04-26 at 2 58 25 PM" src="https://user-images.githubusercontent.com/47859845/234542429-52dc8532-caff-46e3-951a-9947c5e04ae5.png">

<br>

막상 안에 내용을 보니 tests 파일을 인식하지 못해서 테스트 자체가 안 돌아갔다… 코드에서 아래와 같이 테스트를 돌리는데, 문제는 현재 위치가 최상위에서 실행된다는 것이다. 우리의 test들은 developer_discover 하위에 있기 때문에 경로도 인자로 넘겨주어야 했던 것이다.

```python
# 기존 코드
pipenv run python3 developer_discover/manage.py test --settings=developer_discover.settings.test

# 수정
pipenv run python3 developer_discover/manage.py test --settings=developer_discover.settings.test developer_discover 
```

<br>

> 이제 잘 되겠지…? 😸 …. 어?

<br>

```python
django.db.utils.OperationalError: connection to server at "127.0.0.1", port 5432 failed: Connection refused
	Is the server running on that host and accepting TCP/IP connections?
```

DB에 연결할 수 없다는 에러가 나왔다… 저번에 Docker 연결할 때 봤던 것으로 이건 큰 이슈없이 수정했다. 원인은 settings/test 에 지정된 DB 테이블 이름이 github action 파일에서 정의한 이름과 달라서 생긴 것이다. 해당 값과 동일하게 변경하니 정상적으로 테스트가 돌아갔다…!


<img width="406" alt="yml-file" src="https://user-images.githubusercontent.com/47859845/234542435-3c351637-1c05-43b6-8812-a4161e8a0592.png"><img width="706" alt="Success" src="https://user-images.githubusercontent.com/47859845/234542440-ab645376-5918-4b37-b74f-de237afcb3ff.png">

<br>

**좀 더 간단히 할 수 있을까?**

현재 돌아가는 action 구조는 `runs-on: ubuntu-latest` 옵션을 통해서 우분투 위에 pipenv 패키지와 필요한 라이브러리를 깔도록 커맨드를 작성해서 돌아가고 있다. 하지만, Docker를 이용한다면…?

현재 작성된 Docker를 github action 에 pull 받도록 하고 해당 컨테이너 내부에서 test 및 lint 검사를 하면 될 것 같다. 하지만, Docker Pull 받을 서버가… DockerHub 말고는… 허브를 이용한다고 해도, 계정마다 받을 수 있는 횟수가 정해져 있기 때문에 우선 보류한다. 추후 배포로 Docker image를 배포할 때 이미지를 저장하는 곳에서 받아오게 해도 될 것 같다.   일단 이런 방식이 있다 정도만 알고, 개선사항으로 남겨두자.

<img width="296" alt="Screen Shot 2023-04-26 at 3 09 46 PM" src="https://user-images.githubusercontent.com/47859845/234542448-26d32fff-b4a5-4fba-979e-be594a98b0a7.png">

기존… EC2에 올리던 스크립트도 서비스가 어느정도 개발되면 수정해보도록 하겠다.



<br><br>
