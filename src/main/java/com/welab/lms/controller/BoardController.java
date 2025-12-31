package com.welab.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate; // 날짜 저장을 위해 필요

@Controller
public class BoardController {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/board/list")
    public String boardList() {
        return "board_list";
    }

    // 공지사항 작성 페이지 이동 (GET)
    @GetMapping("/board/notice/write")
    public String noticeWriteForm() {
        return "notice_write";
    }

    // ==========================================
    // 1. 공지사항 상세 조회 (GET)
    // ==========================================
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

    // ==========================================
    // 2. 공지사항 삭제 (GET) - 취약점: 권한 체크 없음!
    // ==========================================
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

    // ==========================================
    // 3. 공지사항 수정 페이지 이동 (GET)
    // ==========================================
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

    // ==========================================
    // 4. 공지사항 수정 처리 (POST)
    // ==========================================
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

    // ==========================================
    // 5. 공지사항 등록 처리 (POST)
    // ==========================================
    @PostMapping("/board/notice/write")
    public String noticeWriteProc(
            @RequestParam String category,
            @RequestParam String title,
            @RequestParam String content,
            // @RequestParam String writer, <-- 이거 삭제함 (화면에서 안 받음)
            @RequestParam(required = false, defaultValue = "false") String isImportant,
            javax.servlet.http.HttpSession session // <-- 세션 추가
    ) {
        // [핵심] 화면에서 받는 게 아니라, 서버에 저장된 세션 정보에서 꺼냄
        String writer = (String) session.getAttribute("user_name");

        // 만약 로그인을 안 하고 URL로 몰래 들어왔다면? (세션이 없음)
        if (writer == null) {
            writer = "익명(해킹시도)";
        }

        String sql = "INSERT INTO notices (category, title, writer, content, reg_date, is_important) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category);
            pstmt.setString(2, title);
            pstmt.setString(3, writer); // 세션에서 꺼낸 이름 저장
            pstmt.setString(4, content);
            pstmt.setString(5, LocalDate.now().toString());
            pstmt.setBoolean(6, Boolean.parseBoolean(isImportant));

            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/lecture_view?tab=notice";
    }

    // ==========================================
    // 6. 공지사항 숨기기/공개 토글 (GET) - 취약점: 권한 체크 없음
    // ==========================================
    @GetMapping("/board/notice/hide")
    public String noticeHideToggle(@RequestParam int no) {
        // [SQL] 현재 값의 반대로 뒤집기 (NOT 연산)
        String sql = "UPDATE notices SET is_visible = NOT is_visible WHERE no = ?";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, no);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 처리가 끝나면 다시 해당 글 상세 페이지로 돌아감
        return "redirect:/board/notice/view?no=" + no;
    }
}