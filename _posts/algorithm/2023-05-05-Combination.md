---
title: "조합론(Combination)"
date: 2023-05-05
toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - algorithm
tags:
  - algo
  - math
---
# 조합론


조합론 자체가 문제로 나오는 경우도 있지만, 주로 다른 것과 같이 나오는 경우가 많다. 아무튼, 조합론과 관련된 문제로는 값이 엄청 큰 경우 조합의 경우의 수, 조합할 수 있는 것 중 특정 조건을 만족하는 조합 리스트 등을 요구하는 경우가 있다. 문제마다 포맷은 다르지만 크게 이 2가지로 나누어서 소개를 하겠다.

<br>

## 그전에…!

조합론에서는 nPk 나 팩토리얼 같은 지식도 같이 요구한다. (당연한 이야기지만..) 간단히 소개하고 조합에 관련된 문제 유형을 살펴보자.

<br>

### **팩토리얼이란?**

팩토리얼 n! 이라고 작성하는 이 수식은 n개를 정렬했을 때 나오는 경우의 수와 같다. 3개의 사탕을 정렬한다고 했을 때 어떻게 하면 경우의 수를 구할 수 있을까? 가장 원초적인 것은 무작성 하나씩 정렬하면서 경우를 기억하는 것이지만, 수학을 이용하면 그렇지 않아도 된다.

우선 팩토리얼 식 부터 확인해보자.

```python
N! = N * (N-1) * (N-2) * ... * 2 * 1
```

위와 같이 N! 은 N부터 1까지 사이에 있는 수를 모두 곱한 것이다. 이게 정렬이랑 무슨 관련인가 싶겠지만, 정렬을 할 때 자리를 기준으로 본다고 해보자. N개를 정렬하는 것이니까 자리 역시 N개가 존재한다. 아직 자리에 넣지 않은 것들은 다른 곳에 있다고 가정할 때 각 자리마다 사탕을 가져온다고 가정하자.

<br>

첫번째 자리에 넣을 수 있는 사탕은…? 당연히 N개 중 하나이다. 여기에 하나를 둔다고 했을 때 두번째 자리에는 어떤 사탕이 올 수 있을까? N-1개이다. 즉 이전 자리마다 사탕을 하나씩 넣어두었으니 현재 자리에 둘 수 있는 사탕은 N-자리수 이다.

<br>

여기서 해당 자리에 어떤 사탕을 둘지는 독립적이다. 그렇기 때문에 곱셈을 하게 된다. 이게 팩토리얼이다…

<br>

### **순열(Permutation)이란?**

순열은 팩토리얼의 확장과 같은데… nPr 라고 작성하고, N개의 수에서 r만큼 뽑아서 정렬할 때 나올수 있는 경우의 수를 의미한다. N개를 정렬하는 것은 팩토리얼인데, 거기서 r개만큼 뽑는다는 것은 어떤 의미일까? 가장 간단한 것은… 자리가 r개 밖에 없다는 것과 같다.

```python
nPr = N * (N-1) * (N-2) * ... * (N-r+1)
```

식으로 표현하면 다음과 같은데, N부터 N-r+1 까지 총 R개의 자리의 정렬할 수 있는 경우의 수이다. 

<br>

### **조합(Combination)이란?**

조합(Combination)은 순열과 달리 정렬한다는 개념이 아니라 뽑는다에 중점을 둔다. 즉 [3,2,1]이나 [1,2,3]은 순열에서 2가지 경우의 수로 생각하지만, 조합에서는 같은 것으로 판단한다. 한마디로 조합아이템의 경우의 수이기 때문에 정렬 보다는 적은 값을 가진다.

이 조합을 순열을 이용해서 간단히 계산할 수 있는데, 그게 바로 아래코드와 같다.

```python
nCr = nPr/r!
```

조합에서는 순서를 고려하지 않기 때문에 n개 중 r개를 뽑아서 정렬하는 nPr에서 r! (r만큼 정렬하는 경우의 수)를 나누면 놀랍개도 n개 중 r개를 뽑는 경우만 남는다. (국어적으로 봐도 그렇다…!) 여기까지 식과 함께 간단히 살펴보았다.

