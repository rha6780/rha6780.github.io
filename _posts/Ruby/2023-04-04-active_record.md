---
title: "[Rails] ActiveRecord 란?"
date: 2023-04-04

categories:
  - ruby

---

## 소개

[Active Record Basics - Ruby on Rails Guides](https://guides.rubyonrails.org/active_record_basics.html)

> Active Record is the M in [MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)
 - the model - which is the layer of the system responsible for representing business data and logic. Active Record facilitates the creation and use of business objects whose data requires persistent storage to a database. It is an implementation of the Active Record pattern which itself is a description of an Object Relational Mapping system.
> 

공식문서에서 설명하길  Active_Record 는 MVC 패턴에서 모델 부분에 해당하고 비즈니스 로직, 데이터를 설명하는 레이어라고 한다. 주 기능으로는 비즈니스 로직에 따라서 데이터 생성 후 지속적으로 해당 데이터를 저장하고 활용하는 부분에서 사용한다. Active Record 패턴은 객체-관계-매핑(ORM) 설명을 의미한다.

즉, ORM : 데이터를 가져오고 쿼리를 요청하는 부분이 Active_Record 인 것이다. 따라서 **MVC의 모델 부분**에 해당 Active_Record에 해당하는 클래스를 상속받는다.

<br>

**SRP(Single-responsibility principle) 위반? [🔗](https://jurogrammer.tistory.com/137)**

SRP란, 단일의 클래스 등이 해당 부분에 대해서만 책임을 져야하고 캡슐화하는 원칙을 말한다. 즉, 어떤 클래스가 변경된다고 하자. 해당 클래스를 바꾸기 위해 다른 클래스를 수정해야하는 경우... SRP 방식으로 코드 구성이 되지 않은 것이다. 따라서 어떤 모델, 클래스 단위가 아니라 책임이라는 의미를 중요하게 여기고 이에 따라 모듈을 나누는 결과가 나오는 것이다.

<br>

**SRP를 지키면 좋은점**

- 클래스 응집도가 높음(한 클래스에 필요한 기능 들이 응집해있음)
- 클래스 결합도가 낮음(다른 클래스와 결합하지 않고 독립적으로 기능 가능)
    
     = 클래스끼리의 의존성이 낮음.
    

하지만, Active_Record 의 경우 이런 SRP를 위반하는 내용이 많다. 어떤 홈페이지에서 유저 모델의 Active_Record (ORM)을 생각해도 어떤 게시글 작성, 수정, 삭제 등 해당 유저 모델의 값을 불러오는 과정이 필요하다. 해당 글에 대한 인증이 필요하기 때문... 그렇다고 SRP를 맞추기 위해 게시글 모델을 유저 모델에 지정하는 것도 코드가 길어지고 문제를 야기한다.

참고한 블로그에서는 Active_Record 의 기능을 일부 컨트롤러에서 구현하고 Active_Record 와 Controller 사이에 레이어를 하나 둠으로 이러한 문제를 줄이는 방식을 소개하고 있다. 즉, 앱에 대한 도메인을 나누어서 해결하는 것이다.

우선 이 부분은 추후에 더 살펴보기로 하자.



## 기초 컨벤션

### Naming Conventions

Active Record가 MVC에서 M(모델)의 역할을 한다고 소개하였다. 그렇기 때문에 모델로 인해 구성되는 테이블과도 깊은 관련이 있는데 그 중 하나는 이름이다. 예를 들어 모델을 Book이라고 작성하면 테이블 명은 복수형인 books가 되고 스네이크 케이스로 지정된다.

| Model/class | Table/Schema |
| ----------- | ------------ |
| Article     | articles     |
| Mouse       | mice         |
| BookList    | book_lists   |

### Schema Conventions

스키마 컨벤션은 실제 테이블에 해당하는 속성들 중 일반적인 컨벤션을 의미한다. 그 중 외래키(Foreign_key), 기본키 (Primary_key) 등이 이에 해당한다.

| 이름          | 설명                                                                                                 |
| ------------- | ---------------------------------------------------------------------------------------------------- |
| Primary_key   | 주로 id라는 이름으로 짓고, 타입으로 bigint는 postgres와 mysql, integer은 SQLite에 사용한다.          |
| Foreign_key   | 주로 해당하는 테이블 명(단수)_id 형식으로 작성한다. (ex: book_lists의 기본키를 가져옴→ book_list_id) |
| created_at    | 생성 날짜                                                                                            |
| updated_at    | 수정 날짜                                                                                            |
| lock_version  | 긍정적 locking 에서 사용할 때 추가한다.                                                              |
| 테이블명_type | 다형성(ploymorphic) 구조에서 테이블 타입을 정의할 때 사용한다.                                       |


## 모델 작성하기



위에서 설명했듯이 MVC에서 M을 맡고 있는 Active Record는 기본적으로 ApplicationRecord를 상속한다. 예를 들어 Book이라는 모델을 구성한다고 가정하면 다음과 같이 작성할 수 있다.

```ruby
# model/book.rb
class Book < ApplicationRecord
	self.table_name = "my_books"
	self.primary_key = "book_id"
end
```

이러면 해당 모델이 작성된 것이다… 여기서 기존 컨벤션을 수정하고 싶은 경우 위와 같이 작성할 수 있다.

> ***“ 이게.. 끝..? 야레야레 쉽구먼 ?”***
> 

물론, 필요에 의해 작성할 수 있다. 여기서 말하는 필요는, 특정 속성에 대한 유효성(validation)이나 릴레이션 관계(has_many, belongs_to)에 대한 내용이다. 또한, getter/setter  추가(attr_accessor) 등을 할 수도 있다.

<br>

### 모델의 세부 설정 : Validations

---

유효성 검사는 데이터를 추가(save)하고 수정(update)할 때, 중요한 역할을 한다. 모델 파일에 이를 정의하는 것이 일반적으로 필요에 의해 작성한다. 실패 시 exception의 유무에 따라 아래와 같이 나온다.

- save, update → false
- save!, update! → ActiveRecord::RecordInvalid

```ruby
# model/book.rb
class Book < ApplicationRecord
	validates :name, presence: true
end
```

validates에는 위와 같이 `presence: true`로 name이 blank에 해당하는 값인 경우를 체크할 수 있다. 특수한 키와 같은 경우, `uniqueness: true`로 유일한 값인지 체크할 수 있다.

<br>

또는 사용자가 지정한 메소드를 호출해서 처리할 수 있다. 예를 들어, Score라는 속성의 값이 양수(positive Integer)인 경우에만 유효하다고 가정하자.

```ruby
# model/book.rb
class Book < ApplicationRecord
	validates :name, presence: true
	validate :is_positive?

	def is_positive?
		self.score > 0 ? false : true
	end
end
```

지정한 메소드를 사용하는 경우 `validate`로 작성하고, 기존에 있던 클래스를 이용하는 경우 `validates`로 작성하는 것이다.

<br>

### 모델의 세부 설정 : Callbacks

---

콜백은 모델 객체의 라이프 사이클을 관리하는 부분이다. 주로 before, after 라는 수식어로 시작하며 다음과 같이 사용할 수 있다.

[모델 콜백](https://www.notion.so/5047bc19d7e345bfb2db1f1fdd407356)

위 콜백에서 수식어는 실행 순서를 지정하는 것으로..

- before_ : 액션이 실행되기 전에 수행
- after_ : 액션이 실행된 후 수행
- around_ : `append_before_action` + `prepend_after_action` 이다. ([참고](https://stackoverflow.com/questions/36143039/rails-around-action-in-the-callback-stack))

다음과 같이 before_validation :name_present? 와 같이 작성하면 name_present? 라는 메소드가 validation이 실행되기 전에 수행된다.

**자세한 내용**

[Active Record Callbacks - Ruby on Rails Guides](https://guides.rubyonrails.org/active_record_callbacks.html#creating-an-object)

<br>

### Migrations 작성하기

---

모델 파일을 다 작성한 경우, 마이그레이션 파일을 작성해서 실제 DB 스키마를 구성해야한다. 마이그레이션 파일을 작성한 후 `rails db:migrate`를 해야 DB에 반영된다. 

**예시**

```ruby
class CreatePublications < ActiveRecord::Migration[7.0]
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.references :publication_type
      t.integer :publisher_id
      t.string :publisher_type
      t.boolean :single_issue

      t.timestamps
    end
    add_index :publications, :publication_type_id
  end
end
```

각각 위와 같이 구성할 수 있다. timestamps의 경우 created_at 과 updated_at을 자동으로 구성한다.

- migration 롤백
    
    바로 이전으로 롤백 : `rails db:rollback`
    
    이전 n 단계 전으로 롤백 : `rails db:rollback STEP=n`
    
    특정 버전으로 롤백 : `rails db:migrate:down VERSION=20080906120000`
    
    버전 및 마이그레이션 확인 : `rails db:migrate:status`
    

**자세한 내용**

[Active Record Migrations - Ruby on Rails Guides](https://guides.rubyonrails.org/active_record_migrations.html#active-record-and-referential-integrity)

<br>

### delegate 사용

---

rails 에서는 dry(do not repeat yourself: 같은 코드 반복 최소화)를 지향하기 때문에 어떤 필드를 다른 모델에 그대로 위임하는 경우 delegate를 사용할 수 있다. 해당 블로그에서는 어떤 아이돌 리스트를 보여주는 곳에서 그 아이돌의 좋아요, 싫어요 값을 리스트에 표시하고 싶은 경우 

```ruby
has_one :profile, inverse_of: :idol, dependent: :destroy, class_name: 'Idol::Profile'
def good_count
  self.profile.good_count if self.profile
end

def bad_count
  self.profile.bad_count if self.profile
end
```

이와 같이 해당 모델에 연결된 profile을 불러와서 이와 같이 사용하지만, delegate를 사용하면 이러한 일련의 과정 없이 아래 처럼 불러올 필드만 정의하면 된다.

```ruby
has_one :profile, inverse_of: :idol, dependent: :destroy, class_name: 'Idol::Profile'
delegate :good_count, :bad_count, to: :profile, allow_nil: true
```

[Rails,ruby에서 delegate를 사용하는 이유](https://negabaro.github.io/archive/ruby-module-delegate)

<br>

### rails db:migrate vs rake db:migrate

두 명령어의 차이는 rails 버전이 올라감에 따라서 원래 있던 rake db:migrate에 대해 rails 명령어로 가능하도록 한 것이다. 다만, 이전 버전에 대한 명령어를 놔두고 해당 rake에 대한 명령어에 Proxy 설정이 있어서 해당 설정에 따른 명령어가 있을 수 있다...

[rails db:migrate vs rake db:migrate](https://stackoverflow.com/questions/38403533/rails-dbmigrate-vs-rake-dbmigrate)

<br>
<br>
