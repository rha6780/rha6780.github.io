---
title: "[자료구조] 알고리즘 표현 방식"
date: 2023-09-27
categories:
  - datastructure
tags:
  -
---

**알고리즘**

문제 해결 방법을 추상화 하여 단계적 절차를 논리적으로 기술하는 것

<br>

**쓰는 이유**

특정 문제 상황을 메모리 효율적이고, 빠른 성능으로 해결하기 위해서이다. 정해진 절차나 방법을 공식화하여 표현할 수 있어야 한다.

<br>

## 알고리즘 표현

자연어를 이용한 서술, 순서도, 프로그래밍 언어, 가상 코드 등이 있다.

<br>

**순서도**

순서도는 알고리즘의 과정을 도형들을 이용해 나타낸 것이다. 아래와 같은 도형이 있을때 이를 조합해서 표현할 수 있다.

![Screenshot 2023-09-27 at 2 20 47 AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/8688834a-f7f0-4398-99fd-1f8ce37945bf)

<br>

### **성능 분석 기준**

알고리즘 성능 분석 기준으로는 정확성, 명확성, 수행량, 메모리 사용량, 최적성 등이 있다. 여기서 공간 복잡도와 시간 복잡도가 가장 일반적인 기준이다.

<br>

**공간 복잡도**

알고리즘을 프로그램으로 실행하여 완료 될 때까지 필요한 메모리의 양이다.

공간 복잡도 = 고정 메모리 + 가변 메모리

<br>

**시간 복잡도**

알고리즘을 프로그램으로 실행하여 완료 될 때까지 걸리는 시간이다. 실행 시간의 경우 컴퓨터 성능에 따라 달라질 수 있어 명령문의 실행 빈도수로 계산된다.

시간 복잡도 = 컴파일 시간 + 실행 시간

<br>

## 시간 복잡도 표기법

**빅-오메가 표기법 : Ω(N)**

최선의 경우를 기준으로 시간 복잡도를 계산한다. (Best Case)

<br>

**빅 - 세타 표기법 : θ(N)**

평균적인 경우를 기준으로 시간 복잡도를 계산한다. (Average Case)

<br>

**빅-오 표기법 : O(N)**

최악의 경우를 기준으로 시간 복잡도를 계산한다. (Worst Case)

<br>

일반적으로 빅오 표기법을 이용해서 성능을 파악하고, 연산 횟수에 따라 다음과 같이 작성한다.

<br>

O(1) : 상수 시간 : 입력 크기 N에 상관없이 일정한 연산을 수행하는 경우

O(log N) : 로그 시간 : 입력 크기(N)가 커질 때 연산 횟수가 log N에 비례하는 경우

O(N) : 선형 시간 : 입력 크기(N)가 커질 때 연산 횟수도 N에 비례하는 경우

O(N^2) : 2차 시간 : 입력 크기(N)가 커질 때 연산 횟수도 N^2에 비례하는 경우

O(2^N) : 지수 시간 : 입력 크기(N)가 커질 때 연산 횟수도 2^N에 비례하는 경우

<br>
<br>