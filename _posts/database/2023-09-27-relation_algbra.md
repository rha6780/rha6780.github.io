---
title: "관계대수"
date: 2023-09-27

categories:
  - database
tags:
  -
---


**관계 해석**

원하는 데이터만 명시하고 질의를 어떻게 할 것인지는 명시하지 않는 선언적(비 절차적) 언어이다.

<br>

**관계 대수**

관계대수란 원하는 데이터를 어떻게 추출할지 절차적으로 기술하는 언어이다. 

<br>

## 집합 연산자

### **합집합(R ⋃ S)**

두 릴레이션 R, S의 합집합으로 두 릴레이션에 존재하는 모든 튜플로 이루어진 릴레이션이다.

- **합집합 호환**
    
    합집합을 하려면 호환 조건이 맞아야 하는데, 서로 다른 테이블을 합할 때 갯수가 다르거나 도메인이 다른 경우 합집합을 할 수가 없다.
    

<br>

### **교집합(**R ∩ S**)**

두 릴레이션 R과 S의 교집합은 R과 S 모두에 속한 튜플들로 이루어진 릴레이션이다.

<br>

### **차집합(R-S)**

두 릴레이션 R에는 속하지만, S에는 속하지 않은 튜플들로 이루어진 릴레이션이다.

<br>

### **카티션 프로덕트(R x S)**

카디날리티가 i 인 릴레이션 R과 카디날리티가 j인 릴레이션 S의 곱으로 R과 S 튜플들의 모든 조합으로 이루어진 릴레이션이다.

<img width="602" alt="Screenshot_2023-09-27_at_3 59 31_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/16c4c433-36c6-4d78-8dfb-8dea16794c3a">


<br>
<br>

## 순수 관계 연산자

### **셀렉션(select : σ)**

한 릴레이션에서 셀렉션 조건을 만족하는 튜플들을 찾아주는 연산자.

<img width="504" alt="Screenshot_2023-09-27_at_3 57 29_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/e19d1a79-8c96-4c10-8456-2975ca993e22">

    
<br>

### **프로젝션(project : *π*)**

한 릴레이션에서 조건을 만족하는 애트리뷰트들을 찾아주는 연산자.

<img width="487" alt="Screenshot_2023-09-27_at_3 57 02_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/e5f64ce4-8225-4af0-ba54-edbf38cf2a12">


<br>

### **디비전(division : ÷)**

한 릴레이션에서 다른 릴레이션의 모든 값을 가지고 있는 튜플을 찾아주는 연산자.


<img width="361" alt="Screenshot_2023-09-27_at_3 58 02_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/04a65de0-822b-495d-8a36-da450d678372">

<br>

### **조인 (join : ⨝)**

두 릴레이션으로 부터 연관된 튜플들을 결합하는 연산자

<br>

**연산 방식에 따른 종류**
    
  **세타 조인(theta join: θ)**
  
  두 릴레이션에서 공통된 애트리뷰트를 기준으로 비교 연산자를 이용해 조건을 만족하는 튜플을 결합한다.
  

  <br>

  **동등 조인(equi join)**
  
  세타 조인 중에서 비교 연산자가 = 인 조인이다.
  
  <br>

  **자연 조인**
  
  동등 조인의 결과 릴레이션에서 조인 애트리뷰트를 제외한 조인 (중복 필드 제거)
  
  <img width="458" alt="Screenshot_2023-09-27_at_3 55 12_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/3fa943ff-248a-4fae-9ee6-fb609f1aadff">


  <br>

  **외부 조인**
  
  널값이 있는 튜플을 다루기 위해 확장한 조인으로 대응되는 튜플이 없더라도 결과에 포함하고 해당 값을 null 로 채우는 조인이다. 외부 조인도 어느 릴레이션을 기준으로 할지에 따라서 3가지로 나뉜다.
  
  <br>

  왼쪽 외부 조인 ⟕ : 왼쪽을 튜플을 기준으로 값을 넣고 없는 값을 null로 채운다.
  
  <img width="455" alt="Screenshot_2023-09-27_at_3 54 54_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/a8bb6af2-844d-41b7-9e64-836c2f8d5a7a">

  <br>

  오른쪽 외부 조인 ⟖ : 오른쪽을 튜플을 기준으로 값을 넣고 없는 값을 null로 채운다.
  
  <img width="586" alt="Screenshot_2023-09-27_at_3 54 10_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/fdceca87-455b-4756-a4f8-3ae4beebdb98">
  

  <br>

  완전 외부 조인 ⟗ : 두 튜플을 기준으로 값을 넣고 없는 값을 null로 채운다.
  
  <img width="595" alt="Screenshot_2023-09-27_at_3 54 33_AM" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/af2ca6fd-5cbd-4c2b-9a75-e18fa4734e76">




<br>
<br>

### 그 외

**집단함수**

한 릴레이션의 특정 속성, 총합, 평균, 최대, 최소, 개수 등의 연산을 수행하는 함수.

<br>

**그룹화**

한 릴레이션의 특정 속성에 따라 튜플을 여러 그룹으로 분류하는 연산자.

<br>

---

이미지 출처 : 구글 검색

<br>
<br>
