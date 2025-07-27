## 공부한 것들 회고 등을 기록합니다!

기록...해서 까먹더라도 다시 기억할 수 있게 작성해둡니다.

이전엔 java로 알고리즘 문제를 풀고 대회도 나갔었는데요.. 다른 언어에도 관심이 있어, 여러가지로 정리 하는 중입니다.

<br>

그 외 docker 및 인프라 등 다양한 것들을 정리합니다!

<br>

## 설정 및 포스트 작성 시

git pull 받고, [development_setup](https://github.com/rha6780/development_setup) pull 이후에서 basic 메소드 실행으로 ruby를 설치합니다. 이후 `bundle exec jekyll serve`를 통해 로컬에서 테스트가 가능합니다. 원하는 포스트나 설정 이후 테스트 후 push 하면 퍼블릭하게 적용됩니다.

<br>

⚠️ Docker 를 이용한 개발 시 반영되는 시간이 느리기 때문에 로컬 개발을 추천합니다.

<details>

<summary> Docker 이용 </summary>

아래 명령어를 통해서 실행 $dir 에는 현재 레포 로컬 위치 또는 docker compose up -d 를 통해서 개발 가능

```
docker run --rm \
  --name my-blog \
  --volume="$dir:/srv/jekyll" \
  -p 4000:4000 \
  -it jekyll/jekyll \
  jekyll serve
```

</details>
