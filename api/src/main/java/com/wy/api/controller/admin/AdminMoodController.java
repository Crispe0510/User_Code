package com.wy.api.controller.admin;

import com.wy.api.common.Result;
import com.wy.api.entity.MoodType;
import com.wy.api.mapper.MoodMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/mood")
public class AdminMoodController {

    @Autowired
    private MoodMapper moodMapper;

    @GetMapping("/types")
    public Result<List<MoodType>> listMoodTypes() {
        return Result.ok(moodMapper.findAllMoodTypes());
    }
}
