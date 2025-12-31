<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>공지 수정 | We Lab Space</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="/static/css/welab.css" rel="stylesheet">
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
                        <a href="/logout" class="btn-nav"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
                    </div>

                </div>
            </nav>
            <div class="container-custom mt-5">
                <div class="info-card p-5">
                    <h3 class="fw-bold text-primary mb-4">공지사항 수정</h3>

                    <form action="/board/notice/edit" method="post">
                        <input type="hidden" name="no" value="${notice.no}">

                        <div class="row mb-3">
                            <div class="col-md-3">
                                <label class="form-label fw-bold">분류</label>
                                <select class="form-select" name="category">
                                    <option value="안내" ${notice.category=='안내' ? 'selected' : '' }>안내</option>
                                    <option value="특강" ${notice.category=='특강' ? 'selected' : '' }>특강</option>
                                    <option value="자료" ${notice.category=='자료' ? 'selected' : '' }>자료</option>
                                    <option value="과제" ${notice.category=='과제' ? 'selected' : '' }>과제</option>
                                </select>
                            </div>
                            <div class="col-md-9">
                                <label class="form-label fw-bold">제목</label>
                                <input type="text" class="form-control" name="title" value="${notice.title}" required>
                            </div>
                        </div>

                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="isImportant" name="isImportant"
                                value="true" ${notice.is_important ? 'checked' : '' }>
                            <label class="form-check-label fw-bold text-danger" for="isImportant">중요 공지</label>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">내용</label>
                            <textarea class="form-control" name="content" rows="10"
                                required>${notice.content}</textarea>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
                            <button type="submit" class="btn btn-primary px-5 fw-bold">수정 완료</button>
                        </div>
                    </form>
                </div>
            </div>
        </body>

        </html>