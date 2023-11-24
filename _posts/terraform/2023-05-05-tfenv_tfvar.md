---
title: "[Terraform] Tfenv Tfvar 로 관리하기"
date: 2023-05-05
# toc: true
toc_label: "Content list"
toc_sticky: true
categories:
  - terraform
---

<br>

Terraform 을 이용하기 전에... 우선 개발 환경을 위해서 설치 부터 시작하자. 😉

<br>

# tfenv & tfvar 간단 소개

## tfenv 소개 및 설치

Terraform도 버전이 있다..! 물론 최신 버전을 사용하면 좋겠지만, 프로젝트마다 버전을 변경하거나 다른 버전과 동시에 사용하는 등으로 활용할 수 있습니다. 바로 [tfenv](https://github.com/tfutils/tfenv)를 이용해서…! 맥이라면… brew를 이용해서 설치할 수 있다.

```bash
brew install tfenv
```

<br>

리눅스 OS 의 경우, Git을 클론 해서 PATH 를 추가한 뒤에 사용하면 된다. (윈도우는…)

```bash
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
# zsh 라면 ~/.zshrc 등을 이용
# 필요하다면 symlink 를 적용해도 된다.
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
```

<br>

### tfenv 버전 설치

설치 이후 사용가능한 버전을 확인할 수 있다.

```bash
tfenv list-remote
```

특정 버전을 설치하는 경우 `tfenv install version`, 최신 버전의 경우 `tfenv install latest` 등으로 설치할 수 있다.

<p align="center">
<img width="300" alt="command1" src="https://user-images.githubusercontent.com/47859845/236488460-82fd87c3-62ff-4b50-bc17-939b88978155.png">
</p>

<br>

만약 파일들을 스캔해서 필요한 최소 버전을 다운받는 경우 `tfenv install min-required` 를, 최대 버전을 다운 받는 경우 `tfenv install latest-allowed` 를 이용한다.

<br>

이미 설치된 버전은 `tfenv list` 를 통해 볼 수 있다. 설치된 버전에서 특정 버전을 사용하려면 `tfenv use version` 을 이용해서 사용할 수 있다. 만약, 매번 버전 변경이 번거롭다면 .terraform-version 에 사용하는 버전을 작성하면 된다. (주로 많이 사용함)

```bash
echo 1.4.6 > .terraform-version

# 또는 아래를 통해 현재 버전을 작성
tfenv pin

terraform --version
Terraform v1.4.6
on darwin_arm64
```

<br>

### 필요한 버전 명시하기

인프라를 만들기 전에, 해당 인프라를 지원하는 Terraform 버전을 명시해 줄 수 있다. 바로 terraform 블록에 다음과 같이 작성하면 된다.

```bash
terraform {
  required_version = "1.4.6"
}
```

<br>

## tfvar 사용하기

<p align="center">
<img width="300" alt="think_man" src="https://user-images.githubusercontent.com/47859845/236488506-b93cc961-85bd-4478-be8f-c7ad48cf43ae.jpeg">
</p>

tfvar 는 무엇일까…? 테라폼을 사용하다보면 VPC, 서브넷 아이디 리소스 아이디 등 여러 값을 변수로 뺄 수 있는데, tfvar는 그런 인스턴스 유형 같은 값들을 따로 관리할 수 있는 파일이다. 더 자세한 내용은 [공식문서](https://developer.hashicorp.com/terraform/language/values/variables)를 참고하자.

<br>

사용은 간단하다. `terraform.tfvars` 로 생성 하고 내부에 `변수 명 = 값` 으로 파일을 작성한다.

```bash
#terraform.tfvars
image_id = "ami-18509185djfkse983250"

#variables.tf
variable "image_id" {
	type = string
}
```

이렇게 작성하면 image_id 변수를 쓴 파일들에 해당 값이 들어가게 된다. 만약 terraform.tfvars 말고 환경마다. `test.tfvars`, `alpha.tfvars` 처럼 작성해서 적용할 수 있는데 `terraform apply -var-file=”alpha.tfvars”` 처럼 `-var-file` 옵션을 통해서 가능하다.

<br>

물론 파일을 지정하지 않는다면.. tfvar 대신 direnv 를 사용해도 문제는 없다. 편한 방식을 찾아서 진행하면 된다. 여기 까지 간단히 설명해두었고, 다음 글 부터 천천히 설명하면서 변수들이 어떻게 사용되는지 소개하도록 하겠다.

<p align="center">
<img width="300" alt="DevOps-meme" src="https://user-images.githubusercontent.com/47859845/236488492-378efb24-6990-4ab1-93e1-94c1b16bc84a.png">
</p>

<br>
<br>
