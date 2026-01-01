package com.welab.lms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

@Controller
public class UltimateDirectoryController {

    @GetMapping("/**")
    @ResponseBody
    public String showAnyContent(HttpServletRequest request) {
        String uri = request.getRequestURI();
        try {
            uri = URLDecoder.decode(uri, StandardCharsets.UTF_8.toString());

            // 리눅스 전체를 보고 싶다면 "/", 프로젝트만 보고 싶다면 "src/main/resources" 등 설정
            String baseRoot = "/";
            File target = new File(baseRoot + uri);

            // 1. 존재하지 않는 경우
            if (!target.exists()) {
                return "존재하지 않는 경로입니다: " + target.getAbsolutePath();
            }

            // 2. 폴더(디렉터리)인 경우 -> 목록 출력 (취약점 3번)
            if (target.isDirectory()) {
                StringBuilder sb = new StringBuilder();
                sb.append("<h1>Index of ").append(uri).append("</h1><hr><pre>");
                sb.append("<a href='../'>../</a>\n");
                File[] files = target.listFiles();
                if (files != null) {
                    for (File file : files) {
                        String name = file.getName();
                        String link = uri.endsWith("/") ? uri + name : uri + "/" + name;
                        sb.append("<a href='").append(link).append("'>")
                                .append(file.isDirectory() ? name + "/" : name).append("</a>\n");
                    }
                }
                return sb.toString();
            }

            // 3. 파일인 경우 -> 내용 읽어서 출력 (취약점 15번: 파일 다운로드/경로 조작)
            else if (target.isFile()) {
                // 보안 필터 없이 파일을 그대로 읽어서 반환
                return "<pre>" + new String(Files.readAllBytes(target.toPath()), StandardCharsets.UTF_8) + "</pre>";
            }

        } catch (Exception e) {
            return "에러 발생: " + e.getMessage(); // 에러 정보 노출 (취약점 4번)
        }
        return "알 수 없는 형식입니다.";
    }
}