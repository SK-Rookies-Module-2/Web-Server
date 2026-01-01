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
    public String showEverything(HttpServletRequest request) {
        String uri = request.getRequestURI();
        try {
            uri = URLDecoder.decode(uri, StandardCharsets.UTF_8.toString());
            String baseRoot = "/";
            File target = new File(baseRoot + uri);

            if (!target.exists())
                return "존재하지 않는 경로입니다.";

            // 1. 폴더(디렉터리)인 경우: 무조건 리스트를 보여줍니다. (취약점 3번 유지)
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

            // 2. 파일인 경우: 확장자에 따라 다르게 처리합니다.
            else if (target.isFile()) {
                // 이미지나 CSS 파일은 스프링의 기본 핸들러가 처리하도록 '양보'합니다. (이미지 깨짐 해결)
                if (uri.endsWith(".png") || uri.endsWith(".jpg") || uri.endsWith(".gif") || uri.endsWith(".css")) {
                    return null;
                }

                // 그 외의 모든 파일(passwd, .java 등)은 텍스트로 읽어옵니다. (취약점 15번 유지)
                return "<pre>" + new String(Files.readAllBytes(target.toPath()), StandardCharsets.UTF_8) + "</pre>";
            }

        } catch (Exception e) {
            return "에러: " + e.getMessage();
        }
        return "알 수 없는 경로";
    }
}