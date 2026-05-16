package com.wy.api.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TopicChatMessage {
    private Long id;
    private Long userId;
    /** 共享聊天室 key：单人时 = userId，双人关联时 = min_max(userId1, userId2) */
    private String roomKey;
    private String scenarioKey;
    private String topicKey;
    private String senderType;
    private String memberId;
    private String senderName;
    private String content;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;
}
