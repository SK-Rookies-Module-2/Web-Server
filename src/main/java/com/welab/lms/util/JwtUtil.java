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

    // 헤더의 알고리즘을 none으로 설정하고 서명부를 비워둔 공격용 JWT 생성 [취약점: alg: none 설정을 통한 서명 검증 우회 공격
    // 노출]
    public static String createNoneAlgToken(String userId, String role) {
        try {
            ObjectMapper mapper = new ObjectMapper();

            // 1. Header (알고리즘을 none으로 설정하여 서명이 없음을 명시)
            Map<String, String> header = new HashMap<>();
            header.put("alg", "none");
            header.put("typ", "JWT");
            String encodedHeader = Base64.getUrlEncoder().withoutPadding()
                    .encodeToString(mapper.writeValueAsBytes(header));

            // 2. Payload (조작하고자 하는 사용자 ID 및 권한 정보 설정)
            Map<String, Object> payload = new HashMap<>();
            payload.put("userId", userId);
            payload.put("role", role);
            payload.put("iat", System.currentTimeMillis() / 1000);
            String encodedPayload = Base64.getUrlEncoder().withoutPadding()
                    .encodeToString(mapper.writeValueAsBytes(payload));

            // 3. Signature (알고리즘이 none이므로 마침표 뒤의 서명값을 비워둔 채 반환)
            return encodedHeader + "." + encodedPayload + ".";
        } catch (Exception e) {
            return null;
        }
    }

    // 토큰 헤더의 알고리즘 정보를 확인하고 none일 경우 서명 검증 없이 권한 정보를 추출 [취약점: 헤더 알고리즘 변조(alg: none)를
    // 통한 인증 및 인가 우회]
    public static String getRoleVulnerable(String token) {
        if (token == null || token.isEmpty())
            return "guest";

        try {
            // [로직] 토큰을 마침표(.) 기준으로 분리하여 각 파트(Header, Payload, Signature) 확보
            String[] parts = token.split("\\.");
            if (parts.length < 2)
                return "guest";

            // [로직] 첫 번째 파트인 헤더를 디코딩하여 사용된 알고리즘(alg) 확인
            String headerJson = new String(Base64.getUrlDecoder().decode(parts[0]));
            JSONObject header = new JSONObject(headerJson);
            String alg = header.optString("alg", "HS256");

            // [취약점] 알고리즘이 none인 경우, 서버가 유효한 토큰으로 간주하고 서명 검증(세 번째 파트 확인)을 건너뜀
            if ("none".equalsIgnoreCase(alg)) {
                // [로직] 서명 확인 절차 없이 두 번째 파트(페이로드)를 즉시 디코딩
                String payloadJson = new String(Base64.getUrlDecoder().decode(parts[1]));
                JSONObject payload = new JSONObject(payloadJson);

                // [로직] 페이로드에 담긴 권한(role) 정보를 그대로 반환
                return payload.getString("role");
            }

            // [취약점] alg가 none이 아닌 경우에도 실제 비밀키를 이용한 정밀 서명 검증 로직이 누락되어 있음
            String payloadJson = new String(Base64.getUrlDecoder().decode(parts[1]));
            JSONObject payload = new JSONObject(payloadJson);
            return payload.getString("role");

        } catch (Exception e) {
            return "guest";
        }
    }
}