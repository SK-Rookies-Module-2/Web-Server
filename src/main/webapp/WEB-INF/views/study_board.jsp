<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>${study.title} | 스터디 게시판</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
                    body {
                        background-color: #f8f9fa;
                        font-family: 'Pretendard', sans-serif;
                    }

                    .main-container {
                        max-width: 1200px;
                        margin: 40px auto;
                        background: white;
                        padding: 40px;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
                    }

                    .status-badge {
                        background-color: #e8f5e9;
                        color: #2e7d32;
                        padding: 4px 12px;
                        border-radius: 20px;
                        font-size: 0.8rem;
                        font-weight: bold;
                    }

                    .study-title {
                        font-size: 1.5rem;
                        font-weight: 700;
                        margin-top: 10px;
                        color: #004a99;
                    }

                    .member-grid {
                        display: grid;
                        grid-template-columns: repeat(8, 1fr);
                        gap: 10px;
                        margin-top: 20px;
                    }

                    .member-item {
                        border: 1px solid #ddd;
                        padding: 5px;
                        text-align: center;
                        border-radius: 5px;
                        font-size: 0.8rem;
                        color: #666;
                        background: #fdfdfd;
                    }

                    .search-section {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-top: 40px;
                        margin-bottom: 20px;
                    }

                    .search-box {
                        display: flex;
                        gap: 0;
                        border: 1px solid #dee2e6;
                        border-radius: 5px;
                        overflow: hidden;
                        width: 400px;
                    }

                    .search-box select {
                        border: none;
                        padding: 10px;
                        background: #f8f9fa;
                        border-right: 1px solid #dee2e6;
                        outline: none;
                    }

                    .search-box input {
                        border: none;
                        padding: 10px;
                        flex: 1;
                        outline: none;
                    }

                    .btn-write {
                        background-color: #0d6efd;
                        color: white;
                        border: none;
                        padding: 10px 25px;
                        border-radius: 5px;
                        font-weight: bold;
                    }

                    .table thead {
                        background-color: #fff;
                        border-top: 2px solid #333;
                    }

                    .table th {
                        color: #333;
                        font-weight: 600;
                        padding: 15px;
                        text-align: center;
                    }

                    .table td {
                        padding: 15px;
                        vertical-align: middle;
                        text-align: center;
                        color: #555;
                        border-bottom: 1px solid #eee;
                    }

                    .text-start-title {
                        text-align: left !important;
                    }

                    .post-link {
                        text-decoration: none;
                        color: inherit;
                        transition: color 0.2s;
                    }

                    .post-link:hover {
                        color: #0d6efd;
                        font-weight: 600;
                    }

                    .bottom-banner {
                        background-color: #e3f2fd;
                        padding: 30px;
                        border-radius: 15px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-top: 50px;
                    }

                    .btn-move {
                        background-color: #004a99;
                        color: white;
                        border: none;
                        padding: 10px 25px;
                        border-radius: 5px;
                    }

                    .btn-scroll-top {
                        position: fixed;
                        bottom: 30px;
                        left: 50%;
                        transform: translateX(-50%);
                        width: 50px;
                        height: 50px;
                        background-color: #ff80ab;
                        color: white;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/WEB-INF/views/common/nav.jsp" />
                <div class="main-container">
                    <div class="d-flex justify-content-between">
                        <div>
                            <span class="status-badge">${study.status}</span>
                            <h1 class="study-title">${study.title}</h1>
                        </div>
                        <div class="text-end text-primary fw-bold" style="font-size: 0.9rem;">
                            주 ${study.frequency}회 | 15 / ${study.capacity} <i class="fas fa-list ms-3 text-dark"></i>
                        </div>
                    </div>

                    <div class="member-grid">
                        <c:set var="memberList" value="${fn:split(study.pre_members, ',')}" />
                        <c:forEach var="name" items="${memberList}">
                            <div class="member-item">${fn:trim(name)}</div>
                        </c:forEach>
                    </div>

                    <div class="text-center mt-3 text-muted"><i class="fas fa-chevron-down"></i></div>

                    <div class="search-section">
                        <div class="search-box">
                            <select name="searchType">
                                <option>작성자</option>
                            </select>
                            <input type="text" placeholder="검색어를 입력하세요.">
                            <button class="btn border-0"><i class="fas fa-search text-muted"></i></button>
                        </div>
                        <button class="btn-write" data-bs-toggle="modal" data-bs-target="#writeModal">
                            글쓰기 <i class="fas fa-pen ms-1"></i>
                        </button>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>작성자</th>
                                <th class="text-start-title" style="width: 40%;">제목</th>
                                <th>작성일</th>
                                <th>조회</th>
                                <%-- 🟢 관리 컬럼 추가 --%>
                                    <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="post" items="${postList}">
                                <tr>
                                    <td>${post.post_no}</td>
                                    <td>${post.writer}</td>
                                    <td class="text-start-title">
                                        <a href="/study/post/detail?postNo=${post.post_no}" class="post-link">
                                            ${post.title}
                                        </a>
                                        <c:if test="${not empty post.file_name}">
                                            <a href="/static/images/${post.file_name}" target="_blank">
                                                <i class="fas fa-file-alt text-primary ms-2"></i>
                                            </a>
                                        </c:if>
                                    </td>
                                    <td>${fn:substring(post.reg_date, 0, 10)}</td>
                                    <td>0</td>
                                    <td>
                                        <div class="d-flex justify-content-center gap-2">
                                            <%-- ✅ 내가 쓴 글일 때만 '수정/삭제' 버튼 노출 (UX상 안전해 보임) --%>
                                                <c:if test="${sessionScope.user_name eq post.writer}">
                                                    <a href="/study/post/edit?no=${post.post_no}"
                                                        class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-edit"></i> 수정
                                                    </a>
                                                    <a href="/study/post/delete?no=${post.post_no}&studyNo=${study.no}"
                                                        class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('정말 삭제하시겠습니까?')">
                                                        <i class="fas fa-trash"></i> 삭제
                                                    </a>
                                                </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty postList}">
                                <tr>
                                    <%-- 🟢 colspan을 6으로 수정 (관리 컬럼 포함) --%>
                                        <td colspan="6" class="text-center py-5 text-muted">등록된 게시글이 없습니다.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>

                    <div class="bottom-banner">
                        <div>
                            <div class="small text-muted mb-1">안녕하세요 ~ ${sessionScope.user_name}님.</div>
                            <div class="fw-bold">인터랙티브 코딩 실습장에서 실시간으로 협업하며 보안 감각을 키우세요!</div>
                        </div>
                        <button class="btn-move">지금 이동</button>
                    </div>
                </div>

                <div class="btn-scroll-top"><i class="fas fa-chevron-up"></i></div>

                <%-- 글쓰기 및 파일 업로드 모달 --%>
                    <div class="modal fade" id="writeModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
                                <form action="/study/upload" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="no" value="${study.no}">
                                    <div class="modal-header border-0 px-4 pt-4">
                                        <h5 class="fw-bold">스터디 자료 공유하기</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body px-4">
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold">제목</label>
                                            <input type="text" name="title" class="form-control"
                                                placeholder="제목을 입력하세요." required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold">내용</label>
                                            <textarea name="content" class="form-control" rows="4"
                                                placeholder="내용을 입력하세요."></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold">파일 첨부 (취약점 실습)</label>
                                            <input type="file" name="file" class="form-control">
                                            <div class="form-text text-danger">※ 확장자 검사가 없는 취약한 업로드 폼입니다.</div>
                                        </div>
                                    </div>
                                    <div class="modal-footer border-0 px-4 pb-4">
                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
                                        <button type="submit" class="btn btn-primary px-4">등록하기</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>