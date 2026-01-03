package com.welab.lms.web.controller;

import com.welab.lms.domain.service.LectureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class LectureController {

    @Autowired
    private LectureService lectureService;

    // 메인 강의 대시보드 페이지 호출 및 각 탭별 통합 데이터 조회 [취약점: 세션 기반 권한 검증 미흡 및 인가 로직 부재]
    @GetMapping("/lecture_view")
    public String lectureView(@RequestParam(defaultValue = "roadmap") String tab,
            Model model, HttpSession session) {

        // [로직] 강의 제목, 진도율, 현재 선택된 탭 정보를 화면에 표시하기 위해 모델에 설정
        model.addAttribute("courseTitle", "생성형 AI 활용 사이버보안 전문인력 양성과정 28기");
        model.addAttribute("progress", "39");
        model.addAttribute("currentTab", tab);

        // [로직] 세션에 저장된 사용자 아이디 추출 [취약점: 세션 고정 공격이나 불충분한 세션 유효성 체크 위험]
        String userId = (String) session.getAttribute("user_id");

        // [로직] 서비스 계층을 통해 과정 평가, 공지사항(권한별), 스터디 목록을 통합적으로 조회
        model.addAttribute("evalList", lectureService.getEvaluations());
        model.addAttribute("noticeList", lectureService.getNotices(userId));
        model.addAttribute("studyList", lectureService.getStudyGroups());

        // [로직] 최종 대시보드 화면인 lecture_view.jsp 경로 반환
        return "study/lecture_view";
    }
}