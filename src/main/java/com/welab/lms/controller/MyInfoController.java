package com.welab.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.sql.DataSource;
import java.sql.Connection;
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

            // [취약점 유지] IDOR 실습을 위해 Param을 직접 쿼리에 사용
            // DB 컬럼명이 'id'이므로 user_id를 id로 수정했습니다.
            String sql = "SELECT * FROM users WHERE id = '" + id + "'";
            ResultSet rs = stmt.executeQuery(sql);

            if (rs.next()) {
                // 1. 기본 회원 정보 (컬럼명 id, name, email, phone 사용)
                model.addAttribute("userId", rs.getString("id"));
                model.addAttribute("userName", rs.getString("name"));
                model.addAttribute("userEmail", rs.getString("email"));
                model.addAttribute("userPhone", rs.getString("phone"));

                // 2. 학습 계정 정보 (LoginController에서 생성한 랜덤 값)
                model.addAttribute("awsAccount", rs.getString("aws_account"));
                model.addAttribute("iamUser", rs.getString("iam_user"));
                model.addAttribute("awsPw", rs.getString("aws_pw"));
                model.addAttribute("region", rs.getString("region"));

                // 3. 포인트 및 출석률 (하드코딩 유지)
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
}