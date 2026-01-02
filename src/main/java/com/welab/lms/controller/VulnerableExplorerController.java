package com.welab.lms.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

@RestController
public class VulnerableExplorerController {

    @GetMapping("/root/**") // 오직 /root/로 시작하는 요청만 처리합니다.
    public String explore(HttpServletRequest request) {
        String uri = request.getRequestURI();
        try {
            // 1. URL에서 "/root"를 제거하고 실제 시스템 경로를 만듭니다.
            String pathInSystem = URLDecoder.decode(uri.replace("/root", ""), StandardCharsets.UTF_8.toString());

            // 2. 로컬(윈도우)과 리눅스를 모두 지원하기 위한 경로 설정
            String os = System.getProperty("os.name").toLowerCase();
            String baseRoot = os.contains("win") ? "C:/" : "/";

            File target = new File(baseRoot + pathInSystem);

            if (!target.exists())
                return "경로를 찾을 수 없습니다: " + target.getAbsolutePath();

            // 3. 폴더인 경우 목록 출력
            if (target.isDirectory()) {
                StringBuilder sb = new StringBuilder();
                sb.append("<h1>Index of ").append(pathInSystem).append("</h1><hr><pre>");
                File[] files = target.listFiles();
                if (files != null) {
                    for (File f : files) {
                        String name = f.getName();
                        // 클릭 시 이동할 수 있도록 /root를 앞에 붙여줍니다.
                        String link = "/root" + (pathInSystem.endsWith("/") ? pathInSystem : pathInSystem + "/") + name;
                        sb.append("<a href='").append(link).append("'>")
                                .append(f.isDirectory() ? name + "/" : name).append("</a>\n");
                    }
                }
                return sb.toString();
            }

            // 4. 파일인 경우 텍스트로 출력
            return "<pre>" + new String(Files.readAllBytes(target.toPath()), StandardCharsets.UTF_8) + "</pre>";

        } catch (Exception e) {
            return "에러 발생: " + e.getMessage();
        }
    }
}
