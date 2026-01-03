<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>비밀번호 변경 | We Lab Space</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/myinfo.css">
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/common/nav.jsp" />

        <div class="main-wrapper">
            <div class="info-card" style="width: 550px;">
                <div class="page-title">비밀번호 변경</div>
                <div class="pink-dot"></div>

                <form id="pwForm">
                    <div class="form-group-custom">
                        <p class="form-label-small">현재 비밀번호</p>
                        <input type="password" name="currentPw" id="currentPw" class="input-underline"
                            placeholder="현재 비밀번호를 입력하세요.">
                    </div>
                    <div class="form-group-custom">
                        <p class="form-label-small">새 비밀번호</p>
                        <input type="password" name="newPw" id="newPw" class="input-underline"
                            placeholder="새 비밀번호를 입력하세요.">
                    </div>
                    <div class="form-group-custom">
                        <p class="form-label-small">새 비밀번호 확인</p>
                        <input type="password" id="confirmPw" class="input-underline"
                            placeholder="새 비밀번호를 한 번 더 입력하세요.">
                    </div>

                    <div class="btn-group-bottom">
                        <button type="button" class="btn-custom btn-white" onclick="history.back()">취소</button>
                        <button type="button" class="btn-custom btn-blue" onclick="submitPwChange()">비밀번호 변경</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function submitPwChange() {
                const currentPw = document.getElementById('currentPw').value;
                const newPw = document.getElementById('newPw').value;
                const confirmPw = document.getElementById('confirmPw').value;

                if (!currentPw || !newPw || !confirmPw) {
                    alert("모든 필드를 입력해주세요.");
                    return;
                }
                if (newPw !== confirmPw) {
                    alert("새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
                    return;
                }

                // 전송 데이터 구성
                const params = new URLSearchParams();
                params.append('currentPw', currentPw);
                params.append('newPw', newPw);

                fetch('${pageContext.request.contextPath}/user/updatePassword', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString() // URLSearchParams가 자동으로 인코딩을 처리해줍니다.
                }).then(async res => {
                    if (res.ok) {
                        alert("비밀번호가 변경되었습니다. 다시 로그인해주세요.");
                        localStorage.removeItem("accessToken");
                        location.href = "${pageContext.request.contextPath}/";
                    } else {
                        const errorMsg = await res.text(); // 서버에서 보낸 에러 메시지 확인
                        alert("실패: " + errorMsg);
                    }
                }).catch(err => {
                    console.error("Error:", err);
                    alert("서버 통신 중 오류가 발생했습니다.");
                });
            }
        </script>
    </body>

    </html>