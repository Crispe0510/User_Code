package com.wy.api.controller.h5;

import com.wy.api.common.Result;
import com.wy.api.config.TokenStore;
import com.wy.api.entity.FamilyMember;
import com.wy.api.entity.H5User;
import com.wy.api.entity.Topic;
import com.wy.api.entity.TopicChatMessage;
import com.wy.api.entity.TopicQuestion;
import com.wy.api.mapper.FamilyMemberMapper;
import com.wy.api.mapper.H5UserMapper;
import com.wy.api.mapper.TopicChatMapper;
import com.wy.api.mapper.TopicMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/h5/chat")
public class H5TopicChatController {

    @Autowired private TopicChatMapper topicChatMapper;
    @Autowired private FamilyMemberMapper familyMemberMapper;
    @Autowired private H5UserMapper h5UserMapper;
    @Autowired private TopicMapper topicMapper;
    @Autowired private RestTemplate restTemplate;

    @Value("${deepseek.api-key}")
    private String deepseekApiKey;

    @Value("${deepseek.api-url:https://api.deepseek.com/chat/completions}")
    private String deepseekApiUrl;

    @Value("${deepseek.model:deepseek-chat}")
    private String deepseekModel;

    @Value("${deepseek.max-tokens:500}")
    private int deepseekMaxTokens;

    // ── 获取消息列表 ──────────────────────────────────────────────────────────
    @GetMapping("/messages")
    public Result<List<TopicChatMessage>> list(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @RequestParam("scenarioKey") String scenarioKey,
            @RequestParam("topicKey") String topicKey) {
        Long userId = resolveUserId(auth);
        if (userId == null) userId = 1L;
        String roomKey = computeRoomKey(userId);
        return Result.ok(topicChatMapper.findByRoomAndTopic(roomKey, scenarioKey.trim(), topicKey.trim()));
    }

    // ── 发送用户消息 ──────────────────────────────────────────────────────────
    @PostMapping("/messages")
    public Result<TopicChatMessage> send(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @RequestBody Map<String, String> body) {
        Long userId = resolveUserId(auth);
        if (userId == null) userId = 1L;

        String scenarioKey = body.get("scenarioKey");
        String topicKey    = body.get("topicKey");
        String senderType  = body.get("senderType");
        String content     = body.get("content");
        if (!StringUtils.hasText(scenarioKey) || !StringUtils.hasText(topicKey))
            return Result.fail("Missing scenarioKey / topicKey");
        if (!StringUtils.hasText(content) || content.trim().length() > 2000)
            return Result.fail("Content must be 1-2000 characters");
        if (!"me".equals(senderType) && !"family".equals(senderType))
            return Result.fail("Invalid senderType");

        TopicChatMessage m = new TopicChatMessage();
        m.setUserId(userId);
        m.setRoomKey(computeRoomKey(userId));
        m.setScenarioKey(scenarioKey.trim());
        m.setTopicKey(topicKey.trim());
        m.setSenderType(senderType);
        m.setContent(content.trim());

        if ("family".equals(senderType)) {
            String memberId   = body.get("memberId");
            String senderName = body.get("senderName");
            if (!StringUtils.hasText(memberId) || !StringUtils.hasText(senderName))
                return Result.fail("memberId and senderName required for family type");
            m.setMemberId(memberId.trim());
            m.setSenderName(senderName.trim());
        } else {
            m.setMemberId(null);
            String name = body.get("senderName");
            m.setSenderName(StringUtils.hasText(name) ? name.trim() : "Me");
        }

        topicChatMapper.insert(m);
        if (m.getCreatedAt() == null) m.setCreatedAt(LocalDateTime.now());
        return Result.ok(m);
    }

