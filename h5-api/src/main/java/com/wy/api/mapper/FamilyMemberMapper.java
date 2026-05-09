package com.wy.api.mapper;

import com.wy.api.entity.FamilyMember;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface FamilyMemberMapper {

    @Select("SELECT * FROM family_member WHERE user_id=#{userId} ORDER BY sort_order")
    List<FamilyMember> findByUserId(Long userId);

    @Select("SELECT * FROM family_member WHERE id=#{id}")
    FamilyMember findById(String id);

    @Insert("INSERT INTO family_member(id, user_id, name, role, avatar, sort_order, linked_user_id) " +
            "VALUES(#{id}, #{userId}, #{name}, #{role}, #{avatar}, #{sortOrder}, #{linkedUserId})")
    int insert(FamilyMember m);

    @Update("UPDATE family_member SET name=#{name}, role=#{role}, avatar=#{avatar}, sort_order=#{sortOrder}, linked_user_id=#{linkedUserId} WHERE id=#{id}")
    int update(FamilyMember m);

    /** 根据关联用户 ID 查询（用于反向查找共享聊天室） */
    @Select("SELECT * FROM family_member WHERE linked_user_id=#{linkedUserId}")
    List<FamilyMember> findByLinkedUserId(Long linkedUserId);

    @Delete("DELETE FROM family_member WHERE id=#{id}")
    int deleteById(String id);

    @Select("SELECT COUNT(*) FROM family_member WHERE user_id=#{userId}")
    int countByUserId(Long userId);
}
