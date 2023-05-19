---
title: "에러 메세지, 디자인 수정, 프로필"
date: 2023-05-19
toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - developer_discovery
tags:
  - developer_discovery
---


### 그동안 해온 것들


약 2주간, 몇가지가 진행되었는데, 주로 디자인 과 기능 추가와 관련된 내용이 많다. 프론트에서는 에러 메세지를 보여주는 toast 메세지를 추가하였고, 프로필 페이지에서 토큰을 api에 같이 보내는 것 역시 끝냈다. 정리하면 다음과 같다.

<br>

- react-toastify 적용 및 api 에러 시 toast 메세지 설정
- 메인 페이지 디자인 수정 및 이미지를 백엔드에서 가져오도록 설정(url을 보내도록)
- 프로필 페이지에서 jwt 토큰을 넘겨서 해당 유저 정보를 가져오도록 설정

<br>

하나씩 확인해 보면 다음과 같다.

<br>

### react-toastify 적용

<br>

적용은 간단하다. [공식 npm](https://www.npmjs.com/package/react-toastify) 에서 소개한 것과 같이 인스톨 한 뒤, 에러 메세지가 뜨는 페이지에 `<ToastContainer />` 를 추가한다. 에러 메세지가 띄워지는 로직(내 경우에는 api 에러) 에서 아래와 같이 추가하면 된다.

```jsx
toast.error("회원가입 실패 각 값을 채워주세요", {
                position: "top-center",
                autoClose: 1000,
            });
```

<p align="center">
<img width="700" alt="Error-toast" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/8f7e3297-c50c-44f6-bdf1-65d35c582ee0">
</p>

다음과 같이 toast가 뜨는 걸 볼수가 있다.

<br>

### 이미지 url 을 api로 전송

<br>

이것도 간단하다. 그냥 이미지 url을 백엔드에서 api로 보내면, 프론트에서는 해당 url을 img 태그에 담아서 보여주는 것이다. 하지만, 모든 이미지가 백엔드에서 가져오는 것은 비 효율적이니까 추후에 캐싱을 적용하는 것이 좋을 것 같다. AWS cloudfront나... 이건 일단 나중에 생각해보자.

<br>

<p align="center">
<img width="700" alt="img-url-api" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/0d10f207-1fc1-4b1c-a72c-4d4f730b5e44">
</p>

<br>

### jwt 토큰을 넘겨서 유저 인증

이제까지 다른 api와 달리 유저의 인증이 필요한 api로 current api를 작성하였다. current api는 유저의 jwt를 보내면, 해당 유저의 이메일, 이름을 리턴하도록한다.

이것 뿐만 아니라 이메일 변경, 탈퇴, 비밀번호 변경 버튼도 있어서 해당 api 들 모두에 유저 인증이 필요하다. 과정을 간단히 설명하면 다음과 같다.

```jsx
export const userCurrent = async () => {
    refreshToken();
    const { data } = await ApiClient.get<UserState>(`api/v1/users/current`,
        { headers: { authorization: `Bearer ${getCookie("access_token")}` } });
    console.log(data);
    return data;
};
```

<br>

위와 같이 current api headers에 토큰을 같이 보낸다. jwt는 쿠키에 토큰 값을 저장하기 때문에 getCookie로 브라우저에서 쿠키 값을 가져와서 api에 넣어두는 것이다. 이제 백엔드에서는...

```python
class CurrentUserView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        if request.user is not None:
            return Response({"id": user.id, "email": user.email, "name": user.name}, status.HTTP_200_OK)
        else:
            return Response({"error_msg": "비 로그인 상태입니다."}, status.HTTP_401_UNAUTHORIZED)
```

JWTAuthentication 과 IsAuthenticated 를 이용해서 처리를 한다. 두가지 모두 통과하면 아래 get 메소드에서 처리를 한다.

<br>

현재 진행중인 것은...

- 프로필 관련 기능(이메일 변경, 비밀번호 변경, 탈퇴하기) api 및 페이지 추가
- 메인 페이지 디자인 추가

위와 같고, 메인 페이지의 경우


<p align="center">
<img width="700" alt="Screen Shot 2023-05-19 at 10 39 59 AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/12f4c3f5-485c-4a47-9159-c8227027d4ab">
</p>

<p align="center">
<img width="700" alt="Screen Shot 2023-05-19 at 10 40 06 AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/d48a81bb-c3fd-4c5d-a8cd-f0ea26574868">
</p>

위와 같이 디자인이 되어있고, 디스플레이 크기에 따라서 조금... 이상하게 보이기도 한다. 😅

<br>

추가적으로 테스트 코드가 많이 부족하다. TDD가 이상적일 것 같은데 일단 기획이 정확하게 확정되지 않았기 때문에 TDD를 하기에 너무 힘든것 같다. 다음 프로젝트에서는 기획부터 꼼꼼히 작성하는 것이 좋을 것 같다. (기획하는 법도 공부해볼까..?!)

<br>
<br>
