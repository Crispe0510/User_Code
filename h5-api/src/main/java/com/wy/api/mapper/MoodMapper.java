package com.wy.api.mapper;

import com.wy.api.entity.FamilyMember;
import com.wy.api.entity.MoodLog;
import com.wy.api.entity.MoodType;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface MoodMapper {

    @Select("SELECT * FROM mood_type ORDER BY id")
    List<MoodType> findAllMoodTypes();

    @Select("SELECT * FROM family_member WHERE user_id=#{userId} ORDER BY sort_order")
    List<FamilyMember> findFamilyMembers(Long userId);

    @Select("SELECT * FROM mood_log WHERE member_id=#{memberId} AND log_date=CURDATE() ORDER BY id DESC LIMIT 1")
    MoodLog findTodayMood(String memberId);

    @Select("SELECT * FROM mood_log WHERE member_id=#{memberId} AND user_id=#{userId} " +
            "ORDER BY log_date DESC LIMIT 7")
    List<MoodLog> findWeeklyMoods(@Param("memberId") String memberId, @Param("userId") Long userId);

    @Insert("INSERT INTO mood_log(member_id,user_id,mood_id,note,log_date,log_time) " +
            "VALUES(#{memberId},#{userId},#{moodId},#{note},CURDATE(),#{logTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertMoodLog(MoodLog log);
}
