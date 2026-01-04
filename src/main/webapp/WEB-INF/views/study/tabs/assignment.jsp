<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <link rel="stylesheet" href="/static/css/assignment.css">

        <div id="assignment">
            <div class="assignment-header-tools">
                <button class="btn-assignment-score">
                    내 과제 점수 보기 <i class="fas fa-tasks"></i>
                </button>
            </div>

            <table class="table-assignment text-center">
                <thead>
                    <tr>
                        <th style="width:8%">No</th>
                        <th style="width:15%">작성자</th>
                        <th style="width:40%">제목</th>
                        <th style="width:12%">작성일</th>
                        <th style="width:17%">마감기한</th>
                        <th style="width:8%">조회</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- 실제 데이터가 있을 경우 출력될 영역 --%>
                        <c:forEach var="item" items="${assignmentList}">
                            <tr>
                                <td>${item.no}</td>
                                <td>${item.writer}</td>
                                <td class="text-start">${item.title}</td>
                                <td>${item.reg_date}</td>
                                <td>${item.due_date}</td>
                                <td>${item.views}</td>
                            </tr>
                        </c:forEach>

                        <%-- 과제가 없을 때 (이미지 디자인 반영) --%>
                            <c:if test="${empty assignmentList}">
                                <tr>
                                    <td colspan="6" class="empty-msg text-center">
                                        제출할 과제가 없습니다
                                    </td>
                                </tr>
                            </c:if>
                </tbody>
            </table>

            <div class="assignment-footer-tools">
                <%-- 과제가 있을 때만 페이지네이션 노출 --%>
                    <c:if test="${not empty assignmentList}">
                        <nav>
                            <ul class="pagination mb-0">
                                <li class="page-item"><a class="page-link border-0" href="#"><i
                                            class="fas fa-chevron-left"></i></a></li>
                                <li class="page-item active"><a class="page-link rounded-circle mx-1" href="#"
                                        style="background-color:#1a73e8;">1</a></li>
                                <li class="page-item"><a class="page-link border-0" href="#"><i
                                            class="fas fa-chevron-right"></i></a></li>
                            </ul>
                        </nav>
                    </c:if>

                    <div class="view-option">
                        10개씩 보기 <i class="fas fa-caret-down ms-1"></i>
                    </div>
            </div>
        </div>