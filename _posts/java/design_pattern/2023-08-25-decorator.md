---
title: "[디자인 패턴] 데코레이터(Decorator) 패턴"
date: 2023-08-25

categories:
  - java

tags:
  - java
  - design_pattern

---

## 데코레이터 패턴

데코레이터 패턴이란, 동작을 포함하는 특수 wrapper 객체 안에 객체를 배치해 새 동작을 추가할 수 있는 디자인 패턴이다. 

<br>

**장점**

기존 코드를 수정하지 않고도 동적으로 확장할 수 있는 것이 장점이다. 구성과 위임을 통해서 새로운 행동을 추가할 수 있다. 여러 요소를 조합해서 사용하는 클래스거나 수정이 너무 빈번하게 일어나는 객체에 사용하면 좋다.

<br>

**단점**

의미 없는 객체나 코드가 많이 추가될 수 있다. 또한, 많이 사용하면 코드가 복잡해질 수 있다.

<br>

**구현**

```java
public interface Component {
	String add();
}

public class Coffee implements Component {

	@Override
	public String add() {
		return "일반 커피 음료";
	}
}

abstract public class Decorator implements Component {
	private Component coffeeComponent;

	public Decorator(Component coffeeComponent) {
		this.coffeeComponent = coffeeComponent;
	}

	public String add() {
		return coffeeComponent.add();
	}
}
```

<br>

위 구성에서는 재료가 있고, 베이스가 커피이고 재료를 추가하는 형식으로 구성된다. Decorator 클래스는 추상클래스로 각 재료들이 이 클래스를 상속받아서 구현하게 된다.

<br>

```java
public class WhippDecorator extends Decorator {
	public WhippDecorator(Component coffeeComponent) {
		super(coffeeComponent);
	}

	@Override
	public String add() {
		return super.add() + "휘핑 추가";
	}
}
```

<br>

휘핑 추가에 대한 데코레이터를 정의하여 커피에 휘핑을 추가한다.

<br>

```java
public class MlikDecorator extends Decorator {
	public MlikDecorator(Component coffeeComponent) {
		super(coffeeComponent);
	}

	@Override
	public String add() {
		return super.add() + "- 우유 추가됨";
	}
}
```

<br>

우유 추가로 정의하고 이를 실제 조합에서 다음과 같이 사용할 수 있다.

<br>

```java
public class Main {

	public static void main(String[] args){
		Component basic = new Coffee();
		System.out.println("일반 커피:"+basic.add());

		Component whippCoffee = new WhippDecorator(new Coffee());
		System.out.println("휘핑 + 커피:" + whippCoffee.add()); // 휘핑 + 커피 : 커피 - 휘핑 추가됨

		Component mlikCoffee = new MlikDecorator(new Coffee());
		System.out.println("우유 + 커피:" + mlikCoffee.add()); // 우유 + 커피 : 커피 - 우유 추가됨
	}

}
```

<br>

위 구현에서 알 수 있듯이 실제 원본 객체의 인터페이스가 있고, 원본객체를 꾸밀 수 있는 데코레이터 클래스가 존재한다. 이러한 데코레이터 클래스 들도 베이스가 되는 추상 클래스가 있기 때문에 추상 클래스에서 작성한 기능의 위임을 받아 실행하기 때문에 각 데코레이터 클래스 마다 구성만 달리 가져가는 구성이다.

<br>
<br>
