package com.welab.lms.web.controller;

import com.welab.lms.domain.service.MyInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
public class MyInfoController {

    @Autowired
    private MyInfoService myInfoService;

    // 파라미터로 전달받은 ID를 기반으로 사용자 상세 프로필 정보 조회 [취약점: IDOR - 세션 검증 부재로 인한 타인 정보 열람 가능]
    @GetMapping("/myinfo")
    public String myInfo(@RequestParam String id, Model model) {
        // [취약점] 현재 로그인된 세션 사용자와 요청 파라미터 'id'의 일치 여부를 검사하지 않음
        Map<String, Object> profile = myInfoService.getUserProfile(id);

        if (profile != null) {
            model.addAllAttributes(profile);
        }

        return "user/myinfo";
    }

    // 비밀번호 변경을 위한 입력 폼 페이지 호출
    @GetMapping("/changePw")
    public String showChangePwPage() {
        return "user/changePw";
    }

    // 현재 비밀번호 확인 후 새로운 비밀번호로 업데이트 처리 및 결과 반환
    @PostMapping("/user/updatePassword")
    @ResponseBody
    public ResponseEntity<String> updatePassword(
            @RequestParam String currentPw,
            @RequestParam String newPw,
            HttpSession session) {

        // [로직] 세션에서 현재 로그인된 사용자의 고유 식별자(ID) 추출
        String userId = (String) session.getAttribute("user_id");

        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session Expired");
        }

        // [로직] 서비스 계층을 통해 기존 비밀번호 일치 여부 검증 및 새 비밀번호 반영
        boolean success = myInfoService.changePassword(userId, currentPw, newPw);

        if (success) {
            // [보안] 비밀번호가 변경된 경우 기존 세션을 즉시 무효화하여 보안성 강화
            session.invalidate();
            return ResponseEntity.ok("Success");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Current password incorrect");
        }
    }
}