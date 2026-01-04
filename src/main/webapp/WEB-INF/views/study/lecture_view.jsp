<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>강의실 | We Lab Space</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

            <link href="/static/css/lecture.css" rel="stylesheet">
        </head>

        <body>
            <jsp:include page="/WEB-INF/views/common/nav.jsp" />

            <div class="course-banner">
                <div class="container-custom">
                    <div class="row align-items-center">
                        <div class="col-md-2">
                            <img src="/static/images/mainImage.webp" class="rounded shadow-sm"
                                style="width:100%; height:130px; object-fit:cover;">
                        </div>
                        <div class="col-md-6 ps-4">
                            <small class="text-primary fw-bold">루키즈 AI 보안 28기</small>
                            <h4 class="fw-bold mt-1">${courseTitle}</h4>
                            <div class="mt-2 mb-3">
                                <span class="course-tag"># 생성형 AI</span>
                                <span class="course-tag"># 융합보안</span>
                            </div>
                            <div class="progress"
                                style="height: 10px; border-radius: 5px; background-color: #eeeeee; width: 80%;">
                                <div class="progress-bar" style="width: ${progress}%"></div>
                            </div>
                            <div class="d-flex mt-2">
                                <small class="text-primary fw-bold">진행률 ${progress}%</small>
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="mb-2">
                                <button class="btn btn-outline-primary px-4 me-2 fw-bold">강의실 입장</button>
                                <button class="btn btn-orange px-4 fw-bold">강의 자료실</button>
                            </div>
                            <small class="text-muted">
                                <i class="far fa-clock text-warning"></i> 2025-10-23 ~ 2026-04-17
                            </small>
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

            <div class="container-custom mt-4 mb-5" style="min-height: 500px;">
                <jsp:include page="tabs/${currentTab}.jsp" />
            </div>

            <div class="lms-footer">
                <h5 class="fw-bold">LMS WE LAB SPACE</h5>
                <small class="text-white-50">COPYRIGHT © 2025 WELABSPACE. ALL RIGHTS RESERVED.</small>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>