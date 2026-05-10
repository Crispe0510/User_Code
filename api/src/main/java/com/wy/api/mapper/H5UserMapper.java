package com.wy.api.mapper;

import com.wy.api.entity.H5User;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface H5UserMapper {

    @Select("SELECT * FROM h5_user ORDER BY id")
    List<H5User> findAll();

    @Select("SELECT * FROM h5_user WHERE id = #{id}")
    H5User findById(Long id);

    @Select("SELECT * FROM h5_user WHERE email = #{email}")
    H5User findByEmail(String email);

    @Insert("INSERT INTO h5_user(name,email,password,identity,status) VALUES(#{name},#{email},#{password},#{identity},1)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(H5User user);

    @Update("UPDATE h5_user SET status=#{status} WHERE id=#{id}")
    int updateStatus(@Param("id") Long id, @Param("status") int status);

    @Delete("DELETE FROM h5_user WHERE id=#{id}")
    int delete(Long id);

    @Select("SELECT COUNT(*) FROM h5_user")
    int count();
}
