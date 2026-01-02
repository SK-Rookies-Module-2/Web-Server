<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>게시글 수정 | We Lab Space</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link href="/static/css/welab.css" rel="stylesheet">
        </head>

        <body class="bg-light">

            <nav class="navbar-welab">
                <div class="container d-flex justify-content-between align-items-center">
                    <a href="/dashboard">
                        <img src="/static/images/logo.png" alt="Luckies" style="height: 50px;">
                    </a>
                    <div class="text-white">
                        <strong>${sessionScope.user_name}</strong>님 환영합니다.
                    </div>
                </div>
            </nav>

            <div class="container mt-5">
                <div class="card shadow-sm p-4">
                    <%-- 🛡️ 보안 체크: 로그인 유저와 작성자가 일치하는 경우 --%>
                        <c:if test="${sessionScope.user_name eq post.writer}">
                            <div class="d-flex align-items-center mb-4">
                                <i class="fas fa-edit fa-2x text-primary me-3"></i>
                                <h3 class="fw-bold mb-0">스터디 게시글 수정</h3>
                            </div>

                            <form action="/study/post/edit" method="post">
                                <input type="hidden" name="post_no" value="${post.post_no}">
                                <input type="hidden" name="study_no" value="${post.study_no}">

                                <div class="mb-3">
                                    <label class="form-label fw-bold">제목</label>
                                    <input type="text" class="form-control" name="title" value="${post.title}" required>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold">내용</label>
                                    <textarea class="form-control" name="content" rows="10"
                                        required>${post.content}</textarea>
                                </div>

                                <div class="d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
                                    <button type="submit" class="btn btn-primary px-4 fw-bold">수정 완료</button>
                                </div>
                            </form>
                        </c:if>

                        <%-- ⚠️ 보안 체크: 작성자가 아닌 유저가 접근한 경우 --%>
                            <c:if test="${sessionScope.user_name ne post.writer}">
                                <div class="text-center py-5">
                                    <i class="fas fa-exclamation-triangle fa-4x text-danger mb-4"></i>
                                    <h2 class="fw-bold">접근 권한이 없습니다.</h2>
                                    <p class="text-muted">이 게시글은 작성자 본인만 수정할 수 있습니다.</p>
                                    <button type="button" class="btn btn-primary mt-3"
                                        onclick="location.href='/study/board?no=${post.study_no}'">
                                        목록으로 돌아가기
                                    </button>
                                </div>
                            </c:if>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>