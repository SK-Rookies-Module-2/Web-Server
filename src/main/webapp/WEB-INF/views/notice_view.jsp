<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>${notice.title} | We Lab Space</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link href="/static/css/welab.css" rel="stylesheet">
        </head>

        <body>
            <jsp:include page="/WEB-INF/views/common/nav.jsp" />

            <div class="container-custom mt-5">
                <div class="info-card p-5">
                    <div class="border-bottom pb-3 mb-4">
                        <span class="badge bg-secondary mb-2">${notice.category}</span>
                        <c:if test="${notice.is_important}"><span class="badge bg-danger">필독</span></c:if>

                        <h3 class="fw-bold">
                            ${notice.title}
                            <c:if test="${!notice.is_visible}">
                                <span class="badge bg-secondary ms-2" style="font-size: 0.5em; vertical-align: middle;">
                                    <i class="fas fa-eye-slash"></i> 비공개됨
                                </span>
                            </c:if>
                        </h3>

                        <div class="text-muted small mt-2">
                            <span><i class="fas fa-user me-1"></i> ${notice.writer}</span>
                            <span class="mx-2">|</span>
                            <span><i class="far fa-clock me-1"></i> ${notice.reg_date}</span>
                            <span class="mx-2">|</span>
                            <span><i class="far fa-eye me-1"></i> ${notice.views}</span>
                        </div>
                    </div>

                    <div class="mb-5" style="min-height: 200px; white-space: pre-wrap; line-height: 1.6;">${notice.content}</div>

                    <div class="d-flex justify-content-between">
                        <button class="btn btn-secondary"
                            onclick="location.href='/lecture_view?tab=notice'">목록으로</button>

                        <c:if test="${sessionScope.user_id == 'admin'}">
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline-dark"
                                    onclick="location.href='/board/notice/hide?no=${notice.no}'">
                                    <c:choose>
                                        <c:when test="${notice.is_visible}">
                                            <i class="fas fa-eye-slash"></i> 숨기기
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-eye"></i> 공개하기
                                        </c:otherwise>
                                    </c:choose>
                                </button>

                                <button class="btn btn-outline-primary"
                                    onclick="location.href='/board/notice/edit?no=${notice.no}'">수정</button>
                                <button class="btn btn-outline-danger" onclick="deleteNotice(${notice.no})">삭제</button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <script>
                function deleteNotice(no) {
                    if (confirm("정말 삭제하시겠습니까? 복구할 수 없습니다.")) {
                        location.href = '/board/notice/delete?no=' + no;
                    }
                }
            </script>
        </body>

        </html>