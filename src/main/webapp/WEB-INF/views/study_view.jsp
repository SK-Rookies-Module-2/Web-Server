<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>${study.title} | 스터디 상세 보기</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
                    body,
                    html {
                        margin: 0;
                        padding: 0;
                        height: 100%;
                        overflow: hidden;
                    }

                    .fake-background {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background-color: #f4f7f9;
                        z-index: 1;
                    }

                    .modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.4);
                        backdrop-filter: blur(8px);
                        z-index: 2;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .modal-card {
                        background: white;
                        width: 700px;
                        max-width: 90%;
                        max-height: 85vh;
                        border-radius: 16px;
                        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
                        position: relative;
                        display: flex;
                        flex-direction: column;
                        overflow: hidden;
                        animation: modalAppear 0.3s ease-out;
                    }

                    @keyframes modalAppear {
                        from {
                            opacity: 0;
                            transform: translateY(20px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .btn-close-top {
                        position: absolute;
                        top: 20px;
                        right: 25px;
                        cursor: pointer;
                        font-size: 1.5rem;
                        color: #ccc;
                        z-index: 10;
                    }

                    .btn-close-top:hover {
                        color: #888;
                    }

                    .header-section {
                        padding: 40px 40px 10px;
                    }

                    .info-bar {
                        padding: 0 40px 15px;
                        display: flex;
                        justify-content: space-between;
                        border-bottom: 1px solid #f1f1f1;
                    }

                    .content-section {
                        padding: 25px 40px;
                        flex: 1;
                        overflow-y: auto;
                        min-height: 150px;
                    }

                    .member-section {
                        padding: 15px 40px;
                    }

                    .member-container {
                        background-color: #f8f9fa;
                        padding: 15px;
                        border-radius: 10px;
                    }

                    .member-tag {
                        border: 1px solid #e0e0e0;
                        background: white;
                        padding: 5px 12px;
                        border-radius: 20px;
                        font-size: 0.85rem;
                        margin: 0 4px 8px 0;
                        display: inline-block;
                    }

                    .footer-section {
                        padding: 0 40px 35px;
                        display: flex;
                        gap: 15px;
                    }

                    .btn-entry {
                        flex: 1;
                        padding: 12px;
                        font-weight: bold;
                        border-radius: 8px;
                    }

                    .btn-now {
                        background: #222;
                        color: white;
                        border: none;
                        padding: 8px 18px;
                        border-radius: 5px;
                        font-size: 0.85rem;
                    }
                </style>
            </head>

            <body>

                <div class="fake-background">
                    <nav style="height: 60px; background: #004a99; width: 100%;"></nav>
                    <div style="padding: 50px;">
                        <div style="width: 200px; height: 20px; background: #ddd; margin-bottom: 15px;"></div>
                        <div style="width: 100%; height: 400px; background: #eee;"></div>
                    </div>
                </div>

                <div class="modal-overlay" onclick="location.href='/lecture_view?tab=study'">
                    <div class="modal-card" onclick="event.stopPropagation()">
                        <div class="btn-close-top" onclick="location.href='/lecture_view?tab=study'">
                            <i class="fas fa-times"></i>
                        </div>

                        <div class="header-section">
                            <span
                                class="badge rounded-pill mb-2 ${study.status == '모집중' ? 'bg-danger' : 'bg-secondary'}">
                                ${study.status}
                            </span>
                            <h2 class="fw-bold mb-0">${study.title}</h2>
                        </div>

                        <div class="info-bar">
                            <div class="small fw-bold">
                                <span class="text-primary me-3">주 ${study.frequency}회</span>
                                <span class="text-primary">참여인원 / ${study.capacity}명</span>
                            </div>
                            <div class="text-muted small">
                                <i class="far fa-clock text-warning"></i> 등록일: ${study.reg_date}
                            </div>
                        </div>

                        <div class="content-section">
                            <div style="white-space: pre-wrap; line-height: 1.8; color: #444;">
                                <p class="fw-bold">[스터디 소개]</p>${study.content}
                            </div>
                        </div>

                        <div class="member-section">
                            <p class="small fw-bold mb-2">참여 멤버</p>
                            <div class="member-container">
                                <div class="d-flex flex-wrap">
                                    <c:choose>
                                        <c:when test="${not empty study.pre_members}">
                                            <c:set var="memberList" value="${fn:split(study.pre_members, ',')}" />
                                            <c:forEach var="name" items="${memberList}">
                                                <span class="member-tag border-primary text-primary">
                                                    <i class="fas fa-user-circle me-1"></i>${fn:trim(name)}
                                                </span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">현재 등록된 멤버가 없습니다.</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="footer-section">
                            <button class="btn btn-primary btn-entry"
                                onclick="location.href='/study/board?no=${study.no}'">
                                스터디 게시판 입장하기
                            </button>
                            <button class="btn-now" onclick="alert('곧 이동합니다!')">지금 이동</button>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>