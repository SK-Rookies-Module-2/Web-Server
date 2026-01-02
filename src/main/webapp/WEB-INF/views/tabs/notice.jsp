<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <div id="notice">
            <div class="d-flex justify-content-end mb-3" style="min-height: 38px;">
                <c:if test="${sessionScope.user_id == 'admin'}">
                    <button class="btn btn-danger fw-bold" onclick="location.href='/board/notice/write'">
                        <i class="fas fa-bullhorn"></i> 공지사항 등록
                    </button>
                </c:if>
            </div>

            <div style="border-top: 1px solid #333;"></div>

            <table class="table-welab table-hover text-center" style="border-top:none;">
                <thead>
                    <tr>
                        <th style="width:10%">No</th>
                        <th style="width:10%">분류</th>
                        <th style="width:45%">제목</th>
                        <th style="width:15%">작성자</th>
                        <th style="width:10%">작성일</th>
                        <th style="width:10%">조회</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="notice" items="${noticeList}">
                        <tr style="cursor:pointer; 
                    ${notice.is_important ? 'background-color: #fff5f5;' : ''} 
                    ${!notice.is_visible ? 'background-color: #f0f0f0; color: #999;' : ''}"
                            onclick="location.href='/board/notice/view?no=${notice.no}'">

                            <td>
                                <c:choose>
                                    <c:when test="${notice.is_important}"><span class="badge bg-danger">필독</span>
                                    </c:when>
                                    <c:otherwise>${notice.no}</c:otherwise>
                                </c:choose>
                            </td>

                            <td class="${notice.is_important ? 'text-danger fw-bold' : ''}">${notice.category}</td>

                            <td class="text-start ${notice.is_important ? 'fw-bold text-danger' : ''}">
                                ${notice.title}

                                <c:if test="${!notice.is_visible}">
                                    <span class="badge bg-secondary ms-2" style="font-size: 0.75em;">
                                        <i class="fas fa-eye-slash"></i> 비공개
                                    </span>
                                </c:if>
                            </td>

                            <td>${notice.writer}</td>
                            <td>${notice.reg_date}</td>
                            <td>${notice.views}</td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty noticeList}">
                        <tr>
                            <td colspan="6" class="py-5 text-muted">등록된 공지사항이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <div class="d-flex justify-content-center mt-4">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li class="page-item disabled"><a class="page-link" href="#"><i
                                    class="fas fa-chevron-left"></i></a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>