package com.wy.api.mapper;

import com.wy.api.entity.Scenario;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ScenarioMapper {

    @Select("SELECT * FROM scenario WHERE enabled = 1 ORDER BY sort_order")
    List<Scenario> findAllEnabled();
}
