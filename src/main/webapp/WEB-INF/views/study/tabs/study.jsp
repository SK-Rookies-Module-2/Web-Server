<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div id="study">
            <div class="d-flex justify-content-between align-items-center mb-3 p-3 bg-light rounded">
                <div class="search-box-group">
                    <select class="form-select form-select-sm">
                        <option>그룹이름</option>
                    </select>
                    <input type="text" class="form-control form-control-sm" placeholder="검색어를 입력하세요.">
                    <button class="btn btn-sm btn-secondary"><i class="fas fa-search"></i></button>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <div class="form-check me-2">
                        <input class="form-check-input" type="checkbox" id="myGroup">
                        <label class="form-check-label small" for="myGroup">내 그룹만 보기 <i
                                class="fas fa-users"></i></label>
                    </div>
                    <button class="btn-blue-fill" onclick="location.href='/study/register'">스터디 그룹 만들기 <i
                            class="fas fa-pen"></i></button>
                </div>
            </div>

            <div style="border-top: 1px solid #333;"></div>

            <table class="table-welab table-hover text-center" style="border-top:none;">
                <thead>
                    <tr>
                        <th style="width:10%">No</th>
                        <th style="width:10%">상태</th>
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
                                        <span class="badge-status bg-wait">모집중</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status bg-end">모집완료</span>
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
        </div>