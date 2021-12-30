---
title: "순열(Permutation) & 조합(Combination)"
date: 2021-12-01

categories:
  - algorithm
tags:
  - algo
  - math
---

### 순열(Permutation) & 조합(Combination)


**Permutation** 


N개의 수를 순서 배치하는 경우. t는 인덱스 배열

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
				p = t[loc]; t[loc]=t[i]; t[i]=p;
				perm(t, loc+1);
				p = t[loc]; t[loc]=t[i]; t[i]=p;
			}
		}
	}
```

t 배열을 두고, t배열의 수를 계속해서 바꾸면서 진행하는 구조이다. 
else 에 for문을 보면 loc 자리의 수와 i자리의 수를 계속해서 바꾸면서 진행한다. loc을 0부터 시작 시키면, 0과 0자리를 바꾸고, perm(t, loc+1)를 진행하면, 0과 1을 바꾸고....

이를 반복하여서 마지막자리까지 바꾸면, 다시 원상복귀하는 방식이다.

<수정중>


---

**Combiantion**

N개의 수들 중 K개를 뽑는 경우. t는 인덱스 배열

```java
//1은 뽑힘. 0은 뽑히지 않은 경우.
static void comb(int n, int k) {
		if(k==n) {
			for(int i=0; i<n; i++) {
				t[i]=1;
			} 
			proc(); //출력
			return;
		}
		if(k==0) {
			for(int i=0; i<n; i++) {
				t[i]=0;
			}
			proc();
			return;
		}
		t[n-1]=0;
		combination(n-1,k);
		t[n-1]=1;
		combination(n-1,k-1);
		
	}
```



<br>
<br>