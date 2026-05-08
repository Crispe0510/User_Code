package com.wy.api.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Scenario {
    private String id;
    private String title;
    private String subtitle;
    private String icon;
    private String cover;
    private Integer topicCount;
    private Integer sortOrder;
    private Integer enabled;
    private LocalDateTime createdAt;
}
