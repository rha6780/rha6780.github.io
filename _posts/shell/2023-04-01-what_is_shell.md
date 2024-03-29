---
title: "Shell 이란?"
date: 2023-04-01

categories:
  - shell

---

### shell 이란

shell 이란, 텍스트 기반의 운영체제와 사용자간의 인터페이스이다. 요즘 GUI가 좋아졌긴 했지만, 실제 개발하다보면 CLI 기반으로 작업해야 할 일이 많기 때문에 shell은 여전히 사용되기도 한다.

<br>

**세부적으로 언제 shell 을 사용하나?**

보통 터미널 에서 ls 와 같은 명령어 모두 shell 이다. 우리는 알게 모르게 shell을 사용하고 있다..!

터미널에서 자주 사용하는 명령어 외에도, *.sh 파일을 만들어서 이를 실행할 수도 있다. 자주 쓰는 명령어를 모아서 파일 형태로 만들어두면 해당 파일만 실행하면 되기 때문에 수고가 덜게된다. (인터프리터와 같이 한줄 한줄 읽으면서 실행된다.) 이런걸 `쉘 프로그래밍` 이라고 한다. 내 경험에 따르면… 배포할 때 필요한 과정을 shell 스크립트 내부의 코드로 작성하고 배포 마다 해당 쉘을 실행하는 방식으로 진행하는 등을 봤다. 또 Docker를 사용하게 되면서 환경 세팅 시 쉘을 이용해서 쉽게 세팅하는 경우도 있다.

<br>

**주로 사용하는 shell?**

shell도 종류가 다양하다. 리눅스 기준으로 주로 사용되는 것은 `Bash shell` 또는 `Z shell` 이다.

bash 의 경우, 모든 리눅스가 bash 을 기본으로 사용하고 있기 때문에 많이 사용한다. 대부분의 *.sh 파일은 bash를 기준으로 작성된다. zsh은 기존 bash와 호환이 좋고, 그 외 플러그인이나, 자동완성 등 실제 사용하기 편리하기 때문에 많이 사용한다. 특히 콘솔창을 가독성있게 설정할 수 있기 때문에 작업하기 편하다. 

<br>

[oh my zsh](https://ohmyz.sh/)


많이 사용하는.. 추천하는 플러그인은 oh-my-zsh 가 있다.

windows의 경우 운영체제가 다르기 때문에 쉘 역시 다르다. 주로 batch 파일이라고 부르는 파일이 리눅스에서의 sh 파일과 같다.
