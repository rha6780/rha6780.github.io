---
title: "다각형의 넓이"
date: 2021-12-29

categories:
  - algorithm
tags:
  - algo
  - math
---

### 다각형 넓이

여러 점들이 주어지고 이 점들을 이어서 완성되는 다각형의 넓이는, 여러 점들을 모아 부분부분 삼각형으로 만들고, 해당 삼각형의 넓이를 더해서 구한다.

<br>

Area 함수는 다각형을 삼각형으로 나누어서 넓이를 구하는 함수이다. 원리는 신발끈 공식이다. 해당 함수는 1/2를 하지 않은 상태로 도출하고, 마지막 출력에서 1/2를 한다.

<br>

이와 같은 코드를 짜면, 각 3개의 점 좌표를 따라서 다각형의 넚이를 구할 수 있다.

```java
public class Main {
	
	public static long[][] spot;
	public static double result=0;
	public static void Area(long x1, long y1, long x2, long y2, long x3, long y3){
		long sum=0;
		sum=((x1*y2)-(x2*y1))+((x2*y3)-(x3*y2))+((x3*y1)-(x1*y3));
		result+=((double)sum);
	}
	public static void main(String[] args) {
		Scanner sc=new Scanner(System.in);
		int N=sc.nextInt();
		spot=new long[N][2];
		for(int i=0; i<N; i++){
			spot[i][0]=sc.nextLong(); //x
			spot[i][1]=sc.nextLong(); //y
		}
		
			for(int j=1; j<N-1; j++)
				Area(spot[0][0],spot[0][1],spot[j][0],spot[j][1],spot[j+1][0],spot[j+1][1]);
				
		System.out.println(String.format("%.1f",(double) Math.round(Math.abs(result/2)*10)/10));

	}

}
```

나와 같은 MBTI S형 ("아 신발끈공식으로 되는 코드구나하며 넘길")사람들...

혹은 N형 ("신발끈공식? 근데 왜 신발끈이지 뭔지 모르는데 어케 이해함 아 근데 찾아보기 귀찮다.") 하는 분들을 위해 신발끈 공식을 잠깐 설명하자면 다음과 같다.

<br>

**신발끈 공식 ( 사선식 , 구두끈 공식 )**

<br>

신발끈 공식은 각 점들로 이루어진 다각형의 선분들이 서로 교차하지 않는 단순 다각형이고, 각 점들이 반시계방향/시계방향으로 주어지는 경우에 사용할 수 있다.

<br>

<img width="394" alt="스크린샷 2021-12-29 오후 12 49 39" src="https://user-images.githubusercontent.com/47859845/147625781-0a38d479-e37b-4ccd-8631-c6f975f18ee6.png">

이런 오각형의 각 점들이 A~E까지 순서대로 주어질 때, 넓이를 구하려면 여러 방식이 있다. 

오각형 밖으로 큰 사각형을 두고, 오각형 외부 삼각형들의 넓이를 빼거나, 오각형 내부를 삼각형으로 나누어서 해당 삼각형들의 넓이를 더하는 방식 등등이다.

<br>

모든 단순 다각형은 삼각형으로 이루어지기 때문에, 이 삼각형의 넓이를 이용해 넓이를 구하는 것이 신발끈 공식의 초석이다.

<br>

여기서 잠깐 삼각형의 넓이를 구하는 방식을 생각해보자.

> "(밑변 X 높이)/2 아님? ㅋㅋㅋㅋ"

음... 이것도 삼각형의 넓이를 구하는 것이지만, 이 공식을 설명하기 위해서 벡터를 이용할 생각이다.

<br>

우선 한국에 교육 과정상 기하와 벡터가 수능(가형) 친구들이 배우는 과목이기 때문에 모르는 사람들이 있을 것 같기때문에 벡터의 개념, 외적-내적만 잠깐 설명하고 넘어가도록 하자.


---

<br><brs>

**벡터란?**

벡터는 안타깝게도 관점에 따라 그 개념이 조금씩 다르다.(하지만 본질은 똑같은 내용이다.)

