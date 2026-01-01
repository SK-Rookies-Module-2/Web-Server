<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>홈 | We Lab Space</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="/static/css/welab.css" rel="stylesheet">
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/common/nav.jsp" />
        <div class="container-custom mt-5">
            <div class="p-4 mb-4 bg-light rounded-3 d-flex justify-content-between align-items-center"
                style="background: #eef4fb;">
                <div>
                    <h4 class="fw-bold text-primary">지능형 애플리케이션 개발자 양성과정 5기 모집 중</h4>
                    <p class="text-muted mb-0">단계별 훈련으로 개발 역량 강화</p>
                </div>
                <button class="btn btn-primary btn-sm">바로가기</button>
            </div>

            <h5 class="text-primary fw-bold mb-3">수강중인 과정 <span class="badge bg-light text-dark border">Total :
                    2</span>
            </h5>

            <div class="row">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body p-0">
                            <img src="/static/images/mainImage.webp" class="card-img-top" alt="AI Security"
                                style="height: 160px; object-fit: cover;">
                            <div class="p-3">
                                <h6 class="fw-bold">생성형 AI 활용 사이버보안 전문가</h6>
                                <div class="d-flex justify-content-between small text-muted mt-3 mb-1">
                                    <span>진행률 39%</span>
                                    <span>2025.10 ~ 2026.04</span>
                                </div>
                                <div class="progress" style="height: 6px;">
                                    <div class="progress-bar bg-warning" style="width: 39%"></div>
                                </div>
                                <a href="/lecture_view" class="btn btn-login mt-3 w-100">강의실 입장</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body p-0">
                            <img src="/static/images/hackingTraining.webp" class="card-img-top" alt="AI Security"
                                style="height: 160px; object-fit: cover;">
                            <div class="p-3">
                                <h6 class="fw-bold">Web Hacking Training Center</h6>
                                <div class="d-flex justify-content-between small text-muted mt-3 mb-1">
                                    <span>진행률 0%</span>
                                </div>
                                <div class="progress" style="height: 6px;">
                                    <div class="progress-bar bg-light" style="width: 0%"></div>
                                </div>
                                <button class="btn btn-outline-secondary mt-3 w-100" disabled>오픈 예정</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>