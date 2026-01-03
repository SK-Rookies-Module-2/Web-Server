package com.welab.lms.domain.service;

import com.welab.lms.persistence.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Map;
import java.util.Random;

@Service
public class LoginService {

    @Autowired
    private UserRepository userRepository;

    // 신규 회원가입 및 실습용 AWS 계정 정보 자동 생성 [취약점: 비밀번호 평문 저장 및 취약한 난수 생성]
    public void registerUser(Map<String, String> params) {
        params.put("aws_account", generateAwsAccount());
        params.put("iam_user", params.get("id"));
        params.put("aws_pw", "Welabs!" + generateRandomString(5));
        params.put("region", getRandomRegion());

        userRepository.save(params);
    }

    // 사용자 아이디와 비밀번호를 통한 인증 처리 [취약점: SQL Injection을 이용한 인증 우회 가능]
    public Map<String, Object> authenticate(String id, String pw) {
        return userRepository.findUserVulnerable(id, pw);
    }

    // 이름과 이메일 정보를 이용한 아이디 찾기 [취약점: SQL Injection을 통한 회원 정보 노출]
    public String findUserId(String name, String email) {
        return userRepository.findIdVulnerable(name, email);
    }

    // 사용자 확인 후 임시 비밀번호로 초기화 [취약점: 예측 가능한 고정 문자열 비밀번호 사용]
    public String resetToTempPassword(String id, String email) {
        if (userRepository.checkUserExists(id, email)) {
            String tempPw = "1q2w3e4r!@#";
            userRepository.updatePassword(id, tempPw);
            return tempPw;
        }
        return null;
    }

    // 12자리의 랜덤 AWS 계정 번호 생성 (내부 유틸리티)
    private String generateAwsAccount() {
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 12; i++) {
            sb.append(rnd.nextInt(10));
        }
        return sb.toString();
    }

    // 지정된 길이만큼의 랜덤 알파벳 및 숫자 조합 생성 (내부 유틸리티)
    private String generateRandomString(int len) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }

    // 실습용 AWS 리전 정보를 무작위로 선택 (내부 유틸리티)
    private String getRandomRegion() {
        String[] regions = { "오사카 (ap-northeast-3)", "서울 (ap-northeast-2)", "도쿄 (ap-northeast-1)" };
        return regions[new Random().nextInt(regions.length)];
    }
}