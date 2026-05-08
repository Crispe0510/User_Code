package com.wy.api.controller.h5;

import com.wy.api.common.Result;
import com.wy.api.config.TokenStore;
import com.wy.api.entity.H5User;
import com.wy.api.mapper.H5UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/h5/auth")
public class H5AuthController {

    @Autowired
    private H5UserMapper h5UserMapper;

    @PostMapping("/register")
    public Result<?> register(@RequestBody H5User user) {
        if (h5UserMapper.findByEmail(user.getEmail()) != null) {
            return Result.fail("该邮箱已注册");
        }
        h5UserMapper.insert(user);
        String token = TokenStore.createH5Token(user.getId());
        return Result.ok(buildAuthResult(token, user));
    }

    @PostMapping("/login")
    public Result<?> login(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        String password = body.get("password");
        H5User user = h5UserMapper.findByEmail(email);
        if (user == null || !user.getPassword().equals(password)) {
            return Result.fail("邮箱或密码错误");
        }
        if (user.getStatus() != 1) {
            return Result.fail("账号已被禁用");
        }
        String token = TokenStore.createH5Token(user.getId());
        return Result.ok(buildAuthResult(token, user));
    }

    @PostMapping("/logout")
    public Result<?> logout(@RequestHeader(value = "Authorization", required = false) String auth) {
        if (auth != null && auth.startsWith("Bearer ")) {
            TokenStore.removeH5Token(auth.substring(7));
        }
        return Result.ok();
    }

    private Map<String, Object> buildAuthResult(String token, H5User user) {
        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("id", user.getId());
        data.put("name", user.getName());
        data.put("email", user.getEmail());
        data.put("identity", user.getIdentity());
        return data;
    }
}