    // ── AI 智能回复 ───────────────────────────────────────────────────────────
    /**
     * 根据话题 + 历史消息调用 DeepSeek，生成一条 AI 引导性回复并保存。
     * Request body: { scenarioKey, topicKey, topicTitle (optional) }
     */
    @PostMapping("/ai-reply")
    public Result<TopicChatMessage> aiReply(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @RequestBody Map<String, String> body) {

        Long userId = resolveUserId(auth);
        if (userId == null) userId = 1L;

        String scenarioKey = body.get("scenarioKey");
        String topicKey    = body.get("topicKey");
        String topicTitle  = body.getOrDefault("topicTitle", "");

        if (!StringUtils.hasText(scenarioKey) || !StringUtils.hasText(topicKey))
            return Result.fail("Missing scenarioKey / topicKey");

        String roomKey = computeRoomKey(userId);

        // 1. 加载话题问题（仅内置话题有数据库记录）
        String openingText = "";
        String deepText    = "";
        if (!topicKey.startsWith("custom-")) {
            Topic topic = topicMapper.findById(topicKey);
            if (topic != null) {
                if (!StringUtils.hasText(topicTitle)) topicTitle = topic.getTitle();
                List<TopicQuestion> opening = topicMapper.findQuestions(topicKey, "opening");
                List<TopicQuestion> deep    = topicMapper.findQuestions(topicKey, "deep");
                openingText = opening.stream().map(TopicQuestion::getContent)
                        .collect(Collectors.joining(" | "));
                deepText    = deep.stream().map(TopicQuestion::getContent)
                        .collect(Collectors.joining(" | "));
            }
        }

        // 2. 读取最近 20 条历史消息作为上下文
        List<TopicChatMessage> history =
                topicChatMapper.findByRoomAndTopic(roomKey, scenarioKey, topicKey);
        int start = Math.max(0, history.size() - 20);
        List<TopicChatMessage> recent = history.subList(start, history.size());

        // 3. 构造 DeepSeek 请求
        String systemPrompt = buildSystemPrompt(topicTitle, openingText, deepText);
        List<Map<String, String>> messages = new ArrayList<>();
        messages.add(mapOf("role", "system", "content", systemPrompt));

        // 把历史对话转成 user/assistant 轮流格式
        for (TopicChatMessage msg : recent) {
            String role = "ai".equals(msg.getSenderType()) ? "assistant" : "user";
            String label = StringUtils.hasText(msg.getSenderName())
                    ? "[" + msg.getSenderName() + "]: " : "";
            messages.add(mapOf("role", role, "content", label + msg.getContent()));
        }

        // 如果没有历史，加一条引导语让 AI 开场
        if (recent.isEmpty()) {
            messages.add(mapOf("role", "user",
                    "content", "Please help us start the conversation on this topic."));
        }

        // 4. 调用 DeepSeek
        String aiText;
        try {
            aiText = callDeepSeek(messages);
        } catch (Exception e) {
            return Result.fail("AI service unavailable: " + e.getMessage());
        }

        // 5. 保存 AI 消息
        TopicChatMessage aiMsg = new TopicChatMessage();
        aiMsg.setUserId(userId);
        aiMsg.setRoomKey(roomKey);
        aiMsg.setScenarioKey(scenarioKey);
        aiMsg.setTopicKey(topicKey);
        aiMsg.setSenderType("ai");
        aiMsg.setMemberId(null);
        aiMsg.setSenderName("AI");
        aiMsg.setContent(aiText);
        topicChatMapper.insert(aiMsg);
        if (aiMsg.getCreatedAt() == null) aiMsg.setCreatedAt(LocalDateTime.now());

        return Result.ok(aiMsg);
    }

