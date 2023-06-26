---
title: "도메인 연결 및 EC2에 웹 올리기"
date: 2023-06-22
toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - developer_discovery
tags:
  - developer_discovery
---


# 포크번, 도메인 설정.. 삽질

1년에 만 이천원이면… 꽤 합리적인 것 같아서 포크번에서 도메인을 구매하였다. 가비아나 기존 AWS 에서 구매할까 하다가 포크번이 더 저렴한 것 같아서 이용하게 되었다.

<p align="center">
<img width="500" alt="Screen_Shot_2023-06-22_at_10 31 23_PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/8008f977-f681-4525-8dca-30317dbb6f47">
</p>

도메인 구매 이후 적용되는 동안, AWS에서 해당 호스팅 존을 생성하고 그 정보가 필요하다. 포크번에서 호스팅 할 수 있지만, AWS 공부를 위해 서버만 등록하기로 하였다.

테라폼을 이용해서 빠르게 생성하고 확인하자.
<p align="center">
<img width="500" alt="Screen_Shot_2023-06-22_at_10 52 02_PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/e8dd5038-ced9-44d0-b33e-4c62158321bf">
</p>

<p align="center">
<img width="500" alt="Screen_Shot_2023-06-25_at_8 44 55_PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/27a59415-c360-47c7-9f41-895749a1c918">
</p>

<p align="center">
<img width="500" alt="Screen_Shot_2023-06-22_at_10 52 49_PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/9e27b38a-ed4a-4ac3-8b70-a0e9d05f58df">
</p>

해당 페이지에서 네임 서버들을 포크번에서 구입한 네임서버 칸에 추가한다.

<p align="center">
<img width="500" alt="Screen_Shot_2023-06-22_at_10 55 19_PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/91151d03-dc3d-465a-b39a-ba5e3d176692">
</p>

DNS 캐싱이 있어서 조금 기다리면 확인 할 수 있다. 그동안 다른 인프라를 구성했다.

<br>

alb의 타겟 그룹으로 VPC와 Ec2를 연결하고 확인해봤는데… unhealthy 상태이다. 아무래도 port가 8080으로 되어있는데 Ec2의 포트설정과 다른게 문제가 된것 같다.

<p align="center">
<img width="500" alt="Screen_Shot_2023-06-22_at_11 25 13_PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/7b8bc48d-6d96-4803-b57f-cf337e9ea7d9">
</p>

80으로 바꿨는데.. 이번엔 details에 뭔가 떴다. 404… not found 라.. 

<br>

<p align="center">
<img width="500" alt="Screen_Shot_2023-06-22_at_11 51 02_PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/3c19ad17-dde8-4942-bf60-3d0210ea7072">
</p>

<br>

다시 확인 하니 health check url이 /ping 이었는데 해당 response를 정의하지 않아서 생기는 문제다. 추가하고 기다리니 아래처럼 통과했다.

<p align="center">
<img width="500" alt="Screen_Shot_2023-06-23_at_12 09 39_AM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/21b64809-7227-4d39-bd03-c84dbf76d579">
</p>

<br>


실제 주소에 내가 구매한 도메인을 치면 api 서버 가 나오게 된다. 이제 SSL 설정 이후 SSR 하도록 설정하면 된다.

<p align="center">
<img width="500" alt="Screen_Shot_2023-06-23_at_12 11 29_AM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/4e66240c-687e-4cb3-a3cc-82c86f4bb49f">
</p>


## SSL 설정

위에서 EC2에 도메인 연결까지 끝냈다면 사실 거의다 끝났다. 로드밸런서의 리스너에서 HTTPS 를 추가시키고, 일반 HTTP 요청을 HTTPS로 리다이렉트 시켜서 SSL 에서 항상 요청하도록 한다. 

```jsx
resource "aws_alb_listener" "http_forward" {
  load_balancer_arn = "${aws_alb.devleoper-discovery-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https_forward" {
  load_balancer_arn = "${aws_alb.devleoper-discovery-alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate_validation.developer_discovery_certi_validation.certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.developer-discovery-api.arn}"
    type             = "forward"
  }
}
```

테라폼으로 작성하면 다음과 같다. 이러면 로드 밸런서에서 HTTPS를 EC2로 연결해 EC2에는 항상 SSL 이 적용되게 된다.

이 상태에서 HTTPS 가 적용됨에 따라서 기존 도메인에 연결되지 않는 상태가 되는데, 알고보니 내가 Route53에서 A 레코드를 추가하지 않아서 생기는 문제였다.

