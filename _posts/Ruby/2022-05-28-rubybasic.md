---
title: "[Ruby] 기초 문법"
date: 2022-07-16

categories:
  - ruby

---

👍  지속적으로 업데이트 예정

루비는 컴파일 방식이 아닌 인터프리터 방식이다. 파이썬이랑 비슷해서 좋다... 

- **간단 작명 규칙과 블록**
    
    대부분 스네이크 표기법을 따르고  클래스는 파스칼 케이스를 따른다.
    
    블록의 경우 {}와 do-end로 블록을 지정한다.
    

### **변수**

루비는 타입 구분을 하지 않고 작성이 가능하다. 즉, 자바처럼 int a, String s 처럼 예약어를 작성하지 않아도 된다. 물론, 작성할 수 있지만 편의상 많이 생략한다. 또한 다중 대입이 가능하다.

```ruby
one = 1
avg = 3.5
name = "sara"
boy_friend = nil
game = [ "LoL", "Maple story" ]

# 다중 대입
birth_year, birth_month = 1999, "Dec"
```

<br>

**Scope = 선언하기**

코드를 짜다보면 전역변수, 지역 변수, 인스턴스 변수 등 여러 변수를 작성하게 된다. 해당하는 변수들을 어떻게 선언 하는지 살펴보자.

```ruby
# 지역변수는 그냥 작성
var

# 전역변수는 $를 붙여서
$var

# 인스턴스 변수는 @를 붙여서
@var

# 클래스 변수는 @@를 붙여서
@@var
```

여기서 클래스 변수는 반드시 초기화 해야하고, 인스턴스 변수, 전역변수는 초기화하기 전 nil 값을 가진다. 지역변수는 초기화 전 nil 값을 가지지 않기 때문에 조심하자.

<br>

**▪️ 다양한 값을 가지는 변수들(자료형)**

- 숫자형 :  숫자 값을 가지는 변수 [ Integer , Float ]
    
    ```ruby
    num = 1
    num = 3.5
    
    # 또는
    Integer num1 = 1
    Float num2 = 3.5
    ```
    

- 문자형 : 문자열 값을 가지는 변수 [ String ]
    
    ```ruby
    str1 = "string_1"
    str2 = "string_2 #{str1}" #출력: "string_2 string_1"
    
    # 또는
    String str3 = 1 #출력: "1" 
    ```
    
    #{} 를 통해 이미 선언된 변수를 넣을 수 있다. 또한 String을 미리 지정하여 숫자나 다른 값을 넣어도 문자열로 지정되지만, 1 == “1”은 성립하지 않는다.
    

- bool : true, false를 가지는 변수 [ Bool ]
    
    ```ruby
    bool1 = true
    bool2 = false
    
    # 또는
    Bool bool1 = true 
    ```
    

- nil : 값이 없음 [ Nil ]
    
    ```ruby
    var = nil
    ```
    

<br>

**⚠️ nil 주의점**

nil의 경우 값이 없는 경우를 나타내는데 일반적인 컴퓨터 언어에서 0은 false를 의미하지만, 루비에서는 다르다. 0도 값이 있다고 판단하기 때문에 기존에 다른 언어에서 while(0)이라고 작성한 코드를 루비에서는 실행한다.
    

**nil vs empty vs blank**

자료 구조에서 값이 있는지 확인할 때 nil의 경우 nil을 제외한 [],{}, ‘’, ‘ ’, false 등은 전부 값이 있다고 판단한다. nil이외에 값을 판단하는 기준으로 empty와 blank라는 것도 있다. empty는 [], {}, ‘’, ‘ ’에 대해서만 측정하여서 ‘ ’ 값을 제외하고 전부 값이 비어있다고 판단한다. 상수, bool, nil은 판단할 수 없다. blank의 경우, ‘ ’, ‘’, [], {}, nil, false에 대해서 비어있다고 판단한다. empty와 다른점은 bool과 nil, 상수에 대해서 판단할 수 있다는 것이다.

present 는 !blank와 같다.

<br>


### 심볼

심볼은 변경할 수 없는 유일한 객체를 의미한다. 해당 심볼 유일하기 때문에 해시로 표현할 수도 있다.

```ruby
tmp1 = "dog"
tmp1.object_id # 57832957323 아이디가 자동 할당됨

tmp2 = "dog"
tmp2.object_id # 23595023615
```

