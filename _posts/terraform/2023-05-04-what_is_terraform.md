---
title: "Terraform 이란"
date: 2023-05-04
# toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - terraform

---

# Terraform 이란?

<p align="center">
<img width="500" alt="terraform" src="https://user-images.githubusercontent.com/47859845/236121817-7b997540-5112-4498-980a-c292ab6d7ce4.png">
</p>

### **Terraform 이 필요한 이유**

Terraform 은 IaC 중 하나인 HCL 을 이용해서 클라우드 리소스를 생성, 수정, 제거할 수 있는 툴 중 하나이다. IaC 란 코드형 인프라 라고도 불리며, 코드를 작성하는 것으로 인프라를 생성하거나 수정할 수 있음으로 추후 유지보수나 수정 이력이 남는다는 점에서 이점이 있다. 코드로 남기 때문에 자동화하거나 호출이 간단하다는 장점 역시 있다.

<br>

### Terraform 기본

Terraform은 단순히 인프라 생성, 수정만 지원하는 것이 아니라 tfstate 를 통해서 인프라 상태 등을 기록할 수 있다. 인프라 상태를 기록한다는게 어려울 수 있는데, 간단히 예시를 들면 다음과 같다.

<br>

**예시**

> Terraform 코드가 A, B 팀원 모두의 PC에 있다고 가정하자. 

A 에서 인프라 R을 수정했고, 실제 인프라에 반영되었다. 하지만, B의 PC 내부 로컬 코드 안에서 A가 수정한 코드가 없을 때, B가 R을 수정한다고 했을 때… 어떻게 될까..? B가 수정한 것으로 인프라가 반영되지만, A가 수정한 것과 충돌이 있을 수 있다. (A가 적용한 것이 제대로 반영되지 않을 수 있다는 것이다.) 그렇기 때문에 현재 상태를 알기 위해서 tfstate가 필요하다.

git을 많이 사용했다면, 코드의 버전관리에 대해서 잘 알 것이다. Terraform 코드도 git을 이용해서 관리하긴 하지만, 실제 인프라에 반영하는 것은 조금 다르다. 위 상황에서 A가 git push 를 하지 않았다면, 혹은 했음에도 B가 해당 코드를 pull 해오지 않았다면, 위에서 설명한 문제가 나올 수 있다는 것이다.

<br>

**tfstate 가 작동하는 법**

tfstate는 현재 인프라 상태 코드와 같다. Terraform이 실제 인프라에 적용될 때 코드를 무조건 다 검사해서 적용되는 것이 아니라 이 tfstate라는 파일을 기준으로 검사하고, 이 파일과 다른 부분이 실제 인프라에 적용되는 구조이다. 즉, tfstate의 내용이 실제 인프라와 동일하도록 적용되기 때문에 여러명이서 작업할 때 이 tfstate가 공유한다면, 인프라 상태가 공유되기 때문에 작업을 더 안전하게 할 수 있게 된다.

<br>

**tfstate는 어떻게 공유할까..?**

tfstate를 공유한다고 이야기 하였는데, 주로 공유하기 위해서 AWS S3 등을 이용한다. tfstate를 어디에 저장할 건지 backend 에 정의를 하는데, 작성하지 않은 경우 로컬에 생성된다. 이렇게 저장하고 `terraform init` 이라는 명령어를 사용하면 앞으로 S3에서 tfstate를 읽어올 수 있게 된다.

```json
terraform {
  backend "s3" {
    bucket  = "사용할 버킷"
    key     = "오브젝트 키"
    region  = "버킷 리전"
    profile = "aws profile (aws cli 참고)"
  }
}
```

<p align="center">
<img width="500" alt="state_bucket" src="https://user-images.githubusercontent.com/47859845/236121826-220cb357-4295-4da4-9802-fdf718dc2984.jpeg">
</p>

<br>

**tfstate 는 언제 변경되는 가?**

윗 내용 중 `tfstate 파일과 다른 부분이 실제 인프라에 적용되는 구조이다.` 라고 소개를 하였는데, 실제 적용을 할 때 여러 명령어가 있다. 주로 아래와 같다. (각각 옵션이 세부적으로 있다.)

```python
terraform init # tfstate 에 필요한 플러그인, 라이브러리 등 불러옴
terraform plan # tfstate 와 다른 것 검사
terraform apply # 다른 부분 실제 인프라에 반영
```

하나씩 세부적으로 확인하자.

---

### 주요 명령어

**terraform init**

Terraform 코드를 적용하려면 위 명령어부터 적용을 해야한다. backend, provider 등에 따른 플러그인 들을 다운 받고, tfstate 등을 인식하게 된다. provider는 추후에 설명하겠다.

<br>

**terraform plan**

tfstate 와 실제 Terraform 코드를 비교해서, 생성, 수정, 삭제 등을 확인한다. 해당 명령어를 쓰면 어떤 리소스에 적용되는 지 등이 나오기 때문에 이를 확인하면 된다.

<br>

**terraform apply**

이 명령어를 쓰면 로컬의 Terraform 코드가 실제 인프라에 적용 된다. 바로 적용되는 것이 아니라 어떤게 변경되는지 보여주기 때문에 안심하고 꼼꼼히 확인 후 적용할 수 있다. 실제 인프라에 적용되면 자동으로 tfstate에도 반여되게 된다.

<br>

여기까지 주요 명령어 들로 이제 Terraform 코드만 작성, 설정 등을 할 수 있다면 인프라에 적용까지 가능하다.! Terraform으로는 AWS, kubernetes, Azure 등 여러 방식으로 활용할 수 있다. 우선 AWS 기준으로 진행할 예정이다.

![aws_struct](https://user-images.githubusercontent.com/47859845/236121847-3bcba91f-937c-49e8-813d-1edceb8d9f25.png)

> 프리티어 끝났는데 괜찮겠지..?


<br>
<br>
