package com.wy.api.mapper;

import com.wy.api.entity.TopicChatMessage;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface TopicChatMapper {

    @Select("SELECT * FROM topic_chat_message WHERE room_key=#{roomKey} AND scenario_key=#{scenarioKey} AND topic_key=#{topicKey} ORDER BY id ASC")
    List<TopicChatMessage> findByRoomAndTopic(@Param("roomKey") String roomKey,
                                              @Param("scenarioKey") String scenarioKey,
                                              @Param("topicKey") String topicKey);

    @Insert("INSERT INTO topic_chat_message(user_id,room_key,scenario_key,topic_key,sender_type,member_id,sender_name,content) " +
            "VALUES(#{userId},#{roomKey},#{scenarioKey},#{topicKey},#{senderType},#{memberId},#{senderName},#{content})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(TopicChatMessage m);
}
