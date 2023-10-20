---
title: "[Spring] PSA(Portable Service Abstraction)"
date: 2023-10-20

categories:
  - java

tags:
  - java
  - spring

---

### PSA(Portable Service Abstraction)

일관화 된 서비스 추상화로 하나의 추상화로 여러 서비스를 제공하는 것을 의미한다. DB에서는 추상화된 인터페이스를 JDBC(Java Database Connectivity) 라고 하는데, 각 DB 마다 데이터 베이스에 접근하는 java 드라이버따로 있지만 공통된 인터페이스를 가지고 이를 주입해서 생성하기 때문에 해당 드라이버를 통해서 항상 똑같은 기능을 하게 된다.

<br>

### 대표적인 추상화

PSA와 관련해서 대표적인 예시는 JDBC, JPA, Hibernate 이다. 아래 그림과 같이 3가지 모두 다른 형태로 트랜잭션이 일어나지만, 공통적으로 데이터 무결성을 지키기 위해서 commit, rollback이 일어난다. 해당하는 기능이 PlatformTransactionManager 인터페이스에 정의가 되어있고 각각 환경에 맞게 구현한 TxManager가 있는 상태이다. 해당 TxManager가 실행시에 주입해서 사용되기 때문에 개발자인 우리는 따로 서비스 코드를 손보지 않고 어떤걸 사용할지 설정만 해주면 된다.

<br>

<img width="421" alt="Screenshot_2023-10-05_at_10 44 33_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/4fafdec0-528c-4638-8f2f-7d11fdaaaf86">

출처 : 토비의 스프링 3.1 5장

<br>

즉 정리하자면…

- 공통된 추상화가 있고, 이를 구현한 객체를 사용시에 주입 → 환경, 기술에 상관없이 사용할 수 있다.

스프링의 POJO 로서 중요한 원리 중 하나이다.

<br>
<br>
