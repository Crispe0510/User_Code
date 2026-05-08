package com.wy.api.controller.h5;

import com.wy.api.common.Result;
import com.wy.api.entity.Scenario;
import com.wy.api.entity.Topic;
import com.wy.api.mapper.ScenarioMapper;
import com.wy.api.mapper.TopicMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/h5")
public class H5ScenarioController {

    @Autowired
    private ScenarioMapper scenarioMapper;
    @Autowired
    private TopicMapper topicMapper;

    @GetMapping("/scenarios")
    public Result<List<Scenario>> scenarios() {
        return Result.ok(scenarioMapper.findAllEnabled());
    }

    @GetMapping("/topics")
    public Result<List<Topic>> topicsByScenario(@RequestParam String scenarioId) {
        List<Topic> list = topicMapper.findByScenarioId(scenarioId);
        for (Topic t : list) {
            t.setOpening(topicMapper.findQuestions(t.getId(), "opening"));
            t.setDeep(topicMapper.findQuestions(t.getId(), "deep"));
        }
        return Result.ok(list);
    }

    @GetMapping("/topics/{id}")
    public Result<Topic> topicDetail(@PathVariable String id) {
        Topic t = topicMapper.findById(id);
        if (t == null) return Result.fail("话题不存在");
        t.setOpening(topicMapper.findQuestions(id, "opening"));
        t.setDeep(topicMapper.findQuestions(id, "deep"));
        return Result.ok(t);
    }

    @GetMapping("/recent-topics")
    public Result<?> recentTopics() {
        // 固定返回3条最近话题（演示）
        List<Topic> all = topicMapper.findAll();
        return Result.ok(all.stream().limit(3).collect(java.util.stream.Collectors.toList()));
    }
}
