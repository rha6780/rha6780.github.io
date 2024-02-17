---
title: "[Terraform] Terraform Github Actions PR에서 변경사항 보여주기"
date: 2024-02-17
# toc: true
toc_label: "Content list"
toc_sticky: true
categories:
  - terraform
---

팀 프로젝트에서 Terraform 이용하다 보면, 코드의 변경사항이 보이기는 하지만.. 실제 테라폼에 잘 적용되는지 알려면 Terraform Plan 명령어를 쳐야한다. github action 을 이용해서 어떤 변경점이 있는지 보여주자!

<br>

### 목표

PR을 열고 push 마다 액션이 돈다.. 그러면 위 사진과 같이 커맨트로 Plan의 결과를 보여주는 것이다.

<p align="center">
<img width="600" alt="target" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/66fe8aeb-1be2-4bcf-beba-cb2eaab2aeec">
</p>

<br>

### 코드를 작성하기 까지

우선... 현재 프로젝트 구조를 생각하면 다음과 같다.

- 각 서비스마다 폴더 및 tfstate가 분리되어있다.
- 변경 사항 중 Terraform 코드가 아닌 것이 있을 수 있다.
- 현재 AWS를 이용하고 있기 때문에 깃허브 액션이 돌때도 AWS 키를 신경써야한다.

<br>

여기서 가장 골치가 아픈 것은 tfstate를 가져오는 것이었다. 현재 회사에서 tfcloud 를 사용하고 있다보니 테라폼 클라우드에 접근할 토큰(TF_API_TOKEN)이 필요했다.
또한, 토큰을 넣어주고 별도로 AWS 키도 넣어주어야 했다. 하지만, 변경점에서 스테이지(환경)가 다른 경우가 있기 때문에 dev, prod 등 모든 환경에 키를 설정해줘야 하나 고민했었다..

<br>

하지만, 마침 Terraform 클라우드에서 AWS키를 Workspace(쉽게 말해 환경)별로 variables로 설정해주어서 클라우드에 접속만 가능하면 깃허브 액션에 따로 AWS 키를 넣을 필요가 없었다.

<br>
<br>

일단 결론 부터 말하자면... 아래와 같은 코드로 생성하였다.

```yaml
name: "Terraform Plan"

on: push

env:
  TF_LOG: INFO
  TF_INPUT: false
  TE_VERSION: 1.6.2
  TF_API_TOKEN: ${{ secrets.TF_API_TOKEN }}
  GITHUB_TOKEN: ${{ secrets.GIT_TOKEN }}

jobs:
  setup:
    name: Find Diff Dir
    runs-on: ubuntu-latest
    outputs:
      matrix: ${{ steps.matrix.outputs.value }}
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - id: matrix
        run: |
          DIFF_DIR=`git --no-pager diff --name-only origin/develop HEAD`
          DIFF_DIR=`echo "${DIFF_DIR}" | sed 's|/[^/]*$||'`

          DIR_ARR=(`echo "${DIFF_DIR}"| awk '!seen[$0]++' | tr ' ' ', '`)
          ARR=()
          for dir in ${DIR_ARR[@]}
          do
              if [[ "$dir" == "${DIR_ARR[${#DIR_ARR[@]}-1]}" ]]; then
                  ARR+=(`echo "\"$dir\""`)
              else
                  ARR+=(`echo "\"$dir\","`)
              fi
          done
          echo "value=[${ARR[@]}]" >> $GITHUB_OUTPUT
      - run: |
          echo "${{ steps.matrix.outputs.value }}"
  terraform-plan:
    needs: [setup]
    name: "Terraform Plan"
    runs-on: ubuntu-latest
    strategy:
      matrix:
        value: ${{fromJSON(needs.setup.outputs.matrix)}}
    permissions:
      contents: read
      pull-requests: write
    defaults:
      run:
        working-directory: ./${{ matrix.value }}
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Check TF File Exist
        id: check-file
        run: |
          if [[ -e "main.tf" ]]; then
              echo "exist=true" >> $GITHUB_OUTPUT
          else
              echo "exist=false" >> $GITHUB_OUTPUT
          fi
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        if: ${{ steps.check-file.outputs.exist == 'true' }}
        with:
          terraform_version: ${{ env.TE_VERSION }}
          cli_config_credentials_token: ${{ env.TF_API_TOKEN }}
      - name: Terraform Init
        if: ${{ steps.check-file.outputs.exist == 'true' }}
        id: init
        run: terraform init -input=false
      - name: Terraform Format
        if: ${{ steps.check-file.outputs.exist == 'true' }}
        id: fmt
        run: terraform fmt -check
      - name: Terraform Plan
        if: ${{ steps.check-file.outputs.exist == 'true' }}
        id: plan
        run: terraform plan -no-color
      - name: Add Plan Comment
        id: comments
        uses: actions/github-script@v6
        if: ${{ steps.check-file.outputs.exist == 'true' }}
        env:
          PLAN: "terraform\n${{ steps.plan.outputs.stdout }}"
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            const pullRequests = await github.rest.pulls.list({
                owner: context.repo.owner,
                repo: context.repo.repo,
                state: 'open',
                head: `${context.repo.owner}:${context.ref.replace('refs/heads/', '')}`
            })
            const issueNumber = context.issue.number || pullRequests.data[0].number
            const { data: comments } = await github.rest.issues.listComments({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: issueNumber,
            });
            const botComment = comments.find(comment => {
              return comment.user.type === 'Bot' && comment.body.includes("Show Plan(${{ matrix.value }})")
            });
            const output = `
            **Terraform Cloud Plan Output**

            <details><summary>Show Plan(${{ matrix.value }})</summary>

            \`\`\`\n
            ${process.env.PLAN}
            \`\`\`

            </details>

            **Pusher: @${{ github.actor }}**`;
            if (botComment) {
              github.rest.issues.deleteComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                comment_id: botComment.id,
              });
            }

            github.rest.issues.createComment({
              issue_number: issueNumber,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })
