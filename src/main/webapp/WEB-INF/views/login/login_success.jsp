<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <script>
        // 컨트롤러에서 보낸 jwtToken을 가져옴
        const token = "${jwtToken}";

        if (token) {
            localStorage.setItem("accessToken", token);
        }

        // 대시보드로 이동
        location.href = "/dashboard";
    </script>