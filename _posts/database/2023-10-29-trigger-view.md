---
title: "SQL 중첩 질의와 트리거, 뷰"
date: 2023-10-29

categories:
  - database
tags:
  -
---


기본적인 SQL 중 SELECT 에 대한 내용과 관계 대수 포스트를 숙지하고 이해해보자.

<br>
<br>

## 그룹화

GROUP BY : 특정 애트리뷰트에 동일한 값을 갖는 튜플들을 각각 하나의 그룹으로 묶는다. 이때 사용한 애트리뷰트를 그룹화 애트리뷰트라고 한다.

HAVING : 어떤 조건을 만족하는 그룹에 대해서만 집단 함수를 적용한다.


ex) 점수가 90점 이상인 회사별 데이터로 그룹

```sql
SELECT * FROM {TABLE} GROUP BY COMPANY HAVING GRADE > 90;
```

<br>
<br>

## 조인, 중첩 질의

**조인 연산**

조인은 두 릴레이션으로 부터 연관된 튜플을 결합하는 연산인데, 기본적으로 SELECT 와 함께 JOIN 연산을 사용한다. 이때 조인 조건을 생략하거나 틀린경우 카티션 곱이 되고, 조건에 따라 결과가 달라진다.

<br>

**자체 조인(self join)**

한 릴레이션에 속하는 튜플을 동일한 릴레이션에 속하는 튜플과 조인하는 것을 의미한다.

ex) 회사 내부의 사원과 직속 상사의 이름을 추출한다.

```sql
SELECT E.NAME, M.NAME FROM EMPLOYEE E, EMPLOYEE M WHERE E.MANAGER = M.EMPNO;
```

<br>

**중첩 질의(nested query)**

외부 질의에 WHERE 절을 다시 포함하는 질의문으로 서브 쿼리 라고도 한다. SELECT 외에 DML 인 경우 사용할 수 있다. 

ex) 김사라와 같은 직급의 사원들 정보 검색

```sql
SELECT * FROM EMPLOYEE WHERE TITLE = (SELECT TITLE FROM EMPLOYEE WHERE ENAME = '김사라');
```

<br>

**상관 중첩 질의(correlated nested query)**

중첩 질의의 WHERE 절에 있는 프레디키트에서 외부 질의에 선언된 릴레이션 일부 애트리뷰트를 참조하는 질의이다.


ex) 자신이 속한 부서의 사원들의 평균 급여보다 많은 급여를 받는 사원들에 대해서 이름, 부서, 급여 등을 검색

```sql
SELECT NAME, ... FROM EMPLOYEE E WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DNO = E.DNO);
```

위와 같이 외부 질의에서 정의한 E 릴레이션의 DNO를 내부 질의에서 사용하고 있는 경우이다.

<br>
<br>

## 트리거(Trigger)

명시된 이벤트(DB 갱신)가 발생할때 마다 자동으로 수행하는 정의된 문(프로시저). 트리거를 이벤트-조건-동작(ECA) 규칙이라고도 부른다. 이벤트 전에 동작하는지, 후에 동작하는지에 따라 구분한다.

**특징**

Event : 이벤트의 가능한 예로 튜플 삽입, 삭제, 수정 등이 있다.

Condition :  조건은 임의의 프레디 키트(셀렉션)

Action : 동작은 DB에 대한 임의 갱신

```sql
CREATE TRIGGER {트리거 이름} AFTER|BEFORE insert|update|delete ON {릴레이션} WHEN {조건}
BEGIN {SQL} END;
```

<br>
<br>

## 뷰(View)

**뷰(View) 란?**

데이터 베이스의 보안 메카니즘으로 복잡한 질의를 간단하게 표현하는 수단으로서 데이터 독립성을 높이기 위해 사용한다. 일종의 가상 릴레이션을 의미한다. 뷰는 데이터 검색, 갱신이 가능한 동적인 창의 역할을 한다.

<br>

RDBMS 에서 뷰는 다른 릴레이션으로 부터 유도된 릴레이션으로 ANSI/SPARC 3단계의 외부 뷰와 다르다. 

ex) 기획부에 근무하는 사원에 대한 뷰이다.

```sql
CREATE VIEW {뷰이름} AS SELECT * FROM EMPLOYEE E, DEPARTMENT D WHERE
	E.DNO = D.DPTNO AND D.NAME = '기획';
```

<br>

**장점**

뷰는 복잡한 질의를 간단하게 표현할 수 있게 한다.

<br>

데이터 무결성 보장 (조건 등이 맞지 않는 경우 뷰에서 사라짐.)

데이터 독립성 보장 (DB 구조가 바뀌어도 기존 질의를 다시 작성할 필요성을 줄인다.)

데이터 보안 기능을 제공 (원본에 직접 접근할 수 있는 권한 부여 X → 뷰에 제공된 일부 애트리뷰트만 접근 가능)

<br>

- **갱신이 불가능한 뷰**
    - **한 릴레이션 위에서 정의되었으나 그 릴레이션의 기본 키가 포함되지 않은 뷰**
    - **기본 릴레이션의 애트리뷰트들 중에서 뷰에 포함되지 않은 애트리뷰트에 대해 NOT NULL이 지정되어 있을 때**
    - **집단 함수가 포함된 뷰**
    - **조인으로 정의된 뷰**

<br>

**시스템 카탈로그**

시스템 내의 객체에 대한 정보를 포함하는 것으로 적절히 이용하여 릴레이션의 구조를 쉽게 파악할 수 있다.

<br>
<br>
