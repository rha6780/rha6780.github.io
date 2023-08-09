---
title: "[Rails] Mock을 활용해서 테스트코드를 작성하자."
date: 2023-07-17

categories:
  - ruby

---

# Mock과 FakeAPI

테스트를 구성할 때.. 어떤 기능을 테스트 하는지에 따라서 테스트 코드도 달라진다. 또한, 테스트 환경과 실제 코드의 환경 역시 다르기 때문에 제대로 테스트 코드를 작성하는 것이 어려울 수 있다. 다음은 실제로 내가 어려움을 느낀 부분에 대해서 간단히 정리하였다.

<br>

## Mock 활용을 제대로!

  Mock은 테스트를 할 때 실제 값이 아닌 필요한 값만 정의한 일종에 껍데기와 같다. 어떤 객체를 생성하거나, 필요한 데이터를 불러오는데 기존 구성에 따라 필요하지 않은 값까지 작성하는 경우가 있다. Mock을 이용하면 정말 우리가 필요로하는 데이터만 선언해서 쓸 수 있다.

~~특히 결합도(coupling)이 높은 경우 쉽게 테스트를 작성할 수 있다는 장점이 있다.~~

<br>

### Mock의 객체 타입

이러한 Mock에는 여러 타입들이 있는데, 간단히 요약하면 다음과 같다.

<img width="787" alt="mock_object" src="https://github.com/rha6780/Algorithm/assets/47859845/036ba523-559c-4018-803d-169b240284e8">

어떤 데이터를 구성 함에 있어서...

- Stub : 특정 값, 메세지만 리턴하는 경우
- Mock: 실패,성공에 따른 값을 리턴하는 경우
- Null : 항상 self를 리턴하는 경우
- Spy : 모든 메시지를 등록하는 경우
- Fake : 개발용으로 만들어 두고 실제 프로덕션에 적합하지 않는 경우
- Dummy : 전달되지만, 사용되지 않는 경우

<br>

