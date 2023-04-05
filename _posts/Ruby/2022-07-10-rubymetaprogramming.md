---
title: "[Ruby] Meta 프로그래밍 이해하기"
date: 2022-07-16

categories:
  - ruby
tags:
  - ruby
---


## Self 이해하기

파이썬에서 self는 자기 자신의 클래스를 의미한다. 따라서 어떤 클래스 메소드를 작성하게 되면 self를 붙여서 클래스 메소드임을 표시한다. 자기 자신(클래스)를 의미하기 때문에 def를 통해 어떤 메소드를 정의하면 해당 클래스에 등록된다고 이해하면 편할 것이다. 루비에서의 self도 비슷하긴 하지만, 깊게 생각하면 “`**현재 위치(객체)**`”를 의미한다. 루비에서 self는 어떤 인스턴스 변수를 찾을 때 사용되거나 표현하기 위해서 사용한다.

```ruby
class Test
  def one
    @var = 99
    two
  end
  
  def two
    puts @var
  end
end

t = Test.new
t.one
```

위 코드를 실행하면 결과적으로 99를 출력하게 된다. 이때 그 과정을 살펴보면.. 이 t의 클래스에서 one이라는 메소드가 호출되었기 때문인데, 이 one 메소드를 찾기 위해 self가 사용된다.

self를 t 로 두고, 해당 객체에서 one이라는 메소드가 있는지 확인한다. 메소드가 있으면 해당 메소드를 출력하고, 호출 후 종료될 때 self를 기존 위치로 되돌린다. 즉, 어떤 메소드가 호출될 때.. 그 메소드를 호출하는 수신자(receiver : 리시버)를 필요로 하고, 이 역할을 하는 것이 self인 것이다.

사실 나는 이것을 처음 듣고 한 가지 의문이 들었다. “해당 코드에서는 Test 클래스 아래에 one, two 메소드가 있는데 그렇다면 self가 가리키는 곳이 t가 아닌 Test 여야 해당 메소드를 찾는 것이 아닌가?” 하지만, 그 후 탐이 설명해주신 덕분에 이런 방식이 아니라는 것을 알게 되었다.

> “ 우리가 작성한 Test 클래스도 하나의 객체이다. “
> 

이를 이해하기 위해 클래스 메소드, 인스턴스 메소드를 확인하여서 그 차이점, 그리고 클래스가 객체라는 것을 이해해보자.

### **클래스 메소드와 인스턴스 메소드**

클래스 메소드의 경우 별도로 객체를 생성하지 않고 그대로 사용할 수 있으며, 인스턴스 메소드는 따로 객체를 생성해서 사용해야한다. 하지만, 이번에 공부하고 나면 사실 클래스 메소드가 결과적으로 인스턴스 메소드라는 것을 이해하게 될 것이다.

```ruby
class Test
  puts "In the definition of class Test"
  puts "self = #{self}"
  puts "Class of self = #{self.class}"
end

=> In the definition of class Test
=> self = Test
=> Class of self = Class
```

해당 코드를 보면... self를 출력하고 self.class를 또 출력한다. 실제 해당 코드를 실행하면 self는 Test를 self.class는 Class를 출력한다. 

> “어..?  self 는 Test인데.. Test의 클래스가 Class 라고?”
> 

이 말은 즉, 우리가 생성한 Test라는 클래스는 사실 Class의 객체라는 사실이다. 그렇기 때문에 Test라는 것 자체로도 실행이 가능하다. self를 이용하면 이 Test라는 객체에 어떤 값, 메소드가 있는지도 지정할 수 있다.

```ruby
# self로 Test지정
class Test
  @var = 99
  def self.value_of_var
    @var
  end
end

Test.value_of_var  # => 99
```

```ruby
# self 없이 지정
class Test
  @var = 99
  def value_of_var
    @var
  end
end

Test.value_of_var  # => Method not found
```

이와 같은 코드가 있다고 보면, self를 통해 클래스 메소드를 선언한 것이다. 즉, self를 통해서 Test라는 객체에 value_of_var라는 메소드가 있다고 명시해 준 것이다. 그렇기 때문에 이 경우 Test.new를 통해 새로운 객체를 생성하지 않고 그대로 Test.value_of_var라고 작성할 수 있는 것이다. 

하지만, self를 사용하지 않으면 해당 메소드가 위치하는 Test 아래에 생성되기 때문에 Test 자체 객체에 선언되지 않는다는 것이다. 그렇기 때문에... Test에 해당하는 객체를 생성(new) 해야만 Test 아래에 작성한 메소드들을 쓸 수 있는 것이다. 

