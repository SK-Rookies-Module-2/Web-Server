package com.welab.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Random;

@Controller
public class LoginController {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/loginAction")
    public String loginProcess(@RequestParam String id, @RequestParam String pw, HttpSession session, Model model) {
        try {
            Connection conn = dataSource.getConnection();
            Statement stmt = conn.createStatement();

            // [취약점 유지] 컬럼명을 'user_id'가 아닌 'id'로 수정하여 에러 해결
            String sql = "SELECT * FROM users WHERE id = '" + id + "' AND password = '" + pw + "'";
            System.out.println("[DEBUG] Query: " + sql);

            ResultSet rs = stmt.executeQuery(sql);

            if (rs.next()) {
                // 세션에 정보 저장 (컬럼명 'id', 'name' 사용)
                session.setAttribute("user_id", rs.getString("id"));
                session.setAttribute("user_name", rs.getString("name"));
                session.setAttribute("user_role", rs.getString("role"));

                // 학습 계정 정보가 없으면 랜덤 생성 후 DB 업데이트
                if (rs.getString("aws_account") == null || rs.getString("aws_account").isEmpty()) {
                    String randomAccount = generateAwsAccount();
                    String randomAwsPw = "Welabs!" + generateRandomString(5);
                    String randomRegion = getRandomRegion();
                    String iamUser = rs.getString("id"); // 접속 ID와 동일하게 설정

                    updateUserLearningInfo(rs.getString("id"), randomAccount, iamUser, randomAwsPw, randomRegion);
                }

                return "redirect:/dashboard";
            } else {
                return "login";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "login";
        }
    }

    // --- 랜덤 데이터 생성 유틸리티 ---
    private String generateAwsAccount() {
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 12; i++)
            sb.append(rnd.nextInt(10));
        return sb.toString();
    }

    private String generateRandomString(int len) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < len; i++)
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        return sb.toString();
    }

    private String getRandomRegion() {
        String[] regions = { "오사카 (ap-northeast-3)", "서울 (ap-northeast-2)", "도쿄 (ap-northeast-1)" };
        return regions[new Random().nextInt(regions.length)];
    }

    // --- DB 업데이트 메서드 (컬럼명 'id' 기준) ---
    private void updateUserLearningInfo(String userId, String acc, String iam, String pw, String region) {
        String sql = "UPDATE users SET aws_account=?, iam_user=?, aws_pw=?, region=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, acc);
            pstmt.setString(2, iam);
            pstmt.setString(3, pw);
            pstmt.setString(4, region);
            pstmt.setString(5, userId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session) {
        if (session.getAttribute("user_id") == null)
            return "redirect:/";
        return "dashboard";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}