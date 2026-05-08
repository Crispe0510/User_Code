package com.wy.api.controller.h5;

import com.wy.api.common.Result;
import com.wy.api.config.TokenStore;
import com.wy.api.entity.FamilyMember;
import com.wy.api.mapper.FamilyMemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/h5/family")
public class H5FamilyController {

    @Autowired
    private FamilyMemberMapper familyMemberMapper;

    /** 查询当前用户的家庭成员列表 */
    @GetMapping("/members")
    public Result<List<FamilyMember>> list(
            @RequestHeader(value = "Authorization", required = false) String auth) {
        Long userId = resolveUserId(auth);
        // 与 POST 一致：未登录不回落到演示用户，避免访客误以为已登录却保存失败
        if (userId == null) {
            return Result.ok(Collections.emptyList());
        }
        return Result.ok(familyMemberMapper.findByUserId(userId));
    }

    /** 新增家庭成员（需登录） */
    @PostMapping("/members")
    public Result<FamilyMember> add(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @RequestBody FamilyMember m) {
        Long userId = resolveUserId(auth);
        if (userId == null) return Result.fail(401, "请先登录");
        if (!StringUtils.hasText(m.getName())) return Result.fail("成员名称不能为空");

        m.setUserId(userId);
        m.setId("m" + UUID.randomUUID().toString().replace("-", "").substring(0, 6));
        if (!StringUtils.hasText(m.getRole())) m.setRole("parent");
        if (!StringUtils.hasText(m.getAvatar())) m.setAvatar("👤");
        if (m.getSortOrder() == null) {
            m.setSortOrder(familyMemberMapper.countByUserId(userId) + 1);
        }
        // linkedUserId 原样保留（可为 null）
        familyMemberMapper.insert(m);
        return Result.ok(m);
    }

    /** 修改家庭成员（需登录，且只能改自己的） */
    @PutMapping("/members/{id}")
    public Result<FamilyMember> update(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @PathVariable String id,
            @RequestBody FamilyMember m) {
        Long userId = resolveUserId(auth);
        if (userId == null) return Result.fail(401, "请先登录");
        FamilyMember exist = familyMemberMapper.findById(id);
        if (exist == null || !exist.getUserId().equals(userId)) return Result.fail("成员不存在");
        if (!StringUtils.hasText(m.getName())) return Result.fail("名称不能为空");
        m.setId(id);
        if (!StringUtils.hasText(m.getRole())) m.setRole(exist.getRole());
        if (!StringUtils.hasText(m.getAvatar())) m.setAvatar(exist.getAvatar());
        if (m.getSortOrder() == null) m.setSortOrder(exist.getSortOrder());
        familyMemberMapper.update(m);
        return Result.ok(familyMemberMapper.findById(id));
    }

    /** 删除家庭成员（需登录，且只能删自己的） */
    @DeleteMapping("/members/{id}")
    public Result<?> delete(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @PathVariable String id) {
        Long userId = resolveUserId(auth);
        if (userId == null) return Result.fail(401, "请先登录");
        FamilyMember exist = familyMemberMapper.findById(id);
        if (exist == null || !exist.getUserId().equals(userId)) return Result.fail("成员不存在");
        familyMemberMapper.deleteById(id);
        return Result.ok();
    }

    private Long resolveUserId(String auth) {
        if (auth != null && auth.startsWith("Bearer ")) {
            return TokenStore.getH5UserId(auth.substring(7));
        }
        return null;
    }
}
