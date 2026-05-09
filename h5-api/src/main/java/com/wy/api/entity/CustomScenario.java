package com.wy.api.entity;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class CustomScenario {
    private Long id;
    private Long userId;
    private String title;
    private LocalDateTime createdAt;
    private List<CustomTopic> topics;
}
