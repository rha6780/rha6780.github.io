---
title: "[Docker] Docker 이미지 생성, 삭제"
date: 2023-04-04

categories:
  - docker
tags:
  - docker
---

⚠️ 본문은 맥 기준으로 설명하고 있습니다.

<br>

## **환경 구성 전 확인**

이론편에서 아키텍쳐에 대해 잠깐 이야기 한적이 있는데 해당 이미지를 다시 살펴보면 좋을 것 같다. 아래 설명 처럼 클라이언트, 즉 각 개발자의 환경에서 해당 build, pull, run이 각각 수행된다. 환경은 우분투, 등등이 있다.

간단히 아래와 같이 생각하면 된다.

- build : 이미지 구축
- pull : 이미지 가져오기
- run : 이미지 실행

여기서 [DockerHub](https://hub.docker.com/)에 가면, 우분투, postgres 등등 다양한 이미지가 있다. 여기서 **제공하는 이미지를 통해서 환경을 구축하는 경우**도 있고, **자신이 작성한 이미지를 사용하는 방식** 등이 있다.

<br>

## **DockerHub를 이용해 이미지 실행**

사이트에서 원하는 이미지를 누르고, 해당 이미지를 가져오기 위해 명령어를 통해 가져온다. 이후 터미널에서 아래처럼 명령어를 실행 시킨다.

<img width="424" alt="docker_pull" src="https://user-images.githubusercontent.com/47859845/229750033-34c60829-eaa2-43eb-a14f-51a3fc6e29c6.png">

해당 명령어를 실행하면 해당 이미지를 다운로드 한다. 이전 글에서 말한데로 이미지는 해당 문서화 된 탬플릿이다. 컨테이너는 실제로 구동되는 코드 영역이라면, 이미지는 해당 컨테이너의 생성, 삭제 등을 관리하는 파일이라고 생각하면된다. 즉, 저 명령어로 postgres를 DB로 가지는 프레임의 컨테이너를 설계한 것이다. 우선 우리가 가져온 이미지를 확인하자. docker images 명령어를 작성하면, 아래와 같다. 예전에 postgres로 가져온 것이 있어서 Created가 현재 시간이 아니다.

<img width="633" alt="docker_images_ps" src="https://user-images.githubusercontent.com/47859845/229750030-4b592b6a-29e3-4df8-b294-50f0b8ecccee.png">

아무튼 확인 되었다면, 컨테이너를 실행시켜야 한다.

```shell
docker run --name [컨테이너 이름] -p [호스트 포트:컨테이너 포트] [이미지 이름]

docker run --name 임의의 이름 -p 5432:5432 postgres
```

—name은 컨테이너 이름을 지정하고 -p 는 `host port:container port` 로 포트를 포워딩하기 위한 명령어이다. 마지막엔 이미지 레포을 입력하면된다.

<br>
<br>

<img width="737" style="display:block; margin:auto" alt="port_forwarding" src="https://user-images.githubusercontent.com/47859845/229750025-5a12ecde-4ffe-4175-90e3-845af57d4c87.png">

포트 포워딩이란 위 그림처럼 Host, container가 있는데 호스트와 컨테이너는 서로 독립적인 환경으로 각각 port를 가지고 있고, 사용자가 어떤 요청을 컨테이너에 보내서 결과를 얻기 위해서는 Host의 포트와 컨테이너의 포트를 연결하는 과정이 필요하다. 이를 **포트 포워딩**이라고 한다.

<br>

명령어에서 -p에 해당하는 부분이 `호스트 포트 : 컨테이너 포트` 로 포트를 서로 지정하는 것이다.

<br>

여기서 나는 postgres의 이미지를 사용했는데 이는 DB이기 때문에 초기에 슈퍼유저 세팅이 필요로 한다.
이처럼 pull 한 이미지 환경은 각각 컨테이너 생성 시 조건이 있을 수 있으니 pull 전에 공식문서를 정독하자.

```shell
docker run --name postgres_db -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
```

<br>
<br>

<img width="741" alt="docker_ps" src="https://user-images.githubusercontent.com/47859845/229750017-9fe69bfc-f58f-4a59-93eb-4d5dc45c2ed4.png">

docker ps로 postgres_db라는 이름의 컨테이너를 확인할 수 있다.

- 참고문헌
  개인적으로 원리를 살펴볼 때 해당 [강의](https://youtu.be/SJFO2w5Q2HI)가 도움이 되었다.
  [[Docker] Image를 pull 하고 Container를 run 시키기](https://techblog-history-younghunjo1.tistory.com/203)

<br>

## **직접 이미지 작성**

원하는 경로에서...

```shell
vi Dockerfile
```

직접 이미지를 작성하는 경우 Dockerfile이라는 이름의 파일을 생성하고, 그 안에 우리가 원하는 환경에 대해 작성하면 된다.

```docker
FROM postgres:13.1

RUN 어쩌구 저쩌구...
```

이렇게 작성할 때 각종 설정들이 있는데...

<br>

### **속성들**

`FROM 이미지이름 : 태그` : 베이스 이미지의 이름과 태그를 지정할 수 있다. 태그를 생략하면 자동적으로 최신 버전을 기반으로 한다.

`RUN` : 이미지 빌드 시 실행될 명령어를 지정한다. (빌드 시 1번만 실행)

`CMD` : 컨테이너가 실행될 때마다 수행할 명령어를 나타낸다.

`ENV` : 환경변수를 지정한다.

이 외에도 많은게 있지만, 간단히 이정도만 소개한다. 필요한 설정이 있다면 한번 검색해보자!

<br>

### **간단하게 빌드하기**

여기까지 각 속성이 무슨 역할을 하는지 간단히 살펴보았다. 해당 내용을 통해 간단히 이미지를 빌드해보자. 우선 어플리케이션을 위해 간단한 파일을 생성하자.

```python
# test.py 파일
print("테스트 실행")
```

그리고 Dockerfile을 아래처럼 작성하자.

<img width="500" alt="dockerfile" src="https://user-images.githubusercontent.com/47859845/229751634-9353fad4-61cb-4965-bd4a-82a0c666ea13.png">

Workdir의 경우 현재 Dockerfile 위치에서 실제 빌드되는 환경(컨테이너)이 어느 경로에 있는지 지정하는 것이다. 만약 현재 위치가 아니라 test/dummy 라는 폴더아래에서 빌드 및 실행하려면 해당 경로로 지정하면 된다. Copy는 수행되는 환경에 복사할 경로를 지정하는 것이다. Workdir에서 지정한 경로에서 수행하려면 해당 파일들이 필요해서 이를 복사하는 것이다. 사실 현재 경로에 그대로 하는 것이라서 쓸 필요는 없었지만, 학습을 위해 작성하였다.

<img width="500" alt="copy" src="https://user-images.githubusercontent.com/47859845/229751640-8bfc66fc-b9f5-4f1f-8912-836618576330.png">

대충 이런식으로 작성하면 build 명령어를 통해 이미지 이름과 경로를 적어 빌드한다.

```shell
docker build -t [이미지 이름] 경로

docker build -t python_docker .
```

<img width="723" alt="docker_build" src="https://user-images.githubusercontent.com/47859845/229751632-b8a778dc-4402-428b-bc83-e91e7895b04f.png">

모두 빌드 되었다면 이미지가 정상적으로 생성되었는지 확인하자.

<br>

```shell
docker images
```

<img width="400" alt="images" src="https://user-images.githubusercontent.com/47859845/229751626-8acec10d-bb8c-4751-8479-c8d6cc202c93.png">

그리고 해당 이미지를 실행 시켜보자.

<br>

```shell
docker run python_docker
```

<img width="400" alt="docker_exec" src="https://user-images.githubusercontent.com/47859845/229751618-7dd03486-6def-40f0-a971-9e61a6db3a5b.png">

이처럼 우리가 작성한 docker 이미지가 실행된 것을 볼 수 있다. 작성한 내용이 테스트 실행만 담고 있어서 크게 와 닿지 않을 수 있다. 하지만, 거대한 프로젝트를 배포하고 실행 시키려면 이러한 과정을 필요로 할 것이다.

- 컨테이너 실행

  ```shell
  docker run --name python_container -d python_docker
  ```

    <img width="649" alt="Screen Shot 2022-03-06 at 7 20 38 PM" src="https://user-images.githubusercontent.com/47859845/229753635-3067ff4a-d93a-4315-be46-cb819a7687ba.png">

<br>

다만, 이렇게 작성한 dockerfile로는 한 컨테이너 밖에 구성하지 못한다. 만약 여러 컨테이너를 구축하고 싶은 경우 docker-compose를 통해 관리할 수 있다.

- 참고자료
  [[docker] Dockerfile 작성하기\_1(이미지 만들고 배포하기)](https://cornswrold.tistory.com/449)

<br>

## **Docker-Compose 로 이미지 및 컨테이너 생성**

docker-compose는 리눅스가 아닌 환경에서는 공식홈페이지 혹은 docker desktop를 설치할때 같이 설치된다. 혹시 모르니 docker-compose —version을 통해 확인하자. docker-compose로 여러 컨테이너를 관리하는 방법은 간단하다. Dockerfile 처럼 `docker-compose.yml` 파일을 만들어서 그 안에 각 컨테이너 환경에 따른 설정을 작성하는 것이다.

<br>

여러 컨테이너, 이미지를 관리하기 때문에 여러가지 옵션과 필드를 지정한다. 일반적으로 docker-compose.yml은 프로젝트 최상위에 위치시킨다. 우선 compose로 구성할 수 있는 서비스 중 DB를 먼저 생각하고 구성해보자. docker-compose를 이용해 [postgres DB 환경을 구성](https://github.com/docker/compose)해보자.

```yaml
version: "3.1"

services:
  db:
    image: postgres
    restart: always
    environment:
      - POSTGRES_DB=testDB
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
```

postgres에서는 postgres 라는 default로 이름을 root로 지정해두어서 처음 DB에 접속할 때 위와 같이 지정하는 것이 좋다.

<br>

### **세부적으로 설정하기**

**예시**

```yaml
version: "3.9"  # optional since v1.27.0
services:
	web:
		build: .
		ports:
			- "8000:5000"
		volumes:
			- .:/code
			- logvolume01:/var/log
		links:
			- redis
	redis:
		image: redis

volumes:
logvolume01: {}
```

위 코드 처럼 해당 앱의 버전과 서비스에 대한 설정이 가능하다. services에 web, redis 이외에 db, 등등 사용자가 설정한 서비스의 환경을 지정할 수 있다.

해당 서비스에 몇가지 설정이 가능한데, 차례로 살펴보면 다음과 같다.

<br>

### **속성들**

**build**

build는 해당 서비스의 dockerfile(이미지)을 빌드하기 위한 경로를 지정하기 위해 사용한다. 만약 현재 위치에서 빌드하는 경우 위처럼 작성해도 된다. (pull 하는 경우 생략도 가능)

<br>

**image**

데이터 베이스 등의 애플리케이션은 postgres와 같은 이미지를 주로 내려받는다. image는 어떤 db를 pull 할지 작성한다.

```yaml
services:
	db:
		image: postgres
```

<br>

**ports**

ports는 이름처럼 호스트와 컨테이너의 포트를 매핑, 바인딩(포트 포워딩)에 사용이 된다.

```yaml
services:
  db:
    image: postgres
    environment:
      - POSTGRES_DB=hashcode
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - "5432:5432"
```

<br>

**volumnes**

volumnes 항목은 볼륨 설정을 위해 사용된다. 마운트가 필요한 호스트의 경로와 컨테이너 경로를 지정한다.

<br>

**depends_on**

depends_on은 서비스 간 의존 관계를 지정한다. 어떤 어플리케이션을 올리기 전 먼저 해야하는 어플리케이션이 있다면 다음과 같이 사용할 수 있다.

```ruby
services:
	db:
		...
	app2:
		depends_on:
			- db
```

이 경우 app2가 빌드되기 전 db가 먼저 빌드 된다.

<br>

**environment**

environment는 환경변수를 설정할 때 사용된다. db와 같은 경우 접속하기 위해 id, password를 지정해야하는데 다음처럼 지정하여서 사용할 수 있다.

```yaml
services:
  db:
    image: postgres
    environment:
      - POSTGRES_DB=hashcode
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
```

<br>

**command**

command의 경우 compose 수행시 실행될 커맨드를 수행한다. 아래 처럼 수행할 수 있다.

```yaml
services:
	foo:
		image: busybox
		environment:
			- COMPOSE_PROJECT_NAME
		command: echo "I'm running ${COMPOSE_PROJECT_NAME}"
```

<br>

**networks**

서비스 컨테이너가 사용할 네트워크를 지정한다. 만약 최상위에 네트워크 키를 설정해서 편리하게 이용할 수 있다.

```yaml
services:
  frontend:
    image: awesome/webapp
    networks:
      - front-tier
      - back-tier

networks:
  front-tier: 1234
  back-tier:3532
```

이 처럼 지정하면 1234, 3532라는 키가 해당 frontend 서비스의 네트워크 키로 들어간다. 이 외에도 많은 설정이 있는데, 워낙 많아서 아래 링크를 통해 어떤 것이 있는지 확인하는 것이 좋을 것 같다.

- 속성 설명 링크 & 참고자료
  [compose-spec/spec.md at master · compose-spec/compose-spec](https://github.com/compose-spec/compose-spec/blob/master/spec.md)
  [Overview of Docker Compose](https://docs.docker.com/compose/)

<br>

### **간단하게 빌드하기**

예시로 해당 docker-compose.yml 파일을 생성하였다.

```yaml
services:
  db:
    image: postgres
    environment:
      - POSTGRES_DB=TestDB
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - "5432:5432"
```

<img width="576" alt="docker-compose" src="https://user-images.githubusercontent.com/47859845/229753804-90e8ff06-6568-42a9-a387-fda5cd202ba5.png">

해당 위치에서 `docker-compose up -d`를 실행 시킨다.

<br>

<img width="748" alt="docker ps" src="https://user-images.githubusercontent.com/47859845/229753788-d025c775-dbfc-4232-8b1c-d2c2c9a196aa.png">

docker ps 를 통해서 해당 이미지가 수행되는 것을 볼 수 있습니다. 이를 종료하려면 docker-compose down을 작성하면 된다.

<br>

## **이미지 삭제하기**

해당 내용에 대해서 이미지를 삭제하고 싶다면 아래 명령어들을 이용해 삭제할 수 있다. (단, 실행중인 이미지는 삭제 불가)

```ruby
# 단일 이미지 삭제
docker image rm [image id]
예시: docker image rm dd462f89090

# 모든 이미지 삭제
docker image rmi $(docker images -p) -f

```

<br>
<br>