이때 두 변수는 다른 객체임을 알 수 있다. 하지만 한번 심볼을 적용하면 다음처럼 사용할 수 있다.

```ruby
temp1 = :dog
temp1.object_id # 13857918359

temp2 = :dog
temp2.object_id # 13857918359
```

이처럼 심볼을 이용하면 동일한 값, ID를 가진다. 해당 object_id의 관해 아래 포스트를 참고하면 좋을 것 같다. 요약하면 ID는 포인터와 같다. (ID가 실제 메모리 주소는 아님) 

- 참고 자료 (결론 : 성능을 위해)
    
    [루비에서 object id는 왜 홀수일까?](https://playinlion.tistory.com/10)
    

<br>

### 연산자

다른 언어와 마찬가지로 산술연산(`+, -, **, /, %,***,=`), 논리연산(`!, ~, &&, ||`), 관계연산(`><, ==, <=>, <=, =>, !=, =~, !~`)도 다양하게 제공합니다. 그 외 비트와 관련된 비트연산(`&, |, ^`), 시프트 연산  (`>>, <<`) 등이 있다.

<br>

**크기 비교 `<=>`**

<=> 연산자의 경우 좌항이 크면 1, 같으면 0, 우항이 크면 -1을 반환한다.

```ruby
100 <=> 200 # -1
100 <=> 100 # 0
200 <=> 100 # 1
```

<br>

**배열 집합 연산**

배열 집합 연산으로는 합집합, 교집합, 차집합 연산으로 각각 다음과 같다.

```ruby
arr1 = [ 1, 2, 3, 4 ]
arr2 = [ 2, 4 ]

arr1&arr2 # 교집합 [ 2, 4 ]
arr1|arr2 # 합집합 [ 1, 2, 3, 4 ]
arr1-arr2 # 차집합 [ 1, 3 ]
```

<br>

**증감 연산자가 없다..**

++, — 라는 연산자가 없기 때문에 1증가-감소의 경우 +=1 이나 -=1으로 작성해야한다.

<br>

### 출력하기 및 표현하기

콘솔 등에서 입력을 받을 땐 `gets.chomp`을 이용할 수 있다. chomp가 없으면 엔터까지 입력받는다.

<br>

**print 와 puts**

print와 puts는 둘다 출력하는 기능을 가진다. 하지만, print는 마지막에 개행문자(\n)를 붙이지 않고, puts는 개행문자(\n)를 붙인다.

<br>

**#{}으로 문자열 안에 변수 값 넣기**

`#{}`를 이용해 특정 변수값을 문자열에 담을 수 있습니다.

```ruby
str1 = "text_1"
str2 = "str1 : #{str1}"  # 출력 : "str1 : text_1"
```

<br>

**%를 이용해 다양한 표현하기**

```ruby
value = 100

%q("score #{value}\d") # ()괄호안 내용을 모두 문자열로
# 출력: str #{value}\d

%Q("score #{value}\d") # ()특수문자, 변수 대입 이외 모든 것을 문자열로
# 출력: str 100 \d

%w(dog cat lion) # 배열로 변환
# 출력: ["dog", "cat", "lion"]

%r(정규식) # 정규식으로 변환
%s(#{animal}) # 심볼로 변환
%i(dog cat, lion) # 심볼 배열 [:dog, :cat, :lion]으로 변환

```

<br>

**.. 과 ... 을 이용해 범위 표현하기**

..과 ...은 `≤`와 `<`를 간단히 표현하기 위한 표시입니다. 주로 특정 범위에 속하는 지 확인하기 위해서 많이 사용하게 됩니다. 아래와 같이 사용합니다.

```ruby
0..10  # 0~10 으로 0<= i <=10에 해당하는 범위를 나타냅니다.

0...10 # 0~9 로 0<= i <10에 해당하는 범위를 나타냅니다.
```

<br>

### 조건문

이제 한번 조건문에 대해서 알아보자. 우선 다른 언어들 처럼 `? true:false` 가 가능하다.

```ruby
age = 24
puts age == 25 ? "반오십":"반오십 아님"

# 출력
=> 반오십 아님
```

<br>

**if 와 else**

if 조건문은 다른 언어처럼 해당 조건문에 해당하는 값이 true라면 수행하는 문장이다. 조건의 값은 boolean 값이어야 한다. else를 사용해서 해당 조건이 아닐 때 수행시킬 코드를 작성할 수 있다.

```ruby
# "수행!"을 출력한다.
if true
	puts "수행!"
end

=> "수행!"

# 한줄 코드
puts "수행" if true
```

```ruby
if false
	puts "수행"
else
	puts "조건이 맞지 않습니다."
end

=> "조건이 맞지 않습니다."

```

만약에 if else이외에 몇가지 조건이 더 있다면 elsif를 사용할 수 있다.

<br>

**if 와 elsif 와 else**

```ruby
if false
	puts "수행"
elsif true
	puts "elsif 수행"
else
	puts "조건이 맞지 않습니다."
end

=> "elsif 수행"
```

<br>

**unless**

unless 는 if 문의 반대의 의미로 조건문이 false인 경우에 출력된다. if에 not을 붙이는것 보다 unless 라는 연산자를 새로 만드는 것이 좋은 거라고 생각한 것 같다.

```ruby
unless true
	puts "true"
end

# 또는
puts "true" unless true

=>
```

```ruby
unless false
	puts "not false"
end

# 또는
puts "not false" unless false

=> "not false"
```

<br>

**Case, When**

switch 문 처럼 한 값에 대해 여러 분기를 나눌때 유용하다.

```ruby
def main
	today = "Mon"
	case today
	when "Mon"
		puts "월요일 좋아~!"
	when "Tue"
		puts "불 화요일..."
	when "Wen"
		puts "수요일 급식이 맛있었는데.."
	when "Thr"
		puts "목목하네"
	when "Fri"
		puts "불금!"
	else
		puts "허용되지 않은 데이터"
	end
end
```

<br>

### 반복문

0~9까지 수를 출력하는 간단한 코드를 짠다고 생각해보자 우리는 다양한 반복문을 이용해서 이를 수행할 수 있다.

1. **for 이용하기**
    
    증감식 대신 범위에 해당하는 값을 수행하는 반복문입니다. 아래 코드 작성시 별도의 return이 없으면 return 0..9를 하게 된다. 다른 코드들은 return nil.
    
    ```ruby
    def main
    	for num in 0..9
    		puts num
    	end
    end
    ```
    
2. **while 이용하기**
    
    ```ruby
    def main
    	i = 0
    	while i < 10 do
    		puts i
    		i += 1
    	end
    end
    ```
    

1. **until 이용하기**
    
    until은 조건문이 false일때 수행되는 반복문이다. 
    
    ```ruby
    # i!=10 라면 수행
    def main
    	i = 0
    	until i == 10 do
    		puts i
    		i += 1
    	end
    end
    ```
    

1. **loop 이용하기(break가 없다면 무한 루프)**
    
    ```ruby
    def main
    	i = 0
    	loop do
    		puts i
    		i+= 1
    		break if i >= 10
    	end
    end
    ```
    

1. **times 사용하기**
    
    반복할 횟수를 정해두면 해당 횟수만큼 지정한 코드를 수행한다. 별도로 return 하지 않으면 10이 리턴
    
    ```ruby
    def main
    	i = 0
    	10.times do
    		puts i
    		i+=1
    	end
    return nil
    end
    ```
    
2. **each 사용하기**
each를 사용하면 해시, 배열등의 각 요소에 대해서 순서대로 반복문을 진행한다. 이때 |animal| 에 해당하는 값은 배열에서 가져온 값을 의미하고 반복문 안에서 쓰인다.
    
    ```ruby
    # 배열
    def main
    	animals = ["dog", "cat", "lion"]
    	animals.each do |animal|
    		puts animal
    	end
    end
    
    # 출력
    => dog
    => cat
    => lion 
    ```
    
    ```ruby
    # 해시
    def main
    	scores = {"korean"=>100, "math"=>85}
    	scores.each {| key, value | puts "#{key} : #{value}"}
    end
    
    # 출력
    => korean : 100
    => math : 85
    ```
    

<br>

**반복문 제어**

break : loop 문에서 보았듯이 특정 조건에서 반복문을 탈출하는 문장이다.

next : 현재 조건에서 실행은 중지하지만, 이후 반복을 진행하게 하는 문장이다. break와 다르게 해당 조건을 만족하는 경우에만 실행하지 않는다.

<br>

### 클래스, 메소드 선언하기

**메소드**

어떤 값을 리턴 할지 따로 작성하지 않아도 됩니다. 메소드 이름에 ?,!,=를 작성할 수 있고 해당 특수문자는 각각 다음과 같은 의미를 가진다. 특수문자들은 실제 코드에 영향을 주지않고 어떤 기능을 하는지 알려주는 표현이다. 또한 호출 시 따로 괄호를 적지 않아도 수행된다.

```ruby
def fuction(var)
	puts var
end

function 1 # 출력: "1", 수행됨

fuction? # ture or false를 반환
fuction! # 호출 후 값이 변한다.
fuction= # 내부값을 직접 변경할 수 있다.
```

**클래스**

클래스에서 선언된 인스턴스 변수는 클래스 내에서 사용가능하다. Animal 클래스도 상위 Class의 객체이기 인스턴스 변수로 선언할 수 있는 것이다. 이것에 대해서 슬렉 질문을 보고 적게되었다.

```ruby
class Animal 
	attr_reader :var1
	@var1 #클래스 인스턴스 변수
	def function
		@@var2 # 클래스 변수
		@var3 # function 인스턴스 변수
	end
	def var1
		return @var1
	end
	...
end
```

```ruby
class Cat
	attr_reader :var1
	@var1 = "러시안 블루"
	def cat
		puts @var1
		puts "cute cat!"
	end
end

def main()
	my_cat = Cat.new
	my_cat.cat
end
```
var2는 Animal 클래스 내부 어디서든 사용할 수 있다. 다만, var1은 클래스 내부 메소드 등에서는 접근을 못하고 해당 클래스에서만 사용가능하다. 따라서 클래스 인스턴스 변수 클래스나 해당 메소드 안에서만 사용할때 지정. 외부에 필요한 경우에는 심볼로 지정해야한다.


기본적으로 클래스 내부 메소드들은 public 하지만, 상황에 따라 바꾸기 위해서 아래처럼 가능하다.

```ruby
public
	def func1
	...	
	end
private
	def func2
	...
	end
protected
	def func3
	...
	end 
```

```ruby
	...	

	def func2
	...
	end

	def func3
	...
	end 

private :func2
protected :func3
```

<br>

### 상속

<를 이용해서 상속받을 수 있다. 그리고 상속을 받았는지 확인하기 위해 is_a 관계를 확인 할 수 있다. is_a 외에 kind_of도 있는데, kind_of와 is_a 는 명칭만 다르지 기능은 똑같다고 한다. 

`obj.is_a / kind_of (class)` : class가 obj의 클래스인 경우, 혹은 superclass 거나 obj에 포함된 경우 true, false 반환

```ruby
class Cat < Animal:
	def eat
	...
	end
end

Cat.is_a? Animal # true
Cat.superclass # Animal
eat.is_a? Cat # true
```

인스턴스에 대해서 instance_of를 사용할 수도 있다.

<br>

### 자료 구조

**배열 [ Array ]**
    
배열은 순서가 보장되기 때문에 push, pop을 통해 스택처럼 이용할 수도 있다.

```ruby
var = ["A", "B", "C"]
var[1] = "D" # 대입 가능
```
    

**해시 [ Hash ]**
    
= > 를 이용해서 키에대한 값을 지정한다. 이후 대입이 가능하다.

```ruby
var = {"A"=>1, "B"=>3}
var[A] = 2 # 대입 가능
```

<br>

## 해시 더 살펴보기

해시를 이용하다 보면 key-value를 배열로 변환하거나, 해당 내용중 몇가지를 꺼내고 싶을 때가 있다. 이에 대해서 몇가지를 살펴보도록 하자.

먼저, key-value를 각각 가져오는 상황에는 아래와 같이 사용할 수 있다.

```jsx
# hash라는 값이 있을 때...
hash = { id: 1 , name: "Sara" }

# 1.each do
hash.each do |key, value| { puts "#{key} - #{value}"}

# 2.each
hash.each { |key, value| puts "#{key} - #{value}"}

# 3.each_pair
hash.each_pair { |key, value| puts "#{key} - #{value}"}
```

이 3가지는 모두 같은 key-value 값을 도출한다. 이 외에 다양한 방법으로 활용할 수 있다.
```ruby
#key 값들을 가져올 때
hash.keys
hash.each_key {|key| “#{key}”}


#value 값들을 가져올 때
hash.each_value {|value| puts “#{value}”}


#단일 값을 가져올 때:
hash.fetch(key) # key가 가진 value를 리턴
hash.fetch_values(key, key2) # 각 키가 가진 value를 배열로 리턴


#해시를 결합할 때
hash.merge(hash2)
```

<br><br>