package com.welab.lms.web.controller;

import com.welab.lms.domain.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private BoardService boardService;

    // --- [조회 기능] ---

    // 공지사항 전체 목록 페이지 호출
    @GetMapping("/list")
    public String boardList() {
        return "notice/notice"; // 리스트는 notice.jsp 사용
    }

    // 특정 공지사항 상세 내용 보기
    @GetMapping("/notice/view")
    public String noticeView(@RequestParam int no, Model model) {
        model.addAttribute("notice", boardService.getNotice(no));
        return "notice/notice_view";
    }

    // --- [등록 기능] ---

    // 공지사항 작성 폼 호출 및 관리자 권한 확인 [취약점: 서명 검증이 없는 JWT를 이용한 권한 인증 우회 가능]
    @GetMapping("/notice/write")
    public String noticeWriteForm(
            @RequestHeader(value = "Authorization", required = false) String headerToken,
            @RequestHeader(value = "accessToken", required = false) String cookieToken, // 쿠키 등 다양한 경로 고려
            HttpSession session,
            Model model) {

        // 1. 헤더에 토큰이 없으면 세션에 저장된 토큰이라도 가져와 봅니다.
        String token = headerToken;
        if (token == null) {
            String sessionToken = (String) session.getAttribute("accessToken");
            if (sessionToken != null) {
                token = "Bearer " + sessionToken;
            }
        }

        // 2. 관리자 권한 체크
        if (boardService.checkAdmin(token)) {
            return "notice/notice_write";
        }

        model.addAttribute("msg", "관리자 권한(JWT)이 필요합니다. 토큰이 유효하지 않거나 누락되었습니다.");
        return "common/access_denied";
    }

    // 신규 공지사항 등록 처리 [취약점: Stored XSS - 본문 내용에 대한 스크립트 필터링 부재]
    @PostMapping("/notice/write")
    public String noticeWriteProc(
            @RequestHeader(value = "Authorization", required = false) String headerToken,
            @CookieValue(value = "accessToken", required = false) String cookieToken,
            @RequestParam String category,
            @RequestParam String title,
            @RequestParam String content,
            @RequestParam(defaultValue = "false") boolean isImportant,
            HttpSession session) {

        // 1. 헤더 -> 쿠키 -> 세션 순으로 토큰 찾기
        String finalToken = headerToken;
        if (finalToken == null && cookieToken != null) {
            finalToken = "Bearer " + cookieToken;
        }
        if (finalToken == null) {
            String sessionToken = (String) session.getAttribute("accessToken");
            if (sessionToken != null)
                finalToken = "Bearer " + sessionToken;
        }

        // 2. [취약점 유지] 변조 가능한 토큰으로 관리자 권한 체크
        if (!boardService.checkAdmin(finalToken)) {
            return "redirect:/access_denied?msg=Admin token is missing in POST request";
        }

        // 3. 데이터 구성
        Map<String, Object> notice = new HashMap<>();
        notice.put("category", category);
        notice.put("title", title);
        notice.put("content", content); // [취약점] Stored XSS 실습을 위해 필터링 없이 저장
        notice.put("is_important", isImportant);

        // 4. 저장 및 리다이렉트
        boardService.writeNotice(notice);

        return "redirect:/lecture_view?tab=notice";
    }

    // --- [수정 기능] ---

    // 게시글 수정을 위한 기존 데이터 로드 및 폼 호출
    @GetMapping("/notice/edit")
    public String noticeEditForm(@RequestParam int no, Model model) {
        model.addAttribute("notice", boardService.getNotice(no));
        return "notice/notice_edit";
    }

    // 공지사항 수정 내용 반영 처리
    @PostMapping("/notice/edit")
    public String noticeEditProc(@RequestParam int no, @RequestParam String category,
            @RequestParam String title, @RequestParam String content,
            @RequestParam(defaultValue = "false") boolean isImportant) {
        Map<String, Object> notice = new HashMap<>();
        notice.put("no", no);
        notice.put("category", category);
        notice.put("title", title);
        notice.put("content", content);
        notice.put("is_important", isImportant);

        boardService.modifyNotice(notice);
        return "redirect:/board/notice/view?no=" + no;
    }

    // 게시글의 공개/숨김 상태 토글 처리
    @GetMapping("/notice/hide")
    public String noticeHideToggle(@RequestParam int no) {
        boardService.hideToggle(no);
        return "redirect:/board/notice/view?no=" + no;
    }

    // --- [삭제 및 유틸리티] ---

    // 특정 공지사항 데이터 삭제 처리
    @GetMapping("/notice/delete")
    public String noticeDelete(@RequestParam int no) {
        boardService.removeNotice(no);
        return "redirect:/lecture_view?tab=notice";
    }

    // 접근 권한 부족 시 오류 메시지 페이지 호출
    @GetMapping("/access_denied")
    public String accessDenied(@RequestParam(required = false) String msg, Model model) {
        model.addAttribute("msg", msg != null ? msg : "접근 권한이 없습니다.");
        return "common/access_denied";
    }
}