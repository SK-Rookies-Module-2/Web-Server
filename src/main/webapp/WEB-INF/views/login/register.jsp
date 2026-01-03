<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>회원가입 | We Lab Space LMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
            rel="stylesheet">
        <style>
            body {
                background-color: #004a99;
                font-family: 'Noto Sans KR', sans-serif;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }

            .register-wrapper {
                width: 100%;
                max-width: 500px;
                position: relative;
                margin-top: 40px;
                margin-bottom: 100px;
            }

            .header-area {
                display: flex;
                justify-content: space-between;
                align-items: flex-end;
                padding-bottom: 10px;
                margin-bottom: -15px;
                z-index: 10;
                position: relative;
            }

            .top-logo {
                height: 40px;
                margin-bottom: 15px;
            }

            .character-img {
                height: 120px;
                margin-right: 10px;
            }

            .register-card {
                background-color: #ffffff;
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                position: relative;
                z-index: 5;
            }

            .register-title {
                color: #004a99;
                font-weight: 700;
                font-size: 1.6rem;
                margin-bottom: 25px;
            }

            .form-label {
                font-size: 0.85rem;
                color: #6c757d;
                font-weight: 500;
                margin-bottom: 5px;
            }

            .custom-input {
                background-color: #f1f3f5;
                border: 1px solid transparent;
                border-radius: 8px;
                padding: 10px 15px;
                margin-bottom: 15px;
            }

            .custom-input:focus {
                border-color: #004a99;
                box-shadow: 0 0 0 3px rgba(0, 74, 153, 0.1);
                outline: none;
                background-color: #fff;
            }

            .btn-register {
                background-color: #004a99;
                color: white;
                font-weight: 700;
                padding: 12px;
                border-radius: 8px;
                width: 100%;
                border: none;
                margin-top: 15px;
            }

            .btn-close-pink {
                position: absolute;
                bottom: -70px;
                left: 50%;
                transform: translateX(-50%);
                width: 45px;
                height: 45px;
                background-color: #ff99cc;
                border-radius: 50%;
                color: white;
                border: none;
                cursor: pointer;
            }
        </style>
    </head>

    <body>
        <div class="register-wrapper">
            <div class="header-area">
                <img src="/static/images/lms_logo_white.png" alt="Logo" class="top-logo">
                <img src="/static/images/character.png" alt="Character" class="character-img">
            </div>
            <div class="register-card">
                <h1 class="register-title">회원가입</h1>
                <form action="/registerAction" method="post">
                    <label class="form-label">아이디</label>
                    <input type="text" name="id" class="form-control custom-input" placeholder="사용할 아이디 입력" required>

                    <label class="form-label">비밀번호</label>
                    <input type="password" name="pw" class="form-control custom-input" placeholder="비밀번호 입력" required>

                    <label class="form-label">이름</label>
                    <input type="text" name="name" class="form-control custom-input" placeholder="실명 입력" required>

                    <label class="form-label">이메일</label>
                    <input type="email" name="email" class="form-control custom-input" placeholder="example@welab.com"
                        required>

                    <label class="form-label">휴대전화</label>
                    <input type="text" name="phone" class="form-control custom-input" placeholder="010-0000-0000"
                        required>

                    <button type="submit" class="btn-register">가입하기</button>
                </form>
                <button class="btn-close-pink" onclick="location.href='/'"><i class="fas fa-times"></i></button>
            </div>
        </div>
    </body>

    </html>