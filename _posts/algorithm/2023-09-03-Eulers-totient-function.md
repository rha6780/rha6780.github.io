---
title: "오일러 피(파이)함수(Eular's phi fuction)"
date: 2023-09-03
# toc: true
categories:
  - algorithm
tags:
  - algo
  - math
---

# 오일러 피(파이) 함수

1~N 까지 수에서 N과 서로소인 수의 갯수를 구하는 함수를 ⏀(N)으로 표시하고 이에 대한 여러 성질을 이용해서 문제를 풀 수 있다.

<br>

## **성질**


💡 p^k 에서 p가 소수이고 k가 1 이상의 자연수 일 때, ⏀(p) = p-1 이다. 역으로 ⏀(n) = n-1 이라면 n 은 소수이다. (자기 자신이 소수이기 때문에 자신보다 작은 모든 수가 서로소이다.)

<br>


💡 p^k 이하의 p의 배수가 아닌 수(p와 서로소인 수)는 p^k - p^{k-1} 개가 존재한다. p^k 의 서로소가 아닌 수를 찾는다면, p의 배수인 p, 2p, 3p..(p^{k-1})p 로 총 p^{k-1} 개가 있다. 여기서 전체 p^k 중에 서로소가 아닌 수 p^{k-1}를 뺀 값이 ⏀(p^k) 가 되는 것이다.

<br>

![Eulers phi](https://github.com/rha6780/rha6780.github.io/assets/47859845/d1201c14-cc54-4f12-aef9-0ce633ed1b50)


<br>

💡 곱셈적 함수로, m 과 n이 서로소라면 ⏀(mn) = ⏀(m)*⏀(n) 이다.



<br>

## **알아가기 전에…**

오일러 피 함수는 페르마의 소정리를 다시 정리한 오일러 정리를 알아야 한다. 페르마 소정리는 모듈로 계산에서 한번 소개를 했는데, 요약하면 다음과 같다. 이건 나중에 좀 더 보충해서 설명하도록 하겠다.

<br>

페르마의 소정리 :  a^{p-1} == 1 mod p (단, a 와 p는 서로소)

<br>

오일러 정리 : a^{⏀(p)} == 1 mod p (단, a와 p은 서로소)

<br>

페르마의 소정리에서 p가 소수인 경우 오일러 정리로 변환 할 수 있다. 즉, p은 소수일때 성립된다. p가 소수일때 성질 1에 의해서 ⏀(p) = p-1이 된다. 

<br>

**구현**

실제 알고리즘 문제에서는 숫자 N이 주어지면, 해당 N과 서로소인 양수의 갯수를 구하는 등으로 문제가 주어진다. 핵심적인 부분만 말하면 다음과 같다.

<br>

성질 2번에서 다음과 같은 식이 있었다. ⏀(p^k) = (p^k)(1-1/p) 3번에서는 ⏀(mn) = ⏀(m)⏀(n) 이라는 것까지 생각해보면… 결국에는 모든 n에 대해서 ⏀(n)는 소수의 곱들로 이루어져 있기 때문에 1번 역시 사용된다. 즉, 자신보다 작은 수들을 체크하면서 약수, 소수 등등일때 각 계산을 해주면 되는 것이다.  

```java

public static int phi (int n) {
	int num = n;
	for(int i=2; i<=Math.sqrt(n); i++) {
			// 1. n%i==0 인 것은 n이 i의 배수라는 것을 증명한다. 2번 성질을 적용해서 저장
			if(n%i == 0){ 
				num = num/i*(i-1);
			}

			//2. 다음 계산을 위해 나눈다.
			while(n%i == 0) { 
				n/=i;
			}
	} // 반복문을 거치면, n에 있는 약수는 전부 쪼개지고 n은 소수가 남게 된다.

	//3. n이 1이 아니라면, 1에서 저장한 것을 2번을 이용해 처리한다.
	if(n!=1) { 
			num = num/n*(n-1);
	}
	return num;
 }
```

3에서 num으로 처리하는 이유는 1,2 번에서 처리할 때 언뜻보면 소수라는 조건이 없지만, 결과적으로는 모두 소수들의 곱으로 이루어져있기에 num에는 소수를 처리한 값이 있다.

<details>

<summary>예시</summary>
    
```java

public static int phi (int n) {
    int num = n;
    for(int i=2; i<=Math.sqrt(n); i++) {
            if(n%i == 0){ // n%i==0 인 것은 n이 i의 배수라는 것을 증명한다. 2번 성질을 적용해서 저장
                num = num/i*(i-1);
                System.out.println("반복문 에서.. i가 "+i+" 일때 체크 "+"1) n%i==0 : "+n+" num 에는 :"+num);
            }
            while(n%i == 0) { // 다음 계산을 위해 나눈다.
                System.out.println("반복문 에서.. i가 "+i+" 일때 체크 "+"2) n/=i : "+n);
                n/=i;
                System.out.println("반복문 에서.. i가 "+i+" 일때 체크 "+"3) n/=i : "+n);
            }
    } // 반복문을 거치면, n에 있는 약수는 전부 쪼개지고 소수가 남게 된다.

    if(n!=1) { //n이 1이 아니라면
            num = num/n*(n-1);
            System.out.println("n!=1 : "+num);
    }
    return num;
}

```

아래와 같이 나온다.
    
    
<img width="424" alt="phi_example" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/465899ca-07b7-4075-ad0d-87056e598c19">

</details>

TODO: 증명 부분도 이해하고 정돈해서 다시 올릴 것

<br>
<br>
