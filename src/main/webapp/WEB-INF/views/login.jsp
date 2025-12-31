<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>로그인 | We Lab Space LMS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
            rel="stylesheet">

        <style>
            /* 1. 기본 설정 */
            body {
                background-color: #004a99;
                font-family: 'Noto Sans KR', sans-serif;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                margin: 0;
                padding: 20px;
            }

            /* 2. 메인 래퍼 */
            .login-wrapper {
                width: 100%;
                max-width: 460px;
                position: relative;
                /* [수정됨] 닫기 버튼 공간 확보를 위해 하단 여백을 대폭 늘림 (50px -> 130px) */
                margin-bottom: 130px;
            }

            /* 3. 상단 헤더 영역 */
            .header-area {
                display: flex;
                justify-content: space-between;
                align-items: flex-end;
                padding-bottom: 10px;
                position: relative;
                z-index: 10;
                margin-bottom: -15px;
            }

            .top-logo {
                height: 40px;
                margin-bottom: 15px;
            }

            .character-img {
                height: 140px;
                margin-right: 10px;
                filter: drop-shadow(0 5px 5px rgba(0, 0, 0, 0.1));
            }

            /* 4. 로그인 카드 */
            .login-card {
                background-color: #ffffff;
                border-radius: 20px;
                padding: 50px 40px 40px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                position: relative;
                z-index: 5;
                width: 100%;
            }

            .login-title {
                color: #004a99;
                font-weight: 700;
                font-size: 1.8rem;
                margin-bottom: 30px;
                text-align: left;
            }

            /* 5. 입력 필드 */
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
                padding: 12px 15px;
                font-size: 1rem;
                color: #333;
                transition: all 0.2s;
            }

            .custom-input::placeholder {
                color: #adb5bd;
                font-size: 0.9rem;
            }

            .custom-input:focus {
                background-color: #ffffff;
                border-color: #004a99;
                box-shadow: 0 0 0 3px rgba(0, 74, 153, 0.1);
                outline: none;
            }

            .password-container {
                position: relative;
            }

            .toggle-password {
                position: absolute;
                top: 50%;
                right: 15px;
                transform: translateY(-50%);
                cursor: pointer;
                color: #adb5bd;
            }

            /* 6. 로그인 버튼 */
            .btn-login {
                background-color: #004a99;
                color: white;
                font-size: 1.1rem;
                font-weight: 700;
                padding: 14px;
                border-radius: 8px;
                width: 100%;
                border: none;
                margin-top: 20px;
                transition: background-color 0.2s;
            }

            .btn-login:hover {
                background-color: #003377;
            }

            /* 7. 하단 안내 및 닫기 버튼 */
            .help-text {
                font-size: 0.8rem;
                color: #004a99;
                margin-top: 20px;
                line-height: 1.5;
                text-align: center;
            }

            .close-btn-container {
                position: absolute;
                /* 카드 바로 아래에 위치 */
                bottom: -80px;
                left: 0;
                width: 100%;
                text-align: center;
            }

            .btn-close-pink {
                display: inline-flex;
                justify-content: center;
                align-items: center;
                width: 45px;
                height: 45px;
                background-color: #ff99cc;
                border-radius: 50%;
                color: white;
                font-size: 1.2rem;
                border: none;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                transition: transform 0.2s;
                cursor: pointer;
            }

            .btn-close-pink:hover {
                transform: scale(1.1);
            }

            /* 8. 푸터 */
            .footer {
                /* 상단 여백 제거 (wrapper의 마진이 밀어줌) */
                margin-top: 0;
                text-align: center;
                color: rgba(255, 255, 255, 0.6);
                font-size: 0.7rem;
                padding-bottom: 30px;
            }

            .footer-logo {
                height: 18px;
                margin-top: 8px;
                opacity: 0.8;
            }

            @media (max-width: 576px) {
                .header-area {
                    margin-bottom: -10px;
                }

                .character-img {
                    height: 110px;
                }

                .top-logo {
                    height: 30px;
                }

                .login-card {
                    padding: 40px 25px 30px;
                }

                .login-title {
                    font-size: 1.5rem;
                }
            }
        </style>
    </head>

    <body>

        <div class="login-wrapper">
            <div class="header-area">
                <img src="/static/images/lms_logo_white.png" alt="We Lab Space" class="top-logo"
                    onerror="this.style.display='none';">
                <img src="/static/images/character.png" alt="Character" class="character-img"
                    onerror="this.src='https://placehold.co/120x130/png?text=CH';">
            </div>

            <div class="login-card">
                <h1 class="login-title">로그인</h1>

                <form action="/loginAction" method="post">
                    <div class="mb-3 text-start">
                        <label for="id" class="form-label">Access Id</label>
                        <input type="text" class="form-control custom-input" id="id" name="id" placeholder="ID"
                            required>
                    </div>

                    <div class="mb-4 text-start">
                        <label for="pw" class="form-label">Password</label>
                        <div class="password-container">
                            <input type="password" class="form-control custom-input" id="pw" name="pw"
                                placeholder="●●●●●●●●●●" required>
                            <i class="far fa-eye toggle-password" id="togglePassword"></i>
                        </div>
                    </div>

                    <button type="submit" class="btn-login">로그인</button>
                </form>

                <p class="help-text">
                    암호를 잃어 버리셨거나 아이디를 가지고 있지 않으시면<br>
                    운영팀에게 문의해주세요.
                </p>

                <div class="close-btn-container">
                    <button class="btn-close-pink" onclick="history.back()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="footer">
            <p class="mb-0">COPYRIGHT © 2025 WELABSPACE. ALL RIGHTS RESERVED.</p>
            <img src="/static/images/lms_logo_small.png" alt="LMS" class="footer-logo"
                onerror="this.style.display='none';">
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const toggleBtn = document.getElementById('togglePassword');
            const pwInput = document.getElementById('pw');
            toggleBtn.addEventListener('click', function () {
                const type = pwInput.getAttribute('type') === 'password' ? 'text' : 'password';
                pwInput.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });
        </script>
    </body>

    </html>