여기까지 듣다보면 과연 이게 위에서 든 의문과 무슨 관련이 있는지 알기 힘들 것이다. 한번 내가 이 의문을 풀게 된 논리(?)를 설명해보겠다. 만약 이해가 된다면 다음 색션인 싱글턴으로 넘어가자.

- 의문점

> “해당 코드에서는 Test 클래스 아래에 one, two 메소드가 있는데 그렇다면 self가 가리키는 곳이 t가 아닌 Test 여야 해당 메소드를 찾는 것이 아닌가?”
> 

풀어서 설명해보면, 처음에 self를 “`**현재 위치(객체)**`”라고 소개했다. Test.value_of_var의 경우, self는 Test를 가리킨다. 이때 Test는 Class의 객체이기 때문에 value_of_var에 해당하는 내용이 없다. 이를 코드로 작성하면 다음과 같은 느낌이다.

```ruby
Test = Class.new # self = Test
Test.value_of_var

=> Method not found
```

여기서 self는 Test인데, 해당 Test는 Class의 객체이기 때문에 Class의 구조를 따른다. 하지만, Class에는 value_of_var라는 메소드가 없다. 그렇기 때문에 self(Test)에서 value_of_var라는 메소드를 찾을 수 없다고 뜨는 것이다. class Test 아래 블록에 해당하는 내용은 해당 객체(Test)가 생성하는 객체에 명세되는 내용이라고 생각하면 편할 것 같다.

Test라는 객체에 value_of_var 메소드를 넣고 싶다면.. self.value_of_var를 통해서 Test객체에 해당 메소드 value_of_var는 이런 기능을 가지고 있다고 선언하는 것이다. 하지만 이 경우 Test 객체에 대해서만 선언하는 것이기 때문에 Class의 다른 객체들에게는 영향을 주지 않는다. 

따라서 Test라는 객체 내에 해당 메소드를 위치하여서 Test 클래스 자체 객체에서 호출할 수 있는 메소드를 따로 클래스 메소드라고 부르는 것이지 실제 원리는 인스턴스 메소드와 같다. Test도 결국엔 인스턴스이다...!


**클래스 메소드로 지정하는 것은 무엇이고 인스턴스 메소드로 지정하는 기준이 있을까?**

<br>

개인적으로, 클래스를 통해 어떤 객체가 생성되기 때문에 아래와 같은 예시를 들 수 있다.
    
인간 : 인간은 눈이 두개이다.
사라 : 사라는 눈이 갈색이다.
세라 : 세라는 눈이 검은색이다.

<br>

사라와 세라는 둘다 인간으로 눈을 두개가지고 있다. 하지만, 눈 색과 같이 그 객체 고유의 값이 다를 수 있다. 그렇기 때문에 우리가 원하는 객체의 공통적인 특징의 경우 클래스 메소드로 지정하고, 객체 각각 고유의 특징은 인스턴스 메소드로 구분하는 것이다.

<br>

**요약**

- self 는 “현재 위치(객체)”
- Test 클래스는 Class의 객체
- class Test 아래에 선언한 코드들은 Test객체가 생성한 객체에 대한 구조와 메소드를 선언한 것
- Test객체의 메소드는 Class의 메소드를 가지고 있고, 따로 추가하려면 self를 통해 Test라는 객체에 넣는 방식이 있다.

<br>


## 싱글턴 메소드

싱글턴 메소드는 이름처럼 단순한 메소드를 의미한다. 한번 정해두면 수정되지 않고 꾸준히 사용하게 되는 것이다. 이러한 싱글턴 메소드는 사실 우리도 모르게 자주 사용된다...

```ruby
animal = "cat"
puts animal.upcase

=> CAT
```

<br>

평범하게 위와 같이 코드를 작성한 경우에도 싱글턴 메소드가 사용된다. animal = “cat”이라는 객체를 생성했는데.. 우리가 선언하지 않은 upcase 메소드를 이용해서 CAT이라는 결과를 출력했다..!

<img width="588" alt="Screen Shot 2022-03-21 at 10 15 11 PM" src="https://user-images.githubusercontent.com/47859845/200164418-e05bff1f-1b96-44f2-b1bf-5b32cc5e1e4b.png">


<br>


