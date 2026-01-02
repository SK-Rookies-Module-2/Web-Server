package com.welab.lms.util;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.util.Date;
import java.util.Base64;
import org.json.JSONObject;

public class JwtUtil {
    private static String secretKey = "welab_secret_key_2025_rookies";
    private static long expirationTime = 1000 * 60 * 60;

    public static String createToken(String userId, String role) {
        return Jwts.builder()
                .setSubject(userId)
                .claim("role", role)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    // [취약점 지점] 서명 검증 없이 페이로드의 role만 반환하는 위험한 메서드

    public static String getRoleVulnerable(String token) {
        try {
            // 토큰을 [헤더].[페이로드].[서명]으로 쪼갭니다.
            String[] parts = token.split("\\.");
            if (parts.length < 2)
                return "guest";

            // 두 번째 파트(페이로드)를 Base64로 단순 디코딩합니다. (서명 확인 안 함!)
            String payload = new String(Base64.getUrlDecoder().decode(parts[1]));

            // JSON에서 role 값을 추출합니다.
            JSONObject json = new JSONObject(payload);
            return json.getString("role");
        } catch (Exception e) {
            return "guest";
        }
    }
}