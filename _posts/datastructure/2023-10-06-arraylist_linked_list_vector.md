---
title: "순차 리스트(Array List) / 연결 리스트(Linked List) / 벡터(Vector)"
date: 2023-10-06
categories:
  - datastructure
tags:
  -
---


이전 포스트에 자바에서 List가 인터페이스라는 이야기를 하였다. 이번에는 해당 인터페이스를 구현한 자료구조에 대해서 정리하였다.

<br>

## 순차 리스트(Array List)

**정의**

순차 리스트는 여러 타입의 데이터를 순차적으로 저장 나열한 자료구조이다.

<img width="538" alt="ArrayList Structure" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/fe588bd2-8dee-4382-a59e-67ec7920d8d0">


<br>
<br>

**특징**

- index를 통해서 데이터 찾기가 쉽고 빠르다.
- 논리적인 순서와 물리적인 순서가 같다. (각 데이터가 메모리 공간에 차례대로 존재)
- 데이터 삭제 및 추가 등이 일어날 때 메모리 공간이 확장/축소 된다. (그만큼 오버헤드, 시간이 걸린다.)
- 메모리 크기가 유동적이다.

<br>
<br>

**삽입 등에서 메모리는 어떻게 유동적으로 변할까?**

아래 그림과 같이 뭔가 추가하는 경우 현재 값을 복사하면서 값을 추가하기 때문에 기존 메모리크기가 클수록 오버헤드도 클 수 있다.

<img width="488" alt="ArrayList Add Data" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/fd5c1281-0874-4d3f-aa01-8e1fa66e760a">


<br>
<br>

**Array와 ArrayList**

ArrayList는 이름과 같이 배열을 기반으로 구현된 리스트이기 때문에 메모리가 연속적으로 할당된다는 점과 index를 통한 빠른 탐색이 가능하다는 공통점이 있다.

<br>

**차이점**

배열의 문제점인 메모리 공간을 유동적으로 사용할 수 없는 문제를 해결한 것이다. 또한, 데이터 타입 또한 여러가지로 저장할 수 있다는 차이점이 존재한다. 사실상 리스트의 특징과 같다.

- 메모리 유동적
- 타입 제한 없음

<br>

**언제 사용할까?**

순서를 보장하며 데이터에 빈번히 접근해야하고, 가끔 데이터 삭제, 추가 등이 일어날 때

<br>

**자바 코드로는**

```java
//100개의 Integer형 데이터를 담을 수 있는 순차 리스트 arr 정의
ArrayList<Integer> arr = new ArrayList<Integer>(100);

//배열과 다르게 초기 용량을 설정하지 않을 수 있다.(일반적으로 많이 씀)
ArrayList<Integer> arr = new ArrayList<Integer>();

//또한, 다른 Collection 값으로 설정할수도 있다. (이건 JAVA Collection 다루기에서..)
ArrayList<Integer> arr = new ArrayList<Integer>(collection1);
```

<br>
<br>

## 연결 리스트(Linked List)

**정의**

노드를 통해 데이터, 객체를 순서데로 저장하는 자료구조이다.

연결리스트는 노드의 링크(노드끼리 연결)를 한쪽 방향으로 하는 단순 연결리스트, 양쪽으로 연결하는 이중 연결 리스트가 있다. 연결 리스트의 첫번째 노드를 Head 라고 부른다.

<br>

**단순 연결 리스트(Singly Linked List)**

다음 노드의 주소를 현재 노드에 저장

![Singly Linked List](https://github.com/rha6780/rha6780.github.io/assets/47859845/10b96e55-2bd0-4280-9519-22a5e07cf893)

<br>

**이중 연결 리스트(Doubly Linked List)**

다음 노드의 주소, 이전 노드의 주소를 현재 노드에 저장

![Doubly Linked List](https://github.com/rha6780/rha6780.github.io/assets/47859845/c8cb06e0-dff1-42ee-b411-694d66b97efb)

단순 연결 리스트와 이중 연결 리스트는 이전 노드를 탐색할 수 있는 가? 의 차이가 있다. 이중연결 리스트를 이용하면 노드에 이전 노드의 주소를 저장하여서 노드를 순회 할 수 있다는 장점이 있다. **원형 연결 리스트** 도 있는데, 단순 연결 리스트에서 처음과 끝 노드가 연결되는 특징만 알아두면 될 것 같다.

<br>
<br>

**특징**

- 논리적 순서와 물리적 순서가 다르다. (각 데이터의 메모리가 연속적이지 않다.)
- 삽입, 삭제 등이 효율적이다.
- 어떤 데이터에 접근하기 위해 순차적으로 접근해야한다. (C를 찾으려면 A→B→C 차례대로 접근해야함)
- 메모리 크기가 유동적이다.

<br>

**삽입 등에서 메모리는 어떻게 유동적으로 변할까?**

추가될 노드의 주소를 바로 앞 노드의 주소로 설정하고 다음 노드의 주소를 추가될 노드의 Next로 지정하면 된다. 해당 노드의 메모리가 순차적이지 않아도 되기 때문에 할당은 유동적으로 일어난다.


![Linked List Add Node](https://github.com/rha6780/rha6780.github.io/assets/47859845/15dd1d15-08da-467e-bb74-402900024937)

이중 연결 리스트의 경우도 앞 주소의 변경이 추가된다.

<br>

**언제 사용할까?**

순서를 보장하고, 탐색이 별로 없고, 삽입, 삭제가 빈번히 일어날 때

<br>

배열과 순차 리스트의 비해 삽입 삭제가 효율적이지만, 해당 구조는 특정 순서의 데이터를 찾기 위해서는 첫번째 노드에서 부터 찾아야 하기 때문에 탐색이 많을때 비효율적이다.


<br>

**자바 코드로는**

```java
LinkedList<Integer> link = new LinkedList<Integer>();
```

<br>
<br>

## 벡터(Vector)

**정의**

여러 타입의 데이터를 순차적으로 저장 나열한 자료구조이다.

<br>

**특징**

ArrayList 와 동일한 구조를 가져서 ArrayList와 동일한 특징을 가진다. 

- 동기화 된 메소드로 이루어져 스레드 환경에서 안정성이 높다.
- 스레드가 1개 일때에도 동기화 되어 ArrayList에 비해 추가, 검색, 삭제의 성능은 좋지 않다.

<br>

**자바 코드로는**

```java
Vector<Integer> vec = new Vector<Integer>();
```

<br>

**언제 사용할까?**

ArrayList와 동일한 구조이지만, 스레드 환경에서 안정적이기 때문에 스레드 환경일때 사용한다. 하지만, ArrayList에도 동기화와 관련된 옵션이 있기 때문에… 개인의 취향에 따라 사용하는 것 같다.

<br>
<br>
