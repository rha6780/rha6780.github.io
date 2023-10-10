---
title: "[Spring Boot] Bean 이란?"
date: 2023-08-14

categories:
  - java

tags:
  - java
  - spring

---


Spring에는 Spring Container, IoC Container 라는 것이 있다. 

<br>

Container는 인스턴스의 생명주기를 관리하고, 개발자가 작성한 코드 처리 과정을 위임받은 독립적인 것으로, 생성된 인스턴스들에게 다양한 기능을 제공한다. 즉, 설정만 제대로 한다면, 작성한 코드를 참조하고, 객체의 생성 소멸을 컨트롤하게 된다. 종속 객체의 주입을 이용해서 Application 을 구성하는 Component 들을 관리하는 역할을 한다. (IoC/DI 포스트를 참고하자.)

<br>

여기서 Spring Container 에서 생성되는 객체를 Bean 이라고 한다.

![Spring bean](https://github.com/rha6780/rha6780.github.io/assets/47859845/7a3ecc98-3754-4116-b27f-39ba15ef084b)


<br>
<br>

## Bean

Bean 은 Spring Bean Container에 존재하는 객체로 IoC Container가 인스턴스화, 생성 등을 관리한다. Spring에서 Bean은 보통 싱글톤으로 존재하고, POJO 를 Beans 라고 부른다. Beans는 Container에 제공하는 메타 데이터(XML)에 의해 생성되는데, 이 메타 데이터를 이용해서 Bean의 라이프 사이클, 종속성을 알수가 있다.

<br>

new 를 이용해서 생성하는 객체는 Bean이 아니고, ApplicationContext.getBean() 으로 얻는 객체가 Bean이다. 빈이 **싱글톤**이라는 것을 잊지 말자.

<br>

**생성방식**

Bean은 컴파일 시에 생성되는데, 주로 아래와 같을때 생성된다.

- 특정 어노테이션 (@Controller, @Service 등)
- @Configuration 하위에 @Bean 어노테이션
- XML (일반 Spring일 때)

<br>
<br>

**component Scanning**

`IoC Container`를 만들고 그 안에 Bean을 등록할때 사용하는 인터페이스들을 `Life Cycle Callback` 이라고 부른다. 콜백 중에는 `@Component`가 붙어있는 모든 클래스의 인스턴스를 생성해 Bean으로 등록하는 작업을 수행하는 `Annotation Processor`가 등록되어있다. 여기서 `@ComponentScan` 어노테이션이 붙어있는 클래스가 이 방식을 따른다. 단순히 해당 클래스만 Bean으로 등록하는 것이 아니라 해당 클래스가 있는 package에서 모든 하위 package의 클래스를 탐색하여 `@Component`를 찾게 된다. `@Controller` 어노테이션 등에도 있기 때문에 실제로 개발할 때 한번쯤 확인하면 될 것 같다.

<br>
<br>

**Configuration**

Configuration 은 클래스에 @Configuration 이라는 어노테이션을 사용해서 직접 Bean을 등록한다. 하위에 @Bean 을 이용해서 등록하는데 예시로는 아래와 같다.

```java
@Configuration
public class ExConfiguration {
	@Bean
	public ExController exController() {
		return new ExController;
	}
}
```

여기서 리턴되는 ExController가 Bean으로 등록된다. 내부적으로는 @Configuration 어노테이션 내부적으로 @Component를 사용하기 때문에 @ComponentScan의 검색 대상이 되기 때문에 방법은 비슷하다. 위와 같이 클래스에 정의하거나, 또는 XML 방식으로 작성하는 방식이 있다.

<br>

```java
<bean id="..." class="..."></bean>

<bean id="..." class="..." scope="singleton"></bean>
...
```

이런식으로 정의할 수도 있다.


<br>
<br>

여기서 Scope에 싱글톤이라고 작성하였는데, 해당 스코프에 넣을 수 있는 것은 singleton, prototype, MVC 방식이라면, request, session 등을 넣을 수 있다.



<br>
<br>