<br>

본격적으로 조합 유형과 같이 보자.

<br>

## 조합의 경우의 수를 구하는 문제

조합의 경우의 수를 구하는 경우, 백준의 이항계수 라고 적힌 문제와 비슷한 양식이다. 여기서는 위에서 설명한 식을 코드로 풀어쓰면 된다. 문제는 곱하기가 많기 때문에 수가 항상 범위를 넘어가지 않는 지 확인해야한다. 관련코드를 작성하면 다음과 같다.

```python

public static void main(String[] args) {
	Scanner sc=new Scanner(System.in);
	int k, n, getn=1, getk=1;
	n=sc.nextInt();
	k=sc.nextInt();
	sc.close();

	for(int i=0; i<k; i++) {
		getk*=(k-i);
		getn*=n;
		n--;
	}
	getn/=getk;
	System.out.print(getn);
}

```

위 코드는 백준 [이항계수 1](https://www.acmicpc.net/problem/11050) 문제이다. N이 10 이하이기 때문에 곱셈을 마음껏 해도 범위를 넘지 않는다. 하지만, 범위를 넘는 경우는 조심해야한다. 바로 다음 문제인 [이항계수 2](https://www.acmicpc.net/problem/11051) 문제는 기존 integer 범위를 넘기 때문에 별도로 나눠야 하는 문제인데… 위 코드와 다르게 푸는 방식이 있다. 일단 이항계수와 관련된 것들을 보자.

<br>

### **파스칼의 삼각형**

파스칼의 삼각형은 이항계수를 삼각형 모양으로 나열하는 것을 의미하는데, 해당 모양에서 하키스틱, 등의 패턴등을 확인할 수 있다. nCr = n-1Cr-1 + n-1Cr 이라는 식으로 이전 줄의 가까운 2수의 합이 그 수 사이 아래의 값으로 된다는 의미이다. 예시로 아래 수중 4번째 줄에 4와 6이 보이는데, 각각 더한 값인 10이 그 사이에 항상 위치한다는 것을 볼 수 있다.

![wiki_Pascal_triangle svg](https://user-images.githubusercontent.com/47859845/236375963-70935ec8-af65-47d9-8e8c-4631dbab86b2.png)

<br>

### **하키스틱 패턴**

하키스틱 패턴은 대각선으로 더한 값이 다음줄 값과 같다는 것인데 그 모양이 하키스틱 모양이라서 붙인 패턴이다. 위 그림에서  1, 5, 15, 35, 70 을 더하면 그 다음 대각선인 126이 된다. 

다시 이항계수 2 문제로 돌아가면, 해당 문제에서는 단순히 곱셈으로는 범위를 넘어가기 때문에 파이썬이라면 몰라도 자바나 C 같은 범위가 정해진 경우 단순 for 문으로 해결하기는 어렵다. 그렇기 때문에 BigInteger 이거나, 파스칼의 삼각형을 이용해야한다.

<br>

### **Biginteger 풀이**

```java
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());
        int N = Integer.parseInt(st.nextToken());
        int K = Integer.parseInt(st.nextToken());

        BigInteger n = BigInteger.ONE;
        BigInteger k = BigInteger.ONE;

        for (int i = 0; i < K; i++) {
            n = n.multiply(BigInteger.valueOf(N));
            k = k.multiply(BigInteger.valueOf(K - i));
            N--;
        }

        BigInteger result = n.divide(k).remainder(BigInteger.valueOf(10007));
        System.out.println(result.intValue());
    }
}
```

<br>

### **파스칼의 삼각형 풀이**

```java
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());
        int N = Integer.parseInt(st.nextToken());
        int K = Integer.parseInt(st.nextToken());

        int[][] b_coefficient = new int[N + 1][N + 1];

        b_coefficient[0][0] = 1;
        b_coefficient[1][0] = 1;
        b_coefficient[1][1] = 1;

        for (int i = 2; i <= N; i++) {
            for (int j = 0; j <= i; j++) {
                if (j == 0 || j == i) {
                    b_coefficient[i][j] = 1;
                } else {
                    b_coefficient[i][j] = (b_coefficient[i - 1][j - 1] + b_coefficient[i - 1][j]) % 10007;
                }
            }
        }
        System.out.println(b_coefficient[N][K]);
    }
}
```

<br>


하지만, 이항 계수 2 문제의 경우 위 2가지 풀이로도 풀리지만, [이항 계수 3](https://www.acmicpc.net/problem/11401)부터는 그렇지 않다. 3부터는 숫자 자체가 엄청나게 커지기 때문에 모듈로와 관련된 수학적 개념이 필요하다.


<br>


### 묘듈로 인버스(**modulo inverse**) **풀이**

**모듈로(modulo) 란?**

값이 엄청나게 큰 경우, 모듈로(나머지)와 관련을 둘 수 있다. 아래 예시를 보자.

```java
(7^3)%3 = 343%3 = 1
7%3 = 1

7^3 과 7을 각각 3으로 나누었을 때 나머지는 1로 같다. 이를 아래와 같이 표현할 수 있다.
7^3 = 7(mod 3)

a^p = a(mod p) p는 소수이고, a 는 p의 배수가 아니다.
```

<br>

**모듈로의 역원(modulo inverse)**

```java
페르마의 소정리
p가 소수이고, 모든 정수 a 에서..
a^p = a(mod p)

p가 소수이고 a가 p의 배수가 아니라면
a^p-1 = 1(mod p)

```

모듈로의 역원이란, a(mod p) 에서 c를 곱했을 때 1을 만족하는 c의 값을 의미한다. 아래 예시와 같이 보자.
```java
a/b(mod p) = a(mod p) * c(mod p)
```

다음과 같이 사용이 가능하다 `a/b`라는 식이 있을 때 이를 곱셈으로 치환할 수 있다. 해당 문제에서는 값이 너무 크기 때문에 1,000,000,007로 나눈 나머지를 출력해야하는데, 이 값을 나눗셈에도 적용할 수 없기 때문에 모듈로 인버스를 이용해서 곱셈으로 두어서 계산하는 것이다. 그렇다면 `a/b` 에 곱하면 나머지가 1이되는 수... `c`는 어떻게 구할까? 

<br>

위 페르마의 소정리를 보면 `a^p-1 = 1(mod p)` 라는 식이 있는데, 각각 a 대신 b로 치환한 `b^p-1 = 1(mod p)` 이기 때문에 기존 `a * b^-1 (mod p)` 에 곱하면... 즉, b^-1(mod p)에 역원은 `b^p-2 mod p` 와 같다.

```java
(20/5) % 11 = 4
간단히 계산하면 4로 나오지만, 만약 mod를 이용한다면... 

(20 / 5)(mod 11) = 4(mod 11)
20 (mod 11) * 1/5 (mod 11) = 4 (mod 11)
5^-1(mod 11)이 1이 되는 수를 찾는다.

x * 5^-1(mod 11) = 1 -> x = 5
(20(mod 11)) * 20 = (20 * 20)(mod 11) = 400 % 11 = 4
```

<br>

`x = 5` 는 어떻게 찾은 걸까? `a^p-2 = 1 (mod p)` 라는 공식을 통해서 가능하다. 5^11-2 = (20 * (5^9)%11) % 11=> (20 * 5)%11 = 1(페르마의 소정리에 의하면 a와 p가 서로소 일때 가능하다.)
이렇게 하면 큰수를 mod 11 을 이용해서 작은 수로 변환가능하기 때문에 코드에서 작은 수 끼리만 곱셈이 가능하다. 그렇기에 범위를 넘기지 않는다. 

<br>

다시 조합을 생각해보면… 곱셈은 nCr = n! / (n-r)! r! 이기때문에 `(n! / (n-r)! r!) mod = (n!* ((n-r)! r!)의 역원) mod` 이다. 그럼 `((n-r)! r!)의 역원` 만 제대로 구하면 된다.. 곱셈에는 mod가 각각 들어갈 수 있기 때문에 `n! mod * (n-r)! r!)^p-2) mod` 와 같다. 계산을 위해서 `(n-r)! r!)^p-2` 를 구하고 나눗셈 계산을 하면 된다.

<br>

```java
public class Main {

    public static long mod = 1_000_000_007;

    public static long exponent(long value, long ex) {
        if (ex == 0) {
            return 1;
        } else {
            long tmp = exponent(value, ex / 2);
            if (ex % 2 == 1) {
                return (((tmp * tmp) % mod) * value) % mod;
            }
            return (tmp * tmp) % mod;
        }
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());

        int N = Integer.parseInt(st.nextToken());
        int K = Integer.parseInt(st.nextToken());

        long n = 1;
        long k = 1;

        for (int i = 0; i < K; i++) {
            n *= N;
            n %= mod;

            k *= (K - i);
            k %= mod;
            N--;
        }

        System.out.println((n * exponent(k, mod - 2)) % (mod));
    }
}
```

<br>

<br>

## 조합하는 리스트를 구하는 문제

경우의 수가 아니라, 조합 자체를 구하는 문제가 있을 수 있다. N개의 수들 중 K개를 뽑는 경우로 DP로 푸는 방식과 백트래킹 방식이 있다.


<br>

### **DP 풀이**

visited 에는 뽑힌 경우를 1과 0으로 나타내고, K==0 일 때 뽑힌 것들을 출력한다.

```java

//t는 뽑혔는 지 확인하는 배열 1은 뽑힘. 0은 뽑히지 않은 경우.
static void comb(int n, int r) {
  // n은 nCr 로 고를 수 있는 아이템 갯수
	// r 고를 아이템 개수

	if(k==n) {
		for(int i=0; i<n; i++) {
			visited[i] = 1;
		}
		return;
	}
	if(k==0) {
		for(int i=0; i<n; i++) {
			visited[i] = 0;
			System.out.print(visited[i]+" ");
		}
		return;
	}
	visited[n-1] = 0;
	comb(n-1, k);
	visited[n-1] = 1;
	comb(n-1, k-1);
}

```

DP는 간단하다. comb의 n은 현재 남아있는 숫자의 개수와 같다. 즉 하나를 뽑으면 n-1이 되는 것이다. 그렇기에 n개에서 하나의 숫자를 뽑지 않은 경우 t[n-1] = 0으로 두고, n-1인 경우 조합을 다시 시도한다. 조합이 끝나면, 다시 t[n-1] = 1 로 두어서 뽑은 경우 다시 조합을 시작한다.

이렇게 계속 comb를 호출하는 경우 k==n-1 이나 k-1 == 0이 되는 순간이 있기 때문에 모든 경우에 대해서 출력하게 된다. 이러면, 0,1을 이용해서 어떤 수(인덱스)가 뽑혔는지 구분할 수 있기 때문에 마지막 아이템을 고를때 출력후 다른 조합을 진행한다.

<br>

### **백트래킹 풀이**

백트래킹인 경우, DP에서 하나씩 돌아가면서 조합을 변경하는 방식으로 위에서 visisted를 이용해서 뽑혔는지 확인하며 마지막에는 return 을 하여서 재귀를 진행하도록 하는 방식이다.

```java
static void back_track(int s, int len) {
	// s는 기준 인덱스로 s 보다 큰 아이템을 조합할 수 있다.
	// len 은 남은 길이로 조합으로 필요한 길이이다.
	
	if(len==0) {
		for(int i=0; i<n; i++) {
			if (visited[i] == 1) {
				System.out.print(visited[i]+" ");
			}
		}
		return;
	} else {
		for(int i = s; i < n; i++) {
			visited[i] = 1;
			comb(i+1, len-1);
			visited[i] = 0;
		}
	}
}
```

다른 듯 같은 방식이기 때문에 편한 걸로 골라서 사용하면 될 것 같다.

<br>
<br>
