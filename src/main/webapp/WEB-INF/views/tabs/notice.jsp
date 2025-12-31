<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <div id="notice">
        <div style="border-top: 1px solid #333; margin-top: 20px;"></div>
        <table class="table-welab table-hover text-center" style="border-top:none;">
            <thead>
                <tr>
                    <th style="width:10%">No</th>
                    <th style="width:10%">작성자</th>
                    <th style="width:50%">제목</th>
                    <th style="width:15%">작성일</th>
                    <th style="width:15%">조회</th>
                </tr>
            </thead>
            <tbody>
                <tr style="cursor:pointer;" onclick="location.href='/board/list'">
                    <td colspan="5" class="text-center py-5">
                        <span class="text-primary fw-bold" style="font-size: 1.2rem;">공지가 없습니다</span>
                        <br><small class="text-muted">(클릭하여 게시판 이동)</small>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>