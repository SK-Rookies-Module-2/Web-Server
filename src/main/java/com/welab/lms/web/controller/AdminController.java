package com.welab.lms.web.controller;

import com.welab.lms.domain.service.AdminService;
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

    // 관리자용 전체 사용자 목록 페이지 호출 [취약점: 클라이언트 측 쿠키 조작을 통한 인가 우회 가능]
    @GetMapping("/admin/users")
    public String adminUserList(HttpServletRequest request, Model model) {
        if (!isAdmin(request)) {
            return "redirect:/dashboard";
        }

        model.addAttribute("userList", adminService.getUserList());
        return "admin/admin_users";
    }

    // 특정 사용자 정보 수정을 위한 데이터 조회 및 폼 페이지 반환 [취약점: 부적절한 인증 시나리오 및 IDOR]
    @GetMapping("/admin/user/edit")
    public String editUserForm(@RequestParam String id, HttpServletRequest request, Model model) {
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
        if (!isAdmin(request)) {
            return "redirect:/dashboard";
        }

        adminService.modifyUser(id, name, email, awsAccount, awsPw);
        return "redirect:/admin/users";
    }

    // 요청 프로토콜의 쿠키 값을 분석하여 관리자 여부 확인 [취약점: 고정된 쿠키 명칭 및 값(role=ADMIN) 사용으로 인한 보안 취약]
    private boolean isAdmin(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // [취약점] 서버 세션 검증 없이 'role' 쿠키가 'ADMIN'이면 즉시 권한 승인
                if (cookie.getName().equals("role") && cookie.getValue().equals("ADMIN")) {
                    return true;
                }
            }
        }
        return false;
    }
}