<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>공지사항 등록 | We Lab Space</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="/static/css/welab.css" rel="stylesheet">
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/common/nav.jsp" />

        <div class="container-custom mt-5">
            <div class="info-card p-5">
                <h3 class="fw-bold text-danger mb-4"><i class="fas fa-bullhorn"></i> 공지사항 등록</h3>

                <form action="/board/notice/write" method="post">
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label class="form-label fw-bold">분류</label>
                            <select class="form-select" name="category">
                                <option value="안내">안내</option>
                                <option value="특강">특강</option>
                                <option value="자료">자료</option>
                                <option value="보안">보안</option>
                            </select>
                        </div>
                        <div class="col-md-9">
                            <label class="form-label fw-bold">제목</label>
                            <input type="text" class="form-control" name="title" placeholder="제목을 입력하세요" required>
                        </div>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="isImportant" name="isImportant"
                            value="true">
                        <label class="form-check-label fw-bold text-danger" for="isImportant">중요 공지 (상단 고정)</label>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">내용</label>
                        <textarea class="form-control" name="content" rows="10" required></textarea>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
                        <button type="submit" class="btn btn-danger px-5 fw-bold">등록하기</button>
                    </div>
                </form>
            </div>
        </div>
    </body>

    </html>