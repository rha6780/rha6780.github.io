---
title: "Next.js 구조를 잡으면서"
date: 2023-02-09

categories:
  - developer_discovery
tags:
  - developer_discovery
---


### 인터넷은 모든 걸 알고 있다..

django에서 next.js의 html 파일들을 가져와서 렌더링하는 방식으로 찾고 있었는데, 딱 내가 생각하는 구조를 설명하는 글이 있었다.

[Django + Next.js The Easy Way](https://medium.com/@danialkeimasi/django-next-js-the-easy-way-655efb6d28e1)

여기서 설명하는 라이브러리에는 [django-nextjs](https://www.notion.so/React-Next-js-09c5c85e86dc4592872b13d2d65e6689) 가 있었는데, 이때 머리를 맞은듯이 왜 웹서버로 django로 두어야 할까 그냥 api 용도로 하고 next.js에서 렌더링하면 되지 않을까? 생각하게 되었다.

![Screen Shot 2023-02-09 at 11 08 36 PM](https://user-images.githubusercontent.com/47859845/232233043-19cdd746-d582-4116-b566-93aa432c2f6d.png)

뭔가 조잡하지만 대충 위와 같은 구조이다. 기존에 웹서버로 django 를 베이스로, 페이지만 next.js에 요청하는 방식이라면, 이후 결정한 구조에서는 next.js를 주 웹서버로 두고 django 는 api만 응답하는 용도로 하는 것이다. 그런데… 이러면 CSR과 동일한 부분으로 작동하는데... 일단 SEO는 나중에 생각하고 구현부터 해둔 다음 생각해보는 것으로 진행한다.

![brain](https://user-images.githubusercontent.com/47859845/232233063-839516ee-8d3a-46a3-86fa-034733079b6e.jpeg)


일단, next.js는… 문법과 api 응답을 어떤식으로 처리하고 구조를 어떻게 가져갈지 좀 더 공부해보는 편이 좋을 것 같다. 유튜브를 보다보니 api 응답 status를 모아둔 파일이 있고, 각각 api마다 필요한 응답 처리를 가져와서 사용하는 방식으로 작성한 사람도 있었다.

유지 보수면에서 좋아보이는데 실제로 내가 제대로 사용하려면 그 구조나 큰그림을 그려야 하지 않을까… `JUST DO IT` 도 좋지만, 방향을 정해야 전력질주 할 수 있기 때문에 정보를 모아야 겠다..

<br>

### 그러면 구체적으로 해야할 일이 뭘까…?

1. 토큰 인증 정리하기
2. nginx 삭제
3. next.js에서 api 호출 및 렌더링 처리

JWT를 사용하면 토큰 탈취나 refresh token 등을 설정해줘서 보안 쪽을 확인해봐야하는 작업이 있어 우선 정리 먼저 해야할 것 같다. 우선 이정도로 두고 개발환경에서 로그인 상태를 유지하는 것을 목표로 잡자. 이제 실질적으로 테스트 코드 및 워크 플로우도 작업을 해두어야 할 것 같다. 하고 싶은 건 많은데 몸은 왜 하나일까..

![분신술](https://user-images.githubusercontent.com/47859845/232233069-872be542-471b-4dae-ba8e-fe7aa9eb3b06.jpeg)

맘 같아서는 나루토가 되고 싶다.

<br><br>
