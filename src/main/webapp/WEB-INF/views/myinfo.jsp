<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>내 정보 | We Lab Space</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link href="/static/css/welab.css" rel="stylesheet">
            <style>
                /* 1. 배경 및 기본 폰트 설정 */
                body {
                    background-color: #f4f7f9;
                    font-family: 'Noto Sans KR', sans-serif;
                    margin: 0;
                    padding: 0;
                    min-height: 100vh;
                }

                /* 2. 메인 레이아웃 - 네비게이션이 없으므로 상단 여백을 충분히 확보 */
                .main-wrapper {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    padding-top: 80px;
                    padding-bottom: 100px;
                }

                .nav-tabs-custom {
                    border: none;
                    gap: 4px;
                    margin-bottom: -1px;
                    z-index: 2;
                }

                .nav-tabs-custom .nav-link {
                    background-color: #e2e8f0;
                    color: #4a5568;
                    border: none;
                    border-radius: 12px 12px 0 0;
                    padding: 12px 30px;
                    font-size: 0.95rem;
                    font-weight: 500;
                }

                .nav-tabs-custom .nav-link.active {
                    background-color: #ffffff;
                    color: #004a99;
                    font-weight: bold;
                    border-top: 4px solid #004a99;
                }

                /* 3. 정보 카드 박스 */
                .info-card {
                    background-color: #ffffff;
                    width: 800px;
                    max-width: 95%;
                    border-radius: 20px;
                    padding: 50px 70px;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
                    text-align: center;
                }

                /* 4. 타이틀 장식 */
                .page-title {
                    color: #004a99;
                    font-size: 1.8rem;
                    font-weight: bold;
                    margin-bottom: 5px;
                }

                .pink-dot {
                    width: 6px;
                    height: 6px;
                    background-color: #ff99cc;
                    border-radius: 50%;
                    margin: 5px auto 40px;
                }

                /* 5. 포인트 섹션 */
                .point-container {
                    background-color: #f8fafc;
                    border: 1px solid #edf2f7;
                    border-radius: 12px;
                    padding: 20px 25px;
                    margin-bottom: 40px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .point-label {
                    font-weight: bold;
                    font-size: 1.05rem;
                    color: #333;
                }

                .point-value {
                    font-size: 1.3rem;
                    margin-left: 10px;
                    color: #000;
                }

                /* 6. 입력 폼 스타일 */
                .form-group-custom {
                    text-align: left;
                    margin-bottom: 25px;
                }

                .form-label-small {
                    font-size: 0.85rem;
                    color: #718096;
                    margin-bottom: 4px;
                }

                .input-underline {
                    border: none;
                    border-bottom: 1px solid #e2e8f0;
                    border-radius: 0;
                    padding: 10px 0;
                    width: 100%;
                    font-size: 1.1rem;
                    background: transparent;
                }

                .input-underline:focus {
                    outline: none;
                    border-bottom: 2px solid #004a99;
                }

                /* 7. 버튼 스타일 */
                .btn-group-bottom {
                    display: flex;
                    justify-content: center;
                    gap: 15px;
                    margin-top: 45px;
                }

                .btn-custom {
                    padding: 12px 40px;
                    border-radius: 8px;
                    font-weight: bold;
                    font-size: 1rem;
                }

                .btn-white {
                    border: 1px solid #cbd5e0;
                    color: #4a5568;
                    background: #fff;
                }

                .btn-blue {
                    background-color: #2b6cb0;
                    color: #fff;
                    border: none;
                }

                .btn-pw-change {
                    background-color: #4a5568;
                    color: #fff;
                    border: none;
                }

                /* 8. 푸터 */
                .footer-area {
                    background-color: #004a99;
                    color: #fff;
                    text-align: center;
                    padding: 40px 0;
                    width: 100%;
                }
            </style>
        </head>

        <body>
            <nav class="navbar-welab">
                <div class="container d-flex justify-content-between align-items-center">

                    <div class="d-flex align-items-center">
                        <a href="/dashboard">
                            <img src="/static/images/Logo.png" alt="SK Rookies x WELAB"
                                style="height: 50px; margin-right: 20px;">
                        </a>
                    </div>

                    <div class="d-flex align-items-center">
                        <div class="user-badge">
                            <i class="fas fa-check-circle"></i> 루키즈 AI 보안 28기
                        </div>
                        <span class="text-white me-4" style="font-size:0.95rem;"><strong>
                                <%= session.getAttribute("user_name") %>
                            </strong>님 환영합니다.</span>

                        <a href="/dashboard" class="btn-nav me-2"><i class="fas fa-home"></i> 홈</a>
                        <a href="/myinfo?id=<%= session.getAttribute("user_id") %>" class="btn-nav me-2"><i
                                class="fas fa-user"></i> 내 정보</a>
                        <a href="javascript:void(0);" class="btn-nav" onclick="handleLogout()"><i
                                class="fas fa-sign-out-alt"></i> 로그아웃</a>

                        <script>
                            function handleLogout() {
                                localStorage.removeItem("accessToken");
                                alert("로그아웃 되었습니다.");
                                location.href = "/logout";
                            }
                        </script>
                    </div>

                </div>
            </nav>
            <div class="main-wrapper">
                <ul class="nav nav-tabs nav-tabs-custom" id="myTab" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab1" type="button">회원정보
                            수정</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab2" type="button">학습 계정
                            정보</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab3" type="button">출석
                            정보</button>
                    </li>
                </ul>

                <div class="info-card">
                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="tab1">
                            <div class="page-title">회원정보</div>
                            <div class="pink-dot"></div>

                            <div class="point-container">
                                <div class="point-label">보유 포인트 <span class="point-value">${point}</span></div>
                                <button class="btn btn-sm btn-outline-secondary rounded-pill px-3"><i
                                        class="fas fa-search"></i> 누적현황 보기</button>
                            </div>

                            <h5 class="text-start fw-bold mb-4" style="color:#004a99;">정보수정</h5>

                            <div class="form-group-custom">
                                <p class="form-label-small">아이디</p>
                                <input type="text" class="input-underline" value="${userId}" readonly>
                            </div>
                            <div class="form-group-custom">
                                <p class="form-label-small">닉네임</p>
                                <input type="text" class="input-underline" value="${userName}"
                                    placeholder="닉네임을 입력해 주세요.">
                            </div>
                            <div class="form-group-custom">
                                <p class="form-label-small">이메일</p>
                                <input type="text" class="input-underline" value="${userEmail}"
                                    style="background-color: #f1f5f9;" readonly>
                            </div>
                            <div class="form-group-custom">
                                <p class="form-label-small">휴대전화</p>
                                <input type="text" class="input-underline" value="${userPhone}">
                            </div>

                            <div class="btn-group-bottom">
                                <button class="btn-custom btn-white" onclick="location.href='/dashboard'">취소</button>
                                <button class="btn-custom btn-blue">변경</button>
                                <button class="btn-custom btn-pw-change">비밀번호 변경</button>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="tab2">
                            <div class="page-title">학습 계정 정보</div>
                            <div class="pink-dot"></div>
                            <div class="mt-5" style="padding: 0 40px;">
                                <div class="form-group-custom">
                                    <p class="form-label-small">AWS 계정</p><input type="text" class="input-underline"
                                        value="${awsAccount}" readonly>
                                </div>
                                <div class="form-group-custom">
                                    <p class="form-label-small">IAM user</p><input type="text" class="input-underline"
                                        value="${iamUser}" readonly>
                                </div>
                                <div class="form-group-custom">
                                    <p class="form-label-small">AWS 초기 패스워드</p><input type="text"
                                        class="input-underline" value="${awsPw}" readonly>
                                </div>
                                <div class="form-group-custom">
                                    <p class="form-label-small">리전</p><input type="text" class="input-underline"
                                        value="${region}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="tab3">
                            <div class="page-title">출석 정보</div>
                            <div class="pink-dot"></div>
                            <div class="py-5 text-muted">이수율: ${attendRate}%</div>
                        </div>
                    </div>
                </div>
            </div>

            <footer class="footer-area">
                <img src="/static/images/lms_logo_small.png" alt="LMS"
                    style="height: 30px; margin-bottom: 10px; opacity: 0.8;">
                <p class="mb-0 small" style="opacity: 0.7;">COPYRIGHT © 2025 WELABSPACE. ALL RIGHTS RESERVED.</p>
            </footer>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>