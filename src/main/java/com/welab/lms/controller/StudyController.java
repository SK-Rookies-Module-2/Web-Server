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
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Controller
public class StudyController {

    @Autowired
    private DataSource dataSource;

    // 1. 스터디 등록 페이지 (GET)
    @GetMapping("/study/register")
    public String studyRegisterForm() {
        return "study_register";
    }

    @PostMapping("/study/register")
    public String studyRegisterProc(
            @RequestParam String title,
            @RequestParam String content,
            @RequestParam String frequency,
            @RequestParam int capacity,
            @RequestParam(required = false) String pre_members,
            HttpSession session,
            Model model // 에러 메시 전달용
    ) {
        String writer = (String) session.getAttribute("user_name");

        // 1. 회원 존재 여부 검증
        String cleanMembers = "";
        if (pre_members != null && !pre_members.trim().isEmpty()) {
            String[] memberNames = pre_members.split(",");
            StringBuilder validMembers = new StringBuilder();

            try (Connection conn = dataSource.getConnection()) {
                for (String name : memberNames) {
                    String trimmedName = name.trim();
                    // users 테이블에서 해당 이름이 있는지 확인
                    String checkSql = "SELECT COUNT(*) FROM users WHERE user_name = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                        pstmt.setString(1, trimmedName);
                        ResultSet rs = pstmt.executeQuery();
                        if (rs.next() && rs.getInt(1) > 0) {
                            // 존재하는 회원이면 추가
                            if (validMembers.length() > 0)
                                validMembers.append(",");
                            validMembers.append(trimmedName);
                        } else {
                            // [보안 실습 포인트] 존재하지 않는 회원이 섞여 있으면 등록 거부
                            model.addAttribute("msg", "존재하지 않는 회원입니다: " + trimmedName);
                            return "study_register"; // 다시 등록 폼으로 (이후 JSP에서 alert 처리)
                        }
                    }
                }
                cleanMembers = validMembers.toString();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 2. 실제 INSERT 로직 (검증 통과 시)
        String sql = "INSERT INTO study_groups (title, writer, content, frequency, capacity, pre_members, reg_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, '모집중')";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, title);
            pstmt.setString(2, writer);
            pstmt.setString(3, content);
            pstmt.setString(4, frequency);
            pstmt.setInt(5, capacity);
            pstmt.setString(6, cleanMembers);
            pstmt.setString(7, LocalDate.now().toString());

            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/lecture_view?tab=study";
    }

    // 3. 스터디 상세 보기 (GET) - 모달 스타일 페이지
    @GetMapping("/study/view")
    public String studyView(@RequestParam int no, Model model) {
        String sql = "SELECT * FROM study_groups WHERE no = ?";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, no);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> study = new HashMap<>();
                study.put("no", rs.getInt("no"));
                study.put("title", rs.getString("title"));
                study.put("writer", rs.getString("writer"));
                study.put("content", rs.getString("content"));
                study.put("frequency", rs.getString("frequency"));
                study.put("capacity", rs.getInt("capacity"));
                study.put("pre_members", rs.getString("pre_members"));
                study.put("reg_date", rs.getString("reg_date"));
                study.put("status", rs.getString("status"));

                model.addAttribute("study", study);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "study_view";
    }

}