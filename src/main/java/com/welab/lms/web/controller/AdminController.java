package com.welab.lms.web.controller;

import com.welab.lms.domain.service.AdminService;
import com.welab.lms.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

@Controller
public class AdminController {

    @Autowired
    private AdminService adminService;

    // 관리자용 전체 사용자 목록 페이지 호출 [취약점: 조작된 JWT 헤더(alg: none)를 이용한 관리자 권한 탈취]
    @GetMapping("/admin/users")
    public String adminUserList(HttpServletRequest request, Model model) {
        // [로직] 요청 프로토콜 내의 인증 정보를 확인하여 관리자 권한 검증 수행
        if (!isAdmin(request)) {
            return "redirect:/dashboard";
        }

        model.addAttribute("userList", adminService.getUserList());
        return "admin/admin_users";
    }

    // 특정 사용자 정보 수정을 위한 데이터 조회 및 폼 페이지 반환 [취약점: 부적절한 인증 시나리오 및 IDOR]
    @GetMapping("/admin/user/edit")
    public String editUserForm(@RequestParam String id, HttpServletRequest request, Model model) {
        // [로직] 데이터 수정 권한 확인을 위해 관리자 세션 유효성 검사 실시
        if (!isAdmin(request)) {
            return "redirect:/dashboard";
        }

        model.addAttribute("user", adminService.getUserDetail(id));
        return "admin/admin_user_edit";
    }

    // 전송된 파라미터를 바탕으로 사용자 정보 수정 실행 [취약점: 관리자 권한 검증 로직의 무력화]
    @PostMapping("/admin/user/edit")
    public String editUserProc(@RequestParam String id, @RequestParam String name,
            @RequestParam String email, @RequestParam String awsAccount,
            @RequestParam String awsPw, HttpServletRequest request) {
        // [로직] 민감한 정보 수정 전 최종적으로 요청자의 관리자 권한 재검증
        if (!isAdmin(request)) {
            return "redirect:/dashboard";
        }

        adminService.modifyUser(id, name, email, awsAccount, awsPw);
        return "redirect:/admin/users";
    }

    // 요청 쿠키에 포함된 JWT를 분석하여 관리자 여부 확인 [취약점: 서명 검증이 누락된 취약한 토큰 분석 로직 사용]
    private boolean isAdmin(HttpServletRequest request) {
        String token = null;
        Cookie[] cookies = request.getCookies();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // [로직] 쿠키 배열에서 사용자 인증 토큰이 저장된 'accessToken' 식별
                if (cookie.getName().equals("accessToken")) {
                    token = cookie.getValue();
                    break;
                }
            }
        }

        // [취약점] 전달받은 토큰의 무결성을 검증하지 않고, 헤더의 알고리즘(alg) 설정값에 의존하여 권한 여부 판단
        String role = JwtUtil.getRoleVulnerable(token);

        // [로직] 추출된 권한 정보가 'ADMIN'과 일치하는지 비교하여 최종 결과 반환
        return "ADMIN".equalsIgnoreCase(role);
    }
}