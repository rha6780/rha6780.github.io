---
title: "[디자인 패턴] 추상 팩토리(Abstract Factory) 패턴"
date: 2023-07-31

categories:
  - java

tags:
  - java
  - GOF

---

## 추상 팩토리

추상 팩토리란, 구체적인 클래스를 지정하지 않고 인터페이스를 통해 연관되는 객체들을 그룹으로 표현한 패턴이다. 즉, 상세 서브 클래스를 정의하지 않아도 독립적인 객체 군을 생성하기 위해 인터페이스를 제공하는 패턴으로, 기존 팩토리 패턴과 달리 `if-else` 조건문이 없다.

<br>

**구현**

```java
interface AbstactProductA {
}

class ProductA1 implements AbstactProductA {
}

class ProductA2 implements AbstactProductA {
}

interface AbstactProductB {
}

class ProductB1 implements AbstactProductB {
}

class ProductB2 implements AbstactProductB {
}
```

<br>

위와 같이 AbstactProductA, AbstactProductB 인터페이스가 존재하고, 각 인터페이스를 가지는 프로덕트 1,2 들이 있다고 가정하자. 여기에서 필요한 제품군을 선택해서 구현하는 경우 아래와 같이 작성하면 된다.

<br>

```java
interface AbstactFactory {
	AbstactProductA createProductA();
	AbstactProductB createProductB();
}

// 1번 라인의 제품 생성
class AbstactFactory1 implements AbstactFactory {
	public AbstactProductA createProductA() {
		return new AbstactProductA1();
	}
	public AbstactProductB createProductB() {
		return new AbstactProductB1();
	}
}

// 2번 라인의 제품 생성
class AbstactFactory2 implements AbstactFactory {
	Apublic AbstactProductA createProductA() {
		return new AbstactProductA2();
	}
	public AbstactProductB createProductB() {
		return new AbstactProductB2();
	}
}

// --- 클라이언트에서 ---
//1번 라인의 제품을 원하는 경우
factory = new AbstactFactory1();

AbstactProductA AProduct = factory.createProductA();
```

<br>

이런식으로 접근이 가능하다. 즉, 조건문을 계속해서 추가하는 것이 아니라, 생성하는 단계에서도 추상화를 통해서 정의 할 수 있게 작성하는 것이다. 기존 팩토리와 달리 특정 클래스에 의존하는 경향을 줄일 수 있고, 제품군을 이용해서 대체하거나 코드 분리가 좋다.

<br>

하지만, 기존 팩토리 메소드와 동일하게 새로운 제품이 추가될 때 코드를 구현해야해서 코드양이 많아지는 문제가 있고, 추상 팩토리 세부 사항이 변경되는 경우 모든 제품에 영향을 끼치기 때문에 새로운 제품이나, 기존 값을 수정하는 것에는 좋지 않을 수 있다.

<br>

**추상 팩토리 패턴은 언제 사용하나?**

추상 팩토리 패턴의 가장 큰 장점은 비슷한 제품 군 끼리 모을 수 있다는 것으로, 이와 비슷한 구조일때 사용하는 것이 좋다. 그렇지 않은 경우 팩토리 메소드가 가독성이나 관리면에서 더 좋을 수 있으니 한번 쯤 검토해보는 것이 필요하다.

<br>
<br>
