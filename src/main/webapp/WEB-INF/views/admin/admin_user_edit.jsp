<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>사용자 정보 수정 | Luckies LMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Pretendard', sans-serif;
            }

            .edit-container {
                max-width: 600px;
                margin: 80px auto;
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .form-label {
                font-weight: 600;
                color: #495057;
            }

            .input-readonly {
                background-color: #e9ecef !important;
                cursor: not-allowed;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/common/nav.jsp" />
        <div class="edit-container">
            <h3 class="fw-bold mb-4 text-center"><i class="fas fa-user-edit text-primary me-2"></i>사용자 정보 수정</h3>

            <form action="/admin/user/edit" method="post">
                <div class="mb-3">
                    <label class="form-label">사용자 아이디</label>
                    <input type="text" class="form-control input-readonly" name="id" value="${user.id}" readonly>
                </div>
                <div class="row mb-3">
                    <div class="col">
                        <label class="form-label">이름</label>
                        <input type="text" class="form-control" name="name" value="${user.name}" required>
                    </div>
                    <div class="col">
                        <label class="form-label">리전</label>
                        <input type="text" class="form-control" name="region" value="${user.region}">
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">이메일 주소</label>
                    <input type="email" class="form-control" name="email" value="${user.email}" required>
                </div>
                <div class="mb-3 p-3 rounded" style="background: #f1f3f5;">
                    <label class="form-label text-primary"><i class="fab fa-aws me-1"></i>AWS 계정 번호</label>
                    <input type="text" class="form-control mb-2" name="awsAccount" value="${user.awsAccount}">
                    <label class="form-label text-danger"><i class="fas fa-key me-1"></i>AWS 비밀번호</label>
                    <input type="text" class="form-control" name="awsPw" value="${user.awsPw}">
                </div>

                <div class="d-grid gap-2 mt-4">
                    <button type="submit" class="btn btn-primary btn-lg fw-bold">정보 업데이트</button>
                    <a href="/admin/users" class="btn btn-link text-secondary">취소하고 돌아가기</a>
                </div>
            </form>
        </div>
    </body>

    </html>