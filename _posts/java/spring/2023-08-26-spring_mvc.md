---
title: "[Spring Boot] MVC 웹 전체 과정 구성하기"
date: 2023-08-26

categories:
  - java

tags:
  - java
  - spring

---


Example 이라는 도메인으로 생성하는 웹 페이지를 구성해보자.

<br>

## API 흐름

**MVC**

우선, API 를 구성하기 전에 MVC(Model-View-Controller) 패턴을 알아가야 한다. 

- Model : DB에 구성된 정보를 프레임 워크에서 사용할 수 있도록 객체로 구성된 부분
- View : 실제 웹에서 보여지는 화면, 유저와 상호작용(요청 받기) 등에 대한 부분
- Controller : Model과 View 사이 처리 등을 관리하는 부분

이렇게 3가지 부분을 나누는 개발 방법론으로, 컨트롤러가 모델과 뷰 사이를 중계하며 각각 영향이 없게 유지 보수 할 수 있는 방식이다.

<br>

**계층 구조**

스프링에서 MVC 는 아래 그림과 같이 이루어져 있다.

![Screen_Shot_2023-08-25_at_5 40 22_PM](https://github.com/rha6780/rha6780.github.io/assets/47859845/520b9897-785b-400c-8a5b-4c7d6b94bbf8)

<br>

각각 역할은 다음과 같다.

- Controller : 요청에 대한 흐름과 처리를 관리한다.
- Service : 핵심 로직을 구현
- Repository : DB에 접근하고, 도메인 객체를 관리하는 역할을 한다.
- Domain : 비즈니스 도메인 객체로 DB 테이블인 Model 과 Entity 가 있다.

이 외에 디자인 패턴을 공부 했다면 알겠지만, interface 를 이용해서 느슨하게 결합 하는 등 추가적인 과정이 존재한다. 일반적인 MVC 와 다르게 Repository 같은 것이 추가적으로 있는데 Domain은 DB 에 대한 객체를 의미하고, Repository는 DB에 접근할 때 주로 사용하는 쿼리, 트랜잭션에 대한 부분으로 이해하면 편할 것이다.

<br>
<br>


## 전체 과정 구성하기

API 를 구성하는 순서는 domain → repository → service → controller → view 순으로 진행하도록 하겠다. 기능에 따라서 과정의 순서가 바뀔 수 있으니 참고 하자.

<br>

### **Domain**

도메인은 DB 테이블 등의 객체를 구현하는 것으로 이전 DB 연동에서도 잠깐 다룬 내용이다. 보통은 아래 코드를 작성하고, 빌드 시 실제 DB가 수정되는 부분이기 때문에 이미 데이터가 있는 테이블의 경우 도메인 수정에 유의해야한다. 

```java
package com.example.demo.example.domain;

import jakarta.persistence.*;
import java.util.*;

@Entity
@Table(name="Example")
public class Example {
    @Id
    @Column(name="id")
    @GeneratedValue
    private long id;

    @Column(name="title", nullable = false, length = 512)
    private String title;

    private String content;

    public Example(String title, String content){
        this.title = title;
        this.content = content;
    }

    //Getter, Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
}
```

코드를 보면 Getter와 Setter를 일일이 작성하였는데, 귀찮다면 Lombok을 이용하는 것이 간편하다. 관련 내용은 다음에 문제점과 함께 정리하겠다. 아무튼 관련 어노테이션으로 다음과 같다. 

<br>

@Entity : 이 클래스가 엔티티임을 알려주고, 이걸 쓰면 DB에 테이블을 만들어 준다.

@Table : DB 테이블임을 명시한다.

@Id : DB 에서 id 필드로 매핑한다.

@GeneratedValue : PK를 DB에서 자동으로 생성해주고, 옵션을 통해 생성 전략을 정할 수 있다.

@Colume : DB의 컬럼과 매핑한다. 컬럼에 따로 옵션이 없다면 생략해도 된다.

<br>

**Entity와 Table의 차이?**

Entity의 경우 JPA에서 관리되고, Table의 경우 엔티티와 DB를 매핑하는 것으로 실행은 조금 다르다. 두 어노테이션 모두 name을 지정할 수 있는데, Entity의 경우 JPA에서 엔티티를 식별하는 이름으로, Table의 경우 DB의 테이블 이름으로 작용한다. 하지만, Table이 없는 경우 Entity의 name이 실제 DB에 적용되기 때문에 두 어노테이션을 쓰는 경우는 실제 DB와 JPA에서 사용되는 이름이 다른 경우이다.

<br>

**복합키는 어떻게?**

@Id를 이용하는 경우 PK가 설정되지만… 복합키를 사용하고 싶다면 @Id를 설정하지않는다. 복합키를 사용하는 경우에 EmbeddedId 또는 IdClass 라는 방식이 있다.

<br>

- EmbeddedId 방식

EmbeddedId를 이용하는 경우, Embeddable 어노테이션을 이용해서 클래스를 지정해야한다.. 예시는 아래와 같다.

```java
이전에 book_id로 관리되던 시스템에서 책에 대한 정보가 너무 많아지자.
type과 code 라는 복합키를 이용하도록 수정하게 되었다. 

@Embeddable
public class BookKey implements Serializable {
	private String type;
	private String code;
}

@Entity
public class Book {
	@EmbeddedId
	public BookKey bookKey;
}
```

<br>

- IdClass 방식

IdClass를 이용하는 경우, Serializable 를 꼭 받아야 한다.

```java
public class BookKey implements Serializable {
	private String type;
	private String code;
}

@Entity
@IdClass(BookKey.class)
public class Book {
	...
}
```

두 방식을 비교했을 때 EmbeddedId가 좀더 객체 지향적이고 IdClass는 DB 방식에 가깝다. 데이터베이스 수업을 열심히 들었다면 알겠지만, 복합키를 이용하면 인덱스 등을 이용해서 조회 성능이 달라질 수 있습니다. 하지만, 위에서 Book을 타입으로 정의하였지만, 카디널리티가 낮은 경우 오히려 성능이 떨어질 수 있으니 설계 시 주의해야한다.

<br>

### Repository

리포지토리는 실제 데이터 생성, 조회, 수정, 삭제(CRUD)에 대한 로직을 구현한다. 도메인에서 정의한 칼럼 등을 이용하기 때문에 도메인에 모든 칼럼에 대한 Getter와 Setter가 정의되는 것이 좋다. 일단, 다 구현 되었다는 가정하에 진행하도록하겠다.

```java
@Repository
public interface ExampleRepository extends JpaRepository<Example, Long>{

    List<Example> findFirst2ByIDDesc();
    Optional<Example> findById(Long id);
    Optional<Example> findByTitle(String title);
}
```

<br>

생각보다 간단한데, 여기서 중요한 것은 메소드의 이름이다. JpaRepository를 상속받으면 저렇게 메소드 이름을 지정 함으로 원하는 쿼리를 실행시킬 수 있다. 종류가 다양하기 때문에 이건 실제 개발하면서 공부하자. 주로 조회를 할때에는 `find...By`, `read…By`, `get…By`를 자주 사용한다.

<br>

**쿼리 커스텀**

기초적으로 제공하는 쿼리가 아니라 우리가 지정하는 쿼리를 수행하고 싶을 때가 있는데, 이 경우 @NamedQuery를 이용해서 쿼리를 커스텀 할 수 있다.

```java
@Entity
@NamedQuery(
	name="Example.findByCustomTitle", 
	query="select e from Example e where e.title = :title"
)

```

<br>

**JpaRepository 를 상속받지 않는다면…?**

커스텀한 리포지토리를 상속하는 경우 EntityManager 등을 주입해서 구현하는 방식이 있다. 하지만 그만큼 직접 코드를 작성해야하기 때문에 로깅, 디버깅 등에는 좋지만, 관리 포인트가 늘어나기 때문에 주의하자.

<br>

여기서 CRUD의 R에 대한 부분이 주로 있고, 나머지 생성, 수정, 삭제에 대한 내용이 없는데, 생성 수정 삭제의 경우 `ExampleRepository.save(ex);` `ExampleRepository.update(ex);` , `ExampleRepository.delete();` 로 주로 사용한다. save는 생성, 수정 둘다 적용되는데, 생성되는 것은 해당 엔티티가 없는 경우에 해당되고, 있는 경우에는 수정으로 적용된다.

<br>

save 메소드에서 생성, 수정 어떤걸 적용할지 구분하는 이벤트를 **MergeEvent** 라고 하는데, merge에 따른 오버헤드나 문제점이 있을 수 있으니 무조건 사용하는 것은 아니다. 해당 부분이나 쿼리 자체가 기능에 따라 달라지기 때문에 우선은 이런 것을 사용할 수 있다 정도로 생각하면 될 것 같다. 리포지토리에서 쿼리와 관련된 내용을 다루긴 하지만, Controller 부분에서 PutMapping 등 어노테이션을 통해서 삽입, 수정, 삭제가 일어날 수 있기 때문에 우선 여기까지 확인하도록 하자.


<br>

### Service

실질적인 로직이 들어가는 부분으로 리포지토리에서 정의한 쿼리문을 호출하거나 등등이 이루어진다. 말 그대로 구현하는 기능에 따라 다르기 때문에 꼭 아래와 같이 사용할 필요는 없다.

```java
@Service
public class ExampleService {
	private final ExampleRepository exampleRepository;

	@Autowired
	public ExampleService(ExampleRepository exampleRepository) {
		this.exampleRepository = exampleRepository;
	}

	public Long newExample(Example example) {
		exampleRepository.save(example);
		return example.getId(); // 생성되면 확인을 위해 작성한 내용을 볼 페이지로 이동을 위해 id 반환
	}
}
```

<br>

### Controller

우선 컨트롤러에서는 클라이언트로 부터 받을 필드를 미리 생각하고 해당 요청을 정의한다. Example 과 관련된 내용을 받으면 이를 저장하는 API 를 구성한다고 생각하자.

```java
public class ExampleForm {

    private String title;
		private String content;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

		public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
```

위와 같은 Form을 작성하면 다음과 같이 구현이 가능하다. Form 대신 DTO 나 다른 개념의 객체를 만드는 방식도 있지만, 그건 REST API 구성에서 더 설명하도록 하겠다.

```java
package com.example.demo.example.controller;

import ...

@Controller
public class ExampleController {

    private final ExampleService exampleService;

    @Autowired
    public ExampleController(ExampleService exampleService) {
        this.exampleService = exampleService;
    }

    @GetMapping("/")
    public String getIndexView() {
        return "index";
    }

    @GetMapping("/example/new")
    public String getNewView() {
        return "new";
    }

    @PostMapping("/example/new")
    public String create(ExampleForm form) {
        Example example = new Example(form.getTitle(), form.getContent());
        Long id = exampleService.newExample(example);
        return "redirect:/";
    }
}
```

여기서 `return` 형식을 `html`이나 `redirect` 로 하면 웹서버로 운영되고, 또는 json 형식으로 보내거나 @RestController 어노테이션을 이용하면 API 로 구성된다. REST API 는 따로 기록하도록 하겠다.

<br>

### View

view는 말 그대로 화면이기 때문에 주로 html으로 구성된다. 여기서는 생성하는 페이지와 생성된 루트 페이지를 작성하였다. 해당 코드는 resources 하위 templates에 위치한다. build.gradle에 타임리프가 있는지도 확인하자.

```java
//new.html
//Example을 생성하는 페이지
<!DOCTYPE HTML>
<html>
	<body>
		<div>
		    <form action="/example/new" method="post">
		        <div>
		            <label>제목</label>
		            <input type="text" name="title" placeholder="제목을 입력하세요">
		            <label>내용</label>
		            <input type="text" name="content" placeholder="내용을 입력하세요">
		        </div>
		        <button type="submit">등록</button>
		    </form>
		</div>
	</body>
</html>
```

<br>

```java
//index.html
//루트 페이지
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <a href="/example/new"> Example 생성하기 </a>
</body>
</html>
```

<br>

### 결과


<img width="581" alt="Screen_Shot_2023-08-26_at_7 22 56_PM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/d8787e21-4487-456d-91db-1348ad97af9c">

<img width="768" alt="Screen_Shot_2023-08-26_at_7 23 35_PM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/31576dff-196e-4774-b052-8a89fd67a33e">


다음과 같이 작동한다.

<br>
<br>
