package com.wy.api.entity;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class MoodLog {
    private Long id;
    private String memberId;
    private Long userId;
    private String moodId;
    private String note;
    private LocalDate logDate;
    private String logTime;
    private LocalDateTime createdAt;
}
