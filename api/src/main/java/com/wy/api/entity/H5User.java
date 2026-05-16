package com.wy.api.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class H5User {
    private Long id;
    private String name;
    private String email;
    private String password;
    private String identity;
    private Integer status;
    private LocalDateTime createdAt;
}
