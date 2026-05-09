package com.wy.api.entity;

import lombok.Data;

@Data
public class FamilyMember {
    private String id;
    private Long userId;
    private String name;
    private String role;
    private String avatar;
    private Integer sortOrder;
    /** 关联的 H5 注册账号 ID（可选），关联后双方共享聊天室 */
    private Long linkedUserId;
    // 今日心情（查询时填充）
    private MoodLog today;
}
