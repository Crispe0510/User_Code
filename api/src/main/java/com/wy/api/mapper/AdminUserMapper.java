package com.wy.api.mapper;

import com.wy.api.entity.AdminUser;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface AdminUserMapper {

    @Select("SELECT * FROM admin_user WHERE status = 1 ORDER BY id")
    List<AdminUser> findAll();

    @Select("SELECT * FROM admin_user WHERE id = #{id}")
    AdminUser findById(Long id);

    @Select("SELECT * FROM admin_user WHERE username = #{username}")
    AdminUser findByUsername(String username);

    @Insert("INSERT INTO admin_user(username,password,name,role,status) VALUES(#{username},#{password},#{name},#{role},1)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(AdminUser user);

    @Update("UPDATE admin_user SET name=#{name},role=#{role},status=#{status} WHERE id=#{id}")
    int update(AdminUser user);

    @Update("UPDATE admin_user SET last_login=NOW() WHERE id=#{id}")
    int updateLastLogin(Long id);

    @Delete("DELETE FROM admin_user WHERE id=#{id}")
    int delete(Long id);
}
