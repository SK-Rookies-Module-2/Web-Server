package com.welab.lms.util;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Base64;
import org.json.JSONObject;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JwtUtil {
    private static String secretKey = "welab_secret_key_2025_rookies";
    private static long expirationTime = 1000 * 60 * 60; // 토큰 유효 시간 1시간 설정

    // 사용자 ID와 권한 정보를 담은 HS256 알고리즘 기반 JWT 생성
    public static String createToken(String userId, String role) {
        return Jwts.builder()
                .setSubject(userId)
                .claim("role", role)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    // 헤더와 페이로드를 직접 조합하여 고정된 서명을 가진 위조 JWT 생성 [취약점: 고정 Signature 사용으로 인한 토큰 변조 공격
    // 노출]
    public static String createFakeJwt(String userId, String role) {
        try {
            ObjectMapper mapper = new ObjectMapper();

            // 1. Header (알고리즘 및 타입 정보 설정)
            Map<String, String> header = new HashMap<>();
            header.put("alg", "HS256");
            header.put("typ", "JWT");
            String encodedHeader = Base64.getUrlEncoder().withoutPadding()
                    .encodeToString(mapper.writeValueAsBytes(header));

            // 2. Payload (사용자 ID, 권한, 생성 시간 정보 설정)
            Map<String, Object> payload = new HashMap<>();
            payload.put("userId", userId);
            payload.put("role", role);
            payload.put("iat", System.currentTimeMillis());
            String encodedPayload = Base64.getUrlEncoder().withoutPadding()
                    .encodeToString(mapper.writeValueAsBytes(payload));

            // 3. Signature (검증 과정 없이 통과시키기 위한 고정된 위조 서명값 사용)
            String signature = "vulnerable_signature";

            return encodedHeader + "." + encodedPayload + "." + signature;
        } catch (Exception e) {
            return null;
        }
    }

    // 서버의 비밀키를 이용한 서명 검증 없이 페이로드에서 권한 정보 추출 [취약점: 서명 미검증(Broken Authentication)을 통한
    // 권한 탈취 가능]
    public static String getRoleVulnerable(String token) {
        try {
            // [로직] 토큰을 마침표(.) 기준으로 분리하여 페이로드(두 번째 파트) 확보
            String[] parts = token.split("\\.");
            if (parts.length < 2)
                return "guest";

            // [취약점] 유효한 토큰인지 확인하는 서명 검증 과정 없이 페이로드를 단순 Base64 디코딩
            String payload = new String(Base64.getUrlDecoder().decode(parts[1]));

            // [로직] 디코딩된 JSON 문자열에서 권한(role) 값 추출
            JSONObject json = new JSONObject(payload);
            return json.getString("role");
        } catch (Exception e) {
            return "guest";
        }
    }
}