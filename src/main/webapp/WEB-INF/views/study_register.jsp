<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>스터디그룹 등록 | We Lab Space</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="/static/css/welab.css" rel="stylesheet">
        <style>
            /* 툴바 및 에디터 스타일 */
            .editor-toolbar {
                border: 1px solid #ced4da;
                border-bottom: none;
                background-color: #f8f9fa;
                padding: 8px;
                border-radius: 5px 5px 0 0;
                display: flex;
                gap: 15px;
                color: #555;
            }

            .editor-toolbar i {
                cursor: pointer;
            }

            .editor-textarea {
                border: 1px solid #ced4da;
                border-radius: 0 0 5px 5px;
                padding: 20px;
            }
        </style>
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
                    <a href="javascript:void(0);" class="btn-nav" onclick="handleLogout()"><i
                            class="fas fa-sign-out-alt"></i> 로그아웃</a>

                    <script>
                        function handleLogout() {
                            localStorage.removeItem("accessToken");
                            alert("로그아웃 되었습니다.");
                            location.href = "/logout";
                        }
                    </script>
                </div>

            </div>
        </nav>
        <div class="container mt-5">
            <h4 class="fw-bold text-primary mb-4">스터디그룹 등록</h4>

            <div class="card p-4 shadow-sm border-0">
                <form action="/study/register" method="post">
                    <div class="d-flex mb-3 gap-2">
                        <input type="text" class="form-control" name="title" placeholder="제목을 입력하세요." required
                            style="flex: 3;">

                        <div class="input-group" style="flex: 1;">
                            <span class="input-group-text bg-white">주</span>
                            <input type="number" class="form-control text-center" name="frequency" value="1" required>
                            <span class="input-group-text bg-white">회</span>
                        </div>

                        <div class="input-group" style="flex: 1;">
                            <input type="number" class="form-control text-center" name="capacity" value="4" required>
                            <span class="input-group-text bg-white">명</span>
                        </div>
                    </div>

                    <div class="editor-toolbar">
                        <span><strong>H1</strong></span>
                        <span><strong>H2</strong></span>
                        <i class="fas fa-bold"></i>
                        <i class="fas fa-italic"></i>
                        <i class="fas fa-underline"></i>
                        <span class="border-end mx-1"></span>
                        <i class="fas fa-align-left"></i>
                        <i class="fas fa-align-center"></i>
                        <i class="fas fa-align-right"></i>
                        <span class="border-end mx-1"></span>
                        <i class="fas fa-quote-right"></i>
                        <i class="fas fa-link"></i>
                    </div>

                    <textarea class="form-control editor-textarea shadow-none" name="content" rows="15"
                        placeholder="내용을 입력하세요." required style="border-top: none;"></textarea>

                    <div class="mt-3">
                        <input type="text" class="form-control" name="pre_members"
                            placeholder="사전에 모집된 멤버가 있을 경우 작성해주세요. (ex. 강감찬, 이순신)">
                    </div>

                    <div class="d-flex justify-content-center gap-2 mt-4">
                        <button type="button" class="btn btn-outline-primary px-4"
                            onclick="history.back()">돌아가기</button>
                        <button type="submit" class="btn btn-primary px-5">등록</button>
                    </div>
                </form>
            </div>
        </div>
    </body>

    </html>