<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>강의실 | We Lab Space</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link href="/static/css/welab.css" rel="stylesheet">
            <link href="/static/css/roadmap.css" rel="stylesheet">
            <style>
                .search-box-group {
                    display: flex;
                    gap: 5px;
                    align-items: center;
                }

                .form-select-sm {
                    width: auto;
                    display: inline-block;
                    border-color: #ddd;
                }

                .form-control-sm {
                    display: inline-block;
                    width: 200px;
                    border-color: #ddd;
                }

                .btn-blue-fill {
                    background-color: #0066cc;
                    color: white;
                    border: none;
                    font-weight: bold;
                    font-size: 0.9rem;
                    padding: 6px 15px;
                    border-radius: 4px;
                }

                .btn-blue-fill:hover {
                    background-color: #0056b3;
                    color: white;
                }

                /* 탭 버튼 스타일 재정의 (페이지 이동 방식이므로) */
                .lecture-tabs .nav-link {
                    cursor: pointer;
                }
            </style>
        </head>

        <body>
            <nav class="navbar-welab">
                <div class="d-flex align-items-center">
                    <img src="https://placehold.co/180x45/004d9d/ffffff?text=SK+Rookies+x+WELAB" alt="Logo"
                        style="height: 40px; margin-right: 20px;">
                </div>
                <div class="d-flex align-items-center">
                    <div class="user-badge"><i class="fas fa-check-circle"></i> 루키즈 AI 보안 28기</div>
                    <span class="text-white me-4" style="font-size:0.95rem;"><strong>
                            <%= session.getAttribute("user_name") %>
                        </strong>님 환영합니다.</span>
                    <a href="/dashboard" class="btn-nav me-2"><i class="fas fa-home"></i> 홈</a>
                    <a href="/myinfo?id=<%= session.getAttribute(" user_id") %>" class="btn-nav me-2"><i
                            class="fas fa-user"></i> 내 정보</a>
                    <a href="/logout" class="btn-nav"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
                </div>
            </nav>

            <div class="course-banner">
                <div class="container-custom">
                    <div class="row align-items-center">
                        <div class="col-md-3">
                            <img src="/static/images/mainImage.webp" class="rounded img-fluid"
                                style="width:100%; height:160px; object-fit:cover; border:1px solid #eee;">
                        </div>
                        <div class="col-md-9 ps-4">
                            <small class="text-primary fw-bold">루키즈 AI 보안 28기</small>
                            <h3 class="fw-bold mt-2 mb-3">생성형 AI 활용 사이버보안 전문인력 양성과정 28기</h3>
                            <div class="d-flex justify-content-between align-items-end">
                                <div style="width: 70%;">
                                    <div class="mb-3"><span class="course-tag"># 생성형 AI</span><span class="course-tag">#
                                            융합보안</span></div>
                                    <div class="progress" style="height: 8px; background-color: #e9ecef;">
                                        <div class="progress-bar bg-warning" style="width: 39%"></div>
                                    </div>
                                    <div class="d-flex justify-content-between mt-2"><small
                                            class="text-primary fw-bold">진행률 39%</small></div>
                                </div>
                                <div class="text-end">
                                    <div class="mb-2"><button class="btn btn-outline-primary me-2">강의실
                                            입장</button><button class="btn btn-orange">강의 자료실</button></div>
                                    <small class="text-muted"><i class="far fa-clock text-warning"></i> 2025-10-23 ~
                                        2026-04-17</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="lecture-nav-container">
                <div class="container-custom">
                    <ul class="nav nav-tabs lecture-tabs">
                        <li class="nav-item">
                            <a class="nav-link ${currentTab == 'roadmap' ? 'active' : ''}"
                                href="/lecture_view?tab=roadmap">과정로드맵</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentTab == 'schedule' ? 'active' : ''}"
                                href="/lecture_view?tab=schedule">교육일정</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentTab == 'notice' ? 'active' : ''}"
                                href="/lecture_view?tab=notice">공지</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentTab == 'assignment' ? 'active' : ''}"
                                href="/lecture_view?tab=assignment">과제</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentTab == 'evaluation' ? 'active' : ''}"
                                href="/lecture_view?tab=evaluation">과정평가</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentTab == 'study' ? 'active' : ''}"
                                href="/lecture_view?tab=study">스터디그룹</a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="container-custom mt-4 mb-5">
                <jsp:include page="tabs/${currentTab}.jsp" />
            </div>

            <div class="text-center py-4 bg-dark text-white mt-5">
                <h4>LMS WE LAB SPACE</h4>
                <small class="text-white-50">COPYRIGHT © 2025 WELABSPACE. ALL RIGHTS RESERVED.</small>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>