---
title: "CodeDeploy 설정"
date: 2023-06-04
# toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - developer_discovery
tags:
  - developer_discovery
---

# github actions 으로 EC2 CodeDeploy 자동 배포 적용기


깃허브 액션으로 Ec2에 배포하는 스크립트를 다음과 같이 작성하였다. 이전에 CodeDeploy, Ec2에 대한 Terraform을 작성해서 생성해둔 상태이다.

```yaml
name: deployment

on: workflow_dispatch

env:
  USER: github-action
  AWS_REGION: ap-northeast-2

jobs:
  deployment:
    runs-on: ubuntu-latest
    steps:
      - name: Configure AWS credential
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ap-northeast-2

      - name: Code Deploy
        id: deploy
        run: |
          aws deploy create-deployment \
            --application-name ${{ secrets.APP_NAME }} \
            --deployment-group-name ${{ secrets.EC2_REPO }} \
            --deployment-config-name CodeDeployDefault.AllAtOnce \
            --github-location repository=${{ github.repository }},commitId=${{ github.sha }}
```

깃허브 액션에서는 성공했는데…

<img width="1419" alt="Screen Shot 2023-06-02 at 1 26 23 AM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/8001d353-e668-4313-b818-95b822d26dfa">



실제 코드 디플로이에서는 실패가 되었다.


<img width="1056" alt="Screen Shot 2023-06-02 at 1 00 29 AM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/bf1eac1e-4d65-42d1-b305-23bf9b061f33">

<img width="1057" alt="Screen Shot 2023-06-02 at 1 58 47 AM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/6dd62056-85e3-4d5a-ad9b-998006c62580">


Unknown Error가 뜨는데, 원인을 찾아보니 Ec2에 배포하기 전에 codedeploy-agent 를 설치 해야한다.


<img width="658" alt="Screen Shot 2023-06-02 at 12 26 36 AM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/bb15ace7-7cb9-4919-a5df-8e8a65d112e7">

우선 Ec2에 접속해서 설치해야하는데 위와 같이 Unable to locate package yum 이라는 에러가 나오기 때문에 sources.list에 다운 받을 수 있는 url을 추가시킨다.

```bash
vi /etc/apt/sources.list

deb http://archive.ubuntu.com/ubuntu bionic main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu bionic-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu bionic-updates main restricted universe multiverse

저장 하고... 다시 yum install
```

<img width="652" alt="Screen Shot 2023-06-02 at 10 24 49 AM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/3a643c08-8c95-49f1-ad7f-1cfb0bba401c">

어…? 이번에는 다른 문제가 있다. 에러에 따르면 의존성 때문인것 같으니 위에 나온 pyython-lzma 등등을 우선 설치하고 다시 시도해보자. 이런 식으로 잘 설치된다.


<img width="484" alt="Screen Shot 2023-06-02 at 10 28 21 AM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/76c22016-3cf3-4df8-bd67-ade353429a07">


이제 yum이 있는데… yum repolist all 를 치면 repolist: 0이 나올 것이다. 다운 받을 경로가 없어서 0으로 나오는 것인데 이를 추가 시켜두어야 우리가 원하는 라이브러리를 다운 받을 수 있다. 아래와 같이 적용하면 yum을 사용할 수 있다.



```bash
# repos.d 폴더가 없다면 mkdir로 생성하고 이동
cd /etc/yum/repos.d

vi daum.repo

[base]
name=CentOS-$releasever - Base
baseurl=http://ftp.daum.net/centos/7/os/$basearch/
gpgcheck=1
gpgkey=http://ftp.daum.net/centos/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-$releasever - Updates
baseurl=http://ftp.daum.net/centos/7/updates/$basearch/
gpgcheck=1
gpgkey=http://ftp.daum.net/centos/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-$releasever - Extras
baseurl=http://ftp.daum.net/centos/7/extras/$basearch/
gpgcheck=1
gpgkey=http://ftp.daum.net/centos/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://ftp.daum.net/centos/7/centosplus/$basearch/
gpgcheck=1
gpgkey=http://ftp.daum.net/centos/RPM-GPG-KEY-CentOS-7

# 저장 이후 yum update 를 한다.
```
    
<br>

이제 codedeploy-agent를 설치하기 위해 다음 명령어를 실행하자. yum을 이용할 수도 있지만, 문제는 yum을 이용하면 매번 Ec2에 접속이 안되는 문제가 있어 apt-get install 을 이용한다.

```bash
# 매번 sudo 치기 귀찮아서 일단 root 권한으로 시작한다.
su 

apt-get install ruby
apt-get install wget

cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install

# 설치 파일에 실행 권한 부여
chmod +x ./install

# 설치 진행 및 Agent 상태 확인
sudo ./install auto
sudo service codedeploy-agent status
```

status를 봤을때 아래와 같이 나온다면 성공이다…

<img width="987" alt="Screen Shot 2023-06-03 at 10 15 54 PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/4f6b862f-4f00-412a-b071-6a56029baa21">

<br>


이제 다시 배포를 돌리면..! 아쉽게도 배포 스크립트가 필요하다. 이 배포 스크립트를 작성한 후 codedeploy에서 인식하기 위해서는 appspec.yml 에 정의를 해두어야 한다.

```yaml
version: 0.0
os: linux
permissions:
  - object: /home/ubuntu/
    owner: ubuntu
    group: ubuntu
    mode: 644
    type:
      - directory
      - file
files:
  - source: /
    destination: /home/ubuntu/build
hooks:
  AfterInstall:
    - location: scripts/start.sh
      runas: root
```


<img width="693" alt="Screen Shot 2023-06-04 at 5 11 39 PM" src="https://github.com/rha6780/Backend_Developer_Discovery/assets/47859845/b143a3ab-806b-4656-ad20-1f658599faff">

이렇게 두고 scripts/start.sh 파일을 임시로 생성하고 실행하면… 성공적으로 배포된다.

<br>

### 생각해보기

흐음 일단, 생각할 것이 있다. envs에 해당하는 내용이 복사되지 않는다는 점으로 settings에 정의한 환경변수가 적용되지 않는 다는 것이고, pipenv가 설치되어야 한다. 하지만, Docker 이미지를 이용한다면 조금 다를 수 있다.

docker 이미지 내부에 이미 pipenv 로 라이브러리가 설치된 상태이고 envs 역시 컨테이너 내부에 정의 되어있다. envs의 경우 github에는 올라가 있지 않아서 따로 정의해야한다. 하지만 이러면 환경 변수들이 여러군데에서 관리되어야 하기 때문에 문제가 된다. 물론 파라미터 스토어를 사용한다면… 큰 문제가 되지 않을 수 있다.

일단 Docker를 이용하는 방식으로… Ec2에 Docker를 설치하자.

```bash
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

이렇게 하면… 이제 스크립트에서 해야할 일은 Docker 이미지를 불러오고 해당 이미지로 컨테이너를 실행시키면된다. 이미지를 불러오는 것은…. ECR에서 불러오면 어떨까? 이러면 배포할 때 ECR 에 이미지를 업로드하는 것이 필요하긴 하다. 혹은 CodeDeploy에서 이미지 빌드 시키거나 등등… 일단 좀더 생각해보자.

<br>
<br>