MBTI가 S라 그런지 그런갑다 하고 넘어가려 했지만, 알고보니 구조가 있는 것이었다. animal에서 cat이라는 객체를 생성한 후, String의 특성을 그대로 물려받는다. 즉, Animal.Cat은 String을 클래스로 받기 때문에 String객체에 있는 Uppercase 메소드를 사용한 것이다. (String도 Object를 상속받는 객체이다.)


<img width="654" alt="Screen Shot 2022-03-21 at 10 20 24 PM" src="https://user-images.githubusercontent.com/47859845/200164438-21b1da3e-9d00-4e8d-ac3e-84eb5dd247ef.png">

이렇게 객체를 선언할 때 익명 클래스를 생성하고 연결하게 되는데, 이를 고유 클래스(eigenclass) 또는 싱글턴 클래스라 한다. 

<br>

```ruby
animal = "cat"
def animal.speak
  puts "The #{self} says miaow"
end

animal.speak
puts animal.upcase

=> The cat says miaow
=> CAT
```

해당 코드도 마찬가지다 def를 통해 speak라는 메소드를 정의하면, 익명 클래스에 해당 메소드를 두고 이를 연결해서 사용하게 된다.

### 익명 클래스... 싱글턴 패턴 파악하기

이전에 설명한 self에 대해서 생각해보면... 아래 코드에서 one 메소드와 two 메소드가 같다는 것을 알 수 있다. 결론적으로 self = Dave이기 때문이다.

```ruby
class Dave
  def self.class_method_one
    puts "Class method one"
  end
  def Dave.class_method_two
    puts "Class method two"
  end
end

Dave.class_method_one
Dave.class_method_two
```

만약 위에서 설명한 인스턴스 메소드, 클래스 메소드에 대해서 이해가 잘 안된다면, 이번 익명 클래스가 어떻게 되는지 살펴보면서 그 차이점을 확인하자.

<br>

우선 클래스 메소드가 위 코드처럼 추가되면.... 아래와 같은 구조를 가진다. self를 설명하면서 class 라는 것도 Class의 객체라는 것을 이야기했다.

<br>

클래스 메소드는 이러한 class 객체에 메소드를 정의한 것으로, Dave.log 등 따로 인스턴스를 생성하지 않고 사용할 수 있다. 이미 class라는 객체에 메소드가 선언 되어있기 때문이다!


<img width="598" alt="Screen Shot 2022-03-21 at 10 30 53 PM" src="https://user-images.githubusercontent.com/47859845/200164519-e4c332df-28c5-43f6-8597-2f50d8f0159b.png">


이때 우리가 추가한 메소드 들은 클래스 메소드로 Anonymous에 속하게 되고, Class의 객체로 수행이 되는 것이다.

<br>

---

## include, extend 믹스인 살펴보기

### include

include는 해당 모듈을 다른 모듈이나 클래스 정의 안에 포함 시킬 수 있다. 그렇기 때문에 include를 한 모듈이나 클래스 선언에서는 해당 모듈에 대한 상수, 클래스 변수, 인스턴스 메서드에 대한 권한을 얻는다. 하지만, 클래스 메서드에 접근은 어렵다. 따라서 include한 경우 대부분 인스턴스 메소드로 활용한다.

아래와 같은 코드가 있을 때, Song이라는 클래스에서 Logger를 include하고 있다. 이 경우 위에서 설명한 것 처럼 Song에서는 Logger에 포함된 인스턴스 메소드에 접근이 가능한 것이다.

```jsx
module Object
  def log(msg)
    STDERR.puts Time.now.strftime("%H:%M:%S: ") + "#{self} (#{msg})"
  end

end

class Song
  include Logger
end

s = Song.new
s.log("created")

# 실행 결과
16:31:37: #<Song:0x008f8d91034898> (created)
```

<br>

그렇다면 이것이 어떻게 가능한 것일까? 

<img width="511" alt="Screen Shot 2022-03-21 at 9 56 18 PM" src="https://user-images.githubusercontent.com/47859845/200164643-b9e60371-380b-4437-8909-bf72c49249ac.png">

<br>

Test Class에서 Object Class의 특정 모듈을 쓰고 싶은 경우 include 동작은 위 그림과 같다. 위 그림과 같이 Test 클래스의 상위 클래스의 익명 클래스(Anonymous class)가 연결되고 해당 클래스에 우리가 원하는 모듈이 메소드로 연결되는 것이다.

