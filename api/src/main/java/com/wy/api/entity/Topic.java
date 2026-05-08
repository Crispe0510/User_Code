package com.wy.api.entity;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class Topic {
    private String id;
    private String scenarioId;
    private String title;
    private String titleSub;
    private String recommend;
    private Integer sortOrder;
    private Integer enabled;
    private LocalDateTime createdAt;
    // 关联问题（非DB字段，查询时填充）
    private List<TopicQuestion> opening;
    private List<TopicQuestion> deep;
}
