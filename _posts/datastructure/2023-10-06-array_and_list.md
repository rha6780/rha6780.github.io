---
title: "배열(Array) / 리스트(List)"
date: 2023-10-06
categories:
  - datastructure
tags:
  -
---

### 배열(Array)

**정의**

배열은 한가지 타입의 데이터를 순차적으로 저장 및 나열한 자료구조이다.

<img width="538" alt="Array Structure" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/b7b991ed-f8a7-4780-b429-2ce26487769d">

<br>
<br>

**특징**

- index를 통해서 데이터 찾기가 쉽고 빠르다.
- 데이터 삭제 시 해당 메모리가 남아있어 낭비가 있을 수 있다.
- 메모리 크기가 고정적이다. (메모리에 연속적으로 존재)

<br>
<br>

**언제 사용할까?**

데이터 크기가 고정적이고 빈번히 접근해야할 때

<br>

**자바 코드로는**

```java
//100개의 Integer형 데이터를 담을 수 있는 배열 arr 정의
int[] arr = new int[100];
```

<br>
<br>
<br>

### 리스트(List)

**정의**

순서를 가진 데이터, 객체의 집합

<br>
<br>

**특징**

- 순서가 있다.
- 수정, 삭제 추가 등이 유동적으로 실행될 수 있다.
- 여러 타입의 데이터, 객체를 저장할 수 있다.

<br>
<br>

**언제 사용할까?**

사실 자바에서는 인터페이스로 쓰이기 때문에 목적에 따라 구현체가 나뉜다. 주로 순차 리스트, 연결 리스트로 나뉘는데, 자바의 List를 구현하는 방식으로는 ArrayList, LinkedList, Vector가 있다.

<br>

**자바 코드로는**

```java
// List로 정의하되 실제 객체 구현은 다르게 가능하다.
List<Integer> list = new ArrayList<Integer>();

List<Integer> list = new LinkedList<Integer>();

List<Integer> list = new Vector<Integer>();
```



<br>
<br>
