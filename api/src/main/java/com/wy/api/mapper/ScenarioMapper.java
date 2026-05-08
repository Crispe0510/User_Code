package com.wy.api.mapper;

import com.wy.api.entity.Scenario;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ScenarioMapper {

    @Select("SELECT * FROM scenario WHERE enabled = 1 ORDER BY sort_order")
    List<Scenario> findAllEnabled();

    @Select("SELECT * FROM scenario ORDER BY sort_order")
    List<Scenario> findAll();

    @Select("SELECT * FROM scenario WHERE id = #{id}")
    Scenario findById(String id);

    @Insert("INSERT INTO scenario(id,title,subtitle,icon,cover,topic_count,sort_order,enabled) " +
            "VALUES(#{id},#{title},#{subtitle},#{icon},#{cover},#{topicCount},#{sortOrder},#{enabled})")
    int insert(Scenario scenario);

    @Update("UPDATE scenario SET title=#{title},subtitle=#{subtitle},icon=#{icon},cover=#{cover}," +
            "sort_order=#{sortOrder},enabled=#{enabled} WHERE id=#{id}")
    int update(Scenario scenario);

    @Update("UPDATE scenario SET enabled=#{enabled} WHERE id=#{id}")
    int updateEnabled(@Param("id") String id, @Param("enabled") int enabled);

    @Update("UPDATE scenario SET topic_count=topic_count+1 WHERE id=#{id}")
    int incrTopicCount(String id);

    @Update("UPDATE scenario SET topic_count=topic_count-1 WHERE id=#{id} AND topic_count>0")
    int decrTopicCount(String id);

    @Delete("DELETE FROM scenario WHERE id=#{id}")
    int delete(String id);
}
