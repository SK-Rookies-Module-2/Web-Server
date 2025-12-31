<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <style>
            /* 평가 탭 전용 스타일 (이 파일에서만 쓰임) */
            .eval-card {
                background-color: #fff;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02);
                height: 100%;
            }

            .eval-info-text {
                font-size: 0.8rem;
                color: #888;
                margin-bottom: 5px;
            }

            .eval-title {
                font-size: 1.1rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 10px;
            }

            .eval-date-badge {
                background-color: #999;
                color: white;
                border-radius: 12px;
                padding: 3px 10px;
                font-size: 0.75rem;
                margin-right: 5px;
            }

            .text-primary-custom {
                color: #004d9d !important;
            }

            .bg-primary-custom {
                background-color: #004d9d !important;
            }

            .btn-eval-status {
                width: 60px;
                height: 60px;
                border-radius: 4px;
                border: 1px solid #ddd;
                background-color: #f8f9fa;
                color: #888;
                font-weight: bold;
                font-size: 0.9rem;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .btn-eval-status.active {
                color: #004d9d;
                border-color: #004d9d;
                background-color: white;
            }

            .badge-blue {
                background-color: #0056b3;
                color: white;
                padding: 6px 15px;
                border-radius: 20px;
                font-weight: bold;
                font-size: 0.8rem;
            }

            .badge-gray {
                background-color: #eee;
                color: #aaa;
                padding: 6px 15px;
                border-radius: 20px;
                font-weight: bold;
                font-size: 0.8rem;
            }

            .btn-detail-blue {
                background-color: #0066cc;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 5px 15px;
                font-size: 0.85rem;
                font-weight: bold;
            }

            .btn-detail-gray {
                background-color: #f5f5f5;
                color: #ccc;
                border: 1px solid #eee;
                border-radius: 4px;
                padding: 5px 15px;
                font-size: 0.85rem;
            }

            .icon-gray {
                color: #555;
                font-size: 1rem;
            }

            .icon-light {
                color: #ddd;
                font-size: 1rem;
            }
        </style>

        <div id="evaluation">
            <div class="row g-3 mb-4">
                <c:forEach var="eval" items="${evalList}">
                    <div class="col-md-6">
                        <div class="eval-card d-flex justify-content-between align-items-center">
                            <div>
                                <c:choose>
                                    <c:when test="${eval.status == '평가 완료'}">
                                        <div class="eval-info-text text-muted">${eval.subject} 60문항 - 40분</div>
                                        <div class="eval-title">${eval.eval_name}가 종료되었습니다.</div>
                                        <span class="eval-date-badge">평가일 ${eval.exam_date}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="eval-info-text text-primary-custom">${eval.subject} 90문항 - 40분</div>
                                        <div class="eval-title text-primary-custom">${eval.eval_name}는 준비중입니다.</div>
                                        <span class="eval-date-badge bg-primary-custom">평가일 ${eval.exam_date}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-end">
                                <c:choose>
                                    <c:when test="${eval.status == '평가 완료'}">
                                        <div class="mb-2 text-muted"><i class="fas fa-microphone"></i> <i
                                                class="far fa-comment-dots ms-2"></i></div>
                                        <button class="btn-eval-status">종료</button>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mb-2 text-primary-custom"><i class="fas fa-microphone"></i> <i
                                                class="far fa-comment-dots ms-2"></i></div>
                                        <button class="btn-eval-status active">준비중</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="d-flex justify-content-center mb-5"><button class="btn btn-primary px-4 py-2 fw-bold">개인 과정평가
                    리포트</button></div>

            <table class="table-welab table-hover text-center" style="border-top:2px solid #ddd;">
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
                                <c:choose>
                                    <c:when test="${eval.status == '평가 완료'}"><span class="badge-blue">평가 완료</span>
                                    </c:when>
                                    <c:otherwise><span class="badge-gray">준비중</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-start text-muted">${eval.subject}</td>
                            <td class="text-muted">${eval.eval_name}</td>
                            <td class="text-muted">${eval.exam_date}</td>
                            <td class="text-muted">${eval.avg_score}</td>
                            <td class="text-muted">${eval.my_score}</td>
                            <td><i class="fas fa-microphone ${eval.has_feedback ? 'icon-gray' : 'icon-light'}"></i></td>
                            <td><i class="far fa-file-alt ${eval.has_file ? 'icon-gray' : 'icon-light'}"></i></td>
                            <td><i class="far fa-comment-dots ${eval.has_meeting ? 'icon-gray' : 'icon-light'}"></i>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${eval.status == '평가 완료'}"><button
                                            class="btn-detail-blue">자세히</button></c:when>
                                    <c:otherwise><button class="btn-detail-gray">자세히</button></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>