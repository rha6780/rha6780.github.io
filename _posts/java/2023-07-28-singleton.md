---
title: "[디자인 패턴] 싱글톤(Singleton) 패턴"
date: 2023-07-28

categories:
  - java

tags:
  - java
  - GOF

---

## 싱글톤 패턴

싱글톤 패턴이란, 객체가 1개만 존재하고, 이를 전역적으로 접근이 가능한 디자인 패턴이다. 고정된 메모리 영역을 받기 때문에 메모리 낭비를 방지 할 수 있고, 전역적으로 접근할 수 있어 데이터를 공유할 수 있다. 절대적으로 1개만 존재하기 때문에 빠른 접근이 가능하지만 동시성을 고려해야한다.

<br>

**문제점**

싱글톤의 문제점은 인스턴스가 너무 많은 일을 하거나 데이터를 너무 많이 공유하면 결합도가 높아지기 때문에 수정 및 유지 보수가 어렵다. (개발-폐쇠 원칙 위배) 또한, 멀티 스레드에서 객체가 1개 이상 생기는 경우가 있을 수 있는 문제 등이 있어 필요한 경우가 아니라면 지양해야한다.

<br>

### **구현**

싱글톤이라는 객체를 만들고 멀티 스레드에서 동시성 문제를 해결해보자.

**단일 객체 생성**

```java
public class Singleton {
	private static Singleton singleton;
	private String name = "Sara";

	// 외부에서 객체 생성을 못하도록 막음.
	private Singleton() {
	} 

	public static Singleton getSingleton() {
		if(singleton == null) { singleton = new Singleton();}
		return singleton;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}
}
```

객체 생성은 위와 같이 아주 간편하다. static 변수로 singleton 이라는 인스턴스가 할당되고 다른 곳에서는 `getSingleton` 를 이용해서 접근이 가능하다. 

```java
// 외부에서는 getSingleton 으로
private Singleton singleton = Singleton.getSingleton();

// Sara 라고 출력됨
System.out.println(singleton.getName());
```

<br>
<br>

**멀티 스레드**

싱글톤에서 아래와 같이 작성했는데, 멀티 스레드에서는 아래와 같이 작성하면 객체가 2개 이상 생성될 수 있다. 그렇기 때문에 synchronized 를 이용해서 이를 해결해야한다.

```java
// 스레드 마다 getSingleton을 호출하면 객체가 생성된다.
public static Singleton getSingleton() {
		if(singleton == null) { singleton = new Singleton();}
		return singleton;
}

// synchronized 를 이용하면 동시성 문제를 해결할 수 있다. 하지만, lock에 의한 성능저하가 있다.
public synchronized static Singleton getSingleton() {
		if(singleton == null) { singleton = new Singleton();}
		return singleton;
}

// LazyHolder
// LazyHolder.SINGLETON 을 호출하는 순간 로드 및 초기화가 되고 동시성을 해결할 수 있다.
public static Singleton getSingleton() {
		return LazyHolder.SINGLETON;
}

private static class LazyHolder {
	public static final Singleton SINGLETON = new Singleton();
}
```

가장 이상적인 방식은 LazyHolder 이다. 초기 클래스 로딩에서 인스턴스를 생성하지 않아 메모리가 점유되어 있지 않는다. LazyHolder.SINGLETON 이 참조되는 순간 클래스 로딩이 진행되면서 인스턴스를 생성한다. 해당 인스턴스 생성은 클래스 로딩 시점 한번 뿐이기 때문에 객체가 여러개 생성되는 것을 막을 수 있다. 그렇기에 가장 추천되는 방식이다.


<br>
<br>

**LazyHolder**

```java
public class Singleton {
  private Singleton() {}

  public static Singleton getInstance() {
    return LazyHolder.SINGLETON;
  }
  
  private static class LazyHolder {
    private static final Singleton SINGLETON = new Singleton();  
  }
}
```

<br>

그렇다면… 이런 싱글톤은 실무에서 어떻게 쓰일까?

<br>

가장 대표적인 것은 DB connection pool 이다. DB 연결이 이루어 지면 계속 사용하기 위해 싱글톤으로 사용한다. 매번 객체를 생성하는 것은 비효율 적이기 때문… 현실적으로는 라이브러리 등에서 제공하기 때문에 직접 구현할 일은 적지만 대표적인 예시기 때문에 알아두자.

<br>
<br>
