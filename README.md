# 에코레시피: Eco Recipe
<p align="center">
  
![image](https://github.com/college-capstone-team-1/cooking-app-iOS/assets/67594952/a08d85bc-2f01-4d85-bbe7-c8fdf1814311)
  
</p>

<br>

## 프로젝트 소개 👩‍🏫

<p align="justify">
<b>에코레시피는</b>는 건강하고 친환경적인 식문화를 장려하기 위한 앱입니다. <br>
레시피를 검색하고 원하는 레시피는 저장할 수 있습니다.<br>
</p>

<br>

<br>

## 스택 🔨

### 기술 스택
- 프로젝트 구조: MVC
- 인터페이스: Storyboard
- 패키지 관리: SPM
- 외부 라이브러리: Firebase
- URLSession
- NSCache
- Core Data

### 개발 환경
- OS: macOS Monterey(12.X)
- IDE: Xcode13.2.1

<br>

## 앱 구성

<br>

### 스크린샷

| **메인화면** | **레시피 검색** | **레시피 상세화면** | 
| :------: | :------: | :------: | 
| ![image](https://github.com/college-capstone-team-1/cooking-app-iOS/assets/67594952/9d34579b-d220-4203-9264-7ef9df0dd5d8) | ![image (1)](https://github.com/college-capstone-team-1/cooking-app-iOS/assets/67594952/1d026411-665f-4016-b452-6ec49a3eac4a) | ![312512351235](https://github.com/college-capstone-team-1/cooking-app-iOS/assets/67594952/129fc3c9-b073-4380-b2b9-40c93cb0cf51) |
| **저장된 레시피** | **로그인 화면** | **푸시 알람(FCM)** |
| ![image (2)](https://github.com/college-capstone-team-1/cooking-app-iOS/assets/67594952/fa693eec-c0a9-40d3-8430-085e1086aae5) |![image (3)](https://github.com/college-capstone-team-1/cooking-app-iOS/assets/67594952/563d5f62-b764-4781-8cc6-23d11d82e4d4) | ![image (5)](https://github.com/college-capstone-team-1/cooking-app-iOS/assets/67594952/4e76fdd5-7d12-4a92-8f67-d5801415a33f) |

<br>

### 개발 상세

#### API통신
- API에 필요한 데이터 모델링
- URLSession.dataTask로 데이터 요청
- JSONDecoder로 JSON데이터 파싱

#### 화면 출력
- 파싱된 데이터 테이블뷰, 컬렉션뷰 출력
- tableView(_:willDisplay:forRowAt:)메서드로 무한스크롤 적용
- 이미지 캐시 적용

#### 파이어베이스
- 구글, 이메일 로그인, 회원가입 구현
- FCM(푸시알람) 구현

#### Core Data
- 원하는 레시피 데이터를 로컬저장소에 저장

<br>
<br>
