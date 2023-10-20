---
title: "[Spring] AOP (Aspect Oriented Programming, 관심 지향 프로그래밍)"
date: 2023-10-20

categories:
  - java

tags:
  - java
  - spring

---
### **AOP (Aspect Oriented Programming, 관심 지향 프로그래밍)**

공통된 기능을 모듈화하는 것으로 코드의 재 사용성을 증대시키는 방법이다.

프록시 패턴을 기반으로 작성하게 된다. 이런 AOP는 각각 컴파일, 클래스 코딩, 런타임 시점에서 적용할 수 있다.

<br>
<br>

**AOP 용어**

- Advice: 실질적으로 부가 기능, 로직을 정의하는 곳이다.
- Join point : 추상적인 개념으로 advice가 적용될 수 있는 모든 위치이다. 스프링에서는 프록시 패턴-오버라이드를 이용함으로 항상 메서드 실행지점이다.
- Pointcut : 조인 포인트 중에서 advice가 적용될 위치를 선별하는 기능이다. 스프링에서는 메서드 실행 시점이다. (조인 포인트가 메서드 실행지점만 있기 때문)
- Target : advice의 대상이 되는 객체로 Pointcut 이 결정된 객체이다.
- Aspect: advice와 pointcut을 모듈화 한 것이다. @Aspect 과 같은 기능이다.
- Advisor : 스프링 AOP 에서만 사용되는 용어로 advice와 pointcut 한쌍을 의미한다.
- Weaving : 포인트 컷으로 결정된 타겟-조인 포인트에 advice를 적용하는 것이다.
- AOP 프록시 : AOP 를 구현하기 위해 만든 프록시 객체이다. 주로 JDK 동적 프록시 혹은 CGLB 프록시로 기본은 CGBL 프록시이다.

<br>
<br>

**컴파일 시점**

자바 파일을 컴파일러를 통해 클래스를 만드는 시점에서 로직을 추가하는 방식으로 모든 지점에서 적용할 수 있다. AspectJ가 제공하는 특정 컴파일러를 사용해야해서 조건과 복잡하다는 단점이 있다.

<br>

**클래스 로딩 시점**

클래스 파일을 JVM 내부에 클래스 로더에 보관하기 전에 조작해서 로직을 추가하는 방식으로 모든 지점에서 적용할 수 있다. 컴파일 방식과 같이 클래스 로더 조작을 통해 지정함으로 운영이 어렵다.

<br>

**런타임 시점**

실제 스프링이 사용하는 방식으로 런타임에서 적용된다. 실제 대상코드를 유지 하고 프록시를 통해서 부가적인 기능을 적용한다. 프록시는 메서드 오버라이드로 동작하기에 메소드에만 적용할 수 있고 Bean에만 AOP 를 적용할 수 있다는 조건이 있다.

<br>
<br>

### AOP 구현

AOP 구현을 위해서 아래와 같은 의존성을 추가한다. 이를 적용하면 @Aspect 라는 어노테이션을 사용할 수 있다.

```java
implementation 'org.springframework.boot:spring-boot-starter-aop'
```

Aspect을 지정하면 이제 메서드에서 Advice가 실행되는 시점도 지정되는데, 그에 따른 Around, Before, After 등 여러 어노테이션이 제공된다.

<br>

AOP 를 사용하지 않으면 중복되는 코드가 많아서 수정시 작업이 많이 이루어진다. 구현은 보통 어노테이션을 이용한다.

[[Spring] AOP 사용 방법 (예제 코드)](https://programforlife.tistory.com/107)

<br>
<br>
