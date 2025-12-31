<!-- README.md: 저장소 개요, 구조, 사용법을 요약하는 문서 -->
# Web-Server

## 개요
이 저장소는 Spring Boot와 JSP를 기반으로 구축되어, 실제 서비스 수준의 UI/UX 환경에서 모의해킹 및 보안 교육 실습을 수행하는 구조를 목표로 합니다. SQL Injection, Stored XSS, IDOR 등 주요 웹 취약점을 의도적으로 구현하여 공격 및 방어 기법을 학습할 수 있는 체계를 기본으로 제공합니다.

## 프로젝트 구조
- `src/main/java/`: Spring Boot 애플리케이션의 핵심 로직 및 엔트리포인트
- `src/main/java/.../controller/`: 주요 취약점(SQLi, XSS, IDOR)이 의도적으로 구현된 컨트롤러 계층
- `src/main/resources/`: 데이터베이스 연결 설정(application.properties) 및 서버 구성 파일
- `src/main/webapp/WEB-INF/views/`: 서버 사이드 렌더링을 위한 JSP 뷰 템플릿 (대시보드, 강의실 등)
- `src/main/webapp/static/`: UI 디자인을 위한 정적 리소스 (Grid/Flex 기반 CSS, 이미지)
- `pom.xml`: Maven 프로젝트 빌드 설정 및 라이브러리 의존성 관리

## 모듈 상호작용 흐름

1. User Request: 사용자가 웹 브라우저를 통해 로그인, 게시글 작성, 마이페이지 조회 등의 HTTP 요청을 보냅니다.
2. Vulnerable Controller: LoginController, BoardController 등은 사용자 입력값을 검증이나 필터링 없이 그대로 수신합니다.
3. Database Interaction: 조작된 입력값이 포함된 SQL 쿼리가 MariaDB에서 그대로 실행됩니다.
4. View Rendering: DB에서 조회된 데이터가 JSP 템플릿을 통해 이스케이프 처리 없이 렌더링됩니다.
5. Response & Execution: 최종 HTML이 사용자 브라우저로 반환되며, 저장된 악성 스크립트가 실행되거나 민감 정보가 노출됩니다.

## 핵심 모듈
- `src/main/java/.../controller/`: 사용자 입력을 처리하는 비즈니스 로직이자, **주요 취약점(SQLi, IDOR, XSS)**이 의도적으로 구현된 핵심 계층
- `src/main/webapp/WEB-INF/views/`: JSTL을 사용하여 데이터를 렌더링하는 뷰 템플릿으로, **XSS 공격 구문이 실행**되는 지점
- `src/main/webapp/static/css/`: `Flexbox`와 `Grid` 시스템을 활용하여 LMS의 복잡한 레이아웃(로드맵, 대시보드)을 구현한 스타일시트
- `src/main/resources/`: 데이터베이스 연결 설정(`application.properties`) 및 정적 리소스 매핑 설정

## 빠른 실행
### 1. 데이터베이스 설정
# src/main/resources/application.properties 파일을 열어 DB 정보를 수정합니다. (현재는 리눅스 mariaDB IP로 설정)
spring.datasource.url=jdbc:mariadb://localhost:3306/lms_db
spring.datasource.username=lms_user
spring.datasource.password=secret

# 2. 의존성 설치 및 실행
### Maven을 사용하여 프로젝트를 빌드하고 Spring Boot 서버를 구동합니다.
mvn clean install
mvn spring-boot:run

# 3. 접속 확인
### 서버가 시작되면 브라우저에서 아래 주소로 접속합니다.
### http://localhost:8080
