package com.wy.api.controller.h5;

import com.wy.api.common.Result;
import com.wy.api.config.TokenStore;
import com.wy.api.entity.CustomQuestion;
import com.wy.api.entity.CustomScenario;
import com.wy.api.entity.CustomTopic;
import com.wy.api.mapper.CustomScenarioMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/h5/custom")
public class H5CustomScenarioController {

    @Autowired
    private CustomScenarioMapper customScenarioMapper;

    @GetMapping("/scenarios")
    public Result<List<CustomScenario>> list(
            @RequestHeader(value = "Authorization", required = false) String auth) {
        Long userId = resolveUserId(auth);
        if (userId == null) return Result.fail(401, "请先登录");
        List<CustomScenario> list = customScenarioMapper.findByUserId(userId);
        for (CustomScenario s : list) {
            List<CustomTopic> topics = customScenarioMapper.findTopics(s.getId());
            for (CustomTopic t : topics) {
                List<CustomQuestion> opening = customScenarioMapper.findQuestions(t.getId(), "opening");
                List<CustomQuestion> deep = customScenarioMapper.findQuestions(t.getId(), "deep");
                t.setOpening(opening.stream().map(CustomQuestion::getContent).collect(java.util.stream.Collectors.toList()));
                t.setDeep(deep.stream().map(CustomQuestion::getContent).collect(java.util.stream.Collectors.toList()));
            }
            s.setTopics(topics);
        }
        return Result.ok(list);
    }

    @PostMapping("/scenarios")
    public Result<?> create(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @RequestBody CustomScenario scenario) {
        Long userId = resolveUserId(auth);
        if (userId == null) return Result.fail(401, "请先登录");
        scenario.setUserId(userId);
        customScenarioMapper.insertScenario(scenario);
        if (scenario.getTopics() != null) {
            for (int i = 0; i < scenario.getTopics().size(); i++) {
                CustomTopic topic = scenario.getTopics().get(i);
                topic.setScenarioId(scenario.getId());
                topic.setSortOrder(i + 1);
                customScenarioMapper.insertTopic(topic);
                saveTopicQuestions(topic);
            }
        }
        return Result.ok(scenario.getId());
    }

    @DeleteMapping("/scenarios/{id}")
    public Result<?> delete(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @PathVariable Long id) {
        Long userId = resolveUserId(auth);
        if (userId == null) return Result.fail(401, "请先登录");
        List<CustomTopic> topics = customScenarioMapper.findTopics(id);
        for (CustomTopic t : topics) {
            customScenarioMapper.deleteQuestions(t.getId());
        }
        customScenarioMapper.deleteTopics(id);
        customScenarioMapper.deleteScenario(id);
        return Result.ok();
    }

    private void saveTopicQuestions(CustomTopic topic) {
        if (topic.getOpening() != null) {
            for (int i = 0; i < topic.getOpening().size(); i++) {
                CustomQuestion q = new CustomQuestion();
                q.setTopicId(topic.getId());
                q.setType("opening");
                q.setContent(topic.getOpening().get(i));
                q.setSortOrder(i + 1);
                customScenarioMapper.insertQuestion(q);
            }
        }
        if (topic.getDeep() != null) {
            for (int i = 0; i < topic.getDeep().size(); i++) {
                CustomQuestion q = new CustomQuestion();
                q.setTopicId(topic.getId());
                q.setType("deep");
                q.setContent(topic.getDeep().get(i));
                q.setSortOrder(i + 1);
                customScenarioMapper.insertQuestion(q);
            }
        }
    }

    private Long resolveUserId(String auth) {
        if (auth != null && auth.startsWith("Bearer ")) {
            return TokenStore.getH5UserId(auth.substring(7));
        }
        return null;
    }
}
