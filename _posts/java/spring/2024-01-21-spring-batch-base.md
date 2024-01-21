---
title: "[Spring Batch] Spring Batch 와 구조"
date: 2024-01-21

categories:
  - java

tags:
  - java
  - spring
  - spring-batch
---

## Spring Batch 란?

Spring Batch는 대량의 데이터를 일괄 처리하는 경량화된 프레임워크로, 로깅이나 통계, 대규모 리소스 관리 등에서 사용된다. 스케줄링에 따라 주기적으로 실행시키거나, 대용량 데이터 처리를 위해 분산 방식으로 실행할 수 있다.

<br>

**기능들**

데이터 분산 처리 : 큰 데이터를 분산 처리하는 등 대용량 데이터에 유용하다.

트랜잭션 : 배치 중 실패하는 경우, 처리한 데이터를 롤백하여 데이터 일관성을 유지한다.

재시도 : 작업 중 실패하는 경우, 해당 작업을 다시 실행 시킬 수 있고 재시도 횟수를 설정할 수 있다.

<br>

### 과정과 내부 요소들

<img width="1369" alt="SpringBatch diagram" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/0ae0e84d-e8c5-4234-9820-c3d089abe274">

<br>

**JobScheduler - JobLauncher를 호출하는 스케줄러**

위 그림과 같이 JobScheduler에 의해 JobLauncher가 실행 되는 것으로 시작한다. 이때 JobScheduler는 Jenkins와 같이 자바 외부의 스케줄러일 수 있고, Quartz, Spring Scheduler 처럼 스프링 라이브러리 이거나 자바 프로세스 내부일 수 있다.

<br>

**JobLauncher - Job을 실행하는 인터페이스**

JobLauncher가 실행되면, JobLauncher 내부에 정의된 설정에 따라 Job이 실행된다. JobLauncher 설정에는 Executor 종류에 따라 스레드 풀 설정이나 연결되는 JobRepository 등을 설정할 수 있다. JobLauncher는 스케줄러에서 던진 파라미터를 Job에 전달하면서 설정에 따라 실행되게 한다.

<br>

**Job - 실행되는 작업(JobInstance), 하나의 Job은 여러개의 Step을 가진다.**

Job이 실행되면, Job은 자신에게 정의된 여러개의 Step을 순서대로 실행시킨다. Job에서는 받은 파라미터를 가공해서 Step에 전달한다. JobParameter 로 객체를 받기 힘들기 때문이다. 또한, 각 Job과 Step은 ExecutionContext을 가지고 있는데, 실행이 되면서 필요한 요소를 저장할 수도 있다.

<br>

**Step - 배치 작업의 최소단위**

Job에서 Step이 실행되면, Step은 2가지 방식으로 실행되고 리턴된다. 간단히 말하면 read, process, wirte 등으로 나뉘는 Chunk 방식과 Tasklet 방식으로 나눌 수 있다. 이에 대한 부분은 아래에서 자세히 다루겠다.

<br>

**JobRepository - Job 과 관련된 메타 데이터를 저장하고 조회하기위한 인터페이스**

JobLauncher, Job, Step 등에서 메타 데이터를 수집해서 DB에 저장하는 역할을 한다. DB에 따로 저장하는 이유로는 대용량 처리에 따른 트랜잭션 관리와, 실패시 재시도 지점을 찾기 위한 부분 등 여러가지를 위해 저장한다. 단순히 저장뿐만 아니라 이를 조회할 수 있게 도와주어 모니터링에도 쓰일 수 있다.

<br>
<br>
<br>

## Chunk 와 Tasklet

위에서 간단히 과정을 소개하였는데, Chunk 방식과 Tasklet 방식이 있다. 이 두가지 방식의 차이점을 간단히 정리하면 다음과 같다.

<br>

Chunk : n 개의 단위로 데이터를 처리하는 방식으로 n개가 하나의 트랜잭션으로 처리된다.

Tasklet : 처리하는 데이터를 하나의 트랜잭션으로 처리된다.

<br>

**롤백**

Tasklet의 경우 하나의 트랜잭션으로 모든 데이터를 처리하기 때문에, 데이터 중 2n+1개 에서 오류가 난 경우 앞에서 처리한 모든 결과가 롤백된다. 하지만, Chunk는 2n+1개에서 오류가 난 경우 앞에서 처리된 2n은 이미 트랜잭션이 되었기 때문에 1개만 롤백된다. 그렇기에 Chunk 방식은 재시작 시점은 2n+1 번 부터이고, Tasklet은 처음 부터일 것이다.

<br>

**그렇다면 무조건 Chunk 방식?**

무조건 Chunk 방식으로 해야한다 라고 하기에는 Chunk 방식에는 Reader와 Writer가 반드시 있어야 하는 부분도 있고, 사용하기 어려운 부분이 있다. Tasklet은 하나의 파일, 메소드에 모든 로직이 들어가 있어 간단히 사용할 수 있다. 하지만, Chunk 방식은 필요하다면 Reader, Processor, Writer 에 대한 이해가 필요하고, 목적에 따라서 커스텀을 해야한다는 점이 있다.

<br>

**사실은 같은 개념..**

사실 Tasklet은 하나의 Chunk와 같다. Chunk가 n개로 나누는 방식이라고 했는데, Tasklet은 청크를 나누는 단위가 데이터의 전체인 것이다. 따라서, 필요한 기능이 있는데 Chunk 방식으로 하기에 시간이 안난다면, Tasklet에서 필요한 개수만큼 나눠서 처리해도 Chunk와 비슷하게 된다. (다만 코드가 복잡해짐)

<br>
<br>

## Reader, Processor, Writer

<img width="497" alt="RPW Structure" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/7bd20533-32f3-41e8-8628-ebb30ec217a7">

위 그림과 같이 Step은 3가지가 있지만, 사실 Processor는 없어도 된다. 중요한 부분은 Input, Output 그리고 Reader의 null 이다.

우선 Step이 종료되는 시점은 Reader에서 null이 반환된 순간이다. 만약 null 이 아니라면 해당 객체를 Processor로 전송한다. Processor는 해당 객체를 Output에 해당하는 다른 객체로 변환하거나 로깅 등을 하는 역할을 하는데, Input과 Output이 같은 경우 이 과정을 생략하고 Reader에서 Writer로 바로 전달하기도 한다. Writer에서는 받은 정보를 DB, 파일 등의 형식으로 작성하고 Step으로 다시 돌아간다.

<br>

**코드 예시**

유저가 남긴 히스토리를 모아서 DB또는 파일로 작성하는 스텝이다.

```jsx
@JobScope
    @Bean
    public Step userStep(@Value("#{jobParameters[name]}") String name) throws Exception {

        User user = userRepository.findUserByName(name).orElseThrow();

        return new StepBuilder("userExcute", jobRepository)
            .<UserDto, HistoryDto>chunk(1000, transactionManager)
            .reader(userSteps.userReader(user))
            .processor(userSteps.userHistoryProcessor())
            .writer(userSteps.userWriter())
            .listener(userStepListener)
            .build();
    }
```

위 코드를 기반으로 chunksize는 1000 이고, Input은 UserDto, Output은 HistoryDto가 된다. 여기서 1000개 단위로 처리되는데, reader에서 1000개를 읽고 processor로 넘기고… processor에서도 1000개 처리된 결과를 한꺼번에 writer로 넘긴다. writer에는 1000개를 작성하고 다시 루프를 타는 것이다.

<br>

여기까지 간단한 과정과 내부 요소에 대해서 살펴보았다.. 다음에는 실전편과 함께 적용하고 세부적인 내용을 살펴보자.

<br>
<br>