여기서 많이 사용하는 것은 Stub, Mock, Spy으로, 차이점을 제대로 설명하기 어렵다... [조사한 글](https://www.futurelearn.com/info/blog/stubs-mocks-spies-rspec)을 토대로 정리해보았다..! 해당 글에서는 3가지 타입이 결과를 어떻게 확인 하느냐에 따라 나누고 있다.

<br>

### **Stub, Mock, Spy**

Stub : 어떤 값에 대해서 일관성 있게 유지가 되었는 지 확인할 때

Mock : 응답을 받을 때, 두 객체간의 상호작용이 제대로 일어났는지 확인할 때

Spy : 테스트가 끝날 때, 두 객체간의 상호작용이 제대로 일어났는지 확인할 때

여기서 Mock과 Spy의 경계가 모호할 것이다. 두 객체간의 상호작용이 제대로 일어났는지 확인하지만 그 시점이 다를 뿐인데... Spy는 왜 테스트가 끝날 때 검사하는 거지?  응답을 받으면 그 즉시 값을 반환하지 않나? 하지만, 언제나 예외적인 상황이 있다..

<br>

### Mock vs Spy

우리가 특정 요인에 의해서 응답 값을 기대하기 어려운 경우가 있을 수 있다.  참고한 자료에서는 아래와 같이 설명하고 있다.

```text
시나리오 : 여론조사를 통해서 사용자가 특정 요소를 통해서 nudge!라는 메소드를 호출한다는 것을 테스트하고 싶다.
```

이때, instance_double은 allow를 통해 nudge!를 정의하지 않으면, 해당 메세지를 모르기 때문에 정의해야한다.
만약 항상 nudge!가 불린다면, 쉽게 설정이 가능하다. 항상 불리는게 아니라서 필요한 것은 사용자가 호출한 메소드지만, 
실제로 어떤 메소드를 호출할지 모르기 때문에 모든 경우를 다 작성해야한다.

<br>

하지만, Spy를 이용하면... 메소드와 객체가 실행하는 도중에 발생하는 메세지를 모두 기록하기 때문에 해당 요소를
정의하지 않더라도 기댓값을 구할 수 있다.

즉, 기존에는 특정 요소에 따라 호출되는 메소드가 다르기 때문에 각각 allow를 통해 지정하지만, Spy를 이용하면..
전부 기록하기 때문에 각각 지정할 필요가 없다. 메소드가 종료되면, 기록한 메세지를 종합해 검사하는 것이다.


<br>

**Spy를 썼을때와 Mock을 썼을 때 코드 차이**
    
  form의 좋아요, 싫어요, nudge가 있는 FeedBack클래스가 있고, 사용자의 정보를 담는 Paricipant 클래스가 있다. subjects를 통해 상황에 따라 과목이 선택된다.
  
  ```ruby
  class Feedback
    attr_reader :subject, :likes, :dislikes
  
    def initialize(**args)
      @subject = args[:subject] || 'default'
      @likes, @dislikes = 0, 0
      @nudge = nil
    end
  
    def like
      @likes += 1
    end
  
    def dislike
      @dislikes += 1
    end
  
    def nudge!(data)
      @nudge = data
    end
  
    def nudged?
      @nudge
    end
  end
  ```
  <br>

  ```ruby
  RSpec.describe Poll do
    let(:names) { %w(alice adam peter kate) }
    let(:subjects) { %w(math physics history biology) }
    subject { described_class.new(names: names, subjects: subjects) }	
  
    # 중략
  describe 'test instances with expected arguments not known in advance. Spy vs Mock' do
      context 'using spy' do
        context 'when 4 participants and 4 subjects' do
          it 'nudges one feedback' do
            fake_feedback = instance_spy(Feedback)
            allow(Feedback).to receive(:new).and_return(fake_feedback)
            nudge_template = subject.run
            expect(fake_feedback).to have_received(:nudge!).with(nudge_template).once
          end
        end
      end
  
      context 'using mock' do
        context 'when 4 participants and 4 subjects' do
          it 'nudges one feedback' do
            fake_feedback = instance_double(Feedback)
            allow(fake_feedback).to receive(:nudge!)
            allow(fake_feedback).to receive(:nudged?)
            allow(fake_feedback).to receive(:like)
            allow(fake_feedback).to receive(:dislike)
            allow(Feedback).to receive(:new).and_return(fake_feedback)
            nudge_template = subject.run
            expect(fake_feedback).to have_received(:nudge!).with(nudge_template).once
          end
        end
      end
    end
  end
  ```
  
  즉, Mock은 4명의 사용자가 뭘 호출할지 모르기 때문에 모든 경우에 대해서 allow로 전부 정의 하였지만, Spy를 이용하면 내부에 메세지들을 전부 기록해서 찾을 수 있기 때문에 전부 정의할 필요가 없는 것이다.

<br>    

### Mock vs Stub

Stub을 이용하는 경우와 Mock을 이용하는 경우 목적에 따라 조금 다르다. 아래 링크에 더 자세히 설명하고 있기 때문에 한번 확인하는걸 추천한다. 요약만 말하면, **Stub**은 해당 기능의 상태를 확인하는 것에 초점을 둔다. **Mock**은 실제 그 기능이 호출되었는 지, 어떤 과정을 거치는 지에 더 초점을 둔 것이다. 실제로 테스트를 작성할 때 둘 중 아무거나 사용해도 크게 상관은 없지만, 그 의미를 알고 사용해보자.

[[tdd] 상태검증과 행위검증, stub과 mock 차이](https://joont92.github.io/tdd/%EC%83%81%ED%83%9C%EA%B2%80%EC%A6%9D%EA%B3%BC-%ED%96%89%EC%9C%84%EA%B2%80%EC%A6%9D-stub%EA%B3%BC-mock-%EC%B0%A8%EC%9D%B4/)

Spy를 사용하면 많은 메소드 등을 정의하지 않고 작성이 가능하지만, 가능한 Mock으로 명시해주는 것이 나중에 리뷰나, 참고 및 설정할 때 편하지 않을까 생각한다.

<br>

### **Mock을 시작하면서... 묻고 더블(double)로 가!**

Mocking을 하기 위해서는 double이라는 것 부터 짚고 넘어가야한다. double은 일반적으로 float와 같은 자료형이라고 생각할 수 있지만, 여기서 double은 실제 객체를 대신해서 정말 간단하게 호출할 수 있는 객체(Object와 비슷한 것)를 만든다.

해당 타입을 이용해서 예를 들어...

```ruby
# 실제 user라는 객체를 위해, name, password, email ... 
# 등으로 모델이 지정되어서 해당 값들을 필요로 한다.
user = User.create("rha6780", "password", "rha6780@example.com", ...)

# double을 사용하면
user = double
```

이렇게 쓰면 된다. 정말 많이 생략된 것을 볼 수 있다. 하지만, 너무 많이 생략해서 실제 코드에 필요한 경우 구성해줘야 하지 않나? 라고 생각할 수 있다. 이는 다음을 통해서 해결할 수 있다.

<br>

### **Method stub**

메소드 stub은 말그대로 우리가 작성한 double 객체에서 필요한 메소드에 대해서 정의하는 것이다. 만약 아래와 같이 update라는 메소드를 실행 시키면 특정 문제열을 출력하는 메소드 등을 정의 할 수 있다. and_return 뿐만아니라 특정 객체를 return 하는 등 여러 옵션이 있는데 이는 실제로 작성하면 이해를 금방 할 수 있다.

```ruby
allow(user).to receive(:update).and_return("update success!")

user.update
=> "update success!"
```

하지만 이러면 문제 상황이 일어날 수 있다. allow를 통해서 우리가 가상으로 만든 테스트 객체에 메소드를 추가하였는데... 실제 기능과 다르게 동작하거나, 실제 코드의 메소드의 이름과 다른지 등을 체크해주어야 한다. (이런 경우, 실제 코드는 제대로 작동하지 않는데, 성공 된다거나 정상적인 플로우가 아닌 경우가 있을 수 있다.)

<br>

이 경우 double을 사용한 객체에 대해서는 이를 확인하기 어렵지만, instance_double의 경우 실제로 해당 객체에서 메소드를 호출했는지 여부를 알 수 있다. (이중 확인이라고 부른다.)

```ruby
user = instance_double(User)

# 기존 User 클래스에 정의된 메소드에 대해 성공적으로 실행
allow(user).to receive(:update).and_return("update success!")
=> "update success!"

# 기존 User 클래스에 제대로 정의 되지 않은 메소드에 대해 실패
allow(user).to receive(:not_update).and_return("update success!")
=> Error!
```

- double : 선언은 하지만, 실제로 해당 객체를 불렀는 지의 여부를 체크하지 않음
- instance_double : 선언 및 기능, 실제로 해당하는 것을 호출 했는지 체크

- 참고 자료
    
    [How to Improve Ruby Tests Using RSpec Mocks](https://www.netguru.com/blog/ruby-tests-rspec-mocks)
    
    [Stubs, Mocks and Spies in RSpec - FutureLearn](https://www.futurelearn.com/info/blog/stubs-mocks-spies-rspec)
    

---

<br>

## 특정 외부 API 를 호출하는 경우

[참고 자료](https://github.com/bblimke/webmock)

API를 호출하여서 계산하는 어떤 기능이 있다고 하자. 이때 테스트 코드를 작성하면, 해당 API를 테스트하는 동안에 요청하게 된다. 과정 상으로 문제는 없지만, 네트워크, AWS와 같은 외부 서비스의 API를 이용하는 경우에는 비용적인 측면에도 비 효율적일 수 있다.

<br>

이런 경우 API가 호출되는 도메인에 따라서 Fake Api를 대신 호출하는 gem이 있다. 이번에 소개할 gem은 WebMock이다. WebMock은 API 와 같은 HTTP 통신을 Mocking한다. 말그대로 실제로 API를 호출하지 않고, 우리가 예상하는 응답을 받도록 설정하는 것이다.

<br>

기본적으로 사용방법은 아래와 같다.

```ruby
stub_request(:any, "www.example.com")

Net::HTTP.get("www.example.com", "/")    # ===> Success
```

stub_request를 통해 해당 도메인의 요청인 경우 webmock을 사용한다는 것으로 설정한다. (stub_request를 하지 않으면 기존 API를 요청함.) 그리고 실제로 해당 요청을 한다. 실제로 webmock을 하는 경우는 테스트를 하는 경우가 많으니 Rspec을 기준으로 설명하도록 하겠다.

---

<br>

## Rspec 에서 Fake API 설정

우선 일반적으로 아래와 같은 코드를 가진다. WebMock이라는 객체에 해당 요청을 등록하고 리턴 값을 지정한다. 그리고 해당 요청이 일어났을 때 우리가 원하는 값인지 확인하면 끝이다!

```ruby
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Abyss, type: :model do
  describe 'facet', type: :facet do
    before do
      WebMock.enable!
      WebMock.stub_request(:any, "www.example.com").to_return(
        body: "This is a mock",
        status: 200,
        headers: { 'Content-Length' => 7 }
      )
    end
    subject { Sample.new }
    it 'debug' do
      res = subject.send(:get_request, 'http://www.example.com', '')
			expect(res.body).to eq "This is a mock"
    end
  end
end
```

정말.... 간단하다...!

<br>

하지만, 이렇게 테스트에 대해서 각각 설정하는 경우 문제점이 생길 수 있다. 만약, 우리가 개발한 API의 도메인이 바뀐 경우 모든 테스트에 정의된 stub_request를 바꾸어 주어야한다. 그렇기 때문에 실제로는 class를 통해 객체를 만들고 이를 호출하는 형태로 작성한다.

<br>

그렇기 때문에 이를 관리하는 별도의 파일에 이를 작성해둔다. `spec/support/webmock`이라는 파일에 이런식으로 작성한다. 처음에 disable_net_connect은 내부에 설정한 도메인이 아닌 경우 접속을 차단한다. 그리고 RSpec.configure에 우리가 사용할 FakeApi 클래스를 저장해둔다.

```ruby
require 'webmock/rspec'

WebMock.disable_net_connect!(
...
Settings.hera_client.host #또는 그냥 문자열로 'https://example.com'작성가능
)

RSpec.configure do |config|
  config.before :each do
		...
		stub_request(:any, address\.front\.net/).to_rack(FakeClientApi)
	end
end
```

이렇게 한번 지정하면, Spec에서 해당 도메인을 통해서 요청되는 API는 해당 클래스의 속한 응답 값으로 반환한다. 클래스는 단순히 성공했을 때 뿐만 아니라 실패한 경우에 대해서도 url 처리만 제대로 한다면 설정할 수 있다.

```ruby
class FakeClientApi < Sinatra::Base
  get '/manifest.app.json' do
    content_type 'application/json'
    status 200
    {
      'msg' : '성공!',
    }.to_json
  end

  get '/manifest.fail.json' do
    content_type 'application/json'
    status 500
    {}
  end
end
```

사실 여기에 FactoryBot을 사용하는 방법을 정리하려고 했는데, 생각보다 내용이 많을 것 같아서 다음에 정리하겠다.

<br><br>
