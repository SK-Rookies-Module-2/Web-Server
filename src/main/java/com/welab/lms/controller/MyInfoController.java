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
            // [취약점] IDOR
            String sql = "SELECT * FROM users WHERE id = '" + id + "'";
            ResultSet rs = stmt.executeQuery(sql);

            if (rs.next()) {
                model.addAttribute("userId", rs.getString("id"));
                model.addAttribute("userName", rs.getString("name"));
                model.addAttribute("userEmail", rs.getString("email"));
                model.addAttribute("userPhone", rs.getString("phone"));

                if (id.equals("admin")) {
                    model.addAttribute("point", "99,999");
                    model.addAttribute("awsAccount", "999999999999 (Root)");
                    model.addAttribute("iamUser", "admin-master");
                    model.addAttribute("awsPass", "Admin_Secret_Key!");
                    model.addAttribute("region", "us-east-1 (N. Virginia)");
                    model.addAttribute("attendRate", "100");
                } else {
                    model.addAttribute("point", "0");
                    model.addAttribute("awsAccount", "1234567890");
                    model.addAttribute("iamUser", "HJ01");
                    model.addAttribute("awsPass", "Hello2026!");
                    model.addAttribute("region", "서울");
                    model.addAttribute("attendRate", "39");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "myinfo";
    }
}