package com.wy.api.entity;

import lombok.Data;

@Data
public class MoodType {
    private String id;
    private String emoji;
    private String label;
    private String color;
    private String tip;
}