```jsx
resource "aws_route53_record" "developer_discovery" {
  zone_id = aws_route53_zone.devleoper_discovery_zone.zone_id
  name    = "developerdiscovery.com"
  type    = "A"

   alias {
    name                   = aws_alb.devleoper-discovery-alb.dns_name
    zone_id                = aws_alb.devleoper-discovery-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "developer_discovery_www" {
  zone_id = aws_route53_zone.devleoper_discovery_zone.zone_id
  name    = "www.developerdiscovery.com"
  type    = "A"

   alias {
    name                   = aws_alb.devleoper-discovery-alb.dns_name
    zone_id                = aws_alb.devleoper-discovery-alb.zone_id
    evaluate_target_health = true
  }
}
```

각각 위와 같이 설정하면 A 레코드가 생겨서 이제 본격적으로 다른 사람들도 웹페이지에 접속할 수 있게 된다.

### **A 레코드란?**

DNS에서 IP 와 도메인을 직접 연결한 레코드이다. 직접 연결했기 때문에 도메인을 입력했을때 바로 서버로 접근하는 구조이다. 반면에 CNAME 레코드의 경우 링크드 리스트와 같이 IP를 찾기 위해 여러번 조회를 하게 되는데… 서브도메인과 같은 여러 도메인을 처리할 때 유용하게 사용된다.

서브 도메인을 동일한 IP로 설정하려면 A 레코드로 각각 설정하는 경우, 추후 IP가 바꼈을 때 서브도메인 마다 수정해야하는 문제가 있다. 하지만, CNAME의 경우 서브 도메인마다 체이닝을 해서 1개의 도메인만 수정하면 모든 도메인에 설정되도록 설정할 수 있다.

```python
# 각 서브 도메인 별로 A 레코드가 있는 경우
example.com -> 10.576.89.200(IP)
dev.example.com -> 10.576.89.200
alpha.example.com -> 10.576.89.200

= 3가지 모두 변경해야 한다.

# CNAME을 이용하는 경우
example.com -> 10.576.89.200
dev.example.com -> example.com
alpha.example.com -> example.com

= example.com 만 바꾸면 된다.
```

여기선 가장 기본인 A 레코드를 설정하지 않아서 페이지가 뜨지 않은 것이다.

## SSR 로 페이지 띄우기

이제 API 부분은 EC2에서 성공적으로 확인이 되었다. 이제 Vercel에 올려져 있는 프론트앱에서 Ec2로 페이지를 보내서 이를 렌더링 하면 된다. 다행히도 django_nextjs 라이브러리를 통해서 쉽게 구현할 수 있었다.

[📍 Django-nextjs Docs](https://github.com/QueraTeam/django-nextjs)

위 문서에 따라서 [asgi.py](http://asgi.py) 를 설정하고, nextjs에서 생성한 라우트 마다 아래와 같이 추가하면 된다.

```python
# views.py
from django_nextjs.render import render_nextjs_page_sync

def index(request):
    return render_nextjs_page_sync(request)

def signin(request):
    return render_nextjs_page_sync(request)

...

# urls.py
urlpatterns = [
    path("", views.index, name="home"),
    path("signin", views.signin, name="signin"),
    path("signup", views.signup, name="signin"),
    path("profile", views.profile, name="profile"),
    path("withdrawal", views.withdrawal, name="withdrawal"),
    path("post/", include("apps.pages.post.urls")),
    path("accounts/", include("apps.pages.accounts.urls")),
    path("password/", include("apps.pages.password.urls")),
]
```

그리고 가장 중요한 것은 CORS 와 그외 세팅값들이다. 

```python
# settings.py

CORS_ORIGIN_WHITELIST = ["http://localhost:3000", "https://frontend-developer-discovery.vercel.app"]

...
NEXTJS_SETTINGS = {
        "nextjs_server_url": "https://frontend-developer-discovery.vercel.app",
        # TODO: docker ssl 허용 
        # "nextjs_server_url": "http://127.0.0.1:3000",
}
```

로컬용 url과 실제 프로덕션 url을 추가했는데, 추후 스테이지별 파일로 이전할 예정이다.

결과적으로는 아래와 같이 https , Ec2에서 SSR 방식으로 웹페이지가 구성된다. 웹 디자인, api 등등 구성이 완료되면, 차례로 배포하고, 그 후 캐싱이나 최적화를 고려할 것 같다.

<p align="center">
<img width="1500" alt="Screen_Shot_2023-06-26_at_9 54 59_PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/ffcde9fb-c4dd-4e89-ac88-b16329da07d4">
</p>

[📍 프로젝트 웹 페이지](https://developerdiscovery.com/)

<br>
<br>