---
title: "일반 React 프로젝트를 Next.js 로 옮기면서…"
date: 2023-02-02

categories:
  - developer_discovery
tags:
  - developer_discovery
---


### SSR… 결국 Next.js로

우선 무지성으로 진행하였는데, 로그인을 어떻게 구현할 지에 대해서 문제가 생겼다. 같은 세션인 백엔드(localhost:8000)에서는 current api 가 성공적으로 데이터를 보여주지만… react 즉 프론트(localhost:3000) 쪽에서는 보여지지 않는다. 세션이 다르기 때문이다….

![nooooo1](https://user-images.githubusercontent.com/47859845/232232513-b3cd283e-bc40-4484-9386-2392cbf11428.jpeg)

세션이 다르더라도 JWT 토큰 처럼 브라우저가 해당 유저임을 인증만 한다면 로그인 여부를 전달해 줄 수 있다. 혹은 백엔드에서 해당 화면을 그려주면 되는 문제였다..

<br>

**SSR vs CSR**

방법을 찾다가 SSR 방식을 이용해서 구현하기로 하였다.. CSR 쪽으로 하기엔 SEO 최적화하는게 어려울 것 같아서다. 방법이 있다곤 했지만, 그보다는 SSR이 더 좋아보였다. SSR에서는 서버에서 화면을 그리고 넘겨주는 방식으로 백엔드에서 요청을 하면 화면을 그려줄 render 서버가 필요했다. 이 Next.js가 좋다는 이야기를 듣고 React → Next.js 로 전환하기로 하였다. (Next.js로 두고 나중에 express로 확장 가능하다.) 

<br>

**참고 문서**  
[Migrating to Next.js: Migrating from Create React App | Next.js](https://nextjs.org/docs/migrating/from-create-react-app)
    

### 이민 성공..?

사실 마이그레이션이 크게 어렵지는 않았다. 내 경우 일단 다른 폴더에 next.js를 만들고, 원래 작업폴더에 내용을 옮기고 삭제하기를 반복했다. next를 설치하는데 오류가 있어서 각각 아래와 같이 진행했다.

```python
# next install
npm i -g next

# Cannot find module 'babel-plugin-styled-components' Error
# ''안에 해당하는 값을 넣으면 된다.
npm install --save-dev babel-plugin-styled-components

```

> 어…? 이건 문서에 없었는데… ;;



![Screen Shot 2023-02-02 at 8 23 14 PM](https://user-images.githubusercontent.com/47859845/232232540-90506a2f-2342-4e44-a9bf-d52e2737e9c9.png)

처음보는 에러가 가득한… 경험이었다. 원인은 내장 CSS를 사용하기 때문에 기존에 사용하던 css를 옮겨야 했다. 저 문구를 보면 알 수 있듯이 글로벌하게 적용할 css가 있고, 그런게 아니라면 css 모듈을 이용해서 작성해야한다. 

결국…. css를 다시 설정해야했다.. 또 이번 이민으로 `import { Home } from ‘../components’` 같은 것도 변경되었다. index.js로 각 컴포넌트들을 불러오도록 한 것들을 삭제하고 해당 컴포넌트를 바로 불러오도록 바뀌게 되었다. `import Main from '../components/Home/Main'` 또 router도 react-router-dom 랑 다르게 동작한다.

<br>

**참고 문서**  
[Basic Features: Built-in CSS Support | Next.js](https://nextjs.org/docs/basic-features/built-in-css-support)
    

<br>

### 시간선이 바뀐다.. router 폴더 구조!

기존 React에서는 어떤 페이지에 해당하는 라우터를 정의한 파일에서 페이지를 호출해서 그리는 형식이다. 파일도 따로 두었다. 하지만, Next.js는 단순히 폴더구조로 url을 나타낼 수 있다. (ex: `pages/about.js`→`/about` 이런식으로 설정된다.) 또 url에 slug가 있는 경우 router에서 넣어주어야 되는 것이 next에서는 간단하게 해결된다..! 뭔가 더 좋은 것 같기도…한데 페이지가 많아지면 파일도 많아질 것 같다...

![Screen Shot 2023-02-02 at 10 06 25 PM](https://user-images.githubusercontent.com/47859845/232232717-403c4d8c-6fa4-4399-aa6d-a547926ebf5d.png)


후 일단 css 말고는 전부 완료되었지만… 공들인 모래성이 다시 무너진 기분이다…

![not_happy](https://user-images.githubusercontent.com/47859845/232232725-e30955d6-9f18-43ee-b181-680c9cca7b17.jpeg)

<br><br>
