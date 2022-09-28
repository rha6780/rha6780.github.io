---
title: "Edit-Distance"
date: 2022-09-28

categories:
  - algorithm
tags:
  - algo
  - Edit-Distance
---

### Edit Distance

**편집거리, 최소편짐**

<br>

편집거리는 문자열 A에서 B로 변경하는데 필요한 최소연산횟수를 구하는 문자열 유사도 판단 알고리즘이다.

<br>

```
A : Kitten
B : Sitting
```

위 A,B를 예시로 들 때 A를 B로 만들려고 할때 수정되는 횟수를 의미한다. 단어길이가 다르기 때문에 수정 뿐만 아니라 삭제도 일어나는 것을 인지해야한다.

<br>

즉, 삽입, 삭제, 수정 연산을 최소로 하면서 A->B로 만드는 것이다.

<br>
<br>

그렇다면 이러한 문제를 풀기 위해서는 두 단어가 얼마나 다른지 알아야 한다. 그러기 위해서는 각 문자마다 비교하면서 따지는 게 첫번째 생각이다...!

<br>
<br>

```
D를 문자열의 수정 횟수라고 가정하자.
i: A의 원소
j: B의 원소
```

<br>

과정
1. D[i-1][j]에서 A[i]를 변형할 때 A[1, i-1]은 B[1, j]와 동일하게 변형된 상태이다. 이때 i번째에 대해서 A[i]를 삭제 해야 A와 B가 같기 때문에 삭제한다.
2. D[i][j-1]에서 B[j]를 변형할 때 A[1, i]가 B[1, j-1]와 동일하게 변형된 상태이다. 이때 A[i]뒤에 B[j]를 삽입한다.
3. D[i-1][j-1]에서 A[i]와 B[j]가 다르다면 A[i]를 B[j]로 수정하는 연산을 한다.

<br>

다시 풀어서 예시를 들면 다음과 같다.

<br>

ex)
삭제연산: A[1,5]까지 right로 같다. 이때 o를 삭제한다. 이전 값(D[i-1][j-1]+1)+1

```
    A: righto
    B: right
```
삽입연산: A[1,4]까지 righ로 같다.이때 t를 삽입한다. 이전 값(D[i][j-1])+1
```
    A: righ
    B: right
```
수정연산: A[1,4]까지 righ로 같다.이때 y를 수정한다. 이전 값(D[i-1][j])+1
```
    A: righy
    B: right
```
<br>

<br>

위 3가지 과정을 가지게 된다. 그러면 이제 A의 첫번째 글자 부터 B의 마지막 글자까지 차례로 확인하면서 연산이 이루어지는게 좋은지 살펴본다.

<br>

---

<br>

**점화식**

```java
(if A[i] != B[j]) //수정이 필요한 경우
    D[i][j] = min ( D[i-1][j-1]+1, 
	                D[i-1][j]+1,
		            D[i][j-1]+1)
```

삭제, 삽입 시, j에 -1를 하는 이유는 for문에서 j++을 하기 때문에 삭제 연산시 다시 비교가 불가능하기 때문에, -1을 해서 삭제 연산 이후 B[j]가 A[i]의 다음 문자와 비교할 수 있게 한다.

<br>

---

<br>

JAVA

---

```java
...
//visit[]은 방문 여부
//edge[][]은 근접한 노드 여부

public static void BFS(int cur) {
	Queue<Integer> que = new LinkedList<Integer>();
	visit[cur] = true;
	que.add(cur);

	while(!que.isEmpty()) {
		int t = que.poll();

		for(int i=0; i<N; i++) {
			if(visit[i] || !edge[cur][i]) continue;
			visit[i] = true;
			que.add(i);
		}
	}
}
```
<br><br>

추천문제

---

[1260번: DFS와 BFS](https://www.acmicpc.net/problem/1260)

<br><br>