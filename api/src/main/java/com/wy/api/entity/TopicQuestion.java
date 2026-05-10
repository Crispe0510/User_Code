package com.wy.api.entity;

import lombok.Data;

@Data
public class TopicQuestion {
    private Long id;
    private String topicId;
    private String type;
    private String content;
    private Integer sortOrder;
}
