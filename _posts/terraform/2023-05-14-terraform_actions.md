---
title: "Terraform Github Actions 작성해보기"
date: 2023-05-14
toc: true
toc_label: 'Content list'
toc_sticky: true
categories:
  - terraform

---

팀 프로젝트에서 Terraform 이용하다 보면, 리뷰 이후에 Terraform apply 를 해야하는데 그러다 보면 베이스 브랜치인 master/main 에 머지 후 다시 pull 받고 등등 과정을 수동으로 해야한다. 하지만, github action 을 이용한다면…?!

<br>

### 어떤 과정을 가지나.

리뷰를 받고 master/main 에 머지 할 때 자동으로 apply 되도록 하는 것이다. 또는 따로 apply action 을 구성할 수 도 있다. 우선 생각해야 할 부분은 리뷰를 받고 master에 머지 되는 이벤트를 어떻게 구현할 것인가 이다.

[Trigger Github Actions only when PR is merged](https://stackoverflow.com/questions/60710209/trigger-github-actions-only-when-pr-is-merged)

위 링크에도 잘 나와있지만, 리뷰가 승인되는 것으로 인지할 수 있고, 또는 머지되는 것을 master에 push 이벤트로 받는 것도 가능하다. 일단, master/main 등 베이스에 머지되는 것은 항상 적용된다고 생각하고 다음과 같이 작성하였다.

<br>

### 코드를 작성하기 까지

```yaml
name: terraform-deploy

on:
  push:
    branches:
      - main

env:
  USER: github-action
  AWS_REGION: ap-northeast-2

jobs:
  terraform:
      runs-on: ubuntu-latest
      steps:
        - name: Runner Checkout
          uses: actions/checkout@v3

        - name: Configure AWS credentials
          uses: aws-actions/configure-aws-credentials@v1
          with:
            aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
            aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
            aws-region: ap-northeast-2

        - name: Terraform Init
          run: |
            terraform init

        - name: Terraform Plan
          run: |
            terraform plan
        
        - name: Terraform Apply
          run: |
            terraform apply -auto-approve -input=false
```

하지만, 문제가 있었다. 전 글을 보면 알겠지만, 서비스 별로 폴더를 분리해두어서 각각 terraform init, plan, apply 를 하려면 해당 폴더로 이동해야하기 때문에, 값을 받아서 해당하는 폴더의 리소스에서 액션이 돌아가도록 할 예정이다. 위에는 $ 이 후가 안 나와있지만, `${{ secrets.AWS_ACCESS_KEY_ID }}` 과 `${{ secrets.AWS_SECRET_ACCESS_KEY }}` 가 작성되어있다.

<br>

그러면… 기획을 조금 바꾸어서 main 브랜치에서만 워크 플로우가 돌도록 하는 것을 목표로 잡았다. actions 을 작성할때, 값을 받는 부분이 필요한데, 이는 다음과 같이 작성할 수 있다. ([참고](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions))

```yaml
on:
  workflow_dispatch:
    inputs:
      stage:
        description: 'Stage'
        required: true
        default: prod
        type: choice
        options:
          - alpha
          - beta
          - prod
      aws-service:
        description: 'Terraform Working Directory'
        required: true
        default: 'ec2'
        type: string
```

workflow_dispatch 가 있는 경우 아래와 같이 Run Workflow 라는 버튼이 생긴다. 

<br>


<p align="center">
<img width="800" alt="actions" src="https://github.com/rha6780/Algorithm/assets/47859845/20cfa666-4a68-42d6-99ec-f507f7cfeece">
</p>

<p align="center">
<img width="300" alt="action-inputs" src="https://github.com/rha6780/Algorithm/assets/47859845/c5ba52f4-424e-40ea-b2f5-62ed76d7e04b">
</p>


yml에 작성한 것과 같이 Stage는 선택형으로 dir은 직접 작성하는 것으로 두고, 버튼을 누르면 Deploy 되도록 이제 작성하면 됩니다. stage와 dir을 받으면 간단히 커맨드 전체 default의 working-directory 를 지정하면 커맨드가 해당 dir에서 작동되게 된다.

<br>

runs-on 하위에 defaults 를 다음과 같이 작성하였다.

```jsx
defaults:
	run:
		working-directory: ${{ inputs.stage }}/services/${{ inputs.aws-service }}
```

![Screen_Shot_2023-05-14_at_2 26 18_PM](https://github.com/rha6780/Algorithm/assets/47859845/10ffd686-c70d-41c5-9afe-3dbceb8b3fd5)
<br>

다음과 같이 정상적으로 작동하였다. 이렇게 되면, 서비스별로 따로 배포를 해야한다. 현재 내 개인 프로젝트의 경우 서비스가 적기 때문에 이런 방식도 큰 문제가 없지만, 서비스가 많으면 여러 서비스를 동시에 배포하는 것도 필요 할 수 있다.

<br>

### 전체 코드

```yaml
name: terraform-deploy

on:
  workflow_dispatch:
    inputs:
      stage:
        description: 'Stage'
        required: true
        default: prod
        type: choice
        options:
          - alpha
          - beta
          - prod
      aws-service:
        description: 'Terraform Working Directory'
        required: true
        default: 'ec2'
        type: string

jobs:
  terraform:
      name: "Terraform Action"
      runs-on: ubuntu-latest
      defaults:
        run:
          working-directory: ${{ inputs.stage }}/services/${{ inputs.aws-service }}
      steps:
        - name: Runner Checkout
          uses: actions/checkout@v3

        - name: Configure AWS credentials
          uses: aws-actions/configure-aws-credentials@v1
          with:
            aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
            aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
            aws-region: ap-northeast-2

        - name: Terraform Init
          id: tf_init
          run: |
            terraform init

        - name: Terraform Plan
          id: tf_plan
          run: |
            terraform plan
        
        - name: Terraform Apply
          id: tf_apply
          run: |
            terraform apply -auto-approve -input=false
```

<br>

### Github Action 팁

아무튼 중요한 것만 한번 정리해보자.

- workflow-dispatch 를 이용하면 github 에서 버튼을 이용해 워크 플로우를 실행할 수 있다.
- inputs 를 이용해 워크 플로우가 실행되기 전에 파라미터를 받을 수 있다.
- 각각 job이 돌 때 defaults 를 이용해서 공통적인 값을 설정할 수 있다.
- 각 steps 는 run 이나 users 가 있어야 한다.

<br>

이런걸 가지고 어떻게 이용할 수 있을까…? 이전 회사에서는 같은 리소스 서버를 여러대 개발자가 필요로 할 때 구동 시키는 것이 필요했는데, 템플릿(Terraform) 하나를 두고, 액션을 통해서 inputs로 넣은 값에 따른 서버를 생성하는 용도로 사용했었다. 이거 외에 깃을 이용해서 데브옵스를 관리하는 것을 Gitops 라고도 부르는 것 같다.

<br>
<br>
