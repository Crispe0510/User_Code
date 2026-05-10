package com.wy.api.controller.h5;

import com.wy.api.common.Result;
import com.wy.api.config.TokenStore;
import com.wy.api.entity.FamilyMember;
import com.wy.api.entity.MoodLog;
import com.wy.api.entity.MoodType;
import com.wy.api.mapper.MoodMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/h5/mood")
public class H5MoodController {

    @Autowired
    private MoodMapper moodMapper;

    @GetMapping("/types")
    public Result<List<MoodType>> moodTypes() {
        return Result.ok(moodMapper.findAllMoodTypes());
    }

    @GetMapping("/family")
    public Result<List<FamilyMember>> familyMoods(
            @RequestHeader(value = "Authorization", required = false) String auth) {
        Long userId = resolveUserId(auth);
        if (userId == null) userId = 1L; // 游客展示演示数据
        List<FamilyMember> members = moodMapper.findFamilyMembers(userId);
        for (FamilyMember m : members) {
            m.setToday(moodMapper.findTodayMood(m.getId()));
        }
        return Result.ok(members);
    }

    @GetMapping("/weekly")
    public Result<?> weekly(@RequestHeader(value = "Authorization", required = false) String auth) {
        Long userId = resolveUserId(auth);
        if (userId == null) userId = 1L;
        List<FamilyMember> members = moodMapper.findFamilyMembers(userId);
        Map<String, List<MoodLog>> result = new java.util.LinkedHashMap<>();
        for (FamilyMember m : members) {
            result.put(m.getId(), moodMapper.findWeeklyMoods(m.getId(), userId));
        }
        return Result.ok(result);
    }

    @PostMapping("/checkin")
    public Result<?> checkin(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @RequestBody Map<String, String> body) {
        Long userId = resolveUserId(auth);
        if (userId == null) return Result.fail("请先登录");
        MoodLog log = new MoodLog();
        log.setMemberId(body.get("memberId"));
        log.setUserId(userId);
        log.setMoodId(body.get("moodId"));
        log.setNote(body.get("note"));
        log.setLogTime(LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm")));
        moodMapper.insertMoodLog(log);
        return Result.ok(log.getId());
    }

    private Long resolveUserId(String auth) {
        if (auth != null && auth.startsWith("Bearer ")) {
            return TokenStore.getH5UserId(auth.substring(7));
        }
        return null;
    }
}
