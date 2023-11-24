---
title: "[자료구조] 스택(Stack) / 큐(Queue) / 덱(Dequeue)"
date: 2023-10-07
categories:
  - datastructure
tags:
  -
---

## 스택(Stack)

**정의**

한쪽에서만 넣고 뺄 수 있는 후입선출(LIFO: Last In Frist Out) 형식의 자료 구조이다.

<img width="487" alt="Screenshot_2023-10-07_at_4 37 49_PM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/da3500fd-c897-4ccb-80f4-f7b0ec98ca94">

<br>

**특징**

- 삽입, 삭제가 Top 에서만 이루어진다.

<br>
<br>

## 큐(Queue)

**정의**

한쪽에서 삽입되면 다른 한쪽에서 나오는 선입선출(FIFO: First In First Out) 형식의 자료구조이다.

<img width="475" alt="Screenshot_2023-10-07_at_4 40 42_PM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/e0745f60-cccf-4127-b11b-3c6da7620563">

<br>

**특징**

- 삽입과 삭제 연산이 이루어지는 곳이 정해져 있고, 넣은 순서대로 삭제된다.

<br>
<br>

**큐의 종류**

큐는 삽입이 일어나는 Rear과 삭제가 일어나는 Front가 있다. 큐는 배열로 구현하는데, 삽입, 삭제를 어떻게 처리하는 지에 따라서 선형 큐와 원형 큐로 나뉜다.

<br>

**선형 큐**

선형 큐는 삽입, 삭제를 index+1로 처리한다.

<img width="998" alt="Screenshot_2023-10-07_at_5 08 55_PM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/9b5d30e4-1e95-4e78-8d9b-c0ce89c498c3">

<br>

**원형 큐**

원형 큐는 전체 큐 사이즈의 나머지 연산으로 처리한다.

<img width="1080" alt="Screenshot_2023-10-07_at_5 16 43_PM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/ac174725-37b7-4fce-8869-e5b9cbf52794">

여기서 배열의 포화 상태를 확인하기 위해 주로 배열의 한칸을 남겨두곤 한다. (위 그림에서는 아마 5를 빈칸으로 두었다.)

<br>

**연결 큐**

연결 큐는 단순 연결 리스트로 큐를 구현한 것을 의미한다.

<br>
<br>

## 덱(Dequeue)

**정의**

양쪽에서 삽입 삭제가 가능한 자료 구조이다.

<img width="471" alt="Screenshot_2023-10-07_at_4 44 02_PM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/bca43c97-10f1-4db1-87ae-4ba46288ae5e">

<br>

**입력 제한 덱(Scroll)**

- 양쪽에서 삭제가 가능하지만, 한쪽에서는 삽입을 제한하는 덱

<br>

**출력 제한 덱(Shelf)**

- 양쪽에서 삽입이 가능하지만, 한쪽에서는 삭제를 제한하는 덱

<br>

**특징**

- 양쪽에서 삽입 삭제가 가능하기 때문에 큐나 스택과 달리 입출력 순서가 보장되지 않는다.

<br>
<br>
