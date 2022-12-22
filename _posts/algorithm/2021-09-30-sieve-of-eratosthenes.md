---
title: "에라토스테네스의 체"
date: 2021-09-30

categories:
  - algorithm
tags:
  - algo
---

### 에라토스테네스의 체(Sieve of Eratosthenes)

**소수판정**

에라토스테네스의 체는 특정 범위의 수들이 소수(Prime)인지 아닌지를 판별하는 알고리즘이다. 간단히 말하면 2~Math.sqrt(N)까지의 수로 나누어서 나머지가 0인 것이 없다면 소수임을 이용하는 알고리즘이다.

---

<br>

여기서 만약 2를 넣는다 해도 루트 2는 2보다 작기 때문에 for문을 거치지 않기 때문에 소수로 판명난다. 따라서 0,1을 예외 처리하고 나머지 숫자를 넣으면 소수인지 확인 된다.

<br>

{% codetabs %}

{% codetab Java %}
```java
...

public static void SE(int a) {
	boolean isprime = true;
	for(int i=2; i<=Math.sqrt(a); i++) {
		if(a%i == 0) {
			isprime = false;
			break;
		}
	}
	return isprime;
}
```
{% endcodetab %}

{% codetab Python %}
```java
...
준비중
```
{% endcodetab %}

{% endcodetabs %}

<br><br>
추천문제

---

[1978번: 소수 찾기](https://www.acmicpc.net/problem/1978)

<br><br>