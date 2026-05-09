package com.wy.api.entity;

import lombok.Data;
import java.util.List;

@Data
public class CustomTopic {
    private Long id;
    private Long scenarioId;
    private String title;
    private String titleSub;
    private String recommend;
    private Integer sortOrder;
    private List<String> opening;
    private List<String> deep;
}
