package com.welab.lms.domain.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.welab.lms.persistence.repository.BoardRepository;
import com.welab.lms.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.*;

@Service
public class BoardService {
    @Autowired
    private BoardRepository boardRepository;

    // 특정 공지사항 상세 조회
    public Map<String, Object> getNotice(int no) {
        return boardRepository.findNoticeByNo(no);
    }

    // 신규 공지사항 등록
    public void writeNotice(Map<String, Object> notice) {
        notice.put("writer", "관리자");
        notice.put("reg_date", LocalDate.now().toString());
        boardRepository.insertNotice(notice);
    }

    // 기존 공지사항 내용 수정
    public void modifyNotice(Map<String, Object> notice) {
        boardRepository.updateNotice(notice);
    }

    // 공지사항 노출 여부 상태 전환 (Show/Hide)
    public void hideToggle(int no) {
        boardRepository.toggleVisible(no);
    }

    // 특정 공지사항 삭제
    public void removeNotice(int no) {
        boardRepository.deleteNotice(no);
    }

    // JWT 토큰 기반 관리자 권한 확인 [취약점: 서명 미검증(Signature Verification Missing)으로 인한 토큰 변조
    // 가능]
    public boolean checkAdmin(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            System.out.println("[DEBUG] Authorization 헤더가 없거나 형식이 잘못되었습니다.");
            return false;
        }

        try {
            String token = authHeader.substring(7).trim();
            String[] parts = token.split("\\.");
            if (parts.length < 2)
                return false;

            String payloadJson = new String(Base64.getUrlDecoder().decode(parts[1]));
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> payload = mapper.readValue(payloadJson, Map.class);

            Object roleObj = payload.get("role");
            if (roleObj == null) {
                System.out.println("[DEBUG] 토큰 내에 role 정보가 없습니다.");
                return false;
            }

            String role = roleObj.toString();
            boolean isAdmin = role.equalsIgnoreCase("admin");

            System.out.println("[DEBUG] 토큰에서 추출된 Role: " + role);
            System.out.println("[DEBUG] 관리자 여부 결과: " + isAdmin);

            return isAdmin;

        } catch (Exception e) {
            System.err.println("[ERROR] JWT 파싱 중 오류 발생: " + e.getMessage());
            return false;
        }
    }
}