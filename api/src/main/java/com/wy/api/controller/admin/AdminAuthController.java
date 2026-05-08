package com.wy.api.controller.admin;

import com.wy.api.common.Result;
import com.wy.api.config.TokenStore;
import com.wy.api.entity.AdminUser;
import com.wy.api.mapper.AdminUserMapper;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminAuthController {

    @Autowired
    private AdminUserMapper adminUserMapper;

    @PostMapping("/login")
    public Result<?> login(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String password = body.get("password");
        AdminUser user = adminUserMapper.findByUsername(username);
        if (user == null || !user.getPassword().equals(password)) {
            return Result.fail("用户名或密码错误");
        }
        if (user.getStatus() != 1) {
            return Result.fail("账号已被禁用");
        }
        String token = TokenStore.createAdminToken(user.getId());
        adminUserMapper.updateLastLogin(user.getId());
        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("name", user.getName());
        data.put("role", user.getRole());
        return Result.ok(data);
    }

    @PostMapping("/logout")
    public Result<?> logout(HttpServletRequest request) {
        String token = extractToken(request);
        TokenStore.removeAdminToken(token);
        return Result.ok();
    }

    @GetMapping("/profile")
    public Result<?> profile(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("adminUserId");
        AdminUser user = adminUserMapper.findById(userId);
        user.setPassword(null);
        return Result.ok(user);
    }

    private String extractToken(HttpServletRequest request) {
        String h = request.getHeader("Authorization");
        return (h != null && h.startsWith("Bearer ")) ? h.substring(7) : h;
    }
}
