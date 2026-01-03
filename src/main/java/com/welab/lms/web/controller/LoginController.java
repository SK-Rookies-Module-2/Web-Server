package com.welab.lms.web.controller;

import com.welab.lms.domain.service.LoginService;
import com.welab.lms.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
public class LoginController {

    @Autowired
    private LoginService loginService;

    // --- [로그인 관련 기능] ---

    // 로그인 입력 폼 페이지 호출
    @GetMapping("/")
    public String loginPage() {
        return "login/login";
    }

    // 로그인 인증 수행 및 세션/쿠키/JWT 발급 처리 [취약점: SQL Injection 및 쿠키 변조/평문 노출]
    @PostMapping("/loginAction")
    public String loginAction(@RequestParam String id, @RequestParam String pw,
            HttpSession session, Model model, HttpServletResponse response) {

        // [취약점] SQL Injection 공격에 취약한 서비스 로직 호출
        Map<String, Object> user = loginService.authenticate(id, pw);

        if (user != null) {
            String role = user.get("role") != null ? (String) user.get("role") : "USER";
            String name = (String) user.get("name");

            // 1. [로직] 세션에 사용자 주요 정보(ID, 권한, 이름) 저장
            session.setAttribute("user_id", user.get("id"));
            session.setAttribute("user_role", role);
            session.setAttribute("user_name", name);

            // 2. [취약점] 클라이언트가 직접 조작 가능한 평문 권한 쿠키 발급
            Cookie roleCookie = new Cookie("role", role);
            roleCookie.setPath("/");
            roleCookie.setMaxAge(60 * 60);
            response.addCookie(roleCookie);

            // 3. [로직] 서명 검증 없는 취약한 형태를 포함할 수 있는 JWT 토큰 생성
            String token = JwtUtil.createToken((String) user.get("id"), role);

            // 4. [해결] 브라우저 직접 접속 시에도 인증 유지를 위해 쿠키에 JWT 저장 (실습을 위해 HttpOnly 비활성)
            Cookie jwtCookie = new Cookie("accessToken", token);
            jwtCookie.setPath("/");
            jwtCookie.setMaxAge(60 * 60);
            // jwtCookie.setHttpOnly(true); // 실습 과정에서의 JS 접근 허용을 위해 주석 처리
            response.addCookie(jwtCookie);

            // 5. [해결] 서버 측 컨트롤러에서 참조 가능하도록 세션에도 JWT 저장
            session.setAttribute("accessToken", token);

            model.addAttribute("jwtToken", token);
            return "login/login_success";
        }

        return "login/login";
    }

    // --- [회원가입 관련 기능] ---

    // 신규 회원가입 입력 폼 페이지 호출
    @GetMapping("/register")
    public String registerPage() {
        return "login/register";
    }

    // 신규 사용자 정보 및 자동 생성된 AWS 계정 정보 저장 [취약점: 민감 정보(비밀번호) 평문 저장]
    @PostMapping("/registerAction")
    public String registerAction(@RequestParam Map<String, String> params) {
        // [취약점] 패스워드 해싱 없이 DB에 저장하는 서비스 호출
        loginService.registerUser(params);
        return "redirect:/";
    }

    // --- [계정 찾기 기능] ---

    // 아이디 및 비밀번호 찾기 통합 페이지 호출
    @GetMapping({ "/find-id", "/find-pw" })
    public String findAccountPage() {
        return "login/find_account";
    }

    // 이름과 이메일 정보를 통한 아이디 조회 수행 [취약점: SQL Injection을 통한 계정 정보 노출]
    @PostMapping("/findIdAction")
    public String findIdAction(@RequestParam String name, @RequestParam String email, Model model) {
        String id = loginService.findUserId(name, email);
        model.addAttribute("msg", id != null ? "찾으시는 아이디는 [" + id + "] 입니다." : "일치하는 정보가 없습니다.");
        return "login/find_account";
    }

    // 고정된 임시 비밀번호로 사용자 비밀번호 초기화 [취약점: 취약하고 예측 가능한 비밀번호 재설정 정책]
    @PostMapping("/findPwAction")
    public String findPwAction(@RequestParam String id, @RequestParam String email, Model model) {
        // [취약점] 보안성이 낮은 고정 문자열("1q2w3e4r!@#")을 임시 비밀번호로 사용
        String tempPw = loginService.resetToTempPassword(id, email);
        model.addAttribute("msg", tempPw != null ? "비밀번호가 임시 비밀번호 [" + tempPw + "] 로 초기화되었습니다." : "일치하는 정보가 없습니다.");
        return "login/find_account";
    }

    // --- [대시보드 및 로그아웃] ---

    // 로그인 성공 후 사용자 메인 대시보드 페이지 호출 [취약점: 불충분한 세션 검증]
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session) {
        // [취약점] 공통 필터나 인터셉터가 아닌 개별 메서드에서 세션을 체크하여 누락 가능성 존재
        if (session.getAttribute("user_id") == null) {
            return "redirect:/";
        }
        return "user/dashboard";
    }

    // 로그아웃 처리 및 메인 리다이렉트 [취약점: 불완전한 세션 종료/세션 재사용 가능성]
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // [취약점] session.invalidate()를 명시적으로 호출하지 않아 세션 토큰이 유효하게 남을 수 있음
        return "redirect:/";
    }
}