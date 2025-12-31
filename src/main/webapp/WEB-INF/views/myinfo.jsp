<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>내 정보 | We Lab Space</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="/static/css/welab.css" rel="stylesheet">
    </head>

    <body>
        <nav class="navbar-welab">
            <div class="d-flex align-items-center">
                <img src="/static/images/Logo.png" alt="SK Rookies x WELAB" style="height: 50px; margin-right: 20px;">
            </div>
            <div class="d-flex align-items-center">
                <div class="user-badge">
                    <i class="fas fa-check-circle"></i> 루키즈 AI 보안 28기
                </div>
                <span class="text-white me-4" style="font-size:0.95rem;"><strong>
                        <%= session.getAttribute("user_name") %>
                    </strong>님 환영합니다.</span>

                <a href="/dashboard" class="btn-nav me-2"><i class="fas fa-home"></i> 홈</a>
                <a href="/myinfo?id=<%= session.getAttribute(" user_id") %>" class="btn-nav me-2"><i
                        class="fas fa-user"></i> 내 정보</a>
                <a href="/logout" class="btn-nav"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
            </div>
        </nav>

        <div class="tab-container">
            <ul class="nav nav-pills" id="pills-tab" role="tablist">
                <li class="nav-item"><button class="nav-link active" id="pills-home-tab" data-bs-toggle="pill"
                        data-bs-target="#pills-home">회원정보 수정</button></li>
                <li class="nav-item"><button class="nav-link" id="pills-aws-tab" data-bs-toggle="pill"
                        data-bs-target="#pills-aws">학습 계정 정보</button></li>
                <li class="nav-item"><button class="nav-link" id="pills-att-tab" data-bs-toggle="pill"
                        data-bs-target="#pills-att">출석 정보</button></li>
            </ul>
        </div>

        <div class="info-card">
            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade show active" id="pills-home">
                    <div class="page-title">회원정보</div>
                    <div class="point-box"><span>보유 포인트 <span class="fs-5 ms-2">${point}</span></span><button
                            class="btn btn-sm btn-outline-secondary rounded-pill px-3">누적현황 보기</button></div>
                    <div class="form-section-title">정보수정</div>
                    <div class="mb-4"><label class="form-label">아이디</label><input type="text" readonly
                            class="form-control-plaintext border-bottom" value="${userId}"></div>
                    <div class="mb-4"><label class="form-label">닉네임</label><input type="text" class="form-control"
                            value="${userName}"></div>
                    <div class="mb-4"><label class="form-label">이메일</label><input type="text"
                            class="form-control bg-light" value="${userEmail}" readonly></div>
                    <div class="mb-4"><label class="form-label">휴대전화</label><input type="text"
                            class="form-control-plaintext border-bottom fs-4" value="${userPhone}"></div>
                    <div class="btn-group-custom"><button class="btn btn-outline">취소</button><button
                            class="btn btn-blue">변경</button></div>
                </div>

                <div class="tab-pane fade" id="pills-aws">
                    <div class="page-title">학습 계정 정보</div>
                    <div class="mb-5 mt-5 px-5">
                        <div class="mb-4"><label class="form-label small">AWS 계정</label>
                            <div class="fs-5 text-secondary">${awsAccount}</div>
                            <hr class="mt-1 text-muted">
                        </div>
                        <div class="mb-4"><label class="form-label small">IAM user</label>
                            <div class="fs-5 text-secondary">${iamUser}</div>
                            <hr class="mt-1 text-muted">
                        </div>
                        <div class="mb-4"><label class="form-label small">AWS 초기 패스워드</label>
                            <div class="fs-5 text-secondary">${awsPass}</div>
                            <hr class="mt-1 text-muted">
                        </div>
                        <div class="mb-4"><label class="form-label small">리전</label>
                            <div class="fs-5 text-secondary">${region}</div>
                            <hr class="mt-1 text-muted">
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="pills-att">
                    <div class="page-title">출석 정보</div>
                    <div class="d-flex justify-content-between small mb-1 fw-bold"><span>이수율
                            ${attendRate}%</span><span>2025-12-23 ~ 2026-01-22</span></div>
                    <div class="progress" style="height: 10px;">
                        <div class="progress-bar bg-warning" style="width: ${attendRate}%"></div>
                    </div>
                    <table class="table table-bordered text-center small mt-4">
                        <thead class="bg-light">
                            <tr>
                                <th class="text-danger">일</th>
                                <th>월</th>
                                <th>화</th>
                                <th>수</th>
                                <th>목</th>
                                <th>금</th>
                                <th class="text-primary">토</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-danger">30</td>
                                <td>1</td>
                                <td>2</td>
                                <td>3</td>
                                <td>4</td>
                                <td>5</td>
                                <td class="text-primary">6</td>
                            </tr>
                            <tr>
                                <td class="text-danger">7</td>
                                <td class="bg-primary bg-opacity-10 text-primary fw-bold">출석</td>
                                <td class="bg-primary bg-opacity-10 text-primary fw-bold">출석</td>
                                <td class="bg-primary bg-opacity-10 text-primary fw-bold">출석</td>
                                <td class="bg-primary bg-opacity-10 text-primary fw-bold">출석</td>
                                <td class="bg-warning bg-opacity-25 fw-bold">-</td>
                                <td class="text-primary">13</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="text-center pb-4">
            <h4 style="color:#004d9d; font-weight:bold;">LMS <span style="font-weight:300">WE LAB SPACE</span></h4>
            <small class="text-muted">COPYRIGHT © 2025 WELABSPACE. ALL RIGHTS RESERVED.</small>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>