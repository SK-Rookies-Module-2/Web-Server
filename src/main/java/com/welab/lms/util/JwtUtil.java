package com.welab.lms.util;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.util.Date;

public class JwtUtil {
    // 보안을 위한 비밀키 (실제 서비스에서는 아주 복잡해야 함)
    private static String secretKey = "welab_secret_key_2025_rookies";
    private static long expirationTime = 1000 * 60 * 60; // 유효시간 1시간

    public static String createToken(String userId, String role) {
        return Jwts.builder()
                .setSubject(userId)
                .claim("role", role) // 토큰에 사용자 권한 정보 포함
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }
}