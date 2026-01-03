package com.welab.lms.persistence.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Repository
public class LectureRepository {
    @Autowired
    private DataSource dataSource;

    // 과정 평가 항목 및 성적 데이터 전체 목록 조회
    public List<Map<String, Object>> findAllEvaluations() {
        // [로직] 번호(no) 오름차순으로 모든 평가 데이터를 조회하는 SQL 쿼리
        String sql = "SELECT * FROM evaluations ORDER BY no ASC";
        List<Map<String, Object>> evalList = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();

                // [로직] 데이터베이스 컬럼 데이터를 Map 객체에 1:1로 매핑
                map.put("status", rs.getString("status"));
                map.put("subject", rs.getString("subject"));
                map.put("eval_name", rs.getString("eval_name"));
                map.put("exam_date", rs.getString("exam_date"));

                // [로직] 점수 데이터 가공: 0점일 경우 화면 표시용 '-' 기호로 변환
                int avg = rs.getInt("avg_score");
                int my = rs.getInt("my_score");
                map.put("avg_score", avg == 0 ? "-" : String.valueOf(avg));
                map.put("my_score", my == 0 ? "-" : String.valueOf(my));

                // [로직] 피드백, 파일, 미팅 존재 여부를 나타내는 불리언 값 추출
                map.put("has_feedback", rs.getBoolean("has_feedback"));
                map.put("has_file", rs.getBoolean("has_file"));
                map.put("has_meeting", rs.getBoolean("has_meeting"));

                evalList.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return evalList;
    }
}