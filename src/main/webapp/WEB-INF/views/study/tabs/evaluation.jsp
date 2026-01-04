<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div id="evaluation-section">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/evaluation.css">

            <div class="row g-4 mb-5">
                <div class="col-md-6">
                    <div class="eval-card shadow-sm status-end">
                        <div class="eval-body">
                            <div class="eval-info-text text-muted">생성형 AI 활용한 보안 프로그래밍 기초 60문항 - 40분</div>
                            <div class="eval-title">1차 사전평가가 <br>종료되었습니다.</div>
                            <span class="eval-date-badge">평가일 2025-10-27</span>
                        </div>
                        <div class="eval-footer text-end">
                            <div class="eval-icons mb-4 text-muted"><i class="fas fa-microphone"></i><i
                                    class="far fa-comment-dots ms-2"></i></div>
                            <button class="btn-eval-status">종료</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="eval-card shadow-sm status-end">
                        <div class="eval-body">
                            <div class="eval-info-text text-muted">생성형 AI 활용한 보안 프로그래밍 기초 60문항 - 30분</div>
                            <div class="eval-title">1차 사후평가가 <br>종료되었습니다.</div>
                            <span class="eval-date-badge">평가일 2025-11-18</span>
                        </div>
                        <div class="eval-footer text-end">
                            <div class="eval-icons mb-4 text-muted"><i class="fas fa-microphone"></i><i
                                    class="far fa-comment-dots ms-2"></i></div>
                            <button class="btn-eval-status">종료</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="eval-card shadow-sm status-end">
                        <div class="eval-body">
                            <div class="eval-info-text text-muted">생성형 AI 활용한 보안 응용 95문항 - 30분</div>
                            <div class="eval-title">2차 사전평가가 <br>종료되었습니다.</div>
                            <span class="eval-date-badge">평가일 2025-11-27</span>
                        </div>
                        <div class="eval-footer text-end">
                            <div class="eval-icons mb-4 text-muted"><i class="fas fa-microphone"></i><i
                                    class="far fa-comment-dots ms-2"></i></div>
                            <button class="btn-eval-status">종료</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="eval-card shadow-sm status-end">
                        <div class="eval-body">
                            <div class="eval-info-text text-muted">생성형 AI 활용한 보안 응용 95문항 - 40분</div>
                            <div class="eval-title">2차 사후평가가 <br>종료되었습니다.</div>
                            <span class="eval-date-badge">평가일 2025-12-29</span>
                        </div>
                        <div class="eval-footer text-end">
                            <div class="eval-icons mb-4 text-muted"><i class="fas fa-microphone"></i><i
                                    class="far fa-comment-dots ms-2"></i></div>
                            <button class="btn-eval-status">종료</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="eval-card shadow-sm status-ready">
                        <div class="eval-body">
                            <div class="eval-info-text text-primary-custom">생성형 AI 활용한 보안 심화 60문항 - 40분</div>
                            <div class="eval-title text-primary-custom">3차 사전평가는 <br>준비중입니다.</div>
                            <span class="eval-date-badge bg-primary-custom">평가일 2026-01-06</span>
                        </div>
                        <div class="eval-footer text-end">
                            <div class="eval-icons mb-4 text-primary-custom"><i class="fas fa-microphone"></i><i
                                    class="far fa-comment-dots ms-2"></i></div>
                            <button class="btn-eval-status active">준비중</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="eval-card shadow-sm status-ready">
                        <div class="eval-body">
                            <div class="eval-info-text text-primary-custom">생성형 AI 활용한 보안 심화 40문항 - 40분</div>
                            <div class="eval-title text-primary-custom">3차 사후평가는 <br>준비중입니다.</div>
                            <span class="eval-date-badge bg-primary-custom">평가일 2026-02-10</span>
                        </div>
                        <div class="eval-footer text-end">
                            <div class="eval-icons mb-4 text-primary-custom"><i class="fas fa-microphone"></i><i
                                    class="far fa-comment-dots ms-2"></i></div>
                            <button class="btn-eval-status active">준비중</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center mb-5">
                <button class="btn report-btn px-5 py-3 fw-bold shadow-sm text-white">개인 과정평가 리포트</button>
            </div>

            <div class="table-responsive">
                <table class="table-welab table-hover text-center w-100">
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
                        <tr>
                            <td><span class="badge rounded-pill badge-blue">평가 완료</span></td>
                            <td class="text-start">생성형 AI 활용한 보안 프로그래밍 기초</td>
                            <td class="text-muted">1차 사전평가</td>
                            <td class="text-muted">2025-10-27</td>
                            <td class="fw-bold">63</td>
                            <td class="fw-bold text-primary">68</td>
                            <td><i class="fas fa-microphone icon-gray"></i></td>
                            <td>-</td>
                            <td><i class="far fa-comment-dots icon-gray"></i></td>
                            <td><button class="btn-detail btn-detail-blue">자세히</button></td>
                        </tr>
                        <tr>
                            <td><span class="badge rounded-pill badge-blue">평가 완료</span></td>
                            <td class="text-start">생성형 AI 활용한 보안 프로그래밍 기초</td>
                            <td class="text-muted">1차 사후평가</td>
                            <td class="text-muted">2025-11-18</td>
                            <td class="fw-bold">78</td>
                            <td class="fw-bold text-primary">78</td>
                            <td><i class="fas fa-microphone icon-gray"></i></td>
                            <td><i class="far fa-file-alt icon-gray"></i></td>
                            <td><i class="far fa-comment-dots icon-gray"></i></td>
                            <td><button class="btn-detail btn-detail-blue">자세히</button></td>
                        </tr>
                        <tr>
                            <td><span class="badge rounded-pill badge-blue">평가 완료</span></td>
                            <td class="text-start">생성형 AI 활용한 보안 응용</td>
                            <td class="text-muted">2차 사전평가</td>
                            <td class="text-muted">2025-11-27</td>
                            <td class="fw-bold">65</td>
                            <td class="fw-bold text-primary">72</td>
                            <td><i class="fas fa-microphone icon-gray"></i></td>
                            <td>-</td>
                            <td><i class="far fa-comment-dots icon-gray"></i></td>
                            <td><button class="btn-detail btn-detail-blue">자세히</button></td>
                        </tr>
                        <tr>
                            <td><span class="badge rounded-pill badge-blue">평가 완료</span></td>
                            <td class="text-start">생성형 AI 활용한 보안 응용</td>
                            <td class="text-muted">2차 사후평가</td>
                            <td class="text-muted">2025-12-29</td>
                            <td class="fw-bold">82</td>
                            <td class="fw-bold text-primary">80</td>
                            <td><i class="fas fa-microphone icon-gray"></i></td>
                            <td><i class="far fa-file-alt icon-gray"></i></td>
                            <td><i class="far fa-comment-dots icon-gray"></i></td>
                            <td><button class="btn-detail btn-detail-blue">자세히</button></td>
                        </tr>
                        <tr class="opacity-50">
                            <td><span class="badge rounded-pill badge-gray">준비중</span></td>
                            <td class="text-start">생성형 AI 활용한 보안 심화</td>
                            <td class="text-muted">3차 사전평가</td>
                            <td class="text-muted">2026-01-06</td>
                            <td class="text-muted">-</td>
                            <td class="text-muted">-</td>
                            <td><i class="fas fa-microphone icon-light"></i></td>
                            <td>-</td>
                            <td><i class="far fa-comment-dots icon-light"></i></td>
                            <td><button class="btn-detail btn-detail-gray">자세히</button></td>
                        </tr>
                        <tr class="opacity-50">
                            <td><span class="badge rounded-pill badge-gray">준비중</span></td>
                            <td class="text-start">생성형 AI 활용한 보안 심화</td>
                            <td class="text-muted">3차 사후평가</td>
                            <td class="text-muted">2026-02-10</td>
                            <td class="text-muted">-</td>
                            <td class="text-muted">-</td>
                            <td><i class="fas fa-microphone icon-light"></i></td>
                            <td>-</td>
                            <td><i class="far fa-comment-dots icon-light"></i></td>
                            <td><button class="btn-detail btn-detail-gray">자세히</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>