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
import java.sql.ResultSet;
import java.sql.Statement;

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

            // [취약점] SQL Injection
            String sql = "SELECT * FROM users WHERE id = '" + id + "' AND password = '" + pw + "'";
            System.out.println("[DEBUG] Query: " + sql);

            ResultSet rs = stmt.executeQuery(sql);

            if (rs.next()) {
                session.setAttribute("user_id", rs.getString("id"));
                session.setAttribute("user_name", rs.getString("name"));
                session.setAttribute("user_role", rs.getString("role"));
                return "redirect:/dashboard";
            } else {
                return "login";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "login";
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