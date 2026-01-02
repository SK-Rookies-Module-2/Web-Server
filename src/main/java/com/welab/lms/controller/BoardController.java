package com.welab.lms.controller;

import com.welab.lms.util.JwtUtil; // JwtUtil 임포트
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Controller
public class BoardController {

    @Autowired
    private DataSource dataSource;

    // 공지사항 리스트 (누구나 접근 가능)
    @GetMapping("/board/list")
    public String boardList() {
        return "board_list";
    }

    @GetMapping("/board/notice/view")
    public String noticeView(@RequestParam int no, org.springframework.ui.Model model) {
        String sqlUpdateView = "UPDATE notices SET views = views + 1 WHERE no = ?";
        String sqlSelect = "SELECT * FROM notices WHERE no = ?";

        try (Connection conn = dataSource.getConnection()) {
            // 조회수 증가
            try (PreparedStatement pstmt = conn.prepareStatement(sqlUpdateView)) {
                pstmt.setInt(1, no);
                pstmt.executeUpdate();
            }

            // 데이터 조회
            try (PreparedStatement pstmt = conn.prepareStatement(sqlSelect)) {
                pstmt.setInt(1, no);
                try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        java.util.Map<String, Object> notice = new java.util.HashMap<>();
                        notice.put("no", rs.getInt("no"));
                        notice.put("category", rs.getString("category"));
                        notice.put("title", rs.getString("title"));
                        notice.put("writer", rs.getString("writer"));
                        notice.put("content", rs.getString("content"));
                        notice.put("reg_date", rs.getString("reg_date"));
                        notice.put("views", rs.getInt("views"));
                        notice.put("is_important", rs.getBoolean("is_important"));
                        notice.put("is_visible", rs.getBoolean("is_visible"));

                        model.addAttribute("notice", notice);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "notice_view";
    }

    // 1. 공지사항 작성 페이지 (GET)
    @GetMapping("/board/notice/write")
    public String noticeWriteForm(@RequestHeader(value = "Authorization", required = false) String bearerToken,
            Model model) {
        if (isAdmin(bearerToken)) {
            return "notice_write";
        }
        model.addAttribute("msg", "관리자 권한이 필요합니다.");
        return "access_denied"; // 권한 없음 페이지
    }

    // 2. 공지사항 등록 처리 (POST)
    @PostMapping("/board/notice/write")
    public String noticeWriteProc(
            @RequestHeader(value = "Authorization", required = false) String bearerToken,
            @RequestParam String category,
            @RequestParam String title,
            @RequestParam String content,
            @RequestParam(required = false, defaultValue = "false") String isImportant) {

        if (!isAdmin(bearerToken))
            return "redirect:/access_denied";

        String sql = "INSERT INTO notices (category, title, writer, content, reg_date, is_important) VALUES (?, ?, '관리자', ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, category);
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.setString(4, LocalDate.now().toString());
            pstmt.setBoolean(5, Boolean.parseBoolean(isImportant));
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/lecture_view?tab=notice";
    }

    // 3. 공지사항 삭제 (GET)
    @GetMapping("/board/notice/delete")
    public String noticeDelete(@RequestParam int no) {
        String sql = "DELETE FROM notices WHERE no = ?";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, no);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/lecture_view?tab=notice";
    }

    // 4. 공지사항 수정 페이지 이동 (GET)
    @GetMapping("/board/notice/edit")
    public String noticeEditForm(@RequestParam int no, org.springframework.ui.Model model) {
        String sql = "SELECT * FROM notices WHERE no = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, no);
            java.sql.ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                java.util.Map<String, Object> notice = new java.util.HashMap<>();
                notice.put("no", rs.getInt("no"));
                notice.put("category", rs.getString("category"));
                notice.put("title", rs.getString("title"));
                notice.put("content", rs.getString("content"));
                notice.put("is_important", rs.getBoolean("is_important"));
                model.addAttribute("notice", notice);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "notice_edit";
    }

    // 5. 공지사항 수정 처리 (POST)
    @PostMapping("/board/notice/edit")
    public String noticeEditProc(
            @RequestParam int no,
            @RequestParam String category,
            @RequestParam String title,
            @RequestParam String content,
            @RequestParam(required = false, defaultValue = "false") String isImportant) {
        String sql = "UPDATE notices SET category=?, title=?, content=?, is_important=? WHERE no=?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, category);
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.setBoolean(4, Boolean.parseBoolean(isImportant));
            pstmt.setInt(5, no);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/board/notice/view?no=" + no;
    }

    // 6. 숨기기 토글 (GET)
    @GetMapping("/board/notice/hide")
    public String noticeHideToggle(@RequestParam int no) {
        String sql = "UPDATE notices SET is_visible = NOT is_visible WHERE no = ?";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, no);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/board/notice/view?no=" + no;
    }

    private boolean isAdmin(String bearerToken) {
        if (bearerToken == null || !bearerToken.startsWith("Bearer ")) {
            return false;
        }
        String token = bearerToken.substring(7);
        String role = JwtUtil.getRoleVulnerable(token);
        return "admin".equals(role);
    }
}
