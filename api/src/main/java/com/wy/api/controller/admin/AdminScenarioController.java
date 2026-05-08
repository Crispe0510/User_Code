package com.wy.api.controller.admin;

import com.wy.api.common.Result;
import com.wy.api.entity.Scenario;
import com.wy.api.entity.Topic;
import com.wy.api.entity.TopicQuestion;
import com.wy.api.mapper.ScenarioMapper;
import com.wy.api.mapper.TopicMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminScenarioController {

    @Autowired
    private ScenarioMapper scenarioMapper;
    @Autowired
    private TopicMapper topicMapper;

    // ── 场景管理 ──────────────────────────────────────────

    @GetMapping("/scenarios")
    public Result<List<Scenario>> listScenarios() {
        return Result.ok(scenarioMapper.findAll());
    }

    @PostMapping("/scenarios")
    public Result<?> addScenario(@RequestBody Scenario scenario) {
        scenario.setEnabled(1);
        if (scenario.getSortOrder() == null) scenario.setSortOrder(99);
        scenarioMapper.insert(scenario);
        return Result.ok(scenario.getId());
    }

    @PutMapping("/scenarios/{id}")
    public Result<?> updateScenario(@PathVariable String id, @RequestBody Scenario scenario) {
        scenario.setId(id);
        scenarioMapper.update(scenario);
        return Result.ok();
    }

    @PutMapping("/scenarios/{id}/enabled")
    public Result<?> toggleEnabled(@PathVariable String id, @RequestBody Map<String, Integer> body) {
        scenarioMapper.updateEnabled(id, body.get("enabled"));
        return Result.ok();
    }

    @DeleteMapping("/scenarios/{id}")
    public Result<?> deleteScenario(@PathVariable String id) {
        scenarioMapper.delete(id);
        return Result.ok();
    }

    // ── 话题管理 ──────────────────────────────────────────

    @GetMapping("/topics")
    public Result<List<Topic>> listTopics(@RequestParam(required = false) String scenarioId) {
        List<Topic> list = scenarioId != null
                ? topicMapper.findByScenarioId(scenarioId)
                : topicMapper.findAllAdmin();
        for (Topic t : list) {
            t.setOpening(topicMapper.findQuestions(t.getId(), "opening"));
            t.setDeep(topicMapper.findQuestions(t.getId(), "deep"));
        }
        return Result.ok(list);
    }

    @GetMapping("/topics/{id}")
    public Result<Topic> getTopic(@PathVariable String id) {
        Topic t = topicMapper.findById(id);
        if (t != null) {
            t.setOpening(topicMapper.findQuestions(id, "opening"));
            t.setDeep(topicMapper.findQuestions(id, "deep"));
        }
        return Result.ok(t);
    }

    @PostMapping("/topics")
    public Result<?> addTopic(@RequestBody Topic topic) {
        topic.setEnabled(1);
        if (topic.getSortOrder() == null) topic.setSortOrder(99);
        topicMapper.insert(topic);
        saveQuestions(topic);
        scenarioMapper.incrTopicCount(topic.getScenarioId());
        return Result.ok(topic.getId());
    }

    @PutMapping("/topics/{id}")
    public Result<?> updateTopic(@PathVariable String id, @RequestBody Topic topic) {
        topic.setId(id);
        topicMapper.update(topic);
        topicMapper.deleteQuestions(id);
        saveQuestions(topic);
        return Result.ok();
    }

    @DeleteMapping("/topics/{id}")
    public Result<?> deleteTopic(@PathVariable String id) {
        Topic t = topicMapper.findById(id);
        topicMapper.deleteQuestions(id);
        topicMapper.delete(id);
        if (t != null) scenarioMapper.decrTopicCount(t.getScenarioId());
        return Result.ok();
    }

    private void saveQuestions(Topic topic) {
        if (topic.getOpening() != null) {
            for (int i = 0; i < topic.getOpening().size(); i++) {
                TopicQuestion q = topic.getOpening().get(i);
                q.setTopicId(topic.getId());
                q.setType("opening");
                q.setSortOrder(i + 1);
                topicMapper.insertQuestion(q);
            }
        }
        if (topic.getDeep() != null) {
            for (int i = 0; i < topic.getDeep().size(); i++) {
                TopicQuestion q = topic.getDeep().get(i);
                q.setTopicId(topic.getId());
                q.setType("deep");
                q.setSortOrder(i + 1);
                topicMapper.insertQuestion(q);
            }
        }
    }
}
