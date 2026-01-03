package com.welab.lms.persistence.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Repository
public class StudyRepository {
    @Autowired
    private DataSource dataSource;

    // --- [스터디 그룹 관련 기능] ---

    // 등록된 모든 스터디 그룹 목록 조회
    public List<Map<String, Object>> findAllStudyGroups() {
        String sql = "SELECT * FROM study_groups ORDER BY no DESC";
        List<Map<String, Object>> studyList = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("no", rs.getInt("no"));
                map.put("status", rs.getString("status"));
                map.put("title", rs.getString("title"));
                map.put("writer", rs.getString("writer"));
                map.put("reg_date", rs.getString("reg_date"));
                map.put("capacity", rs.getInt("capacity"));
                studyList.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return studyList;
    }

    // 특정 번호의 스터디 상세 정보 조회 [취약점: SQL Injection - Statement를 통한 문자열 결합]
    public Map<String, Object> findStudyVulnerable(String no) {
        // [취약점] 외부 입력값(no)을 쿼리문에 직접 결합하여 SQL 인젝션 공격에 노출됨
        String sql = "SELECT * FROM study_groups WHERE no = " + no;
        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("no", rs.getInt("no"));
                map.put("title", rs.getString("title"));
                map.put("content", rs.getString("content"));
                map.put("writer", rs.getString("writer"));
                map.put("frequency", rs.getString("frequency"));
                map.put("capacity", rs.getInt("capacity"));
                map.put("pre_members", rs.getString("pre_members"));
                map.put("reg_date", rs.getString("reg_date"));
                map.put("status", rs.getString("status"));
                return map;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 사용자 이름이 데이터베이스에 존재하는지 확인 (스터디 등록 전 검증용)
    public boolean isUserExists(String name) {
        String sql = "SELECT COUNT(*) FROM users WHERE name = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 신규 스터디 그룹 정보 저장
    public void insertStudyGroup(Map<String, Object> study) {
        String sql = "INSERT INTO study_groups (title, writer, content, frequency, capacity, pre_members, reg_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, '모집중')";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, (String) study.get("title"));
            pstmt.setString(2, (String) study.get("writer"));
            pstmt.setString(3, (String) study.get("content"));
            pstmt.setString(4, (String) study.get("frequency"));
            pstmt.setInt(5, (Integer) study.get("capacity"));
            pstmt.setString(6, (String) study.get("pre_members"));
            pstmt.setString(7, (String) study.get("reg_date"));
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- [스터디 게시글 관련 기능] ---

    // 특정 스터디 게시판의 전체 게시글 목록 조회 [취약점: SQL Injection]
    public List<Map<String, Object>> findPostsVulnerable(String studyNo) {
        // [취약점] studyNo 파라미터를 검증 없이 Statement 쿼리에 사용
        String sql = "SELECT * FROM study_posts WHERE study_no = " + studyNo + " ORDER BY post_no DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("post_no", rs.getInt("post_no"));
                post.put("title", rs.getString("title"));
                post.put("writer", rs.getString("writer"));
                post.put("file_name", rs.getString("file_name"));
                post.put("reg_date", rs.getString("reg_date"));
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 특정 게시글의 상세 내용 조회 [취약점: SQL Injection]
    public Map<String, Object> findPostDetailVulnerable(String postNo) {
        String sql = "SELECT * FROM study_posts WHERE post_no = " + postNo;
        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("post_no", rs.getInt("post_no"));
                map.put("study_no", rs.getInt("study_no"));
                map.put("title", rs.getString("title"));
                map.put("writer", rs.getString("writer"));
                map.put("content", rs.getString("content")); // 상세 페이지 노출을 위한 필수 필드
                map.put("file_name", rs.getString("file_name"));
                map.put("reg_date", rs.getString("reg_date"));
                return map;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 새 게시글 데이터베이스 저장
    public void insertPost(int studyNo, String title, String writer, String content, String fileName) {
        String sql = "INSERT INTO study_posts (study_no, title, writer, content, file_name, reg_date) VALUES (?, ?, ?, ?, ?, now())";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studyNo);
            pstmt.setString(2, title);
            pstmt.setString(3, writer);
            pstmt.setString(4, content);
            pstmt.setString(5, fileName);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 기존 게시글 내용 업데이트 [취약점: SQL Injection - title, content 필드 조작 가능]
    public void updatePostVulnerable(Map<String, Object> params) {
        String postNo = (String) params.get("post_no");
        String title = (String) params.get("title");
        String content = (String) params.get("content");

        // [취약점] 사용자 입력값을 싱글 쿼테이션(')으로 감싸 직접 결합하는 방식
        String sql = "UPDATE study_posts SET title = '" + title + "', content = '" + content + "' WHERE post_no = "
                + postNo;

        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 특정 게시글 데이터 삭제 [취약점: SQL Injection]
    public void deletePostVulnerable(String postNo) {
        // [취약점] postNo를 이용한 DELETE 쿼리 조작 가능
        String sql = "DELETE FROM study_posts WHERE post_no = " + postNo;
        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}