---
title: " Terraform AWS 리소스 생성 해보기"
date: 2023-05-11
toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - terraform

---

<br>

코드 타입과 Ec2 를 생성하는 가장 쉬운 방법...!


## Terraform 으로 Ec2 인스턴스 생성

우선 AWS 에서 Terraform 을 사용하기 앞서 aws cli 를 설치하고, profile을 설정해주겠다.

```jsx
brew install awscli
```

<br>

### AWS profile 생성

**profile이 없는 경우..**

IAM>보안 자격증명 > 엑세스 키 만들기에서 엑세스 키를 만든다. 보안상 루트 사용자에 추가하는 건 좋지 않지만, 일단 만들어주었다. 자세한 건 추후 AWS 관련 글을 작성할 때 정리하겠다.
<img width="1103" alt="Screen Shot 2023-05-10 at 7 08 26 PM" src="https://github.com/rha6780/Algorithm/assets/47859845/447ec535-5eee-4281-8b18-6a0008fdf055">



엑세스 키를 만들면, 해당 엑세스 ID, Secret Key 등이 나온다. 페이지를 나가기 전에 아래와 같이 각각 복사해서 값을 넣어준다.

```jsx
# 프로필 이름을 ddprod 라고 일단 붙여두었다. 이름은 마음에 드는 데로 작성하자.
aws configure --profile ddprod 

# 전부 다 작성하면 아래에서 값이 잘 되어있는지 확인하자.
cat ~/.aws/credentials

# 그 후 AWS_PROFILE 를 적용해두자.
export AWS_PROFILE=ddprod
```

<br>

### Terraform 작성하기

이제 ec2 폴더를 생성하고, [backend.tf](http://backend.tf) 즉, tfstate를 저장할 곳을 작성하자. 아래와 같이 작성한다.

```jsx
terraform {
    backend "s3"{
        bucket  = "infra-developer-discovery"
        key     = "prod/services/ec2/terraform.tfstate"
        profile = "ddprod"
        region  = "ap-northeast-2"
    }
}
```

여기서 backend 로 S3를 쓸 예정이다. backend 로 사용 가능한 것이 azurerm, k8s 등이 있기 때문에 상황에 맞게 찾아서 작성하자. ([공식문서](https://developer.hashicorp.com/terraform/language/settings/backends/s3)) 해당 코드를 적용하기 전에, 해당 버킷을 생성하고, 다음과 같이 진행하자.

[provider.tf](http://provider.tf) 파일도 아래와 같이 작성해서 필요한 플러그인을 다운하도록 하자.

```jsx
provider "aws" {
    region = "ap-northeast-2"
}
```

이제 해당 폴더 위치에서 `terraform init → plan → apply` 순으로 명령한다.

<img width="1359" alt="Screen Shot 2023-05-10 at 8 11 20 PM" src="https://github.com/rha6780/Algorithm/assets/47859845/3a5957f1-bada-4f7e-85a6-c0f6557cd997">


각 코드를 다음과 같이 실행하고 마지막 apply 까지 진행하면 key에 해당하는 위치에 tfstate 가 생성되는 것을 볼 수 있다. 각 서비스(lambda, ec2 등)마다 tfstate를 다르게 저장하기 위해서 폴더 및 경로를 분리시켰다. (추후 수정 될 것이다.)


<img width="1359" alt="Screen Shot 2023-05-10 at 8 11 20 PM" src="https://github.com/rha6780/Algorithm/assets/47859845/21550527-fa84-49f6-b1e6-d61bcfe5e701">

일단 ec2 생성 코드를 작성하기에 앞서, [공식문서](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) 에서 필요한 리소스는 어떻게 작성하는 지 확인하자. Terraform을 작성할때 문법적인 부분을 간단히 소개하면 다음과 같다.

```jsx
data "aws_ami" "ubuntu" {
  ...
}

resource "aws_instance" "developer_discovery_api"{
  ...
}
```

다음과 같은 코드가 있을때 이런식으로 코드 블럭을 작성한다. 첫번 째로 작성하는 resource, data는 해당 코드의 타입을 의미한다. 해당하는 타입을 각각 간단히 요약 하면 다음과 같다.

<br>

### 코드 타입

|           | 역할                                                                                                                                      |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| terraform | terraform에 대한 버전, 구성 설정                                                                                                          |
| provider  | 클라우드에 연결할 수 있도록 플러그인 및 구성 및 정의                                                                                      |
| module    | 함께 사용되는 리소스 컨테이너로 .tf 로 정의, 다른 모듈을 호출할 수 있어 해당 구문을 통해 하위 리소스로 둘수 있고, 패키징 하여 재사용 가능 |
| resource  | 실제 인프라 객체를 정의                                                                                                                   |
| data      | 묘듈 내부에서 data를 이용해 외부에서 정의한 리소스에 접근할 수 있도록 함.                                                                 |
| output    | 선언한 값들을 외부에 출력(다른 모듈에서 호출) 하도록 정의                                                                                 |
| variable  | 변수를 선언, 이를 이용해서 값 변경에 유용, 유효성 검사가 가능                                                                             |
| locals    | 로컬 파일에서만 사용되는 변수로, 표현식, 특정 변수와 변수를 결합하는 등으로 사용 가능                                                     |

<br>

두번째로 “aws_ami”, “aws_instance” 는 정의되는 리소스를 의미한다. 만약 api_gateway 라고 적혀있다면, 해당 코드 블럭에서도 api_gateway와 관련된 설정을 정의하게 되어있다. 마지막으로 “developer_discovery_api”는 해당 리소스의 이름이 된다. 이 이름을 통해서 다른 리소스에 id로 참조하는 등으로 쓰이기 때문에 가독성있고, 구분가능하도록 작성하는 게 좋다.

세부 코드를 보면서 감을 익히자. 우선 data는 외부 리소스 aws_ami 인데 우리가 정의한 것이 아니라 aws 에서 정의한 이미지를 가져오기 위해서 정의한다.

```jsx
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "developer_discovery_api"{
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "developer_discovery"
    Stage = "prod"
  }
}
```

resource 는 해당 aws_instance(EC2) 라는 인프라 리소스를 정의한다. 일단 프로젝트 이름과 동일하게 developer_discovery_api 로 작성하고, 위에서 정의한 ami 이미지로 생성하게 두었다. instance_type은 가격이 덜나가는 것으로 지정하였다.

그리고 filter의 경우, 가져올 data source에 대해서 검색하는 기능으로 아래의 경우 이름이 `ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*` 인 것을 찾아서 가져온다. 여러개가 있는 경우 and 로 필터 타입이 같은데, values가 여러 아이템인 경우 or 로 연산된다.

```jsx
filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}
```

지금은 외부(aws)에서 리소스를 가져오지만, 로컬에서 리소스를 생성해서 가져오는 경우가 있다는 것도 알아두자.

<br>

<img width="1180" alt="Screen Shot 2023-05-11 at 8 03 43 PM" src="https://github.com/rha6780/Algorithm/assets/47859845/d50db03a-70d7-4b5a-9c7c-52aaeef4e863">

<br>

해당 코드로 apply 하면 다음과 같이 ec2 서버가 생성된다. tags 의 경우 추후 비용 관련 통계를 보기 위해서 작성해두는 것을 추천한다. 여기서 각 코드 블럭의 filter, tags가 있는데, 코드 타입에 따라서 사용할 수 있는 것이 정의되어있다. 이점은 공식문서를 찾아보는 것이 좋을 것 같다. 😉



<br>
<br>
