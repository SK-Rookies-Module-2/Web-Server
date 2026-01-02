<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JSTL 태그 라이브러리 추가 (메시지 처리를 위해 필요) --%>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>스터디그룹 등록 | We Lab Space</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link href="/static/css/welab.css" rel="stylesheet">
                <style>
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
                <jsp:include page="/WEB-INF/views/common/nav.jsp" />

                <div class="container mt-5">
                    <h4 class="fw-bold text-primary mb-4">스터디그룹 등록</h4>

                    <div class="card p-4 shadow-sm border-0">
                        <%-- 컨트롤러의 @PostMapping("/study/register")와 일치 --%>
                            <form action="/study/register" method="post">
                                <div class="d-flex mb-3 gap-2">
                                    <input type="text" class="form-control" name="title" placeholder="제목을 입력하세요."
                                        required style="flex: 3;">

                                    <div class="input-group" style="flex: 1;">
                                        <span class="input-group-text bg-white">주</span>
                                        <%-- String으로 전달되어도 컨트롤러에서 잘 받도록 name 확인 --%>
                                            <input type="number" class="form-control text-center" name="frequency"
                                                value="1" required>
                                            <span class="input-group-text bg-white">회</span>
                                    </div>

                                    <div class="input-group" style="flex: 1;">
                                        <input type="number" class="form-control text-center" name="capacity" value="4"
                                            required>
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
                                    <%-- 사전 모집 멤버 입력 필드 --%>
                                        <input type="text" class="form-control" name="pre_members"
                                            placeholder="사전에 모집된 멤버가 있을 경우 작성해주세요. (쉼표로 구분: 강감찬, 이순신)">
                                </div>

                                <div class="d-flex justify-content-center gap-2 mt-4">
                                    <button type="button" class="btn btn-outline-primary px-4"
                                        onclick="history.back()">돌아가기</button>
                                    <button type="submit" class="btn btn-primary px-5">등록</button>
                                </div>
                            </form>
                    </div>
                </div>

                <%-- 🟢 추가된 부분: 컨트롤러에서 보낸 에러 메시지(msg)가 있을 경우 알림창 띄우기 --%>
                    <c:if test="${not empty msg}">
                        <script>
                            alert("${msg}");
                        </script>
                    </c:if>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>