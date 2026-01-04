<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>홈 | We Lab Space</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                body {
                    background-color: #f8f9fa;
                    font-family: 'Pretendard', sans-serif;
                }

                /* 배너 섹션 */
                .banner-section {
                    background-color: #eef4fb;
                    border-radius: 15px;
                    padding: 20px 30px;
                    position: relative;
                    margin-bottom: 40px;
                    display: flex;
                    align-items: center;
                }

                .banner-content {
                    flex: 1;
                    padding-left: 20px;
                }

                .banner-img {
                    width: 150px;
                }

                .banner-title {
                    font-size: 22px;
                    font-weight: 700;
                    color: #333;
                    margin-bottom: 5px;
                }

                .banner-sub {
                    font-size: 14px;
                    color: #666;
                    margin-bottom: 20px;
                }

                .btn-go {
                    background-color: #004794;
                    color: white;
                    border-radius: 20px;
                    padding: 5px 20px;
                    border: none;
                    font-size: 14px;
                }

                /* 탭 버튼 스타일 */
                .nav-pills-custom .nav-link {
                    color: #666;
                    background-color: #eee;
                    border-radius: 10px 10px 0 0;
                    margin-right: 5px;
                    font-weight: 600;
                    padding: 10px 25px;
                    font-size: 14px;
                }

                .nav-pills-custom .nav-link.active {
                    color: #004794;
                    background-color: #fff;
                    border: 1px solid #dee2e6;
                    border-bottom: none;
                }

                /* 카드 스타일 */
                .card-custom {
                    border: 1px solid #eee;
                    border-radius: 15px;
                    overflow: hidden;
                    transition: transform 0.2s;
                    background: #fff;
                }

                .card-custom:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
                }

                .card-img-top {
                    height: 180px;
                    object-fit: cover;
                }

                .card-category {
                    font-size: 13px;
                    color: #004794;
                    font-weight: 700;
                    margin-bottom: 5px;
                }

                .card-title {
                    font-size: 16px;
                    font-weight: 700;
                    color: #333;
                    line-height: 1.4;
                    height: 45px;
                    overflow: hidden;
                }

                /* 태그 스타일 */
                .tag-badge {
                    background-color: #f8f9fa;
                    border: 1px solid #eee;
                    color: #777;
                    font-size: 11px;
                    padding: 3px 8px;
                    border-radius: 5px;
                    margin-right: 5px;
                    font-weight: 500;
                }

                /* 진행률 바 */
                .progress-container {
                    margin-top: 15px;
                }

                .progress {
                    height: 6px;
                    background-color: #eee;
                    border-radius: 3px;
                }

                .progress-bar {
                    background-color: #ffc107;
                }

                .progress-text {
                    font-size: 12px;
                    color: #004794;
                    font-weight: 600;
                }

                .date-text {
                    font-size: 12px;
                    color: #999;
                }

                /* 하단 파란 배너 */
                .bottom-banner {
                    background-color: #eef4fb;
                    padding: 30px;
                    border-radius: 15px;
                    margin-top: 50px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .bottom-banner-text {
                    font-size: 14px;
                    color: #444;
                }

                .btn-move {
                    background-color: #004794;
                    color: white;
                    border-radius: 8px;
                    padding: 10px 25px;
                    font-weight: 600;
                    text-decoration: none;
                }

                /* 관리자 버튼 (기존 기능 유지) */
                .btn-admin-access {
                    background-color: #dc3545;
                    color: white;
                    border: none;
                    border-radius: 5px;
                    font-size: 12px;
                    padding: 5px 15px;
                }
            </style>
        </head>

        <body>
            <jsp:include page="/WEB-INF/views/common/nav.jsp" />

            <div class="container mt-4" style="max-width: 1100px;">

                <%-- 관리자 권한 버튼 --%>
                    <c:if test="${cookie.role.value eq 'ADMIN'}">
                        <div class="d-flex justify-content-end mb-2">
                            <a href="/admin/users" class="btn-admin-access">
                                <i class="fas fa-user-shield me-1"></i> 관리자 전용 페이지 접속
                            </a>
                        </div>
                    </c:if>

                    <div class="banner-section">
                        <img src="/static/images/character.png" alt="character" class="banner-img">
                        <div class="banner-content">
                            <div class="banner-sub">단계별 훈련으로 MSA, DevOps, Agile 기술 활용 역량 강화</div>
                            <div class="banner-title">LG CNS AM Inspire Camp 4기 모집중</div>
                        </div>
                        <button class="btn-go">바로가기</button>
                        <div class="ms-3">
                            <i class="fas fa-ellipsis-v text-muted"></i>
                        </div>
                    </div>

                    <%-- 탭 및 카운터 --%>
                        <div class="d-flex justify-content-between align-items-end mb-3">
                            <ul class="nav nav-pills nav-pills-custom">
                                <li class="nav-item">
                                    <a class="nav-link active" href="#">수강중인 과정</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="#">종료된 과정</a>
                                </li>
                            </ul>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="fw-bold" style="font-size: 15px; color: #004794;">
                                Total : <span style="color: #333;">2</span>
                            </div>
                            <div>
                                <i class="fas fa-th-large text-muted me-2"></i>
                                <i class="fas fa-bars text-muted"></i>
                            </div>
                        </div>

                        <%-- 과정 카드 리스트 (2개) --%>
                            <%-- 과정 카드 리스트 (3개 가로 정렬) --%>
                                <div class="row g-4">

                                    <%-- 카드 1: 루키즈 AI 보안 --%>
                                        <div class="col-md-4">
                                            <a href="/lecture_view" class="text-decoration-none">
                                                <div class="card card-custom">
                                                    <img src="/static/images/mainImage.webp" class="card-img-top"
                                                        alt="AI Security">
                                                    <div class="card-body">
                                                        <div class="card-category">루키즈 AI 보안 28기</div>
                                                        <div class="card-title">생성형 AI 활용 사이버보안 전문인력 양성과정 28기</div>
                                                        <div class="mt-2">
                                                            <span class="tag-badge"># 생성형 AI</span>
                                                            <span class="tag-badge"># 융합보안</span>
                                                        </div>
                                                        <div class="progress-container">
                                                            <div class="progress">
                                                                <div class="progress-bar" style="width: 41%"></div>
                                                            </div>
                                                            <div class="d-flex justify-content-between mt-2">
                                                                <span class="progress-text">진행률 41%</span>
                                                                <span class="date-text"><i
                                                                        class="far fa-clock me-1 text-warning"></i>2025-10-23
                                                                    ~ 2026-04-17</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>

                                        <%-- 카드 2: EQST 모의해킹 --%>
                                            <div class="col-md-4">
                                                <div class="card card-custom">
                                                    <img src="/static/images/hackingTraining.webp" class="card-img-top"
                                                        alt="EQST">
                                                    <div class="card-body">
                                                        <div class="card-category">EQST (모의해킹 실습장)</div>
                                                        <div class="card-title">Web Hacking Training Center (Expert
                                                            Qualified Security Team)</div>
                                                        <div class="mt-2">
                                                            <span class="tag-badge"># EQST</span>
                                                            <span class="tag-badge"># 모의해킹</span>
                                                        </div>
                                                        <div class="progress-container">
                                                            <div class="progress">
                                                                <div class="progress-bar" style="width: 0%"></div>
                                                            </div>
                                                            <div class="d-flex justify-content-between mt-2">
                                                                <span class="progress-text" style="color:#999;">진행률
                                                                    0%</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-md-4">
                                                <div class="card card-custom">
                                                    <img src="/static/images/chi.webp" class="card-img-top"
                                                        alt="EQST">
                                                    <div class="card-body">
                                                        <div class="card-category">취업면접의 기초</div>
                                                        <div class="card-title">취업면접의 기초1</div>
                                                        <div class="mt-2">
                                                            <span class="tag-badge"># 취업면접</span>
                                                            <span class="tag-badge"># 합격 노하우</span>
                                                            <span class="tag-badge"># 면접의완성</span>
                                                        </div>
                                                        <div class="progress-container">
                                                            <div class="progress">
                                                                <div class="progress-bar" style="width: 0%"></div>
                                                            </div>
                                                            <div class="d-flex justify-content-between mt-2">
                                                                <span class="progress-text" style="color:#999;">진행률
                                                                    0%</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                </div>

            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>