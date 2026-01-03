package com.welab.lms.domain.service;

import org.springframework.stereotype.Service;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

@Service
public class ExplorerService {

    // 운영체제(OS) 확인 후 시스템 최상위 루트 경로 결정
    public String getBaseRoot() {
        String os = System.getProperty("os.name").toLowerCase();
        return os.contains("win") ? "C:/" : "/";
    }

    // 요청된 경로에 대해 디렉토리 목록을 생성하거나 파일 내용을 읽어서 반환 [취약점: 경로 조작(Path Traversal)을 통한 시스템
    // 파일 노출]
    public String explorePath(String pathInSystem) {
        try {
            // [취약점: 입력값에 대한 '.. /' 등 상위 디렉토리 이동 문자열 검증 부재]
            File target = new File(getBaseRoot() + pathInSystem);

            if (!target.exists()) {
                return "경로를 찾을 수 없습니다: " + target.getAbsolutePath();
            }

            // 폴더일 경우 내부 파일 및 디렉토리 목록을 HTML 링크 형태로 생성
            if (target.isDirectory()) {
                StringBuilder sb = new StringBuilder();
                sb.append("<h1>Index of ").append(pathInSystem).append("</h1><hr><pre>");
                File[] files = target.listFiles();
                if (files != null) {
                    for (File f : files) {
                        String name = f.getName();
                        String link = "/root" + (pathInSystem.endsWith("/") ? pathInSystem : pathInSystem + "/") + name;
                        sb.append("<a href='").append(link).append("'>")
                                .append(f.isDirectory() ? name + "/" : name).append("</a>\n");
                    }
                }
                return sb.toString();
            }

            // 파일일 경우 해당 파일의 전체 바이너리 데이터를 UTF-8 텍스트로 읽어서 반환
            return "<pre>" + new String(Files.readAllBytes(target.toPath()), StandardCharsets.UTF_8) + "</pre>";

        } catch (Exception e) {
            return "에러 발생: " + e.getMessage();
        }
    }
}