벡터는 서로 합할 수 있고, 배수로 늘리거나 줄일 수 있다. 덧 붙여서 벡터는 크기(scalar)와 방향을 가지며, 좌표계에서 어디서 시작하든 상관이 없다.

<br>

즉, 같은 크기와 방향을 가진 벡터는 같은 벡터라는 의미이다. 

크기가 0인 벡터를 영벡터라고 하고, 같은 벡터이지만 방향이 반대인 벡터를 음벡터라 하고, x라는 벡터에 대해 -x로 표시한다.

<img width="200" alt="스크린샷 2021-12-29 오후 1 20 49" src="https://user-images.githubusercontent.com/47859845/147627121-0ae3280b-9642-49ab-b8e0-22beedb45b2f.png">


<br>
<br>

다음으로는 합과 배수로 늘리고 줄이는 경우이다.

<img width="435" alt="스크린샷 2021-12-29 오후 1 30 36" src="https://user-images.githubusercontent.com/47859845/147627508-5adc8ed5-0b75-4c09-8b4a-e9caa00920d9.png">

이와 같이 두 벡터를 합할 수 있고, m이라는 스칼라(크기)를 곱해서 늘리거나 줄이는 게 가능하다.


<br><br>

이는 2차원 평면상에서든 3차원 공간에서든 같다.

현재 우리는 삼각형의 넓이를 위해 2차원 공간임을 가정하자.
이때 삼각형 넓이는 두 선분의 외적을 반으로 나눈 것과 같다. 외적과 내적을 살펴보며 넓이에 대해 생각해보자.

<br>

**벡터의 외적-내적**

<img width="583" alt="스크린샷 2021-12-29 오후 1 57 06" src="https://user-images.githubusercontent.com/47859845/147628760-aeb5a834-948e-4f1f-bd78-ce8161edff8e.png">

<br><br>

**내적**

내적은 쉽게 말해서 한 벡터를 다른 벡터에 투영시키는 것이다. 말 그대로 투영이기 때문에 방향성은 없고 크기만 있다. 위 그림처럼 A*B 내적인 경우,

<img width="169" alt="스크린샷 2021-12-29 오후 2 01 11" src="https://user-images.githubusercontent.com/47859845/147628969-1cf5b6dd-dc05-451c-b73e-22a8862fe43b.png">

이러한 공식으로 스칼라(크기) 값만 나온다.

<br>

**외적**

외적은 두 벡터가 만든 평행사변형에 수직인 벡터이다. (오른손의 법칙인가 뭔가도 있다.) 이때 이 벡터의 크기는 놀랍게도 두 벡터가 만든 평행사변형의 크기와 같다.

> "갑분 평행사변형의 크기..?"

나도 고등학교때 이런 생각을 했다. 당시 선생님이 증명도 해주셨지만 생각이... 안난다... ㅠㅠ

<br>

아래는 그 증명이다.
<img width="800" alt="스크린샷 2021-12-29 오후 2 09 47" src="https://user-images.githubusercontent.com/47859845/147629363-1996dfef-9a3f-4368-9fb8-afe057c2cb06.png">

두 벡터 크기의 sin⍬으로 밑변 X 높이가 성립되어서 해당 평행사변형의 넓이가 된다. 여기서 반으로 나누면 두 벡터에 대한 삼각형의 크기로, 이는 일반 도형에서도 사용가능하다. 

<br>

두 변에 대한 외적식의 1/2는 바로 신발끈 공식이다! 
<img width="335" alt="스크린샷 2021-12-29 오후 2 14 20" src="https://user-images.githubusercontent.com/47859845/147629547-5e8ac9c6-95be-4a3f-b7de-ba28ef2e2a66.png">

빨간색은 +, 파란색은 -로 두면 위 코드에서 아래 부분처럼 식이 나온다.

```java
sum=((x1*y2)-(x2*y1))+((x2*y3)-(x3*y2))+((x3*y1)-(x1*y3));
```


<br>

이와 같이 다각형을 각 삼각형으로 나눈 뒤, 벡터의 외적을 이용해 삼각형 넓이를 구하는 과정을 진행해 다각형의 넓이를 구하는 코드였다!

<br>
<br>
<br>