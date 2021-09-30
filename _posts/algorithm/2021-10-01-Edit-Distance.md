---
title: "DP-Edit Distance"
date: 2021-10-01

categories:
  - algorithm
tags:
  - algo
  - DP
---

### 편집거리, 최소편집

<br>

---

편집거리는 문자열 A에서 B로 변경하는데 필요한 최소연산횟수를 구하는 문자열 유사도 판단 알고리즘이다.

A : Kitten

B : Sitting

<br>

---

**문제를 푸는 핵심은 A를 B로 만들기 위해 삽입/삭제/수정 연산이 있고, 이를 수행하기 위해서 두 문자열에 대해서 한 문자 씩 비교해 나가며 따져봐야 한다.**

<br>

D가 문자열의 수정 횟수일 때 각 연산에 대해 다음과 같다. i: A의 원소, j: B의 원소

1. D[i-1][j]에서 A[i]를 변형할 때 A[1, i-1]은 B[1, j]와 동일하게 변형된 상태이다. 이때 i번째에 대해서 A[i]를 삭제해야 A와 B가 같기 때문에 삭제 연산을 한다.
2. D[i][j-1]에서 B[j]를 변형할 때 A[1, i]가 B[1, j-1]와 동일하게 변형된 상태이다. 이때 A[i]뒤에 B[j]를 삽입한다.
3. D[i-1][j-1]에서 A[i]와 B[j]가 다르다면 A[i]를 B[j]로 수정하는 연산을 한다.
<br><br>
---

ex) 

 삭제연산: A[1,5]까지 right로 같다. 이때 o를 삭제한다. 이전 값(D[i-1][j-1]+1)+1

- A: righto

- B: right

 삽입연산: A[1,4]까지 righ로 같다.이때 t를 삽입한다. 이전 값(D[i][j-1])+1

- A: righ

- B: right

 수정연산: A[1,4]까지 righ로 같다.이때 y를 수정한다. 이전 값(D[i-1][j])+1

- A: righy

- B: right


<br><br>

---

점화식

```java
(if A[i] != B[j]) //수정이 필요한 경우
D[i][j] = min D[i-1][j-1]+1 
							D[i-1][j]+1
							D[i][j-1]+1
```

삭제, 삽입 시, j에 -1를 하는 이유는 for문에서 j++을 하기 때문에 삭제 연산시 다시 비교가 불가능하기 때문에, -1을 해서 삭제 연산 이후 B[j]가 A[i]의 다음 문자와 비교할 수 있게 한다.

<br>

JAVA

---

```java
String A;
String B;
int[][] D = new int[A.length()+1][B.length()+1];

for(int i=0; i<=A.length(); i++) {D[i][0] = i;}
for(int j=0; j<=B.length(); j++) {D[0][j] = j;}

for(int i=1; i<=A.length(); i++) {
	for(int j=1; j<=B.length(); j++) {
		if(A.charAt(i) == B.charAt(j)) {
			D[i][j] = D[i-1][j-1];
		}
		else {
			D[i][j]=Math.min(Math.min(D[i-1][j-1]+1,D[i-1][j]+1), D[i][j-1]+1)
		}
	}
}

System.out.println(D[A.length()][B.length()]);
```

<br><br>
추천문제

---

[15483번: 최소 편집](https://www.acmicpc.net/problem/15483)

<br><br>