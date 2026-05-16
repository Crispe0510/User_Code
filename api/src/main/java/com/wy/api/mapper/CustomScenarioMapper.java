package com.wy.api.mapper;

import com.wy.api.entity.CustomQuestion;
import com.wy.api.entity.CustomScenario;
import com.wy.api.entity.CustomTopic;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface CustomScenarioMapper {

    @Select("SELECT * FROM custom_scenario WHERE user_id=#{userId} ORDER BY id DESC")
    List<CustomScenario> findByUserId(Long userId);

    @Select("SELECT * FROM custom_scenario WHERE id=#{id}")
    CustomScenario findById(Long id);

    @Insert("INSERT INTO custom_scenario(user_id,title) VALUES(#{userId},#{title})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertScenario(CustomScenario scenario);

    @Delete("DELETE FROM custom_scenario WHERE id=#{id}")
    int deleteScenario(Long id);

    @Select("SELECT * FROM custom_topic WHERE scenario_id=#{scenarioId} ORDER BY sort_order")
    List<CustomTopic> findTopics(Long scenarioId);

    @Insert("INSERT INTO custom_topic(scenario_id,title,title_sub,recommend,sort_order) " +
            "VALUES(#{scenarioId},#{title},#{titleSub},#{recommend},#{sortOrder})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertTopic(CustomTopic topic);

    @Delete("DELETE FROM custom_topic WHERE scenario_id=#{scenarioId}")
    int deleteTopics(Long scenarioId);

    @Select("SELECT * FROM custom_question WHERE topic_id=#{topicId} AND type=#{type} ORDER BY sort_order")
    List<CustomQuestion> findQuestions(@Param("topicId") Long topicId, @Param("type") String type);

    @Insert("INSERT INTO custom_question(topic_id,type,content,sort_order) VALUES(#{topicId},#{type},#{content},#{sortOrder})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertQuestion(CustomQuestion q);

    @Delete("DELETE FROM custom_question WHERE topic_id=#{topicId}")
    int deleteQuestions(Long topicId);
}
