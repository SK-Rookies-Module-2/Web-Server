<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>계정 찾기 | We Lab Space LMS</title>

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
                    justify-content: center;
                    align-items: center;
                    padding: 20px;
                    margin: 0;
                }

                .find-wrapper {
                    width: 100%;
                    max-width: 460px;
                    position: relative;
                }

                /* 캐릭터 및 헤더 영역 */
                .header-area {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-end;
                    margin-bottom: -15px;
                    position: relative;
                    z-index: 10;
                }

                .top-logo {
                    height: 40px;
                    margin-bottom: 15px;
                }

                .character-img {
                    height: 120px;
                    filter: drop-shadow(0 5px 5px rgba(0, 0, 0, 0.1));
                }

                /* 카드 설정 */
                .find-card {
                    background-color: #ffffff;
                    border-radius: 20px;
                    padding: 40px;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                    position: relative;
                    z-index: 5;
                }

                /* 탭 디자인 커스텀 */
                .nav-pills {
                    background-color: #f1f3f5;
                    border-radius: 10px;
                    padding: 5px;
                    margin-bottom: 30px;
                }

                .nav-pills .nav-link {
                    color: #6c757d;
                    font-weight: 500;
                    border-radius: 8px;
                    flex: 1;
                    text-align: center;
                    border: none;
                }

                .nav-pills .nav-link.active {
                    background-color: #004a99;
                    color: white;
                }

                /* 입력 필드 스타일 */
                .form-label {
                    font-size: 0.85rem;
                    color: #6c757d;
                    font-weight: 600;
                    margin-bottom: 5px;
                }

                .custom-input {
                    background-color: #f1f3f5;
                    border: 1px solid transparent;
                    border-radius: 8px;
                    padding: 12px;
                    margin-bottom: 20px;
                    width: 100%;
                }

                .custom-input:focus {
                    background-color: #fff;
                    border-color: #004a99;
                    box-shadow: 0 0 0 3px rgba(0, 74, 153, 0.1);
                    outline: none;
                }

                .btn-find {
                    background-color: #004a99;
                    color: white;
                    font-weight: 700;
                    padding: 14px;
                    border-radius: 8px;
                    width: 100%;
                    border: none;
                    transition: 0.2s;
                }

                .btn-find:hover {
                    background-color: #003377;
                }

                /* 하단 X 버튼 */
                .close-btn-container {
                    position: absolute;
                    bottom: -80px;
                    left: 0;
                    width: 100%;
                    text-align: center;
                }

                .btn-close-pink {
                    width: 45px;
                    height: 45px;
                    background-color: #ff99cc;
                    border-radius: 50%;
                    color: white;
                    border: none;
                    cursor: pointer;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                    display: inline-flex;
                    justify-content: center;
                    align-items: center;
                }
            </style>
        </head>

        <body>

            <div class="find-wrapper">
                <div class="header-area">
                    <img src="/static/images/lms_logo_white.png" alt="Logo" class="top-logo"
                        onerror="this.style.display='none';">
                    <img src="/static/images/character.png" alt="Character" class="character-img"
                        onerror="this.src='https://placehold.co/120x120/png?text=CH';">
                </div>

                <div class="find-card">
                    <ul class="nav nav-pills" id="pills-tab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="id-tab" data-bs-toggle="pill" data-bs-target="#find-id"
                                type="button" role="tab">아이디 찾기</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="pw-tab" data-bs-toggle="pill" data-bs-target="#find-pw"
                                type="button" role="tab">비밀번호 찾기</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="pills-tabContent">
                        <div class="tab-pane fade show active" id="find-id" role="tabpanel">
                            <form action="/findIdAction" method="post">
                                <div class="text-start">
                                    <label class="form-label">이름</label>
                                    <input type="text" name="name" class="form-control custom-input"
                                        placeholder="가입하신 이름 입력" required>

                                    <label class="form-label">이메일</label>
                                    <input type="email" name="email" class="form-control custom-input"
                                        placeholder="가입하신 이메일 입력" required>
                                </div>
                                <button type="submit" class="btn-find">아이디 찾기</button>
                            </form>
                        </div>

                        <div class="tab-pane fade" id="find-pw" role="tabpanel">
                            <form action="/findPwAction" method="post">
                                <div class="text-start">
                                    <label class="form-label">아이디 (Access Id)</label>
                                    <input type="text" name="id" class="form-control custom-input"
                                        placeholder="가입하신 아이디 입력" required>

                                    <label class="form-label">이메일</label>
                                    <input type="email" name="email" class="form-control custom-input"
                                        placeholder="가입하신 이메일 입력" required>
                                </div>
                                <button type="submit" class="btn-find">임시 비밀번호 발급</button>
                            </form>
                        </div>
                    </div>

                    <div class="close-btn-container">
                        <button class="btn-close-pink" onclick="location.href='/'">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <script>
                window.onload = function () {
                    // 컨트롤러에서 보낸 msg가 있을 경우 alert 실행
                    <c:if test="${not empty msg}">
                        alert("${msg}");

                        // 성공 메시지(아이디 확인 또는 초기화 완료)일 경우 로그인 페이지로 이동
                        const message = "${msg}";
                        if (message.includes("입니다") || message.includes("초기화")) {
                            location.href = "/";
                }
                    </c:if>
                };
            </script>
        </body>

        </html>