<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>로그인 | We Lab Space</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="/static/css/welab.css" rel="stylesheet">
    </head>

    <body class="login-body">
        <div class="login-card">
            <div class="text-center mb-4">
                <img src="https://placehold.co/240x60/004d9d/ffffff?text=WE+LAB+SPACE" alt="Logo" style="height: 50px;">
            </div>
            <h4 class="mb-4 fw-bold text-start">로그인</h4>
            <form action="/loginAction" method="POST">
                <div class="mb-3 text-start">
                    <label class="small text-muted">Access Id</label>
                    <input type="text" name="id" class="form-control" placeholder="아이디 입력" required>
                </div>
                <div class="mb-4 text-start">
                    <label class="small text-muted">Password</label>
                    <input type="password" name="pw" class="form-control" placeholder="비밀번호 입력" required>
                </div>
                <button type="submit" class="btn-login">로그인</button>
            </form>
            <div class="mt-3 small text-muted">아이디/비밀번호 찾기 | 회원가입 문의</div>
        </div>
    </body>

    </html>