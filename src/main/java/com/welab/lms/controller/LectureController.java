package com.welab.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
    public String lectureView(@RequestParam(defaultValue = "roadmap") String tab, Model model) {
        // 1. 기본 정보
        model.addAttribute("courseTitle", "생성형 AI 활용 사이버보안 전문인력 양성과정 28기");
        model.addAttribute("progress", "39");

        // 2. 현재 선택된 탭 정보 전달
        model.addAttribute("currentTab", tab);

        // 3. [과정평가] DB 데이터 가져오기 (DB 연결 누수 방지 코드 적용)
        List<Map<String, Object>> evalList = new ArrayList<>();

        String sql = "SELECT * FROM evaluations ORDER BY no ASC";

        // [핵심] try (...) 안에 선언하면 실행 후 자동으로 conn.close()가 호출됩니다.
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
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

        return "lecture_view";
    }
}