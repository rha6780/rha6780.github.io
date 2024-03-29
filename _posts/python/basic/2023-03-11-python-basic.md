---
title: "[Python] 변수 선언"
date: 2023-03-11

categories:
  - python

---
### 변수

모든 언어의 기초 “변수”를 파이썬에서 어떻게 정의하는 지 정리합니다. (라임 지렸다…)

```python
dog = 'dogo' #string

age = 10 #number
```

요렇게 쉽게 변수를 정의할 수 있는데, JAVA 와 달리 변수의 타입을 먼저 정하지 않는다. 문제는 이러한 처리 방식을 항상 염두해두어야 한다는 점이다. 

한 변수에 여러 타입을 넣을 수 있는 것은 확실히 프로그래밍을 할 때 타입을 결정해야한다는 스트레스를 줄일 수 있다. 하지만, 해당 변수가 동적으로 변경될 수 있다는 점은 몇가지 문제점이 있을 수 있다.

<br> 

예를 들어 아래와 같이 간단한 함수가 있을 때 …

```python
def add(a, b):
	a+b
```

위 함수에서 a, b에 대한 타입이 무엇인지 함수는 모른다. 그렇기 때문에 오버로딩을 할 때(함수명은 같지만, 타입이 다른 변수를 받는 경우)에는 처리가 필요하다. 

만약 처리하지 않는다면, 실수로 문자, 숫자를 넣었을 때 에러가 나오게 된다.

<br>

> *해당 변수를 항상 숫자로 정의해두면 되지 않나?*


물론! 변수의 타입이 항상 결정된다면 문제가 없지만, 코드의 수가 많아지고, 다른 사람이 코드를 수정하다 보면 가끔 문제가 되는 경우가 있다…

이런 경우, 함수 내부에 if문을 두어서 특정 type일 때 다르게 동작하도록 수정하거나, 함수명을 다르게 가져가는 방식이 있다. 

파이썬 뿐만아니라 다른 타입 추론 방식의 언어들도 비슷하다.

<br>

### 특수한 경우

파이썬에서는 null을 None이라고 작성한다.

즉, 해당 변수의 타입이 동적으로 변하기 때문에 null 값이 있는 변수의 타입을 처리하기 위해서 NoneType이 있는 것이다. 사실 내 뇌피셜이다…. ㅎㅎ(JAVA에서는 null이 변수의 값이지 변수 타입으로 정하지 않았으니까.. 이런 이유지 않을까..?)

또한, boolean 에 경우, 대문자로 시작해야한다. ex: (True, False)

<br>

### 네이밍 컨벤션

파이썬에서는 주로 스테이크 케이스로 이름을 붙인다. 파이썬 로고가 뱀인것만 해도 쉽게 알 수 있다…! 

```python
snake_case = 'shh...'
```

