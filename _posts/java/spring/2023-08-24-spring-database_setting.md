---
title: "[Spring Boot] DB 연동하기 (Postgres)"
date: 2023-08-24

categories:
  - java

tags:
  - java
  - spring

---



### **프로젝트에 DB 연동하기**

DB를 연동하기 위해서는 앞서 이야기 했던, Maven, Gradle 에 따라서 작성 방식이 다른데, 우선 Gradle로 프로젝트를 시작하고, Postgresql 을 사용한다는 가정하에 설명을 하겠다. 


<br>
<br>

**Gradle 설정 파일**

- `build.gradle` : 라이브러리 버전 및 의존성 관리, 그외 프로젝트 빌드, 버전 및 테스트 설정
- `application.properties` : 어플리케이션 - DB 연결, 로깅 등 실제 어플리케이션 레벨에 관한 설정


<br>

**DB 설치 전 설정**

위에서 소개한 2가지 파일이 있는데, 차례대로 아래와 같이 작성한다.


<br>

- **build.gradle**

```java
...

dependencies {
	...
	implementation 'org.springframework.boot:spring-boot-starter-jdbc'
	implementation 'org.postgresql:postgresql:42.5.0'

	...
}
```

총 3가지인데, jdbc의 경우 자바와 DB의 연결을 위한 미들웨어이고, postgresql은 우리가 사용할 DBMS로 취향에 맞게 Mysql이나 다른 것도 가능하다. 의존성 설정이 완료되면 항상 Gradle Sync를 맞추어주자.

![Screen_Shot_2023-08-24_at_12 23 40_PM](https://github.com/rha6780/rha6780.github.io/assets/47859845/2d5d9574-c3fc-4c18-b8b7-76514bc31f66)

<br>

- **application.properties**

```java
...

# DB
spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.hikari.maximum-pool-size=4
spring.datasource.url=jdbc:postgresql://localhost:5434/example
spring.datasource.username=postgres
spring.datasource.password=postgres
spring.datasource.platform=postgres

spring.jpa.show-sql=true
spring.jpa.database=postgresql
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.properties.hibernate.format_sql=true
```

각각 세부적인 부분은 상황에 따라서 변경하면된다. 여기서 driver에 따라서 연결되는 DBMS도 달라지기 때문에 build.gradle 에서 설치한 라이브러리에 맞는 설정을 작성하여야 한다.

<br>
<br>

## DB 실행 및 연결 테스트

위와 같이 작성한 이후에 DB를 실행하지 않은 상태에서 빌드하게 되면 에러가 나온다. 나의 경우 따로 로컬에 DB를 설치하면 버전 및 문제 등이 있어 Docker를 이용하기로 하였다.

- [Docker 설치](https://docs.docker.com/get-docker/)

이후 설치가 완료 되면, 프로젝트 루트에 docker-compose.yml 파일을 생성하고 다음과 같이 작성한다.

```java
// docker-compose.yml
version: '3.1'
services:
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=example
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - "5434:5432"
    restart: always
```

여기서 DB 이름과 `application.properties` 의 DB 정보를 일치시켜야한다. 내 경우 로컬에서 5434이라는 포트를 이용한다는 점인데, 로컬에 이미 기본 포트를 사용하는 경우 위와 같이 변경해서 사용하자. (postgresql은 5432이다.)

<br>

터미널에서 CD 명령어를 이용해 프로젝트 위치로 가고, `docker compose up -d` 를 통해 컨테이너를 띄우자. 컨테이너가 성공적으로 띄워지면 스프링 빌드가 가능할 것이다.

<br>
<br>


**테스트용 모델 구성하기**

스프링이 빌드되면, 아마 데이터 테이블이 생겨야 하는데, 현재 작성한 코드가 없기 때문에 테이블 역시 생성되지 않을 것이다. 현재 프로젝트 패키지 하위에 domain이라는 패키지를 생성하고, Example 이라는 클래스를 생성하자.

![Screen_Shot_2023-08-24_at_12 28 25_PM](https://github.com/rha6780/rha6780.github.io/assets/47859845/25512019-617c-4337-a461-55879ce3aa88)

<br>


해당 Example 클래스에 아래와 같이 작성하자. 필요한 것들을 모두 import 하자. 이렇게 작성하면 빌드 시 테이블이 id, title로 된 Example 테이블이 생성된다.

```java
package com.example.demo.domain;

import javax.persistence.*; //또는 import jakarta.persistence.*;
import java.util.*;

@Entity
@Table(name="Example")
public class Example {
    @Id
    @Column(name="id")
    @GeneratedValue
    private long id;

    @Column(name="title", nullable = false, length = 512)
    private String title;

    private String content;
}
```

여기서 어노테이션들을 보면 감이 오겠지만, id의 경우 생성시 +1 씩 하기 위해 GeneratedValue, id, 어노테이션을 붙였다. Column에는 여러 옵션이 있으니 해당 칼럼에 뭔가 설정해야할 때 title과 같이 추가하면 된다.

<br>

결론적으로 빌드시 아래와 같이 구성되면 DB는 성공적으로 연결된 것이다.

![Screen_Shot_2023-08-24_at_12 28 00_PM](https://github.com/rha6780/rha6780.github.io/assets/47859845/11118f31-7c26-4576-bf25-d17451b980d2)


<br>
<br>


8080 포트로 가보면 다음과 같이 나오면 성공이다. 이제 웹페이지를 구성하거나 API 를 구성하면 된다.


![Screen_Shot_2023-08-24_at_12 26 41_PM](https://github.com/rha6780/rha6780.github.io/assets/47859845/bd62905b-c2cd-48ad-ad8a-1f3b09d678a8)


<br>
<br>
