package com.welab.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class LectureController {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/lecture_view")
    public String lectureView(
            @RequestParam(defaultValue = "roadmap") String tab,
            Model model,
            HttpSession session // [수정됨] 여기에 session을 받아야 아래에서 쓸 수 있습니다.
    ) {
        model.addAttribute("courseTitle", "생성형 AI 활용 사이버보안 전문인력 양성과정 28기");
        model.addAttribute("progress", "39");
        model.addAttribute("currentTab", tab);

        // 1. [과정평가] 데이터 가져오기
        List<Map<String, Object>> evalList = new ArrayList<>();
        String sqlEval = "SELECT * FROM evaluations ORDER BY no ASC";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sqlEval);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", rs.getString("status"));
                map.put("subject", rs.getString("subject"));
                map.put("eval_name", rs.getString("eval_name"));
                map.put("exam_date", rs.getString("exam_date"));

                int avg = rs.getInt("avg_score");
                int my = rs.getInt("my_score");
                map.put("avg_score", avg == 0 ? "-" : String.valueOf(avg));
                map.put("my_score", my == 0 ? "-" : String.valueOf(my));

                map.put("has_feedback", rs.getBoolean("has_feedback"));
                map.put("has_file", rs.getBoolean("has_file"));
                map.put("has_meeting", rs.getBoolean("has_meeting"));
                evalList.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("evalList", evalList);

        // 2. [공지사항] 데이터 가져오기
        List<Map<String, Object>> noticeList = new ArrayList<>();

        // 기본 쿼리
        String sqlNotice = "SELECT * FROM notices ";

        // [로직] 관리자가 아니면, '숨겨지지 않은 글(is_visible=1)'만 가져오도록 조건 추가
        String userId = (String) session.getAttribute("user_id");
        if (userId == null || !userId.equals("admin")) {
            sqlNotice += "WHERE is_visible = TRUE ";
        }

        // 정렬 조건 추가
        sqlNotice += "ORDER BY is_important DESC, reg_date DESC";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sqlNotice);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("no", rs.getInt("no"));
                map.put("category", rs.getString("category"));
                map.put("title", rs.getString("title"));
                map.put("writer", rs.getString("writer"));
                map.put("reg_date", rs.getString("reg_date"));
                map.put("views", rs.getInt("views"));
                map.put("is_important", rs.getBoolean("is_important"));

                // [중요] 뷰(JSP)에서 숨김 상태인지 알 수 있게 전달
                map.put("is_visible", rs.getBoolean("is_visible"));

                noticeList.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 3. [스터디 그룹] 데이터 가져오기
        List<Map<String, Object>> studyList = new ArrayList<>();
        String sqlStudy = "SELECT * FROM study_groups ORDER BY no DESC";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sqlStudy);
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
        model.addAttribute("studyList", studyList);

        model.addAttribute("noticeList", noticeList);

        return "lecture_view";

    }
}
