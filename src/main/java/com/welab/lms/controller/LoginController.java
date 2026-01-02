package com.welab.lms.controller;

import com.welab.lms.util.JwtUtil; // Step 2에서 만들 클래스 임포트
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
            String sql = "SELECT * FROM users WHERE id = '" + id + "' AND password = '" + pw + "'";
            System.out.println("[DEBUG] Query: " + sql);

            ResultSet rs = stmt.executeQuery(sql);

            if (rs.next()) {
                session.setAttribute("user_id", rs.getString("id"));
                session.setAttribute("user_name", rs.getString("name"));
                session.setAttribute("user_role", rs.getString("role"));
                String role = rs.getString("role") != null ? rs.getString("role") : "USER";
                String token = JwtUtil.createToken(rs.getString("id"), role);
                model.addAttribute("jwtToken", token);
                if (rs.getString("aws_account") == null || rs.getString("aws_account").isEmpty()) {
                    updateUserLearningInfo(rs.getString("id"), generateAwsAccount(), rs.getString("id"),
                            "Welabs!" + generateRandomString(5), getRandomRegion());
                }
                return "login_success";
            } else {
                return "login";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "login";
        }
    }

    // --- 회원가입, 아이디/비번 찾기 매핑 (기존 유지) ---
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @GetMapping("/find-id")
    public String findIdPage() {
        return "find_account";
    }

    @GetMapping("/find-pw")
    public String findPwPage() {
        return "find_account";
    }

    @PostMapping("/registerAction")
    public String registerAction(@RequestParam String id, @RequestParam String pw, @RequestParam String name,
            @RequestParam String email, @RequestParam String phone) {
        try (Connection conn = dataSource.getConnection()) {
            String sql = "INSERT INTO users (id, password, name, email, phone, role, aws_account, iam_user, aws_pw, region) VALUES (?, ?, ?, ?, ?, 'USER', ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, id);
                pstmt.setString(2, pw);
                pstmt.setString(3, name);
                pstmt.setString(4, email);
                pstmt.setString(5, phone);
                pstmt.setString(6, generateAwsAccount());
                pstmt.setString(7, id);
                pstmt.setString(8, "Welabs!" + generateRandomString(5));
                pstmt.setString(9, getRandomRegion());
                pstmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/";
    }

    @PostMapping("/findIdAction")
    public String findIdAction(@RequestParam String name, @RequestParam String email, Model model) {
        try (Connection conn = dataSource.getConnection(); Statement stmt = conn.createStatement()) {
            String sql = "SELECT id FROM users WHERE name = '" + name + "' AND email = '" + email + "'";
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next())
                model.addAttribute("msg", "찾으시는 아이디는 [" + rs.getString("id") + "] 입니다.");
            else
                model.addAttribute("msg", "일치하는 정보가 없습니다.");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "find_account";
    }

    @PostMapping("/findPwAction")
    public String findPwAction(@RequestParam String id, @RequestParam String email, Model model) {
        String tempPw = "1q2w3e4r!@#";
        try (Connection conn = dataSource.getConnection()) {
            String checkSql = "SELECT count(*) FROM users WHERE id = ? AND email = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                pstmt.setString(1, id);
                pstmt.setString(2, email);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    String updateSql = "UPDATE users SET password = ? WHERE id = ?";
                    try (PreparedStatement upstmt = conn.prepareStatement(updateSql)) {
                        upstmt.setString(1, tempPw);
                        upstmt.setString(2, id);
                        upstmt.executeUpdate();
                        model.addAttribute("msg", "비밀번호가 임시 비밀번호 [" + tempPw + "] 로 초기화되었습니다.");
                    }
                } else
                    model.addAttribute("msg", "일치하는 정보가 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "find_account";
    }

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

    private void updateUserLearningInfo(String userId, String acc, String iam, String pw, String region) {
        String sql = "UPDATE users SET aws_account=?, iam_user=?, aws_pw=?, region=? WHERE id=?";
        try (Connection conn = dataSource.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
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