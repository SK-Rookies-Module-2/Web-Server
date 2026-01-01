<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <nav class="navbar-welab">
        <div class="container d-flex justify-content-between align-items-center">

            <div class="d-flex align-items-center">
                <a href="${pageContext.request.contextPath}/dashboard">
                    <img src="${pageContext.request.contextPath}/static/images/logo.png" alt="Luckies"
                        style="height: 50px;">
                </a>
            </div>

            <div class="d-flex align-items-center">
                <div class="user-badge-capsule me-3">
                    <i class="fas fa-check-circle me-1"></i> 럭키즈 AI 보안 28기
                </div>

                <span class="text-white me-4">
                    <strong>
                        <%= session.getAttribute("user_name") %>
                    </strong>님 환영합니다.
                </span>

                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn-nav-white">
                        <i class="fas fa-home"></i> 홈
                    </a>
                    <a href="${pageContext.request.contextPath}/myinfo?id=<%= session.getAttribute("user_id") %>"
                        class="btn-nav-white">
                        <i class="fas fa-user"></i> 내 정보
                    </a>
                    <a href="javascript:void(0);" class="btn-nav-white" onclick="handleLogout()">
                        <i class="fas fa-sign-out-alt"></i> 로그아웃
                    </a>
                </div>
            </div>
        </div>
    </nav>