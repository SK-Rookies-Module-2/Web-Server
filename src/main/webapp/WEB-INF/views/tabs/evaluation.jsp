<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/evaluation.css">

        <div id="evaluation">
            <div class="row g-4 mb-5">
                <c:forEach var="eval" items="${evalList}">
                    <div class="col-md-6">
                        <div class="eval-card">
                            <div>
                                <c:choose>
                                    <c:when test="${eval.status == '평가 완료'}">
                                        <div class="eval-info-text">${eval.subject} 60문항 - 40분</div>
                                        <div class="eval-title">${eval.eval_name}가 <br>종료되었습니다.</div>
                                        <span class="eval-date-badge">평가일 ${eval.exam_date}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="eval-info-text text-primary-custom">${eval.subject} 90문항 - 40분</div>
                                        <div class="eval-title text-primary-custom">${eval.eval_name}는 <br>준비중입니다.</div>
                                        <span class="eval-date-badge bg-primary-custom">평가일 ${eval.exam_date}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-end">
                                <div class="mb-3 ${eval.status == '평가 완료' ? 'text-muted' : 'text-primary-custom'}">
                                    <i class="fas fa-microphone"></i>
                                    <i class="far fa-comment-dots ms-2"></i>
                                </div>
                                <button class="btn-eval-status ${eval.status != '평가 완료' ? 'active' : ''}">
                                    ${eval.status == '평가 완료' ? '종료' : '준비중'}
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="d-flex justify-content-center mb-5">
                <button class="btn btn-primary px-5 py-3 fw-bold shadow-sm" style="border-radius: 10px;">
                    개인 과정평가 리포트
                </button>
            </div>

            <table class="table-welab table-hover text-center">
                <thead>
                    <tr>
                        <th>상태</th>
                        <th>교과목명</th>
                        <th>과정평가명</th>
                        <th>응시일자</th>
                        <th>전체평균</th>
                        <th>내점수</th>
                        <th>피드백</th>
                        <th>문제풀이</th>
                        <th>1대1미팅</th>
                        <th>자세히</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="eval" items="${evalList}">
                        <tr>
                            <td>
                                <span class="${eval.status == '평가 완료' ? 'badge-blue' : 'badge-gray'}">
                                    ${eval.status == '평가 완료' ? '평가 완료' : '준비중'}
                                </span>
                            </td>
                            <td class="text-start text-muted"
                                style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                ${eval.subject}
                            </td>
                            <td class="text-muted">${eval.eval_name}</td>
                            <td class="text-muted">${eval.exam_date}</td>
                            <td class="text-muted">${eval.avg_score}</td>
                            <td class="text-muted">${eval.my_score}</td>
                            <td><i class="fas fa-microphone ${eval.has_feedback ? 'icon-gray' : 'icon-light'}"></i></td>
                            <td><i class="far fa-file-alt ${eval.has_file ? 'icon-gray' : 'icon-light'}"></i></td>
                            <td><i class="far fa-comment-dots ${eval.has_meeting ? 'icon-gray' : 'icon-light'}"></i>
                            </td>
                            <td>
                                <button
                                    class="${eval.status == '평가 완료' ? 'btn-detail-blue' : 'btn-detail-gray'}">자세히</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>