<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                <div class="form-check me-2"><input class="form-check-input" type="checkbox" id="myGroup"><label
                        class="form-check-label small" for="myGroup">내 그룹만 보기 <i class="fas fa-users"></i></label></div>
                <button class="btn-blue-fill">스터디 그룹 만들기 <i class="fas fa-pen"></i></button>
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
                <tr>
                    <td>79</td>
                    <td><span class="badge-status bg-end">모집완료</span></td>
                    <td class="text-start">웹서비스 보안 관련 취약점 분석 스터디하실 분</td>
                    <td>박지빈</td>
                    <td>2025-11-21</td>
                    <td>15</td>
                </tr>
                <tr>
                    <td>78</td>
                    <td><span class="badge-status bg-wait">모집중</span></td>
                    <td class="text-start">진실의 방</td>
                    <td>김한수</td>
                    <td>2025-11-14</td>
                    <td>10</td>
                </tr>
            </tbody>
        </table>
    </div>