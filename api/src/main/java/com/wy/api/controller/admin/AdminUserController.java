package com.wy.api.controller.admin;

import com.wy.api.common.Result;
import com.wy.api.entity.AdminUser;
import com.wy.api.entity.H5User;
import com.wy.api.mapper.AdminUserMapper;
import com.wy.api.mapper.H5UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminUserController {

    @Autowired
    private H5UserMapper h5UserMapper;
    @Autowired
    private AdminUserMapper adminUserMapper;

    // ── H5 用户管理 ──────────────────────────────────────

    @GetMapping("/h5-users")
    public Result<List<H5User>> listH5Users() {
        List<H5User> list = h5UserMapper.findAll();
        list.forEach(u -> u.setPassword(null));
        return Result.ok(list);
    }

    @PutMapping("/h5-users/{id}/status")
    public Result<?> updateH5UserStatus(@PathVariable Long id, @RequestBody Map<String, Integer> body) {
        h5UserMapper.updateStatus(id, body.get("status"));
        return Result.ok();
    }

    @DeleteMapping("/h5-users/{id}")
    public Result<?> deleteH5User(@PathVariable Long id) {
        h5UserMapper.delete(id);
        return Result.ok();
    }

    // ── 管理员账号管理 ────────────────────────────────────

    @GetMapping("/admins")
    public Result<List<AdminUser>> listAdmins() {
        List<AdminUser> list = adminUserMapper.findAll();
        list.forEach(u -> u.setPassword(null));
        return Result.ok(list);
    }

    @PostMapping("/admins")
    public Result<?> addAdmin(@RequestBody AdminUser user) {
        if (adminUserMapper.findByUsername(user.getUsername()) != null) {
            return Result.fail("用户名已存在");
        }
        adminUserMapper.insert(user);
        return Result.ok(user.getId());
    }

    @PutMapping("/admins/{id}")
    public Result<?> updateAdmin(@PathVariable Long id, @RequestBody AdminUser user) {
        user.setId(id);
        adminUserMapper.update(user);
        return Result.ok();
    }

    @DeleteMapping("/admins/{id}")
    public Result<?> deleteAdmin(@PathVariable Long id) {
        adminUserMapper.delete(id);
        return Result.ok();
    }

    // ── 统计 ──────────────────────────────────────────────

    @GetMapping("/stats")
    public Result<?> stats() {
        Map<String, Object> data = new HashMap<>();
        data.put("h5UserCount", h5UserMapper.count());
        return Result.ok(data);
    }
}