즉, 인클루드를 하여서 메소드를 사용할 때, 현재 클래스에서 쓰는 메소드는 사실 상위 클래스의 메소드를 찾아서 쓰는 것과 같다. 이 연결 과정은 간접적으로 프락시 클래스 체인이 추가된 것과 같다고 한다.

### extend

include는 클래스의 상위 클래스로 모듈을 추가하는 방식이기 때문에 클래스 메서드에 접근하기 어렵다. 하지만, extend는 이를 가능하게 한다. 

이 과정을 설명하기에 복잡하지만, 정리하면 다음과 같다.

include를 이용하면 어떤 인스턴스 메서드를 쓰고 싶을 때, 해당 객체를 만든 후 호출하는 형태를 띈다. 예를 들어 아래와 같다...

<br>

```jsx
s = Song.new
s.log("created")
```

이 경우, Song.log 형태 즉, 클래스 메서드 처럼 쓰지 못한다. 하지만, extend의 경우 상위 클래스로 두는 것이 아닌 아래와 같이 클래스가 연결되어 있는 형태를 띈다.



<img width="791" alt="Screen Shot 2022-03-21 at 10 12 50 PM" src="https://user-images.githubusercontent.com/47859845/200164665-c54109ae-0133-4778-bda4-c45e51cd048f.png">


이 경우, 해당 클래스의 객체인 Object 싱글턴 클래스가 정의 되어서 Object.new.log 처럼 쓰일 수 있는데, 이를 다시 Song 클래스에서 가져오기 때문에 현재 클래스에서는 Song.log으로 사용할 수 있는 것이다. 

<br>

즉, 내부적으로 속 뜻은 Object.new.log인데, 해당 Object.new가 Song인 것과 같다. 위의 그림처럼 연결되어서 사용하기 때문이다.

<br>

해당 그림과 같이 어떤 메스드나 객체에 대해 정의하면, 해당하는 객체의 싱글턴 클래스를 만들고 해당 클래스에 모듈을 include해서 해당 객체에 접근을 할 수 있도록 하는 것이다. 


그렇기 때문에 include에서는 인스턴스 메소드만 사용하는 경우가 많고, extend를 사용하면 클래스 메소드를 사용하는 경우가 많다. 


이것이 일반적인 특징이기 때문에 아래와 같이 정리한 글이 많았던 것 같다. 이것에 덧붙이면 괄호의 내용과 같은 것 같다.

- include = 인스턴스 메소드 가져오기 (상속 연결-체인)
- extend = 클래스 메소드 가져오기 (싱글톤 클래스 확장)

<br>

---

## Mixin.. Concern!



위에서 설명한 include, extend 의 경우 각각 인스턴스 메소드, 클래스 메소드를 사용할 수 있다는 장점이 있다. 

하지만, 해당 코드를 작성하다 보면 한 클래스에 대해 include, extend를 동시에 하고 싶을 수 있다. 이 경우 include, extend를 써도 문제는 없지만, 이 경우 인스턴스 메소드 이자 클래스 메소드가 되기 때문에 좋은 방식은 아니다.

<br>

### Concern 사용하기

concern을 사용하면 include, extend를 깔끔하게 해결할 수 있다. 위와 같이 클래스 메소드, 인스턴스 메소드 등을 정리하는 부분이라고 보면된다. 크게 2가지 부분으로 소개하는데 include 블록, 클래스 메소드 블록 으로.. 이 두가지를 이용해 메소드들을 정리 할 수 있다.

```ruby
module TestModule
	extend ActiveSupport::Concern

	included do
		scope :disabled, -> {where(enabled: false)}
	end

	class methods do
		def enable_list
			where(enable: true)
		end
	end
end
```

이렇게 사용하면 included에 넣은 scope, class methods 등을 지정한 것 처럼 사용할 수 있다. 

이렇게 작성한 TestModule을 원하는 클래스에 include해서 사용하면 된다.

```ruby
class RunnigTest
 include TestModule
end
```

개발하는 입장에서 중요한 것은 extend한 모듈을 더 안정적이게 include 할 수 있는 방식이라고 생각하면 쉽다. 

루비에서 메타 프로그래밍이란, 위에서 설명한 self, include, extend 등으로 각각 고유의 객체를 가지고 메타 클래스를 이용해서 프로그래밍하는 기법을 의미한다...!

- 참고 자료
    
    [루비 mixin: include, prepend, extend 그리고 Concern](https://spilist.github.io/2019/01/17/ruby-mixin-concern)

<br>