package com.welab.lms.web.controller;

import com.welab.lms.domain.service.ExplorerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.http.HttpServletRequest;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@RestController
public class VulnerableExplorerController {

    @Autowired
    private ExplorerService explorerService;

    // 와일드카드(**) 경로를 이용한 시스템 파일 탐색 및 내용 반환 [취약점: 경로 조작(Directory Traversal) - 상위
    // 디렉토리 이동 문자열(..)에 대한 검증 부재]
    @GetMapping("/root/**")
    public String explore(HttpServletRequest request) {
        String uri = request.getRequestURI();
        try {
            // [로직] 요청 URI에서 "/root" 프리픽스를 제거하여 탐색할 시스템 경로 추출
            String pathInSystem = URLDecoder.decode(
                    uri.replace("/root", ""),
                    StandardCharsets.UTF_8.toString());

            // [취약점] URL 디코딩 후 필터링되지 않은 경로가 서비스 계층에 그대로 전달되어 루트 외부 파일 접근 가능
            return explorerService.explorePath(pathInSystem);

        } catch (Exception e) {
            return "에러 발생: " + e.getMessage();
        }
    }
}