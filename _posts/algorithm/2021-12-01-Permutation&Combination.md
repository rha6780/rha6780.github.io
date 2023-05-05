---
title: "순열(Permutation)"
date: 2021-12-01

categories:
  - algorithm
tags:
  - algo
  - math
---

### 순열(Permutation)


**Permutation** 


N개의 수를 순서 배치하는 경우. t는 인덱스 배열일 때 모든 순서 조합을 출력하는 경우.

```java
static void perm(int[] t, int loc) {
	int p;
	if(loc == N) {
		for(int i=0; i<N; i++){
			System.out.print(t[i]+" ");
		}
		System.out.println();
		return;
	}
	else {
		for(int i=loc; i<N; i++) {
			p = t[loc]; t[loc]=t[i]; t[i]=p; // 값 변경
			perm(t, loc+1);
			p = t[loc]; t[loc]=t[i]; t[i]=p; // 원상복구
		}
	}
}
```

t 배열을 두고, t배열의 수를 계속해서 바꾸면서 진행하는 구조이다. 

else 에 for문을 보면 loc 자리의 수와 i자리의 수를 계속해서 바꾸면서 진행한다. loc을 0부터 시작 시키면, 0과 0자리를 바꾸고, perm(t, loc+1)를 진행하면, 0과 1을 바꾸고....

for 문을 통해서 N-1 까지 진행되면 모든 순서를 출력하게 된다. perm 이라는 메소드에서 출력을 완료하면 다시 원산복구 시킨다.



<br>
<br>
