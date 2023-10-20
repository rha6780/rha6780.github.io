---
title: "[Spring] IoC(Inversion of Control) / DI(Dependency Injection)"
date: 2023-10-20

categories:
  - java

tags:
  - java
  - spring

---
### **IoC : 제어의 역전**

스프링 컨테이너가 프로그램의 제어를 관리하는 것.

<br>

제어의 역전은 모든 제어를 사용하는 쪽에서 관리하도록 뒤집은 것이다. 기존에는 코드 내에서 생명주기나 제어권을 관리하기 위해 코드를 작성하였다. 그렇기에 객체간의 의존성이 있게 되어 결합도가 높아지는 원인이 된다. IoC는 이런 문제점을 해결하기 위한 패턴으로, 스프링 컨테이너가 대신 제어하게 된다.

<br>
<br>


**쓰는 이유**

- 객체간의 결합도를 줄이고 유연한 코드 작성 가능 → 코드 재사용성 및 유지 보수가 편해짐.
- 개발자가 객체 관리를 신경쓰지 않아도 된다.

<br>
<br>

### DI : 의존성 주입

객체간의 의존성을 객체 내부에서 직접 호출하는 대신 외부에서 객체를 생성한 후 넣어주는 방식이다.

<br>

객체 내부에서 new를 통한 생성을 하게 되면, 강한 결합도를 가진다. 강한 결합도를 가진다는 의미는, 해당 객체 내부에 직접 생성을 통한 코드를 작성하면, 내부의 객체를 수정할 때 객체자체를 새로 수정하여야한다는 의미이다. 의존성 주입을 이용하면, 그럴필요 없이 주입하는 객체만 바꾸면 된다.

<br>
<br>

**쓰는 이유**

- 객체간의 느슨한 결합이 가능하다.
- 런타임에서 의존 관계가 결정되어 유연하다.

<br>

**예시**

```java
import ...

@Service
public class ExampleService {
	
	private ExampleRepository exampleRepository;

	public ExampleService(ExampleRepository exampleRepository) {
		this.exampleRepository = exampleRepository;
	}
}
```

위와 같이 구성 했을 때… 아래와 같이 주입이 가능하고, repository의 객체가 변경되면 주입할때 변경된 객체를 넣기만 하면 된다. 오버로딩에 효과적!

```java
// 다른 코드에서 repository를 생성
ExampleRepository exampleRepository = new ExampleRepository();

ExampleService service = ExampleService(exampleRepository);

// EX: 객체 변경 시 이점.
//repository 객체 구성이 변경됨
ExampleRepository exampleRepository = new ExampleRepository(example);

// repository에서 기능 몇가지 달라져도 해당 코드는 그대로
ExampleService service = ExampleService(exampleRepository);
```

<br>
<br>

### **Spring Container(IoC Container)**

스프링에서 IoC와 관련하여 객체들을 관리하는 컨테이너

<br>

**구조**

빈 팩토리, DI 컨테이너, 애플리케이션 컨텍스트 라고 부르기도 하는 IoC Container는 용도에 따라서 조금 다르게 부르기도 한다. 

<br>

**빈 팩토리(Bean Factory) or DI 컨테이너 (DI Container)**

빈 팩토리 또는 DI 컨테이너는 스프링 컨테이너의 최상위 인터페이스로, 빈을 관리하고 조회하는 역할을 담당한다. 

<br>

**애플리케이션 컨택스트(ApplicationContext)**

애플리케이션 컨텍스트는 빈 팩토리를 상속받고, 몇가지를 extends 하여 추가 기능을 제공한다. 일반적으로 IoC 컨테이너는 애플리케이션 컨텍스트를 의미한다.

<br>

추가 기능
- 환경 변수를 구분해서 처리 가능(profile)
- 메시지 소스 국제화 기능(I18n)
- 편리한 애플리케이션 이벤트 발행-구독 지원
- 편리한 리소스 조회

<br>

**차이점 - 빈 로딩 시점**

빈 팩토리 - Lazy Loading : 빈 팩토리의 경우 빈을 사용할 때 빈을 로딩한다.

애플리케이션 컨텍스트 - Eager Loading : 애플리케이션 컨텍스트는 런타임 실행 시 모든 빈을 로딩 시킨다.

<br>
<br>
