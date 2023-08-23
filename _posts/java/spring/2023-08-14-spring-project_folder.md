---
title: "[Spring Boot] 프로젝트 폴더 구조"
date: 2023-08-14

categories:
  - java

tags:
  - java
  - Spring

---


### **프로젝트 생성 시 폴더 구조(Gradle)**

```text
ProjectName
  ├── src/main/java : 자바 파일이 모여있는 폴더
  ├── src/main/resources : DI를 위한 프로퍼티, xml 파일 등 자바 외의 자원이 모여있는 폴더
  ├── src/test/java : main에 있는 코드를 테스트 하기 위한 폴더로 테스트 자바 코드가 모여있다.
  ├── src/test/resources : 테스트에 필요한 자원 들을 모아둔다.
  ├── JRE System Library
  ├── Gradle Dependencies : (메이븐/그래들)이 자동으로 관리해주는 라이브러리가 모여있는 곳
  ├── build
  ├── src
  └── target
```

메이븐, 그래들에 따라서 파일이 조금씩 다르지만, 대체적으로 위와 같은 구조를 가진다. 그래들 기준으로 build.gradle 에서는 빌드 시 스크립트를 지정할 수 있다.

<br>


프로젝트 폴더 구조에서 이제 우리는 각각 기능에 맞는 코드 및 클래스를 생성할 것이다. 여기서 각 기능별로 모아둘지, 계층별로 모아둘지 선택해서 폴더 구조를 만들 수 있다.

<br>

**스프링에서 각 파일이 하는 일**

- api : 컨트롤러 클래스가 모여있고, 주로 rest api 로 구성하는 경우에 사용된다.
- repository : 특정 도메인 객체를  지속적으로 사용하기 위해 영속적으로 구현된 기능으로 주로 DAO 과 관련이 깊다. ORM 과 같이 DB에 접속해 CRUD 작업을 하는 클래스라고 이해하면 된다. (DAO 란 Data Access Object로 데이터 베이스에 접근하기 위해 생성하는 객체)
- domain : 도메인 엔티티에 관한 클래스로 특정 도메인에만 속하는 Enum 등도 포함된다. (도메인 = 모델 객체)
- dto: 주로 request, response에 필요한 객체들로 구성된다.
- expection: 해당 도메인이 발생시키는 Exception으로 구성된다.

<br>

### **계층형 구성**

repository 별로 repository 패키지에 같이 모아두고, controller, service 별로 모아두는 방식이다. 계층형의 경우 도메인이 많을 수록 폴더에 파일도 많아지기 때문에 큰 프로젝트에서는 관리하기 어려울 수 있다. 하지만, 전체적인 구조를 빠르게 파악할 수 있는 장점이 있다.

```text
ProjectName
  └── src
      └── main
          └── java
              └── com
                  └── example
                      └── demo
                          ├── repository
                          ├── controller
                          └── domain
```

<br>

### **도메인형 구성**

하나의 도메인 별로 repository, controller, service 파일을 모아두는 방식이다. 도메인 별로 모아두기 때문에 코드들이 응집해 있다. 단점은 전체적인 구조를 파악하기 어려운 점이다. 

```text
ProjectName
  └── src
      └── main
          └── java
              └── com
                  └── example
                      └── demo
                          ├── user
                          │   ├── controller
                          │   ├── domain
                          │   ├── service
                          │   └── exception
                          └── post
                              ├── api
                              ├── domain
                              ├── service
                              └── dto
```


<br>

**설계상으로 볼 때..**

설계 상 고려할 점은 코드의 응집도와 결합도이다. 이 폴더 구조의 경우 응집도를 고려한다면, 도메인 형으로 구성하는 것이 이상적이다. 여기서 도메인 별로 나누다 보니 공통되는 기능을 어떻게 연결 시킬까 하는 고민이 있을 수 있는데, 이 경우 글로벌 폴더를 따로 두어서 관리하는 등으로 나눌 수 있다. (이건 프로젝트에 맞게 설정하면 될 것 같다.)

```markdown
ProjectName
...
  └── demo
      ├── domain
      │   ├── user
      │   └── post
      └── global
          ├── common
          ├── error
          └── util
```



<br>
<br>
