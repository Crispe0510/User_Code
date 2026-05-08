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

    @Select("SELECT * FROM topic ORDER BY scenario_id, sort_order")
    List<Topic> findAllAdmin();

    @Select("SELECT * FROM topic WHERE id=#{id}")
    Topic findById(String id);

    @Insert("INSERT INTO topic(id,scenario_id,title,title_sub,recommend,sort_order,enabled) " +
            "VALUES(#{id},#{scenarioId},#{title},#{titleSub},#{recommend},#{sortOrder},1)")
    int insert(Topic topic);

    @Update("UPDATE topic SET title=#{title},title_sub=#{titleSub},recommend=#{recommend}," +
            "scenario_id=#{scenarioId},sort_order=#{sortOrder},enabled=#{enabled} WHERE id=#{id}")
    int update(Topic topic);

    @Delete("DELETE FROM topic WHERE id=#{id}")
    int delete(String id);

    // Questions
    @Select("SELECT * FROM topic_question WHERE topic_id=#{topicId} AND type=#{type} ORDER BY sort_order")
    List<TopicQuestion> findQuestions(@Param("topicId") String topicId, @Param("type") String type);

    @Select("SELECT * FROM topic_question WHERE topic_id=#{topicId} ORDER BY type, sort_order")
    List<TopicQuestion> findAllQuestions(String topicId);

    @Insert("INSERT INTO topic_question(topic_id,type,content,sort_order) VALUES(#{topicId},#{type},#{content},#{sortOrder})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertQuestion(TopicQuestion q);

    @Delete("DELETE FROM topic_question WHERE topic_id=#{topicId}")
    int deleteQuestions(String topicId);

    @Select("SELECT COUNT(*) FROM topic WHERE enabled=1")
    int count();
}
