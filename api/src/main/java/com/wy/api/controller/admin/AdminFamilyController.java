package com.wy.api.controller.admin;

import com.wy.api.common.Result;
import com.wy.api.entity.FamilyMember;
import com.wy.api.mapper.FamilyMemberMapper;
import com.wy.api.mapper.H5UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/family")
public class AdminFamilyController {

    @Autowired
    private FamilyMemberMapper familyMemberMapper;

    @Autowired
    private H5UserMapper h5UserMapper;

    /** 查询所有家庭成员（可按 userId 过滤） */
    @GetMapping("/members")
    public Result<List<FamilyMember>> list(@RequestParam(required = false) Long userId) {
        if (userId != null) {
            return Result.ok(familyMemberMapper.findByUserId(userId));
        }
        return Result.ok(familyMemberMapper.findAll());
    }

    /** 新增家庭成员 */
    @PostMapping("/members")
    public Result<FamilyMember> add(@RequestBody FamilyMember m) {
        if (!StringUtils.hasText(m.getName())) return Result.fail("成员名称不能为空");
        if (m.getUserId() == null) return Result.fail("必须指定所属 H5 用户");

        // 生成唯一 ID
        String rawId = "m" + UUID.randomUUID().toString().replace("-", "").substring(0, 6);
        m.setId(rawId);

        if (!StringUtils.hasText(m.getRole())) m.setRole("parent");
        if (!StringUtils.hasText(m.getAvatar())) m.setAvatar("👤");
        if (m.getSortOrder() == null) {
            m.setSortOrder(familyMemberMapper.countByUserId(m.getUserId()) + 1);
        }
        familyMemberMapper.insert(m);
        return Result.ok(m);
    }

    /** 修改家庭成员 */
    @PutMapping("/members/{id}")
    public Result<FamilyMember> update(@PathVariable String id, @RequestBody FamilyMember m) {
        FamilyMember exist = familyMemberMapper.findById(id);
        if (exist == null) return Result.fail("成员不存在");
        if (!StringUtils.hasText(m.getName())) return Result.fail("成员名称不能为空");
        m.setId(id);
        if (!StringUtils.hasText(m.getRole())) m.setRole(exist.getRole());
        if (!StringUtils.hasText(m.getAvatar())) m.setAvatar(exist.getAvatar());
        if (m.getSortOrder() == null) m.setSortOrder(exist.getSortOrder());
        familyMemberMapper.update(m);
        return Result.ok(familyMemberMapper.findById(id));
    }

    /** 删除家庭成员 */
    @DeleteMapping("/members/{id}")
    public Result<?> delete(@PathVariable String id) {
        if (familyMemberMapper.findById(id) == null) return Result.fail("成员不存在");
        familyMemberMapper.deleteById(id);
        return Result.ok();
    }
}
