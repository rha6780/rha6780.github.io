---
title: "Next.js Docker로 연결!"
date: 2023-02-12

categories:
  - developer_discovery
tags:
  - developer_discovery
---

### Docker 다시 작성하자…

Next.js 로 변경되면서 기존에 react로 썼던 docker 파일을 수정하게 되었다. 기존에 사용하던 docker 파일로 작업을 시작하려했는데 8000 포트와 연결이 안되고, 수정하다보니 완전히 작동을 안하게 되었다.

결국 몇가지 참고해서 조금 수정하게 되었다. 기존 node-16 대신 18로도 업그레이드 하려 했지만, 생각보다 오류가 많이 나와서 기존 코드에서 몇가지만 참고하는 수준으로 수정되었다. (에러 좀 찍어서 기록해둘걸..)

![Screen Shot 2023-02-12 at 2 14 07 PM](https://user-images.githubusercontent.com/47859845/232233298-4a4f605c-f3eb-43c2-8225-90efec49dc92.png)

<br>

**참고 자료**  
[Deployment | Next.js](https://nextjs.org/docs/deployment)

[How to use Next.js with Docker and Docker compose a beginner's guide](https://geshan.com.np/blog/2023/01/nextjs-docker/)


크으으 다시 복구 완료이다!

우선 로그인/회원가입 페이지부터 건들이기로 했다. `“보기 좋은 떡이 먹기도 좋다.”` 라는 말이 있듯이 가시성 있게 변경해야 테스트하기 편할 듯 하고, api 테스트할때 클라이언트가 먼저 구성되어야 전체 흐름을 확인 할 수 있을 것 같다.

글로벌 css의 경우, style/globals.css 로 들어가 있는데 이를 pages에 app.tsx에 import 시키면 적용된다. 우선 간단히 양 옆에 여백을 주고, 가운데에 관련 컴포넌트를 추가하는 식으로 작성하자. (nav*bar 의 경우만 조금 신경쓰자.)

![Screen Shot 2023-02-12 at 3 17 21 PM](https://user-images.githubusercontent.com/47859845/232233300-2b07b44d-4fae-4354-84fb-c5029457d173.png)

어라…?

되긴 하지만, 문제는 코드가 변경될때 마다 docker 이미지를 새로 빌드해야한다는 점이다. 볼륨이나 마운트 설정을 통해서 로컬 코드가 바로 docker에 적용되도록 수정이 필요하다. 또한, volumn을 지정해두어서 로컬 코드가 변경될 때 docker 내부 코드도 변경된다. 
핫로딩을 위해 docker-compose 파일에 `restart: always`를 추가했다.

[ImpleDocker With Hot Reloading In Next JS](https://articles.wesionary.team/impledocker-with-hot-reloading-in-next-js-f3e57fba84ce)

이제 코드를 반영하면 자동으로 [localhost:3000](http://localhost:3000) 에 반영되기 때문에 쉽게 확인이 가능하다. (api를 담당하는 django에도 적용해두었다.)


<br><br>
