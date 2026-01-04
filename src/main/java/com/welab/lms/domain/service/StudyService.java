package com.welab.lms.domain.service;

import com.welab.lms.persistence.repository.StudyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.util.*;

import javax.servlet.http.HttpServletResponse;

@Service
public class StudyService {
    @Autowired
    private StudyRepository studyRepository;

    // [조회] 스터디 그룹 상세 정보 조회 [취약점: SQL Injection - 외부 입력값이 쿼리에 직접 포함됨]
    public Map<String, Object> getStudyDetail(String no) {
        return studyRepository.findStudyVulnerable(no);
    }

    // [조회] 특정 스터디에 속한 게시글 전체 목록 조회 [취약점: SQL Injection]
    public List<Map<String, Object>> getPostList(String no) {
        return studyRepository.findPostsVulnerable(no);
    }

    // [조회] 게시글 상세 내용 및 첨부 파일 정보 조회 [취약점: SQL Injection]
    public Map<String, Object> getPostDetail(String no) {
        return studyRepository.findPostDetailVulnerable(no);
    }

    // [등록] 멤버 존재 여부 검증 후 스터디 그룹 등록
    public String registerStudy(Map<String, Object> params, String pre_members) {
        StringBuilder validMembers = new StringBuilder();
        if (pre_members != null && !pre_members.trim().isEmpty()) {
            for (String name : pre_members.split(",")) {
                String trimmedName = name.trim();
                if (studyRepository.isUserExists(trimmedName)) {
                    if (validMembers.length() > 0)
                        validMembers.append(",");
                    validMembers.append(trimmedName);
                } else {
                    return "error:" + trimmedName;
                }
            }
        }
        params.put("pre_members", validMembers.toString());
        params.put("reg_date", LocalDate.now().toString());
        studyRepository.insertStudyGroup(params);
        return "success";
    }

    // [등록] 작성된 게시글 데이터를 데이터베이스에 저장
    public void savePost(int studyNo, String title, String writer, String content, String fileName) {
        studyRepository.insertPost(studyNo, title, writer, content, fileName);
    }

    // [수정] 기존 게시글의 제목 또는 내용 수정 [취약점: SQL Injection]
    public void updatePost(Map<String, Object> params) {
        studyRepository.updatePostVulnerable(params);
    }

    // [삭제] 게시글 레코드 삭제 및 서버에 저장된 물리 파일 삭제 [취약점: SQL Injection 연계 가능]
    public void deletePost(String no, String uploadPath) {
        // 1. 삭제 전, DB에서 파일명이 있는지 먼저 조회
        Map<String, Object> post = studyRepository.findPostDetailVulnerable(no);

        if (post != null && post.get("file_name") != null) {
            String fileName = (String) post.get("file_name");
            // 2. 파일명이 존재하면 서버 폴더에서 해당 파일 삭제
            File file = new File(uploadPath + File.separator + fileName);
            if (file.exists()) {
                file.delete(); // 실제 파일 삭제 실행
            }
        }
        // 3. 파일 삭제 후 DB 레코드 삭제
        studyRepository.deletePostVulnerable(no);
    }

    // [파일] 서버의 지정된 경로에 첨부 파일 업로드 [취약점: 무제한 파일 업로드 - 확장자 및 실행 권한 체크 부재]
    public String uploadFileVulnerable(MultipartFile file, String uploadPath) {
        if (file.isEmpty())
            return "";
        try {
            // 폴더가 없으면 자동으로 생성
            File dir = new File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String fileName = file.getOriginalFilename();
            // [취약점] 검증 없이 요청된 경로와 파일명을 조합하여 저장
            File dest = new File(uploadPath + File.separator + fileName);
            file.transferTo(dest);
            return fileName;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    // [파일] 다운로드를 위한 파일 객체 생성 [취약점: 경로 조작(Path Traversal) - ../ 등을 이용한 상위 경로 접근 가능]
    public File getDownloadFileVulnerable(String fileName, String uploadPath) {
        return new File(uploadPath + File.separator + fileName);
    }

    public void fetchRemoteResource(String urlString, HttpServletResponse response) {
        try {
            URL url = new URL(urlString);
            // [수정] HttpURLConnection으로 형변환하지 않고 일반 Connection으로 받음
            java.net.URLConnection connection = url.openConnection();
            connection.setConnectTimeout(3000);
            connection.setReadTimeout(3000);

            // 데이터를 읽어서 사용자에게 전달
            try (InputStream is = connection.getInputStream();
                    OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[1024];
                int len;
                while ((len = is.read(buffer)) != -1) {
                    os.write(buffer, 0, len);
                }
            }
        } catch (Exception e) {
            // [중요] 에러가 발생해도 사용자에게 내용을 보여주도록 설정 가능 (여기서는 로그만 출력)
            System.err.println("SSRF 요청 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
}