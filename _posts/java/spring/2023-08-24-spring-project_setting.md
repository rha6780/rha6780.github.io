---
title: "[Spring Boot] 프로젝트 생성"
date: 2023-08-24

categories:
  - java

tags:
  - java
  - spring

---


### **시작하기 전에**

기록을 위해 깃 설정 부터 진행하겠다. 로그인 후 repository 섹션에서 New repository 버튼을 눌러서 레포 하나를 만들자. 


![Screen_Shot_2023-08-24_at_10 47 40_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/9b5b0b9a-d926-4fc7-abd7-12f643e99d80)

<br>

![Screen_Shot_2023-08-24_at_10 48 36_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/c434be6c-529e-4e2b-b02d-e9b5a3fa2926)



성공적으로 생성되었다면 위와 같이 Quick setup 이라는게 나오는데 저기 HTTPS 링크를 복사하고, 로컬 터미널에 들어가 원하는 위치에서 `git clone 복사한링크` 를 작성하면 아래와 같이 우리가 만든 레포 환경이 만들어 진다. 해당 폴더를 원하는 IDE에서 열자. 우선 문서 기준은 IntelliJ 로 진행할 예정이다. 해당 에디터에서 README.md와 .gitignore을 작성해야하는데, gitignore의 경우 아래 링크를 참고하자. (인텔리 제이에 Marketplace에 ignore 플러그인이 있는데, 귀찮은 경우 한번 써도 될 것 같다.)

![Screen_Shot_2023-08-24_at_10 49 48_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/c0df314a-efad-4b83-8a2e-57792f2b1a91)

<br>


[springframework - gitingore](https://github.com/spring-projects/spring-framework/blob/main/.gitignore)


<br>
<br>

### 프로젝트 만들기

[spring initializr](https://start.spring.io/) 또는 사용하는 IDE 에서 생성한 파일을 이용해 프로젝트를 생성한다. 인텔리제이 커뮤니티 버전에서는 스프링 프로젝트 생성 지원에 불편함이 있어 아래와 같은 과정을 거치는 것이 좋다. (학교 인증을 했다면 에디터에서 바로 생성할 수 있다.) 또한 모든 구성은 Gradle 로 진행할 예정이다.

아래와 같이 설정을 하고 Generate 를 누른다. 
![Screen_Shot_2023-08-24_at_10 36 55_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/9e5dd4d9-7960-464f-920c-2c92f59e9077)



- 참고
    
    [[Spring] 빌드 관리 도구 Maven과 Gradle 비교하기.](https://jisooo.tistory.com/entry/Spring-빌드-관리-도구-Maven과-Gradle-비교하기)
    

![Screen_Shot_2023-08-24_at_10 55 23_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/2bd0a2cf-daff-4539-8220-9aeabc6add0e)

이제 다운 받은 ZIP 파일을 우리가 만든 프로젝트에서 압축을 풀고 해당 파일을 에디터에서 열어보자. (시간이 조금 걸릴 수 있다.) 아래와 같이 각각 파일이 보인다.

![Screen_Shot_2023-08-24_at_10 57 45_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/ea294b28-e7ab-43f5-8a1c-8e69825a61aa)


<br>

### Dependencies 설정

gradle 의 경우, `build.gradle` 이라는 파일이 있을 것이다. 필요한 라이브러리를 아래와 같이 추가하면 된다. 간단하게 `jpa` 와 `thymeleaf` 를 추가하였다. (타임리프는 html을 동적으로 제공할 수 있는 라이브러리이기 때문에 API만 개발하는 경우 제외해도 된다.)


![Screen_Shot_2023-08-24_at_11 00 28_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/b9913de4-b9a3-4ffd-9f36-b470f08cfa56)


<br>
<br>

### 로컬환경 설정

**빌드해보기**

이제 프로젝트를 한번 빌드 해보자. src>main>… 하위에 DemoApplication.java가 보일 것이다. 여기가 스프링 앱이 시작되는 메인 함수가 있어 해당 위치에서 빌드가 가능하다. 하지만 현재 프로젝트의 JDK 가 설정되어있지 않기 때문에 IntelliJ 에서 쉽게 빌드, 실행하기 위해서 이를 설정해주어야 한다.

![Screen_Shot_2023-08-24_at_11 25 16_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/2dd2a151-6573-4936-95dc-093b8e10b33e)

위에서 간단하게 SetUp 버튼을 누르거나. 아래와 같이 Project Structure 에서 설정해주자. 단, 수동으로 하는 경우 Modules에 Project default 에서 Language Level도 동일한 버전으로 세팅해야한다.



![Screen_Shot_2023-08-24_at_11 36 32_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/53887b7a-e86a-4662-8bb8-085878f6e5c2)

<br>

![Screen_Shot_2023-08-24_at_11 39 15_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/aef95e9d-7682-4ee7-9007-572b3f697aca)

여기서 문제는 해당 버전의 JDK 가 없는 경우인데, IntelliJ에서 자동으로 다운할 수 있기 때문에 무리없이 할 수 있을 것이다. 중간 중간 아래 같은 것도 실행하자.


![Screen_Shot_2023-08-24_at_11 43 03_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/c4df7451-ff93-404e-a3f1-076c5e5f1a44)

<br>




### Configuration 생성

주로 우리가 실행시킬때 아래와 같은 버튼을 누르는데, 이 버튼을 누르기 전에 바로 옆에 있는 Add configuration 을 진행해야한다.

![Screen_Shot_2023-08-24_at_11 41 42_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/ca1bbff7-6a07-4a71-8ec0-1298ae9cfa69)


왼쪽은 Gradle로 생성하고, 실행 설정으로 bootRun 을 선택해서 완료하자.


![Screen_Shot_2023-08-24_at_11 52 55_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/d718a721-b358-4417-9ee5-ddc610909efa)

<br>

![Screen_Shot_2023-08-24_at_11 53 29_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/70e16466-3177-44cb-baf5-3860d0340580)

<br>

![Screen_Shot_2023-08-24_at_11 51 24_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/3bdfe862-cb1b-44a2-ae45-65b57f64db5b)


그러면 위와 같이 초록색 버튼이 활성화된다. 누르면 아래와 같이 FAILED 가 나오는데 DB가 없어서 생기는 문제이다.


![Screen_Shot_2023-08-24_at_11 56 40_AM](https://github.com/rha6780/rha6780.github.io/assets/47859845/590dafe4-889b-4dcb-9d2b-7f5a20e07eb1)

<br>
<br>
