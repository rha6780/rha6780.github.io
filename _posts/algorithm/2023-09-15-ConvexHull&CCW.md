---
title: "볼록껍질(Convex Hull)&CCW(Conter Clock Wise)"
date: 2023-09-15
# toc: true
categories:
  - algorithm
tags:
  - algo
  - math
---

# Convex Hull & CCW

기하학 중 볼록 껍질과 CCW(Counter Clock Wise)를 알아보자.

<br>

### **CCW**

3개의 점을 순서대로 이은 선분이 반시계 방향이면 1, 시계방향이면 -1, 일직선이면 0을 출력하는 것으로 CCW를 통해 점이 어느 방향에 있는지 확인 할 수 있다. 간단히 예시를 들면, A, B, C 라는 점이 있을 때 AB 벡터와 CA 백터를 외적하면… ( (1) * (-5) ) - ( (10) * (-5) ) = 45 로 양수이다. 양수라면 반시계 방향이라는 것을 보장하게 되는 것이다.

![Screenshot_2023-09-15_at_2 39 15_PM](https://github.com/rha6780/rha6780.github.io/assets/47859845/43c4bd58-56db-46d5-9227-90a40fa9d1aa)


```python
	public static int ccw(Hull a, Hull b, Hull c) {
		long cal=0;
		cal=(long)(b.x-a.x)*(c.y-a.y)-(long)(c.x-a.x)*(b.y-a.y);
		if(cal>0) return 1;
		else if(cal<0) return -1;
		else return 0;
	}
```

<br>
<br>

### **볼록껍질**

무수한 점 중 볼록껍질(모든 점을 포함하도록 선을 그어 만드는 껍질)을 구성하는 점을 구하는 알고리즘이다. 보통 O(NlogN) 으로 구현되는데, 점들의 정렬이 시간 복잡도에 영향을 많이 준다. 이런 볼록껍질을 구성할때 Quick Hull, 그라함 스캔 등으로 여러 방식이 있는데 이번엔 그라함 스캔 방식으로 설명하도록 하겠다.

<br>
<br>

**그라함 스캔(**그레이엄 스캔**)**

이 방식은 기준점에서 CCW(외적, 기울기 등)를 통해서 테두리로 가능한지 판별하는 방식이다. 간단히 방법을 설명하면 다음과 같다.

<br>

- 기준점으로 y, x 가 가장 작은 점을 선정한다.
- 해당 점을 기준으로 각도가 증가하는 순으로 정렬 (스칼라 곱인 외적의 부호로 판정하는 것이 일반적이다.)
- 우선 기준점과 그 다음점을 스택에 넣고 나머지 점들을 순차적으로 처리, 현재 처리하는 점이 이전 선의 어느 방향으로 회전하였는 지를 판단해서 반 시계 방향인 경우에만 스택에 추가한다.
- 만약 처리하는 중 CCW의 값이 0보다 작거나 같다면 두번째 점은 볼록 껍질 내부에 있다는 것을 의미하기 때문에 스택에서 제외하고 넘어간다.

<br>
<br>

**구현**

대표적인 문제로는 아래와 같다. 볼록껍질을 만들고 볼록껍질을 구성하는 점의 개수를 구하는 문제이다.

<br>

[1708번: 볼록 껍질](https://www.acmicpc.net/problem/1708)


<br>

우선 기준점을 정하고, 이 기준점에서 반 시계방향으로 정렬한다. 정렬된 순서대로 기준점과 그 다음 점을 비교하는데, 해당 점이 반 시계 방향일 경우 그대로 진행하고 아닌 경우 다른 점을 찾는다. 즉, 각 점들을 탐색하면서 반시계 방향인 것들을 찾아가면, 모든 점을 포함하는 도형을 그릴 수 있는 것이다.

<br>
<br>

```java
class Hull implements Comparable<Hull>{
	int x; int y;
	public Hull(int x, int y){
		this.x=x; this.y=y;
	}
}

public class Main {

	public static List<Hull> P = new ArrayList<Hull>();
	public static int N;
	public static Hull first = new Hull(40001, 40001);

	public static long dist(Hull a1, Hull a2) {
		return (long)(a2.x-a1.x)*(a2.x-a1.x)+(long)(a2.y-a1.y)*(a2.y-a1.y);
	}

	public static int ccw(Hull a, Hull b, Hull c) {
		long cal=0;
		cal=(long)(b.x-a.x)*(c.y-a.y)-(long)(c.x-a.x)*(b.y-a.y);
		if(cal>0) return 1;
		else if(cal<0) return -1;
		else return 0;
	}

	
	public static void main(String[] args) {
		Scanner sc=new Scanner(System.in);
		N=sc.nextInt();
		for(int i=0; i<N; i++) {
			int x=sc.nextInt(); int y=sc.nextInt();
			P.add(new Hull(x,y));
		}

		// 기준점을 y가 가장작고, x가 작은 점으로 선정한다.
		for(int i=0; i<N; i++) {
			Hull target = P.get(i);
			if(target.y < first.y) {
				first = target;
			} else if(target.y == first.y) {
				if(target.x < first.x) {
					first = target;
				}
			}
		}
		
		
		// 기준 점으로 부터 CCW 를 통해서 반시계 방향인 것을 우선하도록 정렬한다. 
		P.sort(new Comparator<Hull>() {
			@Override
			public int compare(Hull a, Hull b) {
				int v=ccw(first, a, b);
				if(v>0) return -1;
				if(v<0) return 1;
				if(v==0) { //만약 직선이라면 가까운 것을 우선 오도록 한다.
					//제외시킬 때 가까운 것을 제외시키게 하기 위해서
					long R1 = dist(first,a);
					long R2 = dist(first,b);
					if(R1 > R2) {
						return 1;
					}
				}
				return -1;
			}
		});

		Stack<Hull> stack=new Stack<>();
		stack.add(first); // 스택에 기준점을 두고

		for(int i=1; i<P.size(); i++) {
			while(stack.size()>1&&ccw(stack.get(stack.size()-2), stack.get(stack.size()-1), P.get(i))<=0) {
				stack.pop(); // 직선, 시계방향이라면 2번째 값을 뺀다.
			}
			stack.add(P.get(i)); // 반시계라면 추가한다.
		
		}
		System.out.println(stack.size());

	}

}
```

<br>

**추천 문제**

개인적으로 2년 전쯤 이 문제를 풀었을 때, 정확한 방법과 원리를 몰랐던 부분이 있었다. 이렇게 한번 정리하고 나니까 생각보다 구현은 크게 어렵지 않은데, 시간이 지나면 또 까먹을게 당연하기 때문에 문제를 보면 바로 방법이 생각할 정도로 공부를 해야겠다. 비슷한 문제로는 [2699](https://www.acmicpc.net/problem/2699) 번을 추천한다.

<br>
<br>
