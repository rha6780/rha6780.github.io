---
title: "PEP8과 pre-commit에 black,flake8 적용"
date: 2022-01-09

categories:
  - django
tags:
  - django
---

### PEP8에 대해서

<br>

PEP 8은 파이썬 코드를 구성할 때의 규칙이다

물론 이 규칙을 따르지 않더라도 코드는 돌아가지만 가시성과 협업을 위한 약속들로, 파이썬 코드에서 이 방식을 제안하고 있다.

<details>
<summary>인덴테이션</summary>
<div markdown="1">
    인덴테이션은 코드 실행에도 중요한 역할을 하지만, 변수 구분, 코드 블록 등을 인지하기 위해서 적절히 사용되어야 한다.
    
    ```python
    # 변수가 많을 때 -> 변수 위치를 맞춰어서 읽기 편하도록 한다.
    foo = long_function_name(var_one, var_two,
                             var_three, var_four)
    
    # 수행문과 구분하기 위해 공백 4개를 추가해 구분한다.
    def long_function_name(
            var_one, var_two, var_three,
            var_four):
        인쇄(var_one)
    
    # 또는 아래와 같이 변수들을 정렬할 수도 있다.
    foo = long_function_name(
        var_one, var_two,
        var_three, var_four)
    
    # 연산자를 앞으로 오게 정렬한다.
    income = (gross_wages
              + taxable_interest
              + (dividends - qualified_dividends)
              - ira_deduction
              - student_loan_interest)
    ```

</div>
</details>

<br>

<details>
<summary>import</summary>
<div markdown="1">
    특히 내 코드는 import 에 대해서 조금 무신경하게 작성 했기 때문에 리뷰를 잘 참고하여 아래 사항을 습관화 시키도록 하자. 
    
    ( 경로가 비슷한 경우 = 비슷한 기능의 파일을 모아둔 디렉토리 이기때문에 근접하게 그룹화 시키는 게 좋다. 그룹화 기준은 빈 줄이다.)
    
    Imports should be grouped in the following order:
    
    1. Standard library imports.
    2. Related third party imports.
    3. Local application/library specific imports.You should put a blank line between each group of imports.
    
    각각의 경우 빈줄로 나누어 준다.

</div>
</details>

<br>

<details>
<summary>공백</summary>
<div markdown="1">
    - ham[1] 등의 배열 및 튜플 등은 ham[ 1 ]과 같이 공백을 포함하지 않아야 한다. `ham[1:3]`도 마찬가지. `ham[lower::step]`
    - , 가 있는 x, y, 등의 상황도 x , 과 같이 쓰이지 말아야 한다.
    - `i = i + 1` 와 같이 수식 코드는 띄어쓰기로 구분해준다.
    - 함수도 `def munge() -> PosInt:` 와 같이 → 뒤에 공백이 있어야 한다.
    - `b = math` 같은 기호는 = 기호 앞뒤로 공백이 없어야 한다. (위의 수식 연산과 다름 같다는 의미라면 공백필요.)
    - 조건문, 반복문 다음줄에 실행문을 넣자.
    - 비슷한 의미를 가지는 코드끼리 근접하게 두고, 빈줄을 사용해 다른 코드와 분리 시키자.
    - 불필요한 공백은 최대한 지우자.
</div>
</details>

<br>

<details>
<summary>명명 규칙</summary>
<div markdown="1">
    - 모듈 : 소문자로된 짧은 문장/단어
    - 클래스, 타입 변수 : 카멜케이스
    - 에러  : Error를 시작으로 하는 단어 (ex: ErrorGetMessage)
    - 함수, 변수 : 소문자 _ 혼용(ex: pub_date)
    - 메소드 인자 : self 는 필수, 인자 뒤에 _ 단일 후행 추가 (ex: class_)
    - 상수 : 대문자+_ (ex: MAX_)
    - 클래스나 객체 내의 보호 속성을 정의할 때에는 첫글자를 밑줄 부터 시작한다.(보호속성 : 클래스 내에서만 사용할 객체)
    - 예약어와 같은 이름의 변수이름을 사용하려면 예약어 뒤에 밑줄을 붙인다.
    - 클래스나 객체의 비공개 속성은 외부에서 직접 접근할 수 없게 이름을 변경하는 구조인 맹글링 처리방식이다. 이때 이름 앞에 __(_ 두개)를 붙이면 자동으로 클래스 이름이 붙는다.
        
        ex) _var = 1    __var1 = 2
        
        tc._var=1   tc.__var1 = 정의 안됨.(외부에서 사용 불가)
        
    - 파이썬 내부에서만 사용되는 스폐셜 속성이나 메소드는 이름 양쪽에 _를 붙여 사용한다.
