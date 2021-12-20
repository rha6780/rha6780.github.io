---
title: "AOS와 IOS의 생명주기"
date: 2021-12-20

categories:
  - appbasic
tags:
  - appbasic
---

# 생명주기

안드로이드 공식 설명 : [https://developer.android.com/guide/components/activities/activity-lifecycle](https://developer.android.com/guide/components/activities/activity-lifecycle)

> 사실 이전 인턴기간 때 정리한 내용인데, 자주 까먹어서 블로그에 게시한다!


### 서론

애플리케이션을 접하면 애플리캐이션은 사용자의 행동에 따라서 작동한다. 예를 들면, 앱을 나가고, 탐색하고 등의 다양한 상태로 전환된다.


이러한 상태 전환은 앱의 Activity 인스턴스의 생명주기(생존주기 또는 수명주기) 안에서 작동된다. 따라서 사용자에게 유용한 서비스를 제공하기 앞서서 이 주기를 파악하고 상태를 파악하는게 중요하다.


"생명주기와 상태가 무슨 관계인가?" 라는 의문을 가질수 있다. 생명주기는 주로 아래 4가지 문제에서 중요한 역할을 가진다.


1. 사용자가 앱을 사용하는 도중 전화나 다른 앱으로 전환될 때 비정상 종료 문제
2. 사용자가 앱을 활발하게 사용하지 않아서 리소스가 소비되는 문제 
3. 사용자가 앱을 나갔다가 다시 들어왔을 때 정보나 진행상태가 저장되지 않는 문제
4. 화면이 세로모드, 가로 모드로 회전하는 경우 비정상 종료되거나 진행상태가 저장되지 않는 경우. 



위 4가지 문제 이외에도 생명주기가 문제가 되는 경우가 많이 있다. 생명주기, 즉 리소스-인스턴스의 수명은 앱을 효율적으로 구성하기 위해 꼭 필요한 개념이다.



즉, 상태에 따라서 비정상 종료, 리소스 낭비, 진행상태 저장 X 등 생명주기에 따라 영향을 받는다. 이는 앱을 설계하고 개발하는 입장에서 가장 방지해야하는 상황이다. (= 무한 로딩 또는 앱이 죽음.)


이러한 상황을 방지하기 위해서 생존주기의 개념과 각 상태를 알아보자.



### AOS 기준-생명 주기 (활동 수명 주기)

![image](https://user-images.githubusercontent.com/47859845/146782474-a5cab97b-b6ba-4bf3-9782-0cd8fe31b7e3.png)

→ 출처 : [https://developer.android.com/guide/components/activities/activity-lifecycle](https://developer.android.com/guide/components/activities/activity-lifecycle)

생존 주기는 6개의 회색 박스로 이루어지고, 각 상태를 넘어가는 순서는 위와 같다. 사용자가 이러한 Activity (활동)을 나갈때 이를 해체하는 과정을 거칩니다. ~~경우에 따라서 부분적으로 해체한다.~~ 이때 활동은 여전히 메모리에 남아있어서 잠시 나갔다 와도 진행상태가 보존된다.

 // 몇가지 경우를 제외하고 백그라운드로 실행되는 도중에 활동을 실행할 수 없다. : 백그라운드에 있다고 판정되면 상태가 변하지 않는다.?

이러한 생존주기는 상태에 따라 언제 종료할지, 메모리를 초기화 할지 등을 설정할 수 있고, 모든 상태에 대해서 구현할 필요가 없습니다. 중요한 것은 이러한 상태에 대해서 앱이 정상적으로 동작할 수 있도록 구현하는 것이다. 어떻게 구현할까 ..?

이런 다양한 상태들을 안드로이드에서는 콜백 메서드로 제공하고 있다. 상태는 다음과 같다.

onCreate(), onStart(), onResume(), onPause(), onStop(), onDestroy()      //~~onRestart()는...?~~

일부 메소드는 이미 활동주기를 포함하는 경우도 있다. (setContentView..) 하지만 종속적인 수명주기를 구현하기위해서는 수명주기를 각각 설정해주어야 한다.

---

### IOS 기준 - 생명주기 (활동 수명 주기)

IOS는 안드로이드와 달리 제스쳐가 기본적으로 구현되어있다. (AOS는 직접 구현해야한다.) 그렇기 때문에 화면 전환이 자유로운데, 이 화면 전환에 따라 생명주기 역시 영향이 가게 된다.

화면이 왔다갔다하면 생명주기 달라진다 = 화면에 대한 생명주기 + 앱에 대한 생명주기 + 컨트롤러에 대한 생명주기

- 앱에 대한 생명주기 (App lifecycle)
    
    앱에 관한 생명주기는 5개로 구분될 수 있다. 이 생명주기도 IOS 버전에 따라서 조금씩 달라진다. (버전 13 전후..)
    
    12까지 동작 과정
    
    Not Running, Inactive, Active, Background, Suspened로 일단 나눈다.
    
    ```swift
    Not Running : 실행되지 않는 상태
    Inactive : 실행되는 상태 + 이벤트가 없는 상태
    Active : 실행되는 상태 + 이벤트가 발생한 상태
    Background : 보이지는 않지만 실행되고 있는 상태
    Suspened : background상태이지만 아무 기능도 작동하지 않는 상태 -> 시스템에서 background 상태
    를 확인해서 suspend로 전환한다.
    
    ```
    
    백그라운드 상태에서는 최소한의 메모리 공간을 사용하게 되고, foreground(화면에 비쳐지는 작업)보다 자원할당에서 우선순위가 낮다. 즉, foreground인 Active, Inactive 상태가 자원할당에 있어서 메모리 등 우선순위를 가지고, 메모리 부족에 경우 우선순위가 낮은 background 리소스를 해제하거나 종료하는 등의 구조를 가진다.
    


![image](https://user-images.githubusercontent.com/47859845/146782609-a4c7a605-7cf9-42c3-aff3-9616fa238d4d.png)

해당 앱의 생명주기는 위와 같은 순서로 변화가 된다.

실제로 foreground 상태에서 앱이 중단되면 백그라운드로 잠시 이동하게 된다.

이러한 과정이 실제로 코드에서는 delegate 함수들을 통해 다음과 같이 매칭이 되어서 실행이 된다.

```swift
13버전 이전
// 앱이 처음 시작될 때 실행
application(_:didFinishLaunching:) 

// 앱이 active 에서 inactive로 이동될 때 실행
applicationWillResignActive:   

// 앱이 background 상태일 때 실행 
applicationDidEnterBackground:

// 앱이 background에서 foreground로 이동 될 때 실행
// (아직 foreground에서 실행중이진 않음)
applicationWillEnterForeground:

// 앱이 active상태가 되어 실행 중일 때
applicationDidBecomeActive:

// 앱이 종료될 때 실행
applicationWillTerminate:
```

```swift
13버전 이후
//scene이 처음시작될 때
scene(_:sillConnectTo: options:)

//scene의 연결이 해제될 때 호출
sceneDidDisConnect(_:)

//scene이 background로 진입
sceneDidBackground(_:)

//scene이 foreground로 진입
sceneWillEnterForeground(_:)

//scene과의 상호작용을 시작할 때 호출
sceneDidBecomeActive(_:)

//사용자가 scene과의 상호작용을 중지할 때 호출
sceneWillResignActive(_:)
```

- 버전13이랑 이전 것들이 어떤게 동일하고 차이가 있는 지 확인
    
    13 버전 이전과 13 버전의 큰 차이는 window 개념이 Scene으로 변화한 것이다. window와 달리 Scene은 같은 앱을 여러 창으로 실행이 가능하고,  각 앱에 대해서 여러 Scene을 만들 수 있고 각각 다른 상태에 있거나, 별도로 숨기는 등으로 활용할 수 있다. 이 기능을 사용해도 되고, 사용하지 않더라도 상관없다.
    
    13버전 이전에는 AppDelegate를 이용해서 구성하게 된다. AppDelegate는 하나의 프로세스와 하나의 UI를 사용하기 때문에 여러개의 세션이나 화면이 되기 어렵다. 따라서 13버전이후로는 SceneDelegate로 여러개의 화면이나 세션 생성이 가능해진다.
    
    AppDelegate에는 해당 애플리케이션이 실행된 직후, 최초 실행 시, 백그라운드 상태로 전환된 직후 호출 등을 구현할 수 있는 func을 가지고 있다.
    
    SceneDelegate 역시 세션이나 다른 기능에 대한 func을 가지고 있기 때문에 세부적인 관리를 필요로 할때 더 주의깊게 보아야한다.
    

- 뷰 컨트롤러에 대한 생명주기 (View Controller lifecycle)
    
    뷰 컨트롤러에 대한 생명주기는 생성부터 뷰 컨트롤러가 종료되는 시점까지 있다. ( 종료란 메모리에서 내려가는 순간 )
    
    ```swift
    LoadView : 뷰 컨트롤러를 생성하기 위해 메모리에 올리는 과정 (한번만 수행됨.)
    ViewDidLoad : 컨트롤러가 메모리에 올라가고 호출. 뷰가 생성됨. (한번만 수행됨)
    ViewWillAppear : 뷰가 화면에서 보여질때 호출.
    ViewDidAppear : 뷰가 화면에 보여진 후에 호출.
    ViewWillDisappear : 뷰가 화면에서 사라질때 호출. 주로 사용자 데이터를 저장하고 네트워크 작업을 취소하는 부분,
    ViewDidDisappear : 뷰가 사리지고 난 후 호출.
    ```
    
    해당 생명주기의 Will은 보여지거나 사라지기 직전에 수행되는데, will이 있는 이유는 그전에 준비하거나 취소해야할 사항 들을 미리 수행하는 부분을 담당한다.
    
    Did의 경우는 해당 작업을 수행한 후에 일어나는 부분을 담당하게 된다.
    
    ---
    
    이후 loadView() 를 통해서 화면에 띄울 view를 메모리로 올리게 된다. (이때 view로 올리는 값은 설정된 값이 아니고 메모리로 올라감.) 이 메소드는 직접 호출하면 안되기 때문에 초기화를 하거나 그렇게 하기 위해서는 viewDidLoad를 이용해서 해야한다. (직접호출 : self.loadView()는 안되지만, super.loadView() 라던지 오버라이드는 가능하다.) 
    
    viewDidLoad()를 통해서 view가 메모리로 올라간 이후 시스템에 의해 자동으로 호출이 되는 것으로 올려진 view의 리소스를 초기화하거나 초기 화면을 설정한다. 처음 한번만 초기화가 필요한 상황 등에서 유용하게 쓰일 수 있다.
    
    viewWillAppear : view가 화면에 나타나기 직전에 호출이 된다. 
    
    viewDidAppear : 뷰가 보여질 때 호출되는 메소드
    
    viewDidDisappear : 뷰가 사라질 때 호출되는 메소드 
    
    viewDidUnload 뷰에 해당하는 메모리를 전부 내리는 작업 후 일어나는 메소드로 메모리에서 내려간다는 것은 해당 뷰를 구성하는 것이 메모리에 없다는 것으로 다시 메모리에 올려야만 뷰가 보여질 수 있다.
    
    view가 많을 수록 view가 차지하는 메모리 역시 차지하게 된다. 이 경우 메모리가 모자랄 수 있기 때문에 메모리를 해제 할 수 있는 것을 찾아서 해제하는 과정을 거치게 되는데, 이 경우 viewUnload 과정을didReceiveMemoryWarning()  에서 대신 수행하게 된다. (뷰가 뷰 계층에 없는 지 확인이 필요.)
    

- 어떤 과정인지 ?
    
   
    ![image](https://user-images.githubusercontent.com/47859845/146782694-164300e2-1595-4fb4-bf39-26f40814fb5b.png)
    
    사용자가 이벤트를 일으키면 OS에서 해당 이벤트받고, 큐에 저장한다. 앱은 큐에 지정된 이벤트들을 차례대로 수행하고, 이에 관련한 객체에서 지정한 코드를 수행하게 된다.
    
    이벤트에 대해서 바로바로 적용되는 게 아니고, 이런 과정을 가진다. 큐에 여러가지 일들이 있는데 특정 이벤트에 대해서 오래걸리다가 실행되고, 이후에 다른 이벤트들이 순식간에 처리가 될 수도 있다.
    

- 화면 전환

    1. 프레젠테이션
    
        : 기존 화면이 실행되는 도중에 다른 화면을 위로 보여주는 상황
    
        몇개가 되었든 기존 아래에 화면들은 실행이 되고 있는 상태 기존 아래 
    
        아래에 화면을 덮는 상황.
    
        즉, 다른 화면들은 종료되지 않은 채 계속해서 살아있는 상태

    
    2. 내비게이션
    
        : 기존 화면 위에 다른 화면을 스택 형식으로 쌓아서 보여주는 상황
    
        아래에 화면을 덮는 상황으로 스택을 기본적으로 사용하는 방식
    
        즉, 다른 화면들은 종료되지 않은 채 계속해서 살아있는 상태 but dissmiss로는 종료가 안되고, 스택에서 pop 해야한다.
    
        이전화면으로 돌아갈 시에 최상위에 있는 화면이 종료되고 실행되고 있는 아래에 화면이 나타남.

    
    3. 세그웨이 

        세그웨이의 경우 각 화면에 따른 컨트롤러를 연결하는 방식으로 다른 화면으로 넘어가면 기존 화면은 종료되는 형식이다.
    
    
        ![image](https://user-images.githubusercontent.com/47859845/146782773-4776585e-c172-4fd6-88df-fd48a51a42e0.png)
    

- 프레젠테이션 방식 와 내비게이션 방식 차이에서
    
    ⇒ 이전의 화면의 뷰 컨트롤러가 어떤 생명주기를 타는지
    
    A화면과 B화면이 있고, A화면에 버튼을 눌러서 B화면으로 갈 때 A화면의 생명주기 변화는?
    
    앱 실행 후 A화면이 첫 화면으로 나온다고 가정.
    

▶️ 프레젠테이션 방식

A viewDidLoad()

A viewWillAppear()

A viewDidAppear()

버튼을 누름

B viewWillAppear()

B viewDidAppear()

▶️ 내비게이션 방식

A viewDidLoad()

A viewWillAppear()

A viewDidAppear()

버튼을 누름

A viewWillDisappear()

B viewWillAppear()

A viewDidDisappear()

B viewDidAppear()

프레젠테이션 방식은 기존 화면에 대해서 Disappear 하지 않고 다음 화면을 보여주는 반면에 내비게이션 방식은 기존 화면을 사라지게 하고, 다음화면을 보여주는 형식이다. 따라서 프레젠테이션 방식은 기존 사용자가 입력한 데이터나 그런것을 다음 화면이 보여지고 있는 와중에도 붙잡고 있기 때문에 이 데이터가 모델에 반영이 안되는 등이 일어날 수 있다.



**프레젠테이션 방식을 써야할 때**

 그냥 단순한 팝업이나, 잠시 동안만 보여지는 화면으로 전환하는 경우에는 프레젠테이션 방식으로 시간을 절약할 수 있을 것 같다.



**내비게이션 방식을 써야할 때**

주기적으로 데이터가 바뀌거나, 사용자가 입력한 데이터를 저장하는 과정에 있어서는 내비게이션 방식이 더 좋아보인다.