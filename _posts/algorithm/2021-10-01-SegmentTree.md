---
title: "SegmentTree"
date: 2021-10-01

categories:
  - algorithm
tags:
  - algo
---


<br>

이분탐색 선행 필요.

---
<br>

세그먼트 트리(Segment Tree)는 구간에 대한 정보를 빠르게 구현할 수 있으며 이진 트리 형식의 구조를 가지는 자료구조이다.

<br>

구간의 최솟값, 또는 최대값, 합을 구하는 문제에서 효율적으로 쓰일 수 있다. 세그먼트 트리는 주어진 배열을 완전 이진트리의 최하단에 위치시킨다.

<br>
만약 배열이 {1,5,6,-5}순으로 있고, 최솟값을 찾는 문제라고 하자. 이때 트리는 아래와 같이 구성된다. 각 노드인 0, 2, 4, 6 번째 : 최하단에 위치하고 부모노드는 최솟값으로 넣는다.

<br> 

![캡처](https://user-images.githubusercontent.com/47859845/135498793-b2c9107a-cbcd-4941-ace4-28f2ba20f042.PNG)


문제의 목적이 최솟값을 구하는 경우, 부모노드는 자식노드들 중 최솟값이다.

최대값인 경우, 부모노드는 최대값, 합이면 합한 결과가 부모노드로 업데이트 된다.

<br>

이후 완성된 트리에서 이분 탐색을 통해 원하는 값을 빠르게 찾을 수 있습니다.

---

일반 세그먼트는 3가지 기능으로 나누어 지는데, update-lazy(게으른 갱신)까지 총 4가지를 우선 설명하겠다.

1. 트리 그리기 및 초기화
2. 합 구하기 또는 최솟값 구하기...
3. 값 바꾸기
4. 게으른 갱신


<br>

---

우선적으로 세그먼트 트리의 크기는 다음과 같이 구한다.

```java
//N은 배열의 길이
int height = (int) Math.ceil(Math.log(N)/Math.log(2));
int treesize = 1;
for(int i=0; i<height+1; i++) {
	treesize*=2;
}
Tree = new int[Treesize];
```

여기서 height는 트리의 높이를 의미한다. 2의 계승에 따라서 높이가 결정되고, 해당 높이마다 노드의 갯수가 2씩 곱해져서 나오게 된다.

---

<br>

1. 트리 그리기 및 초기화

```java
	public static void makeTree(int left, int right, int node){
		if(left==right){Tree[node]=left;}
		else{
		int mid=(left+right)/2;
		makeTree(left, mid, node*2);
		makeTree(mid+1, right, node*2+1);
		if(arr[Tree[node*2]]<arr[Tree[node*2+1]]){
			Tree[node]=Tree[node*2];
		}
		else{
			Tree[node]=Tree[node*2+1];
		}
		}
	}
```

트리는 이분매칭과 비슷하게 진행된다.  위에서 설명한데로 문제의 목적에 따라서 부모노드가 결정된다.

<br><br>

> 문제의 목적이 최솟값을 구하는 경우, 부모노드는 자식노드들 중 최솟값이다. 최대값인 경우, 부모노드는 최대값, 합이면 합한 결과가 부모노드로 업데이트 된다.
> 

<br>

따라서 위 코드에서는 상황에 따라서 달라진다.

```java
//최소
if(arr[Tree[node*2]]<arr[Tree[node*2+1]]){
			Tree[node]=Tree[node*2];
}

//최대
if(arr[Tree[node*2]]<arr[Tree[node*2+1]]){
			Tree[node]=Tree[node*2+1];
}

//합
Tree[node]=Tree[node*2]+arr[Tree[node*2+1]];

```

---

<br>

2. 원하는 값 구하기.

```java
	public static int query(int s, int e, int i, int j, int node){
		if(e<i||s>j)return -1;
		else if(i<=s&&e<=j) return Tree[node];
		int mid=(s+e)/2;
		int lquery=query(s,mid, i, j,node*2);
		int rquery=query(mid+1,e,i,j,node*2+1);
		if(lquery==-1){
			return rquery;
		}
		else if(rquery==-1) return lquery;
		else if(arr[lquery]<arr[rquery]) return lquery;
		else return rquery;
		
	}
```

트리가 구성되면, 해당 트리에 범위를 넘지 않는 선에서 원하는 값이 있는지 확인해야한다. 각 이분탐색으로... 왼쪽, 오른쪽 자식노드로 이동하면서 원하는 값이 있는지 탐색한다.

<br>

---

3. 값 바꾸기

```java
public static long update(int s, int e, int node, int index, int diff){
		if(!(index>=s&&e>=index)){return Tree[node];}
		if(s==e){return Tree[node]=diff;}
		int mid=(s+e)/2;
		return Tree[node]=(update(s,mid,node*2,index, diff)%rest*update(mid+1,e,node*2+1, index, diff)%rest)%rest;
	}
```

s와 e는 각각 start, end의 변수로 변경되는 범위를 나타낸다. 해당 인덱스가 범위를 넘어가는 경우 그냥 return 되고, 마지막까지 도달 (이분탐색이 끝나는 s==e 시점)에서 해당 값을 변경한다.

여기서 diff는 현재 값에서 더하거나 뺄 값이다.

<br>

---

4. 게으른 갱신

```java
public void update_lazy(int node, int begin, int end) {
	if(lay[node]!=0) {
		Tree[node] +=(end-begin+1)*lazy[node];
		if(begin != end) {
			lazy[node*2] += lazy[node];
			lazy[node*2+1] += lazy[node];
		}
		lazy[node] = 0 ;
	}
}

public void update_range(int node, int begin, int end, int left, int right, int diff) {
	update_lazy(node, begin, end);
	if(end<left || right<begin) return;
	if(left <=begin && begin <=right) {
		Tree[node]+= (end-begin+1)*diff;
		if(begin!=end) {
			lazy[node*2]+=diff;
			lazy[node*2+1]+=diff;
		}
		return;
	}
	int mid = (begin+end)/2;
	update_range(node*2, begin, mid, left,right, diff);
	update_range(node*2+1, mid+1, end, left,right, diff);
	Tree[node] = Tree[node*2] + Tree[node*2+1];
}
```

---

<br><br>

추천문제

어려운 문제이기 때문에 해당 문제와 함께 코드 설명을 올린다. 위에서 설명한 코드도 이 문제의 코드로 설명을 했다.

[6549번: 히스토그램에서 가장 큰 직사각형](https://www.acmicpc.net/problem/6549)

```java
import java.util.*;
public class Main {
	public static int[] Tree;
	public static int[] arr;
	public static void makeTree(int left, int right, int node){
		if(left==right){Tree[node]=left;}
		else{
		int mid=(left+right)/2;
		makeTree(left, mid, node*2);
		makeTree(mid+1, right, node*2+1);
		if(arr[Tree[node*2]]<arr[Tree[node*2+1]]){
			Tree[node]=Tree[node*2];
		}
		else{
			Tree[node]=Tree[node*2+1];
		}
		}
	}

	public static int query(int s, int e, int i, int j, int node){
		if(e<i||s>j)return -1;
		else if(i<=s&&e<=j) return Tree[node];
		int mid=(s+e)/2;
		int lquery=query(s,mid, i, j,node*2);
		int rquery=query(mid+1,e,i,j,node*2+1);
		if(lquery==-1){
			return rquery;
		}
		else if(rquery==-1) return lquery;
		else if(arr[lquery]<arr[rquery]) return lquery;
		else return rquery;
		
	}
	
	public static long getArea(int s, int e){
		int N=arr.length-1;
		int ind=query(1,N,s,e,1);
		long area=(long)(e-s+1)*(long)arr[ind];
		if(s<ind){
			long temp=getArea(s,ind-1);
			area=Math.max(area,temp);
		}
		if(e>ind){
			long temp=getArea(ind+1,e);
			area=Math.max(area, temp);
		}
		return area;
	}
	public static void main(String[] args) {
		Scanner sc=new Scanner(System.in); 
		while(true){
			int n=sc.nextInt();
			if(n==0) break;
			int h=(int)Math.ceil(Math.log(n)/Math.log(2));
			int ts=1;
			for(int j=0; j<h+1; j++){
				ts*=2;
			}
			arr=new int[n+1];
			Tree=new int[ts];
			for(int i=1; i<=n; i++){
				arr[i]=sc.nextInt();
			}
			
			makeTree(1,n,1);
			System.out.println(getArea(1,n));
		}

	}

}
```


<br><br>