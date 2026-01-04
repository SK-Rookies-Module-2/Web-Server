package com.welab.lms.web.controller;

import com.welab.lms.domain.service.StudyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

@Controller
@RequestMapping("/study")
public class StudyController {
    @Autowired
    private StudyService studyService;

    // --- [스터디 그룹 관리 기능] ---

    // 신규 스터디 그룹 등록을 위한 입력 폼 페이지 호출
    @GetMapping("/register")
    public String studyRegisterForm() {
        return "study/study_register";
    }

    // 전송된 파라미터를 기반으로 스터디 그룹 생성 실행
    @PostMapping("/register")
    public String studyRegisterProc(@RequestParam Map<String, Object> params,
            @RequestParam(required = false) String pre_members,
            HttpSession session, Model model) {
        params.put("writer", session.getAttribute("user_name"));
        params.put("capacity", Integer.parseInt((String) params.get("capacity")));

        String result = studyService.registerStudy(params, pre_members);
        if (result.startsWith("error:")) {
            model.addAttribute("msg", "존재하지 않는 회원: " + result.split(":")[1]);
            return "study/study_register";
        }
        return "redirect:/lecture_view?tab=study";
    }

    // --- [조회 기능] ---

    // 스터디 게시판 메인 및 게시글 목록 조회 [취약점: SQL Injection - no 파라미터 조작 가능]
    @GetMapping("/board")
    public String studyBoard(@RequestParam String no, Model model) {
        model.addAttribute("study", studyService.getStudyDetail(no));
        model.addAttribute("postList", studyService.getPostList(no));
        return "study/study_board";
    }

    // 스터디 상세 정보 조회(이전 매핑 대응) [취약점: SQL Injection]
    @GetMapping("/view")
    public String studyView(@RequestParam String no, Model model) {
        model.addAttribute("study", studyService.getStudyDetail(no));
        model.addAttribute("postList", studyService.getPostList(no));
        return "study/study_board";
    }

    // 특정 스터디의 기본 정보 상세 조회 [취약점: SQL Injection]
    @GetMapping("/detail")
    public String studyDetail(@RequestParam String no, Model model) {
        model.addAttribute("study", studyService.getStudyDetail(no));
        return "study/study_post_detail";
    }

    // 특정 게시글의 상세 내용 및 첨부 파일 정보 조회 [취약점: SQL Injection]
    @GetMapping("/post/detail")
    public String studyPostDetail(@RequestParam String no, Model model) {
        // [로직] DB에서 게시글 상세 데이터를 조회하여 모델에 전달
        Map<String, Object> postData = studyService.getPostDetail(no);

        // [디버깅] 데이터 바인딩 확인을 위한 서버 로그 출력
        System.out.println("컨트롤러가 DB에서 가져온 데이터: " + postData);

        model.addAttribute("post", postData);
        return "study/study_post_detail";
    }

    // --- [등록 및 파일 처리 기능] ---

    // 게시글 내용 저장 및 첨부 파일 업로드 실행 [취약점: 무제한 파일 업로드 - WebShell 등 악성 파일 실행 권한 획득 가능]
    @PostMapping("/upload")
    public String studyFileUpload(@RequestParam("file") MultipartFile file,
            @RequestParam String title,
            @RequestParam String content,
            @RequestParam int no,
            HttpSession session, HttpServletRequest request) {

        // [로직] 서버 내 물리적 업로드 경로 설정
        String uploadPath = request.getServletContext().getRealPath("/folder");
        // [취약점] 파일 확장자 및 실행 권한에 대한 검증 없이 서버에 저장
        String fileName = studyService.uploadFileVulnerable(file, uploadPath);
        String writer = (String) session.getAttribute("user_name");

        studyService.savePost(no, title, writer, content, fileName);

        return "redirect:/study/board?no=" + no;
    }

    // 서버에 저장된 첨부 파일 다운로드 처리 [취약점: Path Traversal - 상위 경로(../) 이동을 통한 시스템 파일 탈취]
    @GetMapping("/download")
    public void fileDownload(@RequestParam String fileName, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String uploadPath = request.getServletContext().getRealPath("/static/folder");
        // [취약점] fileName 파라미터에 대한 필터링 부재로 의도하지 않은 경로의 파일 접근 가능
        File file = studyService.getDownloadFileVulnerable(fileName, uploadPath);

        if (file.exists()) {
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
            try (FileInputStream fis = new FileInputStream(file);
                    OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[1024];
                int len;
                while ((len = fis.read(buffer)) != -1)
                    os.write(buffer, 0, len);
            }
        }
    }

    // --- [수정 및 삭제 기능] ---

    // 게시글 수정을 위한 기존 데이터 로딩 및 폼 호출 [취약점: SQL Injection 및 IDOR - 타인 게시글 접근 가능]
    @GetMapping("/post/edit")
    public String studyPostEditForm(@RequestParam String no, Model model) {
        model.addAttribute("post", studyService.getPostDetail(no));
        return "study/study_post_edit";
    }

    // 게시글 내용 수정 사항 반영 실행 [취약점: SQL Injection]
    @PostMapping("/post/edit")
    public String studyPostEditProc(@RequestParam Map<String, Object> params) {
        studyService.updatePost(params);
        String studyNo = (String) params.get("study_no");
        return "redirect:/study/view?no=" + studyNo;
    }

    // 게시글 데이터 삭제 및 관련 물리 파일 삭제 실행 [취약점: SQL Injection 및 IDOR]
    @GetMapping("/post/delete")
    public String studyPostDelete(@RequestParam String no, @RequestParam String studyNo, HttpServletRequest request) {
        String uploadPath = request.getServletContext().getRealPath("/static/folder");
        // [취약점] 삭제 대상에 대한 본인 여부 확인 로직 부재
        studyService.deletePost(no, uploadPath);
        return "redirect:/study/view?no=" + studyNo;
    }

    @GetMapping("/external/preview")
    public void getExternalPreview(@RequestParam String url, HttpServletResponse response) {
        // [로직] 사용자가 보낸 외부 URL을 서비스 계층에 전달하여 데이터를 가져오게 함
        studyService.fetchRemoteResource(url, response);
    }
}