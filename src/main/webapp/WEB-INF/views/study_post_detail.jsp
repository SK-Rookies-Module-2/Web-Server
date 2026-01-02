<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${post.title} | 상세보기</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                body {
                    background-color: #f8f9fa;
                    font-family: 'Pretendard', sans-serif;
                }

                .detail-container {
                    max-width: 900px;
                    margin: 50px auto;
                    background: white;
                    padding: 40px;
                    border-radius: 15px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
                }

                .post-header {
                    border-bottom: 2px solid #eee;
                    padding-bottom: 20px;
                    margin-bottom: 30px;
                }

                .post-title {
                    font-size: 2rem;
                    font-weight: 700;
                    color: #333;
                }

                .post-info {
                    color: #888;
                    font-size: 0.9rem;
                    margin-top: 10px;
                }

                .post-content {
                    min-height: 300px;
                    line-height: 1.8;
                    color: #444;
                    font-size: 1.1rem;
                    white-space: pre-wrap;
                }

                .file-box {
                    background: #f1f3f5;
                    padding: 15px;
                    border-radius: 8px;
                    margin-top: 30px;
                }
            </style>
        </head>

        <body>
            <div class="detail-container">
                <div class="post-header">
                    <h1 class="post-title">${post.title}</h1>
                    <div class="post-info">
                        <span><i class="fas fa-user"></i> ${post.writer}</span>
                        <span class="ms-3"><i class="fas fa-calendar-alt"></i> ${post.reg_date}</span>
                    </div>
                </div>

                <div class="post-content">${post.content}</div>

                <c:if test="${not empty post.file_name}">
                    <div class="file-box">
                        <strong><i class="fas fa-paperclip"></i> 첨부 파일:</strong>
                        <a href="/study/download?fileName=${post.file_name}" class="ms-2 text-primary font-weight-bold">
                            ${post.file_name}
                        </a>
                    </div>
                </c:if>

                <div class="text-center mt-5">
                    <button class="btn btn-outline-secondary px-4" onclick="history.back()">목록으로</button>
                    <%-- IDOR 실습을 위해 study_no를 사용하여 게시판으로 돌아감 --%>
                        <button class="btn btn-primary px-4 ms-2"
                            onclick="location.href='/study/board?no=${post.study_no}'">게시판으로</button>
                </div>
            </div>
        </body>

        </html>