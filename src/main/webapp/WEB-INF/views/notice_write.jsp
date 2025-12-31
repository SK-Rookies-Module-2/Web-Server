<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>공지사항 등록 | We Lab Space</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                <h3 class="fw-bold text-danger mb-4"><i class="fas fa-bullhorn"></i> 공지사항 등록</h3>

                <form action="/board/notice/write" method="post">
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label class="form-label fw-bold">분류</label>
                            <select class="form-select" name="category">
                                <option value="안내">안내</option>
                                <option value="특강">특강</option>
                                <option value="자료">자료</option>
                                <option value="보안">보안</option>
                            </select>
                        </div>
                        <div class="col-md-9">
                            <label class="form-label fw-bold">제목</label>
                            <input type="text" class="form-control" name="title" placeholder="제목을 입력하세요" required>
                        </div>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="isImportant" name="isImportant"
                            value="true">
                        <label class="form-check-label fw-bold text-danger" for="isImportant">중요 공지 (상단 고정)</label>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">내용</label>
                        <textarea class="form-control" name="content" rows="10" required></textarea>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
                        <button type="submit" class="btn btn-danger px-5 fw-bold">등록하기</button>
                    </div>
                </form>
            </div>
        </div>
    </body>

    </html>