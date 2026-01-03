<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>접근 거부 | We Lab Space</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light">
        <div class="container vh-100 d-flex align-items-center justify-content-center">
            <div class="text-center p-5 shadow bg-white rounded-4">
                <h2 class="fw-bold text-danger">🚫 접근 권한이 없습니다.</h2>
                <p class="text-muted mt-3">${msg}</p>
                <hr>
                <p>공지사항 작성은 <strong>관리자(JWT role: admin)</strong>만 가능합니다.</p>
                <button onclick="history.back()" class="btn btn-primary mt-3">뒤로 가기</button>
            </div>
        </div>
    </body>

    </html>