package com.wy.api.mapper;

import com.wy.api.entity.ReportTimeline;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ReportMapper {

    @Select("SELECT * FROM report_timeline WHERE user_id=#{userId} ORDER BY sort_order")
    List<ReportTimeline> findByUserId(Long userId);

    @Select("SELECT * FROM report_timeline ORDER BY sort_order")
    List<ReportTimeline> findAll();

    @Select("SELECT COALESCE(MAX(sort_order),0)+1 FROM report_timeline WHERE user_id=#{userId}")
    int nextSortOrder(@Param("userId") Long userId);

    @Insert("INSERT INTO report_timeline(id,user_id,event_date,place,title,detail,type,sort_order) " +
            "VALUES(#{id},#{userId},#{eventDate},#{place},#{title},#{detail},#{type},#{sortOrder})")
    int insert(ReportTimeline item);

    @Delete("DELETE FROM report_timeline WHERE id=#{id}")
    int delete(String id);
}
