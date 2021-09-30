---
title: "Disjoint-set, Union-find"
date: 2021-10-01

categories:
  - algorithm
tags:
  - algo
---

### Disjoint-set

또는 Union-find, 서로소 집합

---

서로소 집합은 집합, 혹은 그룹을 관리하는 효율적인 알고리즘이다. 각 그룹을 트리형식으로 관리하고 주로 두가지 연산을 가진다.


find(x) : x노드의 최고 조상 노드를 찾는 함수

union(x, y) : x가 속한 그룹과 y가 속한 그룹을 합치는 함수


즉 위 연산을 수행하면,,...

{1,2,3,4,5}라는 집합을 아래 처럼 관리가 가능하다.


![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0ead2768-4303-4de9-afa0-31e4127bdf56/Untitled.png)



이 경우 find(3) =1로 2,3,4,5는 최고 조상 노드로 1를 반환한다.

만약 다음과 같은 경우, {1,2,3}, {4,5}를 통합한다고 할 때 다음과 같다.


![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7b6aa15b-518f-4da9-8455-c4b93fe22e02/Untitled.png)


{1,2,3}이 속한 그룹의 최고 조상노드는 1, {4,5} 그룹의 최고 조상노드는 4이다. 두 그룹을 통합시키면 {1,2,3,4,5}로 {4,5}그룹의 최고 조상 노드를 1로 변환하면 쉽게 가능하다.



여기서 {1,2,3}에 find(3)을 해도 1로 나온다. 그림으로는 2 아래에 있다고 표현했지만 실제로는 1 아래에 2연결, 3연결 형태가 되어있다. 간혹 위 그림처럼 그룹내에서 순서를 요구하는 경우도 있다. 다양한 응용을 보면서 이론을 공부하자.


---

JAVA

---

```java
...
static int[] par; //부모노드를 저장하는 배열

public static int find(int x) {
	if(par[x] == x) return x;
	else return par[x] = find(par[x]);
}

public static void union(int x, int y) {
	par[find(x)] = find(x);
}
```


추천문제

---


[1976번: 여행 가자](https://www.acmicpc.net/problem/1976)