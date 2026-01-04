<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <link rel="stylesheet" href="/static/css/study.css">

        <div id="study">
            <div class="study-header-bar">
                <div class="search-box-group">
                    <select class="search-category">
                        <option value="title">그룹이름</option>
                        <option value="writer">그룹장</option>
                    </select>
                    <input type="text" class="search-input" placeholder="검색어를 입력하세요.">
                    <button class="btn-search"><i class="fas fa-search"></i></button>
                </div>

                <div class="tools-group">
                    <label class="check-my-group" for="myGroupCheckbox">
                        <input type="checkbox" id="myGroupCheckbox" class="form-check-input m-0">
                        내 그룹만 보기 <i class="fas fa-users"></i>
                    </label>
                    <button class="btn-create-study" onclick="location.href='/study/register'">
                        스터디 그룹 만들기 <i class="fas fa-pen"></i>
                    </button>
                </div>
            </div>

            <table class="table-study text-center">
                <thead>
                    <tr>
                        <th style="width:8%">No</th>
                        <th style="width:12%">상태</th>
                        <th style="width:40%">그룹이름</th>
                        <th style="width:15%">그룹장</th>
                        <th style="width:15%">생성일</th>
                        <th style="width:10%">총인원</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="study" items="${studyList}">
                        <tr style="cursor:pointer;" onclick="location.href='/study/view?no=${study.no}'">
                            <td>${study.no}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${study.status == '모집중'}">
                                        <span class="badge-status bg-recruiting">모집중</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status bg-finished">모집완료</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-start">${study.title}</td>
                            <td>${study.writer}</td>
                            <td>${study.reg_date}</td>
                            <td>${study.capacity}</td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty studyList}">
                        <tr>
                            <td colspan="6" class="py-5 text-muted">등록된 스터디 그룹이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <div class="study-footer-tools">
                <nav>
                    <ul class="pagination mb-0">
                        <li class="page-item"><a class="page-link border-0 text-muted" href="#"><i
                                    class="fas fa-chevron-left"></i></a></li>
                        <li class="page-item active"><a class="page-link rounded-circle mx-1" href="#"
                                style="background-color:#1a73e8; border-color:#1a73e8;">1</a></li>
                        <li class="page-item"><a class="page-link border-0 text-muted" href="#"><i
                                    class="fas fa-chevron-right"></i></a></li>
                    </ul>
                </nav>

                <div class="view-option-study">
                    10개씩 보기 <i class="fas fa-caret-down ms-1"></i>
                </div>
            </div>
        </div>