```

<br>

**참고 링크**
아래 링크를 참고해서 스크립트를 작성하였다...

- [마켓 플레이스 관련](https://github.com/marketplace/actions/terraform-plan)
- [HCL 클라우드 공식 Github Actions](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)
- [Terraform Github Actions](https://www.env0.com/blog/terraform-github-actions)
- [HttpError: Not Found 에러 참고](https://github.com/actions/github-script/issues/273)

<br>
<br>

과정을 짧게 설명하면 다음과 같다.

- origin/develop 브랜치와 변경사항에 해당하는 파일이름을 가져온다.
- 해당 파일의 경로를 가져오고 해당 경로에 main.tf 파일이 있는지 찾는다.
- 해당 파일이 있는 경우, terraform plan 스텝을 거친다.
- terraform plan은 매트릭 형태로 병렬 실행된다.
- 서비스 별로 커맨트가 생기고, 기존에 해당 서비스에 대한 커맨트가 있다면, 삭제하고 새로 생성한다.

<br>

매트릭으로 설정하면 다음과 같이 실행된다.

<p align="center">
<img width="694" alt="action-matrix" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/b02d5ca4-3fd6-4864-a2d3-df5e529fcead">
</p>

<br>

### TODO

개선점... 위 스크립트의 문제점으로 아래와 같다..

<br>

- 커맨트가 많이 달린다.
- 변경사항 중 코드를 추가 했다가 다시 롤백해서 커맨트가 삭제 되지 않고 유지되는 경우가 있다.
- if 구문에서 반복된다.
- 각 서비스 마다 main.tf 파일이 반드시 있다는 가정이고, 추후 .tf 로 파일을 찾도록 변경해야할 것 같다.
- 추후 유지 보수를 위해 내부의 스텝을 파일로 나눈다.

<br>

PR당 변경되는 서비스가 적으면 상관없지만...

<p align="center">
<img width="972" alt="lotofcomments" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/62166acb-2d53-4243-8aaf-19b83814356c">
</p>

우선적으로 커맨트가 많이 달리는 문제는 모든 매트릭이 끝나면, 통합해서 결과를 보여주는 잡을 추가하는 방식으로 진행될 것 같다.

<br>

깃허브에서 해당 팀이 해고 되었다는 슬픈 소식이 있다.. 일단 마켓 플레이스에 유사한 기능이 있는데 정리가 되는데로 업데이트할 예정이다.

<br>

스크립트 작성을 하면서 sed 명령어를 많이 사용하게 되었는데, 조만간 한번 정리하겠다...!

<br>
<br>
