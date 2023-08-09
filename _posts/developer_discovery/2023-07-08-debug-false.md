---
title: "Debug=False 와 렌더링 시간"
date: 2023-07-08
toc: true
categories:
  - developer_discovery
tags:
  - developer_discovery
---



### Debug=False 적용에서 생긴 일…

Django는 테스트 환경에서는 Debug=True로 두고 확인을 한다. 이 경우, static 파일 등을 전송해주지만, 에러 상황등이 있을 때 웹페이지에 오류 및 코드가 보이기 때문에 보안상 좋지 않다. 따라서 DEBUG=False로 프로덕션을 구성하는데…

![Screen_Shot_2023-07-08_at_8 58 19_PM](https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/66cfddbd-64d5-44a3-950d-fd58f39b3be8)

문제는 위와 같이 관련 CSS, JS 파일이 404 에러가 나오게 되는 점이다. 이걸 해결하는 방안으로는 기존 Next.js 를 SSG 방식, 즉 정적 파일로 만들어서 S3에 올리고, 서버에서 이를 가져오는 방식이 있다. 다른 하나는 nginx 인데…. 이 경우 현재 배포 프로세스를 변경해야하는 문제가 있었다.

<br>

S3를 올리는 것 보다, nginx를 추가하더라도 SSR 방식을 고수하는 것이 좋을 것이라고 생각이 들었다. SSG 라면 결과적으로 풀스택 개발과 동일한 것 뿐만아니라, S3에 올리고 다시 가져오는 방식에서 비효율적이라고 느끼게 되었기 때문이다.

<br>

ECS 를 이용하는 것도 생각을 해보았지만… 생각보다 ECS의 가격이… 컸다.. 내 생각에는 어느정도 트래픽이 높은 경우에는 ECS 가 효율적일 것 같지만, 현재 이런 토이 프로젝트 같은 경우는 적게 가져가도 될 것 같다. 또 쿠버네티스를 공부하다 보면 또 다른 방법이 있을 수 있어 다음 프로젝트때 살짝 생각해보기로 한다.

<br>

결과적으로 현재 구성에서 ECR 제거, CodeDeploy 내부 스크립트가 변경되고, EC2 내부에 Nginx가 Django와 Vercel 트래픽을 나누는 것이 된다.

![DeveloperDiscovery](https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/1585ee8f-9393-4565-ae16-a03009a0beaf)

Nginx를 도입함으로 얻는 효과는 로컬에서도 SSL 적용이 편리해졌다는 점이고, DEBUG=False 에서도 페이지를 완벽하게 서빙한다는 점이다.

문제는 배포 스크립트 및 스테이지(개발, 프로덕션) 설정을 제대로 해야한다는 점이다. 오히려 좋을지도…? 일단 EC2 내부에서 직접 명령어를 입력해서 배포해둔 상태이고, CodeDeploy, compose 파일 등을 수정할 예정이다.

<br>

<br>

### **페이지 로딩…문제**

![Screen_Shot_2023-07-08_at_4 30 03_PM](https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/21b9cce3-ea4c-4f0f-a4db-d9f05da83cc4)

![Screen_Shot_2023-07-08_at_4 22 20_PM](https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/6ad35797-b217-4fc4-abe2-c1af5059485c)



프로덕션에서 렌더링 시간이 1분 정도 걸린다. 단순히 메인 페이지에서 회원가입 페이지 등으로 이동할 때에도 같은 결과이다. 이렇게 시간이 오래 걸리는 원인으로 몇가지 생각해보면 아래 외에 몇가지 더 있을 것 같다.



- CSS, JS 최적화
- 이미지나 파일 용량
- 요청 수
- DNS
- 캐싱 안됨

<br>

1. **서로 다른 서버**

    페이지가 SSR 방식인데, 이게 Vercel → Ec2, EC2 → Vercel 로 통신이 이루어지기 때문에 그런 것 같다. 이렇게 서로 다른 서버에서 통신하게 되면 그만큼 DNS 에서 도메인을 찾는 과정이 있고, 그 사이에 파일이 전송되기 때문에 딜레이가 있을 수 있다.


    ![Screen_Shot_2023-07-08_at_4 30 33_PM](https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/15599283-3aaa-4943-bf92-a518492fe997)


    즉, 페이지를 렌더링 할때 API 호출 → 페이지 생성 → EC2로 전송 → 클라이언트에게 전송 으로 네트워크 통신이 많기 때문이 아닐까 생각한다. 캐싱을 하거나, 서버를 가까이에 두도록 구조를 변경해야 시간이 줄어들 것 같다.

    현재는 프론트엔드가 EC2 외부에 있지만, 이를 내부에 두면 외부 네트워크를 탈 이유가 없으니 시간을 조금 줄일 수 있을 것 같다.

    <br>

1. **캐시 사용하기**

    API 데이터에 따라 내용이 변하지 않는 페이지, 로그인, 회원가입 페이지, 탈퇴 페이지 등은 캐시를 오래 잡아도 상관이 없다. 이런 부분도 캐싱 해두면 리소스 요청을 줄일 수 있다. CDN 인 CloudFront를 사용할지는 조금 생각해봐야 할 것 같다. 또는 브라우저 캐시나 등등을 고려해봐야 할 것 같다.

    <br>

    일단, 개인적인 생각은 이렇고, 실제 pagespeed를 이용하면 다음과 같다.


    ![Screen_Shot_2023-07-08_at_5 10 39_PM](https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/8b7aee46-c1d3-40be-a605-9b81cfd02ec6)

    ![Screen_Shot_2023-07-08_at_5 11 22_PM](https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/6ae2366f-5d71-4e43-91ae-788be041a796)


    사용하지 않는 자바 스크립트… 텍스트 압축등이 있다. 그런데… 데스크톱의 경우 결과가 달랐다…?


    ![Screen_Shot_2023-07-08_at_5 12 37_PM](https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/d2f8cd42-8376-4166-a152-5526de15b79e)

    몇번 접속하면 위와 같이 성능이 향상되었다고 나오지만, 브라우저 캐시를 지우면 다시 시간이 오래걸리는 이슈가 있었다. 첫 접속시 렌더링 시간이 오래걸리는 것은 사실 큰 문제이다.

<br>
<br>