</div>
</details>

<br>

<details>
<summary>프로그래밍 습관</summary>
<div markdown="1">
    ```python
    if not foo is None: # 좋지 않음
    if foo is not None: # 좋음
    
    # 예외 상황은 언제나 exception과 함께
    try:
        import platform_specific_module
    except ImportError:
        platform_specific_module = None
    
    code: int # : 다음 공백이 있는게 좋다.
    
    code : int (x) # : 앞에 공백은 없어야 한다.
    ```

</div>
</details> 

등등 공식 홈페이지에 자세히 나와있다.

링크 → [공식 홈페이지](https://www.notion.so/prgrms/PEP8-95f9932aa4ba48949c581c10fb32806f#d3c017e546cf4642a0a5cd2dd34ce310)

<br>

PEP8을 정리하는 이유 중 하나는 협업에 있어서 코드를 정해진 규칙에 따라서 적는 것은 아주 중요하다는 것을 말하고 싶기 때문이다.

<br>


혼자하는 프로젝트라면, 변수 이름이나 공백 등을 굳이 맞출 이유가 없지만 다른 팀원들과 공유하기 위해서는 간결하고 보기 쉽게 PEP8을 맞추면서 이를 따를 필요가 있다.

<br>

---

<br>

**그렇다면 PEP8을 지키면서 코드를 쉽게 작성할 수 있을까?**

<br>

이에 관한 문제를 black, flake8을 이용해 해결할 수 있다.


black과 flake8은 쉽게 말해 코드가 PEP8을 잘 따랐는지 확인하는 패키지이다. 이를 적용하면 우리가 작성한 코드 중 고쳐야 하는 부분을 알려주는데....

<br>

> "잠깐... 그럼 우리가 일일히 black이랑 flake8을 돌려야 하나..? 귀찮은데.."

<br>

물론, 일일히 돌리는 것은 매우 귀찮다. 그렇기 때문에 협업 프로세스에서 우리가 원하는 시점에 검사만 하면 얼마나 좋을까..?!

<br>

이를 도와주는 것이 pre-commit 이다.

pre-commit은 말 그대로 commit 하기 전으로, black과 flake8을 pre-commit에 설정해두면 커밋 전에 코드를 검사하고 알려준다.


<br>

본격적으로 한번 pre-commit 구성과 black, flake8을 적용하자.

우선, brew, pip install 을 통해 pre-commit, black, flake8을 받아두자. 가상환경이 있다면 터미널에서 명령어를 사용해 해당 가상환경에서 pre-commit, black, flacke8(선택사항)을 다운하자.

<br>
아래는 pipenv를 기준으로 작성하였다.

``` python
pipenv install pre-commit
pipenv install black

pre-commmit install # pre-commit 준비 완료
pre-commmit uninstall # pre-commit 끔
```

<br><br>

일단 pre-commit을 끄고, 아래 2가지 파일이 필요하다. .pre-commit-config.yaml 과 pyproject.toml 인데, pyproject.toml은 글자 수 제한이나 검사 제외할 파일을 지정하지 않는다면 필요없다.

<br>

가장 중요한 것은 .pre-commit-config.yaml이다. 아래와 같이 지정해두면, python 3.10을 기준으로 black과 flack8을 사용하게 된다.



<br>



``` yaml
# .pre-commit-config.yaml

repos:
  - repo: https://github.com/ambv/black
    rev: stable
    hooks:
      - id: black
        language_version: python3.10
  - repo: https://gitlab.com/pycqa/flake8
    rev: 3.7.9
    hooks:
      - id: flake8

```

``` toml
# pyproject.toml
[tool.black]
line-length = 119
include = '\.pyi?$'
exclude = '''
/(
    \.git
  | \.venv
  | \.github
  | README.md
  | Pipfile
  | Pipfile.lock
)/
'''
```

이를 마치고 간단히 PEP8을 지키지 않은 코드를 돌려보면...

<br>

<img width="149" alt="ㅑㅡㅎ1" src="https://user-images.githubusercontent.com/47859845/148682480-3bbe045f-5cef-4828-88ba-88296527a413.png">

<img width="146" alt="ㅑㅡㅎ2" src="https://user-images.githubusercontent.com/47859845/148682481-e97142a3-dea0-43db-8aa0-4252071d48d7.png">

<br>
<br>


이런식으로 밑줄 처진 것들이 변환되는 것을 볼 수 있다.!!

pre-commit 이기 때문에 아직 commit 되지 않은 상태로, 변환된 경우 commit을 다시 해주어야한다.

<br>
<br>
