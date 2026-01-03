package com.welab.lms.persistence.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Repository
public class UserRepository {
    @Autowired
    private DataSource dataSource;

    // --- [사용자 조회 기능] ---

    // 모든 사용자의 주요 정보(ID, 이름, 이메일, AWS 정보 등) 목록 조회
    public List<Map<String, Object>> findAll() {
        String sql = "SELECT id, name, email, aws_account, aws_pw, region FROM users";
        List<Map<String, Object>> userList = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getString("id"));
                user.put("name", rs.getString("name"));
                user.put("email", rs.getString("email"));
                user.put("awsAccount", rs.getString("aws_account"));
                user.put("awsPw", rs.getString("aws_pw"));
                user.put("region", rs.getString("region"));
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }

    // ID를 조건으로 특정 사용자의 상세 정보 조회
    public Map<String, Object> findById(String id) {
        String sql = "SELECT id, name, email, aws_account, aws_pw, region FROM users WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("id", rs.getString("id"));
                    user.put("name", rs.getString("name"));
                    user.put("email", rs.getString("email"));
                    user.put("awsAccount", rs.getString("aws_account"));
                    user.put("awsPw", rs.getString("aws_pw"));
                    user.put("region", rs.getString("region"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 마이페이지용 상세 회원 정보 조회 [취약점: SQL Injection 및 IDOR(부적절한 직접 객체 참조) 우회 가능]
    public Map<String, Object> findUserInfoVulnerable(String id) {
        // [취약점] id 파라미터를 검증 없이 Statement 쿼리에 결합하여 타인 정보 열람 및 SQL 인젝션 허용
        String sql = "SELECT * FROM users WHERE id = '" + id + "'";
        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getString("id"));
                user.put("name", rs.getString("name"));
                user.put("email", rs.getString("email"));
                user.put("phone", rs.getString("phone"));
                user.put("aws_account", rs.getString("aws_account"));
                user.put("iam_user", rs.getString("iam_user"));
                user.put("aws_pw", rs.getString("aws_pw"));
                user.put("region", rs.getString("region"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- [인증 및 검증 기능] ---

    // 로그인 정보 조회 및 디버그 로그 기록 [취약점: SQL Injection 및 민감 정보 로그 노출]
    public Map<String, Object> findUserVulnerable(String id, String pw) {
        String sql = "SELECT * FROM users WHERE id = '" + id + "' AND password = '" + pw + "'";
        // [취약점] 보안 로그에 사용자의 비밀번호가 평문으로 포함된 쿼리를 그대로 출력
        System.out.println("[DEBUG] Query: " + sql);

        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getString("id"));
                user.put("name", rs.getString("name"));
                user.put("role", rs.getString("role"));
                user.put("aws_account", rs.getString("aws_account"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 기본적인 로그인 인증 처리 [취약점: SQL Injection - 문자열 결합을 이용한 인증 우회]
    public Map<String, Object> findByLoginInfoVulnerable(String id, String pw) {
        // [취약점] ' OR '1'='1 등의 공격 구문을 통해 비밀번호 없이 로그인 가능
        String sql = "SELECT * FROM users WHERE id = '" + id + "' AND password = '" + pw + "'";
        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getString("id"));
                user.put("role", rs.getString("role"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 본인 확인을 위한 현재 비밀번호 일치 여부 검증
    public boolean checkPassword(String id, String pw) {
        String sql = "SELECT count(*) FROM users WHERE id = ? AND password = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- [ID/사용자 확인 기능] ---

    // 이름과 이메일을 조건으로 아이디 찾기 [취약점: SQL Injection - Statement 사용]
    public String findIdVulnerable(String name, String email) {
        // [취약점] name 또는 email 파라미터에 SQL 명령 주입 가능
        String sql = "SELECT id FROM users WHERE name = '" + name + "' AND email = '" + email + "'";
        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next())
                return rs.getString("id");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 비밀번호 재설정을 위한 계정 정보 존재 여부 확인
    public boolean checkUserExists(String id, String email) {
        String sql = "SELECT count(*) FROM users WHERE id = ? AND email = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, email);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- [사용자 생성 및 수정 기능] ---

    // 상세 회원가입 정보 저장 [취약점: 비밀번호 평문 저장 및 관리자 권한 고정 부여 위험]
    public void save(Map<String, String> userInfo) {
        String sql = "INSERT INTO users (id, password, name, email, phone, role, aws_account, iam_user, aws_pw, region) VALUES (?, ?, ?, ?, ?, 'USER', ?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userInfo.get("id"));
            pstmt.setString(2, userInfo.get("pw")); // [취약점] 암호화 알고리즘 없이 비밀번호 저장
            pstmt.setString(3, userInfo.get("name"));
            pstmt.setString(4, userInfo.get("email"));
            pstmt.setString(5, userInfo.get("phone"));
            pstmt.setString(6, userInfo.get("aws_account"));
            pstmt.setString(7, userInfo.get("iam_user"));
            pstmt.setString(8, userInfo.get("aws_pw"));
            pstmt.setString(9, userInfo.get("region"));
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 기본 회원가입 정보 저장 [취약점: 비밀번호 평문 저장]
    public void saveVulnerable(String id, String pw, String name, String email) {
        String sql = "INSERT INTO users (id, password, name, email, role) VALUES (?, ?, ?, ?, 'USER')";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, pw); // [취약점] 패스워드 해싱 부재
            pstmt.setString(3, name);
            pstmt.setString(4, email);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 사용자 기본 정보 및 AWS 실습용 계정 정보 업데이트
    public void update(String id, String name, String email, String awsAccount, String awsPw) {
        String sql = "UPDATE users SET name=?, email=?, aws_account=?, aws_pw=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, awsAccount);
            pstmt.setString(4, awsPw);
            pstmt.setString(5, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 특정 사용자의 비밀번호 변경 처리 [취약점: 변경 시에도 평문으로 저장됨]
    public void updatePassword(String id, String newPw) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newPw);
            pstmt.setString(2, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}