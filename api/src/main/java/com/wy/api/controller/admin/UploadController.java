package com.wy.api.controller.admin;

import com.wy.api.common.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/upload")
public class UploadController {

    @Value("${upload.dir:uploads}")
    private String uploadDir;

    @PostMapping("/image")
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) return Result.fail("请选择文件");
        String original = file.getOriginalFilename();
        String ext = (original != null && original.contains("."))
                ? original.substring(original.lastIndexOf(".")).toLowerCase()
                : ".jpg";
        // 只允许图片格式
        if (!ext.matches("\\.(jpg|jpeg|png|gif|webp|svg)")) {
            return Result.fail("仅支持 jpg/png/gif/webp/svg 格式");
        }
        String filename = UUID.randomUUID().toString().replace("-", "") + ext;
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();
        try {
            file.transferTo(new File(dir, filename));
        } catch (IOException e) {
            return Result.fail("上传失败: " + e.getMessage());
        }
        return Result.ok("/uploads/" + filename);
    }
}
