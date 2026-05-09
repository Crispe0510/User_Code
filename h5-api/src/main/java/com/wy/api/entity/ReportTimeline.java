package com.wy.api.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ReportTimeline {
    private String id;
    private Long userId;
    private String eventDate;
    private String place;
    private String title;
    private String detail;
    private String type;
    private Integer sortOrder;
    private LocalDateTime createdAt;
}
