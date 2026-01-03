package com.welab.lms.persistence.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Repository
public class BoardRepository {
    @Autowired
    private DataSource dataSource;

    // 권한에 따른 공지사항 전체 목록 조회 [취약점: 동적 쿼리 조작을 통한 데이터 노출 위험]
    public List<Map<String, Object>> findAllNoticesVulnerable(boolean isAdmin) {
        String sql = "SELECT * FROM notices ";
        if (!isAdmin) {
            sql += "WHERE is_visible = TRUE ";
        }
        sql += "ORDER BY is_important DESC, reg_date DESC";

        List<Map<String, Object>> noticeList = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("no", rs.getInt("no"));
                map.put("category", rs.getString("category"));
                map.put("title", rs.getString("title"));
                map.put("writer", rs.getString("writer"));
                map.put("reg_date", rs.getString("reg_date"));
                map.put("views", rs.getInt("views"));
                map.put("is_important", rs.getBoolean("is_important"));
                map.put("is_visible", rs.getBoolean("is_visible"));
                noticeList.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return noticeList;
    }

    // 특정 공지사항 상세 조회 및 조회수 증가 처리
    public Map<String, Object> findNoticeByNo(int no) {
        String updateSql = "UPDATE notices SET views = views + 1 WHERE no = ?";
        String selectSql = "SELECT * FROM notices WHERE no = ?";

        try (Connection conn = dataSource.getConnection()) {
            try (PreparedStatement upstmt = conn.prepareStatement(updateSql)) {
                upstmt.setInt(1, no);
                upstmt.executeUpdate();
            }
            try (PreparedStatement pstmt = conn.prepareStatement(selectSql)) {
                pstmt.setInt(1, no);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("no", rs.getInt("no"));
                    map.put("category", rs.getString("category"));
                    map.put("title", rs.getString("title"));
                    map.put("writer", rs.getString("writer"));
                    map.put("content", rs.getString("content"));
                    map.put("reg_date", rs.getString("reg_date"));
                    map.put("views", rs.getInt("views"));
                    map.put("is_important", rs.getBoolean("is_important"));
                    map.put("is_visible", rs.getBoolean("is_visible"));
                    return map;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 신규 공지사항 데이터 저장 [취약점: Stored XSS - 내용(content) 필터링 부재로 악성 스크립트 삽입 가능]
    public void insertNotice(Map<String, Object> notice) {
        String sql = "INSERT INTO notices (category, title, content, writer, is_important, reg_date) " +
                "VALUES (?, ?, ?, ?, ?, now())";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, (String) notice.get("category"));
            pstmt.setString(2, (String) notice.get("title"));
            pstmt.setString(3, (String) notice.get("content"));
            pstmt.setString(4, (String) notice.get("writer"));
            pstmt.setString(5, (String) notice.get("isImportant"));

            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 기존 공지사항 레코드 내용 수정
    public void updateNotice(Map<String, Object> notice) {
        String sql = "UPDATE notices SET category=?, title=?, content=?, is_important=? WHERE no=?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, (String) notice.get("category"));
            pstmt.setString(2, (String) notice.get("title"));
            pstmt.setString(3, (String) notice.get("content"));
            pstmt.setBoolean(4, (Boolean) notice.get("is_important"));
            pstmt.setInt(5, (Integer) notice.get("no"));
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 공지사항 노출 여부(is_visible) 상태 반전 처리
    public void toggleVisible(int no) {
        String sql = "UPDATE notices SET is_visible = NOT is_visible WHERE no = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, no);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 특정 공지사항 레코드 완전 삭제
    public void deleteNotice(int no) {
        String sql = "DELETE FROM notices WHERE no = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, no);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}