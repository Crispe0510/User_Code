package com.wy.api.mapper;

import com.wy.api.entity.Topic;
import com.wy.api.entity.TopicQuestion;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface TopicMapper {

    @Select("SELECT * FROM topic WHERE scenario_id=#{scenarioId} AND enabled=1 ORDER BY sort_order")
    List<Topic> findByScenarioId(String scenarioId);

    @Select("SELECT * FROM topic WHERE enabled=1 ORDER BY scenario_id, sort_order")
    List<Topic> findAll();

    @Select("SELECT * FROM topic WHERE id=#{id}")
    Topic findById(String id);

    @Select("SELECT * FROM topic_question WHERE topic_id=#{topicId} AND type=#{type} ORDER BY sort_order")
    List<TopicQuestion> findQuestions(@Param("topicId") String topicId, @Param("type") String type);
}
