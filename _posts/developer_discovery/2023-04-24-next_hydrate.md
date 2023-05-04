---
title: "hydrate 란?"
date: 2023-04-24
categories:
  - developer_discovery
tags:
  - developer_discovery
---

지난 번에 이어서 로그인에서 받은 토큰 값을 이용해서 렌더링을 분기 시키는 작업을 이어 하던 중 에러를 마주쳤다. hydration이 잘못됬다는 오류였는데…

![Screen Shot 2023-04-23 at 3 52 10 PM](https://user-images.githubusercontent.com/47859845/233912536-22d8c4f8-1b8e-48b4-a98a-b1c485fd17da.png)


자세히 보면 아래와 같다.

```python
Unhandled Runtime Error
Error: Hydration failed because the initial UI does not match what was rendered on the server

Unhandled Runtime Error
Error: Text content does not match server-rendered HTML.

Unhandled Runtime Error
Error: There was an error while hydrating. 
Because the error happened outside of a Suspense boundary, 
the entire root will switch to client rendering
```

<br>

**Hydration?**

하이드레이션이란, React-DOM에서 페이지를 다시 그리는 기능을 이야기한다. react와 같이 동적 웹페이지의 경우, 기존 뼈대를 먼저 렌더링 한 이후에 요소를 다시 렌더링한다. 이러한 특징은 SSG 나 SSR에서 일어나는데 그 과정을 한번 알아보자. SSR은 서버에 요청을 보내면 서버에서 각 html 과 페이지들에 대한 정보를 보낸다. 클라이언트에서는 하나씩 데이터를 가져오는데로 페이지를 구성해갑니다. 주로 HTML → JS → Hydrate 순서로 진행된다.

즉, 기본 뼈대(HTML)만 잡아두고 이후 기능 보충(JS)하는 것을 hydrate 라고 한다. 따라서 hydrate가 일어나야 버튼을 눌렀을 때 정상적으로 기능할 수 있는 것이다.

<br>

내 생각에는 component return 전에 if 문으로 분기처리를 해서 hydrate할때 문제가 생기는 것 같다.

![Screen Shot 2023-04-23 at 4 25 36 PM](https://user-images.githubusercontent.com/47859845/233912540-932246ae-b0e7-4ed8-8eae-7fa06b9877da.png)


기존 코드에서 className 을 토큰이 있는지에 따라서 결정되도록 해두고, disable 일때 `display: none` 으로 두어서 보이지 않도록 수정했다. 이러면 초기에 getCookie에 따라서 렌더링되는 Dom 구조가 달라지기 때문에 오류가 나온 것이다. 오류를 살펴보던 중 [링크](https://nextjs.org/docs/messages/react-hydration-error)가 있어서 한번 살펴보았다.

<br>

해당 문서에서 이야기하는 오류의 원인은, 어플리케이션을 렌더링하는 동안 리액트 Dom 에서 먼저 렌더링하게 되는데, 해당 Dom 트리와 현재 렌더링하는 트리의 차이가 있어서 문제가 생기는 것이다. 내가 생각하던 부분이 맞았다…

이걸 수정하려면… useState를 이용해야했다. 일단 로그인 여부만 확인하기 위해서 refresh_token이 유무에 따라서 렌더링 요소를 변경하도록 하였다.

```python
const [isLogin, setisLogin] = useState(false);
useEffect(() => setisLogin(getCookie('refresh_token') != null), []);

<a className={`${isLogin ? styles.signup_link : styles.disable}`} > 로그 아웃 </a>
...
```

이번에는 정상적으로 잘 나온다!!

![Screen Shot 2023-04-24 at 12 49 35 PM](https://user-images.githubusercontent.com/47859845/233912556-39a2b030-ca47-400a-8c1f-d01e19a8b825.png)

<br>


### 정리하기


**useState란?**

리액트에서 변경되는 값을 관리할때 기존에는 컴포넌트에서 관리하지 못했었는데 16.8 이후 버전 부터 이 useState를 이용해서 값을 관리할 수 있게 됩니다. 아래와 같이 useState는 배열로 반환되는데, 0번재는 값을 1번째는 setter 함수를 반환합니다. 여기서 코드에서 0을 넣어주었는데 이러면 value에 기본값으로 0이 들어갑니다.

```python
const [value, setvalue] = useState(0);
```

이렇게 하면, setvalue 함수를 이용해서 value의 값을 변경시킬 수 있다.

<br>

**useEffect란?**

리액트가 초기에 Dom을 미리 구성하고, 특정 값이 달라지는 경우 감지해서 이를 변경할 수 있도록 하는 함수이다. 여기서 몇가지 목적에 따라 사용방식이 달라지는데 정리하면 다음과 같다.

```jsx
// 간단히 구성
useEffect(() => { console.log('useEffect!') });

// 빈 dependency
useEffect(() => { console.log('useEffect!') }, []);

// dependency 를 이용한 경우
useEffect(() => { console.log('useEffect!') }, [dependency]);
```

<br>

**간단히 구성**

렌더링이 완료 될 때, 값이 변경될 때마다 실행이 된다. 해당 코드를 넣고 실행시키면…! 아래처럼 3번 실행된다.

```jsx
useEffect(() => { console.log('useEffect!') });
```
![Screen Shot 2023-04-24 at 1 21 44 PM](https://user-images.githubusercontent.com/47859845/233912542-3ee49d6c-5b4c-40c2-a708-2764cfb77acd.png)



페이지가 처음 렌더링되고 한번 실행되고, 값(요소)이가 변경되는 경우 한번 실행되어서 총 2번이 실행되게 된다. 여기서 요소(값)은 useState 값일 수 있고, 실제 보여지는 Dom의 구성요소 일 수 있다. 작은 것 하나가 바뀌더라도 해당 함수가 호출된다. 따라서 이대로 사용하면 너무 많이 호출되기 때문에 비효율적이다.

<br>

**빈 dependency**

아래 코드를 넣고 돌리면, 2번만 실행된다.

```jsx
useEffect(() => { console.log('useEffect!') }, []);
```

처음 렌더링때 1번, 렌더링 이후에 1번 해서 총 2번만 실행되고 이후에는 실행되지 않는다.
![Screen Shot 2023-04-24 at 1 23 05 PM](https://user-images.githubusercontent.com/47859845/233912546-57405130-8a1e-4cf0-9d15-12b66513e71e.png)



<br>

**값이 있는 dependency**

아래 코드와 같이 초기에는 +1 씩 업데이트 되도록 두었다.

```jsx
const [dependency, setdependency] = useState(0);
const updateDependency = () => setdependency(dependency + 1);
useEffect(() => { console.log('useEffect!') }, [dependency]);

....

<button onClick={updateDependency}> update </button>
```


![Screen Shot 2023-04-24 at 1 30 37 PM](https://user-images.githubusercontent.com/47859845/233912548-6f9313ee-c222-412b-976e-27d4ecbb7f84.png)

이제 오른쪽 상단 update 버튼을 누르면…이렇게 로그가 쌓인다. (3번 누름)

![Screen Shot 2023-04-24 at 1 31 00 PM](https://user-images.githubusercontent.com/47859845/233912549-8296b308-def2-4b7b-8fe0-423c5cad1662.png)


<br>

정리하면… 다음과 같다.

1. 초기 렌더링시 useEffect가 무조건 한번 실행된다.
2. 사소한 변경시에는 dependency를 없이.
3. 초기 렌더링 이후 1번만 실행되면, 빈 dependency 로 작성.
4. 초기 렌더링 이후 특정 값에 따라 실행되도록 하려면 dependency에 값 추가.


<br><br>
