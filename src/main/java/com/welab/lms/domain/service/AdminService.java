package com.welab.lms.domain.service;

import com.welab.lms.persistence.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class AdminService {
    @Autowired
    private UserRepository userRepository;

    // 전체 사용자 정보 목록 조회
    public List<Map<String, Object>> getUserList() {
        return userRepository.findAll();
    }

    // 특정 사용자를 ID로 상세 조회 [취약점: IDOR - 적절한 권한 검증 부재 시 타인 정보 노출 가능]
    public Map<String, Object> getUserDetail(String id) {
        return userRepository.findById(id);
    }

    // 사용자 프로필 및 AWS 계정 정보 수정 [취약점: 민감 정보(비밀번호) 평문 전송 및 저장]
    public void modifyUser(String id, String name, String email, String awsAccount, String awsPw) {
        userRepository.update(id, name, email, awsAccount, awsPw);
    }
}