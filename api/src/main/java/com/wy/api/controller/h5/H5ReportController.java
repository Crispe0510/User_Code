package com.wy.api.controller.h5;

import com.wy.api.common.Result;
import com.wy.api.config.TokenStore;
import com.wy.api.entity.ReportTimeline;
import com.wy.api.mapper.ReportMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/h5/report")
public class H5ReportController {

    @Autowired
    private ReportMapper reportMapper;

    @GetMapping("/timeline")
    public Result<List<ReportTimeline>> timeline(
            @RequestHeader(value = "Authorization", required = false) String auth) {
        Long userId = resolveUserId(auth);
        List<ReportTimeline> list = (userId != null)
                ? reportMapper.findByUserId(userId)
                : reportMapper.findByUserId(1L); // 游客展示演示数据
        return Result.ok(list);
    }

    /** 登录用户新增一条时间线（前台自助记录） */
    @PostMapping("/timeline")
    public Result<ReportTimeline> add(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @RequestBody ReportTimeline body) {
        Long userId = resolveUserId(auth);
        if (userId == null) {
            return Result.fail(401, "请先登录");
        }
        if (!StringUtils.hasText(body.getTitle())) {
            return Result.fail("标题不能为空");
        }
        if (!StringUtils.hasText(body.getEventDate())) {
            return Result.fail("日期不能为空");
        }
        String type = StringUtils.hasText(body.getType()) ? body.getType().trim() : "topic";
        if (!Arrays.asList("topic", "browse", "report").contains(type)) {
            type = "topic";
        }
        body.setUserId(userId);
        body.setId("rt" + UUID.randomUUID().toString().replace("-", "").substring(0, 12));
        body.setType(type);
        body.setSortOrder(reportMapper.nextSortOrder(userId));
        if (body.getPlace() != null) {
            body.setPlace(body.getPlace().trim());
        }
        if (body.getDetail() != null) {
            body.setDetail(body.getDetail().trim());
        }
        reportMapper.insert(body);
        return Result.ok(body);
    }

    private Long resolveUserId(String auth) {
        if (auth != null && auth.startsWith("Bearer ")) {
            return TokenStore.getH5UserId(auth.substring(7));
        }
        return null;
    }
}
