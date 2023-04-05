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


---

**Combiantion**

N개의 수들 중 K개를 뽑는 경우. t는 인덱스 배열일 때 모든 조합을 출력하는 경우.

```java
//1은 뽑힘. 0은 뽑히지 않은 경우.
static void comb(int n, int k) {
	if(k==n) {
		for(int i=0; i<n; i++) {
			t[i] = 1;
			
		}
		return;
	}
	if(k==0) {
		for(int i=0; i<n; i++) {
			t[i] = 0;
			System.out.print(t[i]+" ");
		}
		return;
	}
	t[n-1] = 0;
	comb(n-1, k);
	t[n-1] = 1;
	comb(n-1, k-1);
	
}
```

`K==N`이라면 전부 다 뽑는 것이기 때문에 1(뽑힘)로 두고 출력한다.

`K==0`이라면 전부 다 뽑지 않은 것이기 때문에 0(뽑지 않음)로 두어서 출력한다. 

이 상태에서 DP를 진행한다. DP는 간단하다. comb의 n은 현재 남아있는 숫자의 개수와 같다. 즉 하나를 뽑으면 n-1이 되는 것이다. 그렇기에 n개에서 하나의 숫자를 뽑지 않은 경우 t[n-1] = 0으로 두고, n-1인 경우 조합을 다시 시도한다. 조합이 끝나면, 다시 t[n-1] = 1 로 두어서 뽑은 경우 다시 조합을 시작한다.

이렇게 계속 comb를 호출하는 경우 k==n-1 이나 k-1 == 0이 되는 순간이 있기 때문에 모든 경우에 대해서 출력하게 된다.

<br>
<br>
