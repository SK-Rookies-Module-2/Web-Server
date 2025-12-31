<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>게시판 | We Lab Space</title>
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

            <div class="container-custom mt-5">
                <h3 class="fw-bold text-primary mb-4"><i class="fas fa-comments"></i> 자유 질문 게시판</h3>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="input-group" style="width: 300px;">
                        <input type="text" class="form-control" placeholder="검색어를 입력하세요">
                        <button class="btn btn-outline-secondary"><i class="fas fa-search"></i></button>
                    </div>

                    <div class="d-flex gap-2">
                        <c:if test="${sessionScope.user_id == 'admin'}">
                            <button onclick="location.href='/board/write?type=notice'" class="btn btn-danger fw-bold">
                                <i class="fas fa-bullhorn"></i> 공지사항 등록
                            </button>
                        </c:if>

                        <button onclick="location.href='/board/write'" class="btn btn-blue-fill">
                            <i class="fas fa-pen"></i> 질문 등록하기
                        </button>
                    </div>
                </div>

                <div style="border-top: 1px solid #333;"></div>

                <table class="table-welab table-hover text-center" style="border-top:none;">
                    <thead>
                        <tr>
                            <th style="width:10%">No</th>
                            <th style="width:10%">구분</th>
                            <th style="width:45%">제목</th>
                            <th style="width:15%">작성자</th>
                            <th style="width:15%">작성일</th>
                            <th style="width:5%">조회</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="table-light fw-bold" style="cursor:pointer;"
                            onclick="location.href='/board/view?id=100'">
                            <td><span class="badge bg-danger">공지</span></td>
                            <td class="text-danger">필독</td>
                            <td class="text-start">3월 보안 교육 일정 변경 안내</td>
                            <td>관리자</td>
                            <td>2025-12-31</td>
                            <td>999</td>
                        </tr>

                        <tr style="cursor:pointer;" onclick="location.href='/board/view?id=1'">
                            <td>1</td>
                            <td>질문</td>
                            <td class="text-start">로그인이 안되는데 저만 그런가요?</td>
                            <td>김루키</td>
                            <td>2025-12-30</td>
                            <td>12</td>
                        </tr>
                    </tbody>
                </table>

                <div class="d-flex justify-content-center mt-4">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li class="page-item disabled"><a class="page-link" href="#"><i
                                        class="fas fa-chevron-left"></i></a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>

            <div class="text-center py-4 bg-dark text-white mt-5">
                <h4>LMS WE LAB SPACE</h4>
                <small class="text-white-50">COPYRIGHT © 2025 WELABSPACE. ALL RIGHTS RESERVED.</small>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>