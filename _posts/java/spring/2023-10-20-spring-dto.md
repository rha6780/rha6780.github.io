---
title: "[Spring] DTO(Data Transfer Object)"
date: 2023-10-20

categories:
  - java

tags:
  - java
  - spring

---

### DTO(Data Transfer Object)
Data Transfer Object 란 계층간 데이터 교환을 위해서 사용하는 객체이다. 예를 들면 API 로 응답을 할때 각각 모델에 있는 정보를 모아두는 객체라고 생각하면 편하다. 이런 DTO 는 빌더 패턴과 같이 사용되는 경우가 많다.

<br>

Entity 와 유사하지만, 엔티티가 DB와 밀접하게 연관되어있기 때문에 DTO를 따로 두어서 역할을 분리하는 목적을 가지고 있다. DTO를 이용해서 강한 의존성을 유연하게 분리할 수 있다. 그렇기 때문에 Entity는 DB 설계 쪽, DTO는 실제 비즈니스 로직을 구현하는 쪽이다. 물론 항상 그런 것은 아니고 설계에 따라 그냥 Entity를 이용하는 것이 더 간편한 경우가 있다.


<br>
<br>

**DTO를 사용하는 예**

가장 보편적인 예로는 페이지 네이션이 있다. 페이지 네이션은 page 넘버와 데이터 사이즈를 통해서 응답할 데이터의 개수를 조절하는데, 해당 페이지의 정보도 응답해줘야 하기 때문이다. 이 정보는 기존에 필요한 데이터와 결합해야하기 때문에 DTO 형식으로 많이 작성한다.

```java
{
	"data": [
		{
			"id" : 1
			"name": "sara"
		},
		{
			"id" : 2
			"name": "jack"
		},
		{
			"id" : 3
			"name": "andy"
		}
	],
	// 위의 일반 data와 pageInfo의 결합으로 구성
	"pageInfo": {
		"page": 1,
		"size": 10,
		... 
	}
}
```

data와 pageInfo의 결합으로 구성 되었기 때문에 이를 반복적으로 엔티티 객체에 작성하는 것이 아니라, data와 pageInfo를 주입받을 수 있는 DTO 객체를 구성하고 엔티티에서는 이를 넣어서 응답해주는 형식인 것이다. 단순이 이런 data와 pageInfo 뿐만이 아니라 여러 테이블 또는 데이터를 가공해서 응답해주어야 할때 DTO를 조합해서 하나의 DTO를 만드는 등으로 사용하기도 한다.

<br>
<br>

아무튼, 위와 같은 결과를 나타내기 위해서 DTO의 경우… 

```java
public class UserDTO<User> {
	private User data;
	private PageInfo pageInfo;

	public UserDTO(User data, PageInfo pageInfo) {
		this.data = data;
		this.pageInfo = pageInfo;
	}
}
```

<br>

위와 같이 구성하고 실제 응답을 해줄 때..

<br>

```java
public ResponseEntity getUsers(@Positive @RequestParam int page, @Positive @RequestParam int size) {
	
	// 비즈니스 로직이 들어감
	// data와 page 를 각각 User, PageInfo 클래스에 맞게 데이터를 가져온다. (대충 아래와 같이..)
	User data = User.builder().name("test").build();
	PageInfo pageInfo = PageInfo.builder().page(page).build();

	return new ResponseEntity<>(new UserDTO(data, pageInfo), HttpStatus.OK);

}
```

이런식으로 사용할 수 있다. 여기서 이런 DTO를 구현하다보면 인터페이스 등 여러 문제가 있을 수 있으니 디자인 패턴을 많이 참고해보자.



<br>
<br>
