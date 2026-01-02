package com.welab.lms.controller;

// Spring Framework 관련
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

// Servlet 및 HTTP 세션 관련
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Database (JDBC) 관련 - [주의] java.sql.Statement를 사용해야 합니다.
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

// Java 유틸리티 및 입출력
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

    @PostMapping("/study/upload")
    public String studyFileUpload(@RequestParam("file") MultipartFile file,
            @RequestParam("title") String title,
            @RequestParam("no") int studyNo, // 파라미터 추가
            HttpSession session,
            HttpServletRequest request) throws IOException {

        String fileName = "";
        if (!file.isEmpty()) {
            String uploadPath = request.getServletContext().getRealPath("/static/folder");
            fileName = file.getOriginalFilename();
            File dest = new File(uploadPath + File.separator + fileName);
            file.transferTo(dest);
        }

        // DB 저장 (사용자명은 세션에서 가져옴)
        String writer = (String) session.getAttribute("user_name");
        String sql = "INSERT INTO study_posts (study_no, title, writer, file_name) VALUES (?, ?, ?, ?)";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studyNo);
            pstmt.setString(2, title);
            pstmt.setString(3, writer);
            pstmt.setString(4, fileName);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/study/board?no=" + studyNo; // 다시 해당 게시판으로
    }

    @GetMapping("/study/detail")
    public String studyDetail(@RequestParam("no") String no, Model model) {
        try (Connection conn = dataSource.getConnection()) {
            Statement stmt = conn.createStatement();

            // [취약점 유지] SQL Injection이 가능한 형태의 쿼리
            String sql = "SELECT * FROM study_groups WHERE no = " + no;
            ResultSet rs = stmt.executeQuery(sql);

            if (rs.next()) {
                // DB 데이터를 Map이나 VO 객체에 담아 'study'라는 이름으로 모델에 추가
                Map<String, Object> study = new HashMap<>();
                study.put("no", rs.getInt("no"));
                study.put("title", rs.getString("title"));
                study.put("content", rs.getString("content"));
                study.put("writer", rs.getString("writer"));
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
        return "study_detail"; // 위에서 만든 상세 페이지 JSP 이름
    }

    // StudyController.java에 추가
    @GetMapping("/study/board")
    public String studyBoard(@RequestParam("no") String no, Model model) {
        try (Connection conn = dataSource.getConnection()) {
            Statement stmt = conn.createStatement();

            // 1. 상단 헤더용 스터디 정보 (SQLi 취약점 유지)
            String studySql = "SELECT * FROM study_groups WHERE no = " + no;
            ResultSet rsStudy = stmt.executeQuery(studySql);
            if (rsStudy.next()) {
                Map<String, Object> study = new HashMap<>();
                study.put("no", rsStudy.getInt("no"));
                study.put("title", rsStudy.getString("title"));
                study.put("pre_members", rsStudy.getString("pre_members"));
                study.put("capacity", rsStudy.getInt("capacity"));
                study.put("frequency", rsStudy.getString("frequency"));
                study.put("status", rsStudy.getString("status"));
                model.addAttribute("study", study);
            }

            // 2. 게시판 목록 데이터 (새로 만든 study_posts 테이블 연동)
            String postSql = "SELECT * FROM study_posts WHERE study_no = " + no + " ORDER BY post_no DESC";
            ResultSet rsPosts = stmt.executeQuery(postSql);

            List<Map<String, Object>> postList = new ArrayList<>();
            while (rsPosts.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("post_no", rsPosts.getInt("post_no"));
                post.put("title", rsPosts.getString("title"));
                post.put("writer", rsPosts.getString("writer"));
                post.put("file_name", rsPosts.getString("file_name")); // 파일명 추가
                post.put("reg_date", rsPosts.getString("reg_date"));
                postList.add(post);
            }
            model.addAttribute("postList", postList);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "study_board";
    }

    // 6. 게시글 삭제
    @GetMapping("/study/post/delete")
    public String deleteStudyPost(
            @RequestParam("no") int postNo,
            @RequestParam int studyNo,
            HttpServletRequest request) {

        String selectSql = "SELECT file_name FROM study_posts WHERE post_no = ?";
        String deleteSql = "DELETE FROM study_posts WHERE post_no = ?";

        try (Connection conn = dataSource.getConnection()) {

            // 1. 삭제 전 파일명 먼저 조회
            String fileName = null;
            try (PreparedStatement pstmt = conn.prepareStatement(selectSql)) {
                pstmt.setInt(1, postNo);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    fileName = rs.getString("file_name");
                }
            }

            // 2. 실제 파일이 존재한다면 서버 폴더에서 삭제
            if (fileName != null && !fileName.trim().isEmpty()) {
                String uploadPath = request.getServletContext().getRealPath("/static/folder");
                File file = new File(uploadPath + File.separator + fileName);

                if (file.exists()) {
                    if (file.delete()) {
                        System.out.println("[파일 삭제 성공] " + fileName);
                    } else {
                        System.out.println("[파일 삭제 실패] 권한 문제 또는 파일 사용 중");
                    }
                }
            }

            // 3. DB 레코드 삭제
            try (PreparedStatement pstmt = conn.prepareStatement(deleteSql)) {
                pstmt.setInt(1, postNo);
                pstmt.executeUpdate();
                System.out.println("[공격 성공 확인] " + postNo + "번 데이터가 삭제되었습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/study/board?no=" + studyNo;
    }

    // 7. 게시글 수정 폼 (다시 취약하게 수정: 작성자 검사 삭제)
    @GetMapping("/study/post/edit")
    public String editStudyPostForm(@RequestParam("no") int postNo, Model model) {
        String sql = "SELECT * FROM study_posts WHERE post_no = ?";
        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postNo);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("post_no", rs.getInt("post_no"));
                post.put("title", rs.getString("title"));
                post.put("content", rs.getString("content"));
                post.put("study_no", rs.getInt("study_no"));
                model.addAttribute("post", post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "study_post_edit";
    }

    @PostMapping("/study/post/edit")
    public String editStudyPostProc(
            @RequestParam int no,
            @RequestParam int studyNo,
            @RequestParam String title,
            @RequestParam String content) {

        String sql = "UPDATE study_posts SET title = ?, content = ? WHERE post_no = ?";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setInt(3, no);
            pstmt.executeUpdate();

            System.out.println("[수정 완료] 게시글 번호: " + no);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/study/board?no=" + studyNo;
    }

    // 다운로드 로직
    @GetMapping("/study/download")
    public void fileDownload(@RequestParam String fileName,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        // 사용자가 입력한 fileName에 '../'와 같은 경로 조작 문자열이 있는지 검증하지 않음
        String uploadPath = request.getServletContext().getRealPath("/static/folder");
        File file = new File(uploadPath + File.separator + fileName);

        if (file.exists()) {
            // 파일을 읽어서 브라우저로 전송하는 로직
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

            try (FileInputStream fis = new FileInputStream(file);
                    OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[1024];
                int len;
                while ((len = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, len);
                }
            }
        }
    }

    @GetMapping("/study/post/detail")
    public String studyPostDetail(@RequestParam("no") int postNo, Model model) {
        String sql = "SELECT * FROM study_posts WHERE post_no = ?";

        try (Connection conn = dataSource.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postNo);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("post_no", rs.getInt("post_no"));
                post.put("title", rs.getString("title"));
                post.put("writer", rs.getString("writer"));
                post.put("content", rs.getString("content"));
                post.put("file_name", rs.getString("file_name"));
                post.put("reg_date", rs.getString("reg_date"));
                post.put("study_no", rs.getInt("study_no"));
                model.addAttribute("post", post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "study_post_detail";
    }
}
