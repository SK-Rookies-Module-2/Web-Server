<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>관리자 전용 | Luckies LMS</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                body {
                    background-color: #f8f9fa;
                    font-family: 'Pretendard', -apple-system, sans-serif;
                }

                .main-container {
                    max-width: 1200px;
                    margin: 50px auto;
                    background: white;
                    padding: 40px;
                    border-radius: 15px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
                }

                .admin-header {
                    border-bottom: 2px solid #eee;
                    padding-bottom: 20px;
                    margin-bottom: 30px;
                }

                .admin-title {
                    font-size: 1.8rem;
                    font-weight: 700;
                    color: #333;
                }

                .table thead {
                    background-color: #f1f3f5;
                    border-top: 2px solid #333;
                }

                .table th {
                    font-weight: 600;
                    color: #495057;
                    text-align: center;
                    padding: 15px;
                }

                .table td {
                    padding: 15px;
                    vertical-align: middle;
                    text-align: center;
                    color: #555;
                    font-size: 0.95rem;
                }

                .text-aws-account {
                    color: #0d6efd;
                    font-family: 'Consolas', monospace;
                }

                .text-aws-pw {
                    color: #dc3545;
                    font-family: 'Consolas', monospace;
                    background: #fff5f5;
                    padding: 2px 6px;
                    border-radius: 4px;
                }

                .btn-back {
                    border-radius: 8px;
                    padding: 10px 25px;
                    font-weight: 600;
                }
            </style>
        </head>

        <body>
            <jsp:include page="/WEB-INF/views/common/nav.jsp" />
            <div class="main-container">
                <div class="admin-header d-flex justify-content-between align-items-center">
                    <h1 class="admin-title"><i class="fas fa-user-shield text-primary me-2"></i>사용자 관리 시스템</h1>
                    <div class="text-end">
                        <span class="text-muted small">Total Users</span>
                        <h3 class="fw-bold text-dark">${userList.size()}</h3>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>AWS 계정</th>
                                <th>AWS PW</th>
                                <th>리전</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${userList}">
                                <tr>
                                    <td class="fw-bold">${user.id}</td>
                                    <td>${user.name}</td>
                                    <td>${user.email}</td>
                                    <td><code class="text-aws-account">${user.awsAccount}</code></td>
                                    <td><code class="text-aws-pw">${user.awsPw}</code></td>
                                    <td><span class="badge bg-light text-dark border">${user.region}</span></td>
                                    <td>
                                        <a href="/admin/user/edit?id=${user.id}"
                                            class="btn btn-sm btn-outline-primary px-3">
                                            <i class="fas fa-edit me-1"></i>수정
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="text-center mt-5">
                    <a href="/dashboard" class="btn btn-outline-secondary btn-back">대시보드로 돌아가기</a>
                </div>
            </div>
        </body>

        </html>