package com.welab.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Controller
public class AdminController {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/admin/users")
    public String adminUserList(Model model) {
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
            model.addAttribute("userList", userList);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "admin_users";
    }

    // 수정 페이지 호출
    @GetMapping("/admin/user/edit")
    public String editUserForm(@RequestParam String id, Model model) {
        String sql = "SELECT id, name, email, aws_account, aws_pw, region FROM users WHERE id = ?";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getString("id"));
                user.put("name", rs.getString("name"));
                user.put("email", rs.getString("email"));
                user.put("awsAccount", rs.getString("aws_account"));
                user.put("awsPw", rs.getString("aws_pw"));
                model.addAttribute("user", user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "admin_user_edit";
    }

    // 수정 실행
    @PostMapping("/admin/user/edit")
    public String editUserProc(@RequestParam String id,
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String awsAccount,
            @RequestParam String awsPw) {

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

        return "redirect:/admin/users";
    }
}