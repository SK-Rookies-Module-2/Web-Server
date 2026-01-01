package com.welab.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

@Controller
public class MyInfoController {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/myinfo")
    public String myInfo(@RequestParam String id, Model model) {
        try {
            Connection conn = dataSource.getConnection();
            Statement stmt = conn.createStatement();

            String sql = "SELECT * FROM users WHERE id = '" + id + "'";
            ResultSet rs = stmt.executeQuery(sql);

            if (rs.next()) {
                model.addAttribute("userId", rs.getString("id"));
                model.addAttribute("userName", rs.getString("name"));
                model.addAttribute("userEmail", rs.getString("email"));
                model.addAttribute("userPhone", rs.getString("phone"));

                model.addAttribute("awsAccount", rs.getString("aws_account"));
                model.addAttribute("iamUser", rs.getString("iam_user"));
                model.addAttribute("awsPw", rs.getString("aws_pw"));
                model.addAttribute("region", rs.getString("region"));

                if (id.equals("admin")) {
                    model.addAttribute("point", "99,999");
                    model.addAttribute("attendRate", "100");
                } else {
                    model.addAttribute("point", "0");
                    model.addAttribute("attendRate", "100");
                }
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "myinfo";
    }

    // 비밀번호 변경 페이지 호출 (views/changePw.jsp)
    @GetMapping("/changePw")
    public String showChangePwPage() {
        return "changePw";
    }

    // [DB 연동] 비밀번호 변경 처리
    @PostMapping("/user/updatePassword")
    @ResponseBody
    public ResponseEntity<String> updatePassword(
            @RequestParam String currentPw,
            @RequestParam String newPw,
            HttpSession session) {

        // 1. 세션에서 로그인한 사용자의 ID 가져오기
        String userId = (String) session.getAttribute("user_id");

        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session Expired");
        }

        try (Connection conn = dataSource.getConnection()) {
            // 2. 현재 비밀번호가 일치하는지 먼저 확인
            String checkSql = "SELECT count(*) FROM users WHERE id = ? AND password = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                pstmt.setString(1, userId);
                pstmt.setString(2, currentPw);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    // 3. 일치한다면 새로운 비밀번호로 업데이트
                    String updateSql = "UPDATE users SET password = ? WHERE id = ?";
                    try (PreparedStatement upstmt = conn.prepareStatement(updateSql)) {
                        upstmt.setString(1, newPw);
                        upstmt.setString(2, userId);
                        upstmt.executeUpdate();

                        // [보안] 변경 성공 시 서버 세션 무효화 (클라이언트는 JS에서 JWT 삭제)
                        session.invalidate();
                        return ResponseEntity.ok("Success");
                    }
                } else {
                    // 현재 비밀번호가 틀린 경우
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Current password incorrect");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("DB Error");
        }
    }
}