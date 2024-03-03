---
title: "[Network] 서버렉 여러 장치들"
date: 2024-02-17

categories:
  - network

tags:
  - network
---

## 서버렉 살펴보기

저번 스위치, 라우터 이야기 이후로 하드웨어적으로 어떤 장치들이 있는지 조금 더 알아보자. 대학교 과정에는 짧게 넘어갔지만...
회사 업무를 하다보니 Terraform 과 함께 인프라를 공부할 기회가 오게 되었다. (^>^)7 머쓱 ㅎㅎ

<br>

마침 저번에 이야기한 스위치 라우터 외에 VM이나 서버렉 등을 공부하는 기회가 되어 각각 어떤 역할을 하는 지 등을 정리해보려고 한다.

<br>

**서버렉이란?**

서버렉은 여러 서버를 정리할 수 있는 케이스이다. 이러한 케이스에는 단순한 컴퓨터가 아닌 스위치나 다양한 장치를 넣게 되는데.. 차근차근 어떤 것들이 있는지 살펴보자.

<br>
<br>

## 보안과 관련된 장치, 기능들

**UTM(Unified Threat Management)**

통합 위협 관리 로 안티바이러스, 방화벽, 가상사설망(VPN), IDS, ISP 등의 보안 기능이 모여있는 장비를 말한다.

우선 서버의 보안을 담당하는 부분부터 살펴보자. 보안과 관련된 기능들을 담당하는 장치를 UTM 이라고 한다. UTM 내부에는 여러 기능이 있다. 기존에는 보안 기능에 따라 장비를 따로 구성해야했는데, UTM 을 통해서 장비를 추가하지 않고, 필요한 소프트웨어를 설정하여 사용할 수 가 있다.

아래에서 이야기하는 대부분의 기능이 UTM 장치 하나에 설정할 수 있다..!

<br>
<br>

**가상사설망(VPN, Virtual Private Network)**

가상의 사설망을 형성해서 인터넷 트래픽을 보호한다. VPN 라우터를 이용하여 망을 완전히 분리하고, 이를 가상화 시킨것이다.

VPN에는 터널링을 이용해서 접속한다는 이야기를 많이 하는데, 터널링이란 라우터에 있는 VPN 프로토콜 중 하나를 이용해서 접속하는 것으로 단말기와 라우터 사이에 연결이 암호화된다. 이 사이 연결 및 기록이 암호화 되기 때문에 보안적으로 이점이있다. 또 이러한 VPN 접속 및 터널링을 위해서는 암호나 키가 필요하기 때문에 해커나 익명의 사용자가 네트워크에 접근하는 것도 막을 수 있다.

이러한 VPN 프로토콜에는 여러 종류가 있다.

- WireGuard
- SoftEther
- IKEv2/IPsec
- L2TP/IPsec
- SSTP
- PPTP

아래로 PPTP는 안전하지 않은 프로토콜이지만 설정이 간단하다. 각 프로토콜에 따라 연결 거리, 호환성등이 다르기 때문에 설정하는 경우 세부적으로 알아보는 것이 좋다.

<br>
<br>

**방화벽(Firewall)**

허가되지 않은 엑세스를 방지하는 역할을 한다.

방화벽을 이용하면, 악의적인 패킷에 대해서 차단이 가능하다. 단, 방화벽 내부 네트워크와 외부 네트워크 사이의 세션 연결을 위한 패킷 등등 정보를 이용해서 방화벽에서 허용되는 패킷에 악의적인 코드나 요청을 보낼 수 있기 때문에 절대적으로 믿어서는 안된다. 그렇기 때문에 방화벽 이외에 세부적으로 IDS, IPS가 필요한 것이다.

<p align="center">
<img width="654" alt="Firewall" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/26171699-e1fc-4ea2-8829-dd65f4e080a1">
</p>

<br>
<br>

**IDS(Intrusion Detection System)**

침입 탐지 시스템

침입 탐지 시스템은 네트워크 트래픽을 모니터링 하고 트래픽 내용을 분석해서 침입이 있는지 파악하는 시스템이다. 바이러스 등은 방화벽에 막히더라도 허용된 패킷이 악의적인지 파악하는 과정을 거친다. 여기서 탐지만 하고 실질적으로 차단하지는 않는다. 따라서 모니터링은 되지만, 해당 패킷을 차단하기 위해서는 수동으로 작업해야한다.

패킷을 탐지하는 방식으로는 **시그니처** 패턴을 참고하여 트래픽을 검출한다. 시그니처 패턴은 악성코드를 해시화 한 것으로 이걸 저장해 두고, 트래픽의 내용가 이와 일치하는 지 여부를 통해서 감지한다. 하지만, 문자를 조금만 바꿔도 해시값이 완전히 달라지기 때문에 시간이 지날 수록 저장되는 해시가 많아지고, 해커가 우회하기 쉽기 때문에 이러한 방식도 문제가 되고 있다.

IDS는 주로 방화벽 앞단에 위치한다.

<p align="center">
<img width="654" alt="IDS" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/bbec715c-199a-4ff3-ba42-c2dea674e724">
</p>

<br>
<br>

**ISP(Intrusion Prevention System)**

침입 방지 시스템

침입 방지 시스템은 악의적인 트래픽이 검출되면, 해당 패킷을 차단하거나 세션을 끊어 방어하는 역할을 한다. IDS와 마찬가지로 패킷을 분석하고, 이를 모니터링 할 수 있다. 하지만, 과도한 오탐으로 인해 오히려 서비스를 못하는 곳도 있다고 한다...

ISP 도 방화벽 앞단에 위치한다.

<p align="center">
<img width="654" alt="IPS" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/84136a2d-d869-49e1-9729-4ba0f39d196b">
</p>

<br>
<br>

**안티 바이러스(Anti-Virus)**

PC의 악성 코드등을 탐지하고 이를 차단, 제거하는 기능을 말한다. 바이러스 스캔등이 있는 소프트웨어가 대다수이다.

<br>
<br>

**DMZ(DeMilitarized Zone)**

비무장 지대

뭔가 익숙한 용어... DMZ이다. 네트워크에서 DMZ는 주로 기업에서 네트워크를 나누는 기준에서 나오는데, 기업 사내에서 쓰는 내부 네트워크, 외부 네트워크, 마지막으로 DMZ가 존재한다. DMZ는 내부, 외부 네트워크와 분리된 네트워크로 주로 내부 네트워크와 외부 네트워크 사이를 중개한다. 즉, 내부 - 외부가 직접적으로 통신할 수 없고, DMZ에 있는 공개 서버를 통해서만 통신이 가능하다는 이야기 이다.

<p align="center">
<img width="654" alt="DMZ" src="https://github.com/rha6780/rha6780.github.io/assets/47859845/ba4e834c-0a31-4ba6-bc04-5f91a9184bcf">
</p>

이러한 DMZ는 로깅과 방화벽 역할도 하면서.. 트래픽이 많은 경우 로드 밸런서와 같이 회선 부하를 분산한다.

<br>
<br>

## 기타 장치

**USP(Uninterruptible Power Supply system)**

무정전 전원 장치

USP는 정전이나 전력공급에 이상이 생겼을 때 일정 시간 만큼 전력을 공급할 수 있는 장치이다. 비상 전력 배터리와 동일한 기능을 한다. 주로 핵심적인 서비스에 연결을 해둔다. 이러한 USP는 타입이 있는데, 전원 공급을 정류하는 기능, 비상시 전력 저장 배터리, 전압을 바꾸는 인버터 등 여러 타입이 있다.

<br>

이외에는 공부하는데로 추가하도록 하겠다...!

<br>
<br>