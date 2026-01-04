<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <link rel="stylesheet" href="/static/css/notice.css">

        <div id="notice">
            <div class="notice-header-tools">
                <c:if test="${sessionScope.user_id == 'admin'}">
                    <button class="btn btn-danger btn-sm fw-bold px-3" onclick="location.href='/board/notice/write'">
                        <i class="fas fa-bullhorn me-1"></i> 공지사항 등록
                    </button>
                </c:if>
            </div>

            <table class="table-notice text-center">
                <thead>
                    <tr>
                        <th style="width:8%">No</th>
                        <th style="width:10%">분류</th>
                        <th style="width:47%">제목</th>
                        <th style="width:15%">작성자</th>
                        <th style="width:12%">작성일</th>
                        <th style="width:8%">조회</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="notice" items="${noticeList}">
                        <tr style="cursor:pointer;"
                            class="${notice.is_important ? 'row-important' : ''} ${!notice.is_visible ? 'row-hidden' : ''}"
                            onclick="location.href='/board/notice/view?no=${notice.no}'">

                            <td>
                                <c:choose>
                                    <c:when test="${notice.is_important}">
                                        <span class="badge badge-important">필독</span>
                                    </c:when>
                                    <c:otherwise>${notice.no}</c:otherwise>
                                </c:choose>
                            </td>

                            <td class="${notice.is_important ? 'text-danger' : ''}">${notice.category}</td>

                            <td class="td-title">
                                <span class="${notice.is_important ? 'text-danger' : ''}">${notice.title}</span>
                                <c:if test="${!notice.is_visible}">
                                    <small class="text-muted ms-2"><i class="fas fa-eye-slash"></i></small>
                                </c:if>
                            </td>

                            <td>${notice.writer}</td>
                            <td>${notice.reg_date}</td>
                            <td>${notice.views}</td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty noticeList}">
                        <tr>
                            <td colspan="6" class="empty-msg text-center">
                                공지가 없습니다
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <c:if test="${not empty noticeList}">
                <div class="d-flex justify-content-center">
                    <nav aria-label="Page navigation">
                        <ul class="pagination shadow-sm">
                            <li class="page-item disabled">
                                <a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>