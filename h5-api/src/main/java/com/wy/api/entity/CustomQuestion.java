package com.wy.api.entity;

import lombok.Data;

@Data
public class CustomQuestion {
    private Long id;
    private Long topicId;
    private String type;
    private String content;
    private Integer sortOrder;
}
