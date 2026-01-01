<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>내 정보 | We Lab Space</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/myinfo.css">
            <link href="/static/css/welab.css" rel="stylesheet">

        </head>

        <body>
            <jsp:include page="/WEB-INF/views/common/nav.jsp" />
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
                                <button type="button" class="btn-custom btn-pw-change"
                                    onclick="location.href='${pageContext.request.contextPath}/changePw'">
                                    비밀번호 변경
                                </button>
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