    // ── 获取可关联的 H5 用户列表（供前端 Manage 弹窗选择） ────────────────────
    @GetMapping("/linkable-users")
    public Result<?> linkableUsers(
            @RequestHeader(value = "Authorization", required = false) String auth) {
        Long userId = resolveUserId(auth);
        if (userId == null) return Result.ok(Collections.emptyList());
        List<H5User> all = h5UserMapper.findAll();
        List<Map<String, Object>> list = all.stream()
            .filter(u -> !u.getId().equals(userId))
            .map(u -> {
                Map<String, Object> item = new HashMap<>();
                item.put("id", u.getId());
                item.put("name", u.getName());
                item.put("email", u.getEmail());
                item.put("identity", u.getIdentity());
                return item;
            })
            .collect(Collectors.toList());
        return Result.ok(list);
    }

    // ── 私有工具方法 ──────────────────────────────────────────────────────────

    private String buildSystemPrompt(String topicTitle, String openingQs, String deepQs) {
        StringBuilder sb = new StringBuilder();
        sb.append("You are Bridge AI, a warm and empathetic family conversation facilitator. ");
        sb.append("Your role is to help family members — especially across generations — ");
        sb.append("have meaningful, comfortable, and memorable conversations.\n\n");

        if (StringUtils.hasText(topicTitle)) {
            sb.append("Current topic: \"").append(topicTitle).append("\"\n");
        }
        if (StringUtils.hasText(openingQs)) {
            sb.append("Opening questions for this topic: ").append(openingQs).append("\n");
        }
        if (StringUtils.hasText(deepQs)) {
            sb.append("Deeper questions: ").append(deepQs).append("\n");
        }
        sb.append("\n");
        sb.append("Guidelines:\n");
        sb.append("- Respond in the same language as the conversation participants.\n");
        sb.append("- Keep your response concise: 2-3 sentences maximum.\n");
        sb.append("- Be warm, curious, and encouraging — never prescriptive.\n");
        sb.append("- You may ask a follow-up question, share a gentle observation, ");
        sb.append("or suggest a new angle from the topic questions above.\n");
        sb.append("- Do NOT repeat what was already said verbatim.\n");
        return sb.toString();
    }

    @SuppressWarnings("unchecked")
    private String callDeepSeek(List<Map<String, String>> messages) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + deepseekApiKey);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", deepseekModel);
        requestBody.put("messages", messages);
        requestBody.put("max_tokens", deepseekMaxTokens);
        requestBody.put("stream", false);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        ResponseEntity<Map> response =
                restTemplate.exchange(deepseekApiUrl, HttpMethod.POST, entity, Map.class);

        Map<String, Object> resBody = response.getBody();
        if (resBody == null) throw new RuntimeException("Empty response from DeepSeek");

        List<Map<String, Object>> choices = (List<Map<String, Object>>) resBody.get("choices");
        if (choices == null || choices.isEmpty()) throw new RuntimeException("No choices in response");

        Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
        if (message == null) throw new RuntimeException("No message in choice");

        Object content = message.get("content");
        if (content == null) throw new RuntimeException("No content in message");
        return content.toString().trim();
    }

    private String computeRoomKey(Long userId) {
        List<FamilyMember> myMembers = familyMemberMapper.findByUserId(userId);
        for (FamilyMember fm : myMembers) {
            if (fm.getLinkedUserId() != null) {
                return sharedKey(userId, fm.getLinkedUserId());
            }
        }
        List<FamilyMember> reversed = familyMemberMapper.findByLinkedUserId(userId);
        if (!reversed.isEmpty()) {
            return sharedKey(userId, reversed.get(0).getUserId());
        }
        return String.valueOf(userId);
    }

    private String sharedKey(Long a, Long b) {
        long min = Math.min(a, b);
        long max = Math.max(a, b);
        return min + "_" + max;
    }

    private Long resolveUserId(String auth) {
        if (auth != null && auth.startsWith("Bearer ")) {
            return TokenStore.getH5UserId(auth.substring(7));
        }
        return null;
    }

    private static Map<String, String> mapOf(String k1, String v1, String k2, String v2) {
        Map<String, String> m = new LinkedHashMap<>();
        m.put(k1, v1);
        m.put(k2, v2);
        return m;
    }
}
