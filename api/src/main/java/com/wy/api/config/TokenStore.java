package com.wy.api.config;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 简单内存 Token 存储（演示用，生产应使用 Redis）
 */
public class TokenStore {

    private static final Map<String, Long> H5_TOKENS = new ConcurrentHashMap<>();

    public static String createH5Token(Long userId) {
        String token = UUID.randomUUID().toString().replace("-", "");
        H5_TOKENS.put(token, userId);
        return token;
    }

    public static Long getH5UserId(String token) {
        return token == null ? null : H5_TOKENS.get(token);
    }

    public static void removeH5Token(String token) {
        if (token != null) H5_TOKENS.remove(token);
    }
}
