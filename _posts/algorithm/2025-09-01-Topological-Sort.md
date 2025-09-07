---
title: "위상정렬(Topological Sort)"
date: 2025-09-01
# toc: true
categories:
  - algorithm
tags:
  - algo
  - math
---

위상 정렬(Topological Sort)은 방향성 비순환 그래프(Directed Acyclic Graph, DAG)에 대해 정점들을 정렬하는 알고리즘입니다. 

<br>

DAG는 모든 정점에서 시작하여 다른 정점으로 이동할 수 있지만, 어떤 정점에서 시작해서 다른 정점으로 이동할 때 순환이 발생하지 않는 그래프를 의미합니다.

<br>

**위상 정렬의 핵심**

DAG의 정점들을 순서대로 나열했을 때, 모든 간선이 왼쪽 정점에서 오른쪽 정점으로 향하도록 하는 순서입니다.  즉, 각 정점 u에 대해, u에서 v로 가는 간선이 있다면, u는 v보다 먼저 정렬되어야 합니다.(의존성에 맞게 정렬)



<br>

**시간 복잡도**

위상 정렬 알고리즘의 시간 복잡도는 사용되는 구현 방식에 따라 달라진다.


| 알고리즘 | 구현 방식 | 시간 복잡도 | 공간 복잡도 | 장점 | 단점 |
|---|---|---|---|---|---|
| **칸 알고리즘 (Kahn's Algorithm)** | BFS (너비 우선 탐색) | O(V + E) | O(V) | 구현 용이, 효율적, 사이클 확인 가능 | 메모리 사용량 증가 가능성 |
| **DFS (Recursive)** | 재귀적인 DFS | O(V + E) | O(V) | 직관적, 메모리 효율적 | 스택 오버플로우 가능성, 구현 복잡 |
| **DFS (Iterative)** | 반복문 + 스택 | O(V + E) | O(V) | 스택 오버플로우 방지, 안전 | 구현 복잡 |


일반적으로 시간복잡도, 공간 복잡도에는 큰 차이가 없지만, DFS로 구현하는 경우 오버플로우 및 단점이 있어 Kahn's Algorithm 을 많이 사용됩니다.

<br>

위에서 설명한 Kahn's Algorithm의 시간 복잡도는... 

- 진입 차수 계산: 그래프의 모든 정점과 간선을 순회해야 하므로 O(V + E) 시간이 소요됩니다.

- 큐 초기화: 진입 차수가 0인 정점을 찾는 데 O(V) 시간이 소요됩니다.

- BFS 반복: 큐의 크기는 최대 V가 될 수 있으며, 각 정점은 한 번씩 큐에서 꺼내어 처리됩니다. 따라서 BFS 반복에는 O(V + E) 시간이 소요됩니다.

따라서 전체적인 시간 복잡도는 O(V + E) + O(V) + O(V + E) = O(V + E) 가 됩니다. 이는 그래프의 정점 수와 간선 수에 비례하는 시간 복잡도이므로, 큰 그래프에서도 효율적으로 위상 정렬을 수행할 수 있습니다.


<br>

### 코드 예시 (Kahn's Algorithm)

- [BOJ 1516](https://www.acmicpc.net/problem/1516) 

```java
import java.util.*;

import java.util.*;
import java.io.*;

public class Main {


	public static void main(String[] args) throws IOException {
		BufferedReader br =new BufferedReader(new InputStreamReader(System.in));
		
		int N = Integer.parseInt(br.readLine());
		ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
		int[] indegree = new int[N+1];
		int[] times = new int[N+1];
		int[] result = new int[N+1];

		for (int i=0; i<=N; i++) {
			graph.add(new ArrayList<Integer>()); // 그래프를 그린다.
		}

		StringTokenizer st;
		for(int i=1; i<=N; i++) {
			st = new StringTokenizer(br.readLine());
			times[i] = Integer.parseInt(st.nextToken());
			while(true) {
				int num = Integer.parseInt(st.nextToken());
				if (num == -1) {break;}
				graph.get(num).add(i);
				indegree[i]++; // 진입차수로 그래프에 연결된 만큼 증가한다.
			}
		}

		Queue<Integer> que = new LinkedList<Integer>();

		for(int i=1; i<=N; i++) {
			if (indegree[i] == 0) { // 진입차수가 0인 것 부터 탐색한다.
				que.add(i);
			}
		}

		while (!que.isEmpty()) {
			int now = que.poll();
			
			for (int j : graph.get(now)) { // 진입차수가 0인 것에서 최대 값을 찾기 위해 반복한다.
				result[j] = Math.max(result[j], (result[now] + times[now])); // 문제에 따라서 최소 시간을 계산하는 경우도 있다.
				indegree[j]--;
				if (indegree[j] == 0) {
					que.add(j);
				}
			}
		}

		for(int i=1 ; i<=N; i++) {
			System.out.println(result[i] + times[i]);
		}

	}

}

```

### 코드 설명

inDegree : 각 정점의 진입 차수를 저장하는 배열입니다.

- 큐 초기화 : 진입 차수가 0인 정점들을 큐에 넣습니다.
- BFS 반복 : 큐가 빌 때까지 반복하며, 큐에서 정점을 꺼내 결과 리스트에 추가하고, 해당 정점의 이웃 정점들의 진입 차수를 감소시킵니다.
- 결과 : 여기서 문제에 따라서 어떤 위상정렬에서 최소 시간을 구하는 문제도 있을 수 있고, 단순히 순서를 나열하는 문제에 따라 result 배열을 업데이트하는 방식이 달라진다.

<br>

만약 사이클을 검사해야한다면...
사이클 검사: 위상정렬로 인한 나열된 결과 리스트의 크기가 정점 수와 다르면 사이클이 존재함을 의미한다.

<br>

**추천 문제**

작업 간의 의존성을 고려하여 작업을 순서대로 나열하거나.. 여러가지의 답 중 가장 최소길이의 답을 출력하거나..
여러 답안의 개수를 세거나 등이 포함된다.

문제로는 [1005 : ACM Craft](https://www.acmicpc.net/problem/1005), [2056: 작업](https://www.acmicpc.net/problem/2056)을 추천한다.

<br>



