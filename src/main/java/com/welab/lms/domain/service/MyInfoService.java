package com.welab.lms.domain.service;

import com.welab.lms.persistence.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class MyInfoService {

    @Autowired
    private UserRepository userRepository;

    // 사용자 상세 프로필 및 포인트/출석률 정보 조회 [취약점: IDOR - 타인의 ID 입력 시 정보 노출, SQL Injection - id
    // 파라미터 조작 가능]
    public Map<String, Object> getUserProfile(String id) {
        Map<String, Object> profile = userRepository.findUserInfoVulnerable(id);

        if (profile != null) {
            // [디버깅] 데이터 로딩 확인을 위한 로그 출력
            System.out.println("DB에서 가져온 데이터: " + profile.toString());

            if ("admin".equals(id)) {
                profile.put("point", "99,999");
                profile.put("attendRate", "100");
            } else {
                profile.put("point", "1,250");
                profile.put("attendRate", "100");
            }
        }
        return profile;
    }

    // 기존 비밀번호 확인 후 새로운 비밀번호로 변경 처리 [취약점: 비밀번호 평문 전송 및 저장]
    public boolean changePassword(String userId, String currentPw, String newPw) {
        if (userRepository.checkPassword(userId, currentPw)) {
            userRepository.updatePassword(userId, newPw);
            return true;
        }
        return false;
    }
}