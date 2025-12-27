---
title: 让 AI 说“机器话”：JSON Schema 与解析
---

# 03. 让 AI 说“机器话”：JSON Schema 与解析

!!! quote "🎓 本节目标：打破“人机隔阂”"
AI 天生是个“文科生”，喜欢吟诗作对、长篇大论。
但 Java 后端程序是个“理科生”，只认识严谨的 **JSON 数据**。

```
* **AI 说**：“根据您的描述，我觉得这个用户的名字叫张三，今年25岁...” ❌ (程序没法处理)
* **程序要**：`{"name": "张三", "age": 25}` ✅

今天我们要给 AI 立个规矩：**“少废话，给 JSON！”**

```

---

## 😫 第一部分：痛点回顾

在上一节的结尾，我们为了构造请求体，写出了这样的代码：

```java
// ❌ 危险的字符串拼接
String jsonBody = """
    {
        "content": "%s"
    }
    """.formatted(userInput.replace("\"", "\\\""));

```

一旦 `userInput` 里包含换行符、制表符或者特殊的 Emoji，这个 JSON 就会瞬间格式错误，导致 API 报错。

**解决方案**：使用 Spring Boot 自带的 **Jackson** 库（`ObjectMapper`），把 Java 对象自动“序列化”为 JSON 字符串。

---

## 📋 第二部分：输出控制——JSON Mode

如何让 AI 只返回 JSON？
目前主要靠 **Prompt 约束**。我们需要在 **System Prompt** 中植入一段“催眠指令”。

### 1. 催眠指令 (System Prompt)

> **System**:
> 你是一个数据提取助手。请从用户的描述中提取关键信息，并**严格只输出 JSON 格式**的数据。
> **不要输出 markdown 代码块（如 ```json），不要包含任何解释性文字。**

### 2. 定义 Java 结构 (Schema)

假设我们要让 AI 从一段自我介绍中提取用户信息。我们需要先定义一个 Java 类（Java Bean），这其实就是我们的 **Schema (数据规范)**。

```java title="UserProfile.java"
package com.example.demo.model;

import java.util.List;

// 使用 Java 14+ 的 record (记录类)，简洁定义数据结构
public record UserProfile(
    String name,
    Integer age,
    List<String> skills,
    String summary // 一句话总结
) {}

```

---

## 🛠️ 第三部分：实战——自动化提取工具

我们将实现一个功能：用户输入一段随意的自我介绍，系统自动将其转换为标准的 `UserProfile` 对象存入数据库（模拟）。

在 `src/test/java` 下新建 `JsonParseTest.java`。

### 1. 引入 Jackson 工具

Spring Boot Web Starter 默认自带了 Jackson，我们通过 `@Autowired` 注入 `ObjectMapper`。

### 2. 完整代码

```java title="JsonParseTest.java"
package com.example.demo;

import com.example.demo.model.UserProfile;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;

@SpringBootTest
public class JsonParseTest {

    @Autowired
    private ObjectMapper objectMapper; // Spring Boot 的御用 JSON 工具

    private static final String API_KEY = "sk-你的Token";
    private static final String API_URL = "[https://api-inference.modelscope.cn/v1/chat/completions](https://api-inference.modelscope.cn/v1/chat/completions)";

    @Test
    void testExtractJson() throws Exception {
        // ==========================================
        // 1. 准备用户输入 (非结构化数据)
        // ==========================================
        String rawText = "大家好，我是李四，今年刚满22岁。我擅长Java和Python，平时喜欢在这个博客写点技术文章。";

        // ==========================================
        // 2. 构造 Prompt (强制 JSON 输出)
        // ==========================================
        String systemPrompt = """
            你是一个严格的数据解析器。请分析用户输入，提取以下字段：
            - name (String): 姓名
            - age (Integer): 年龄
            - skills (Array<String>): 技能列表
            - summary (String): 第三人称简短总结
            
            ⚠️ 重要要求：
            1. 仅返回纯 JSON 字符串。
            2. 不要使用 Markdown 代码块包裹（不要 ```json ... ```）。
            3. 如果信息缺失，用 null 或空数组填充。
            """;

        // 使用 Map 组装请求体，不再手动拼字符串！✅
        Map<String, Object> requestBody = Map.of(
            "model", "deepseek-ai/DeepSeek-R1-0528",
            "messages", List.of(
                Map.of("role", "system", "content", systemPrompt),
                Map.of("role", "user", "content", rawText)
            )
        );

        // ==========================================
        // 3. 发送请求
        // ==========================================
        RestClient client = RestClient.builder()
                .baseUrl(API_URL)
                .defaultHeader("Authorization", "Bearer " + API_KEY)
                .build();

        System.out.println("🤖 AI 正在提取数据...");

        // 这里我们先拿到原始的 JSON 响应结构（包含 choices 等外壳）
        String apiResponse = client.post()
                .contentType(MediaType.APPLICATION_JSON)
                .body(objectMapper.writeValueAsString(requestBody)) // ✅ 自动序列化
                .retrieve()
                .body(String.class);

        // ==========================================
        // 4. 清洗与解析 (关键步骤)
        // ==========================================
        // 第一步：从 API 响应中拿到 content 内容
        // (为了简化演示，这里用简单的字符串截取或假设我们有一个 ApiResponse 类)
        // 实际开发建议定义一个 DeepSeekResponse 类来接
        String aiContent = extractContentFromDeepSeek(apiResponse); 
        
        System.out.println("📜 AI 返回的原始 Content:\n" + aiContent);

        // 第二步：清洗可能存在的 Markdown 标记
        // 即使我们提示了不要 ```，有些模型还是很客气地加上了
        String cleanJson = aiContent.replaceAll("```json", "").replaceAll("```", "").trim();
        
        // 第三步：反序列化为 Java 对象
        UserProfile userProfile = objectMapper.readValue(cleanJson, UserProfile.class);

        // ==========================================
        // 5. 验证结果
        // ==========================================
        System.out.println("\n✅ 转换成功！Java 对象信息：");
        System.out.println("姓名: " + userProfile.name());
        System.out.println("年龄: " + userProfile.age());
        System.out.println("技能: " + userProfile.skills());
        System.out.println("总结: " + userProfile.summary());
    }

    // 一个简单的辅助方法，用于从复杂的 API JSON 中提取 content 字段
    // 真实项目中应该用类映射
    private String extractContentFromDeepSeek(String json) throws Exception {
        var node = objectMapper.readTree(json);
        // 兼容 DeepSeek/OpenAI 结构: choices[0].message.content
        return node.path("choices").get(0).path("message").path("content").asText();
    }
}

```

---

## 🧹 第四部分：清洗 Markdown 的必要性

你可能会问：*“我在 Prompt 里都说了不要 Markdown，为什么代码里还要 `replaceAll`？”*

**永远不要完全信任 AI。**
即使是最先进的模型（如 GPT-4 或 DeepSeek-V3），有时也会为了“格式好看”而加上 `json ... `。作为健壮的后端程序，我们必须在代码层面做一个**兜底处理**。

这个简单的正则替换就是最常用的**“去格式化”**手段：

```java
String cleanJson = aiContent.replaceAll("```json", "").replaceAll("```", "").trim();

```

---

## 🔍 第五部分：JSON Schema 的深层意义

虽然本节我们通过“自然语言描述”告诉了 AI 字段格式（如 `name (String)`），但这还不够严谨。

在更高级的场景（如 OpenAI 的 **JSON Schema Mode** 或下一节的 **Tool Calling**）中，我们会用更标准的 JSON 描述来定义结构：

```json
{
  "type": "object",
  "properties": {
    "age": { "type": "integer", "minimum": 0 },
    "email": { "type": "string", "format": "email" }
  },
  "required": ["age", "email"]
}

```

这就是 **JSON Schema**。它不仅定义了字段，还定义了约束（如“年龄不能小于0”）。
下一节讲 **Tool Calling** 时，我们将看到 AI 是如何利用这些 Schema 来准确调用我们的 Java 方法的。

---

## 📝 总结

1. **输入端**：不要拼接字符串！使用 `ObjectMapper.writeValueAsString()` 将 Map 或对象转为 JSON。
2. **输出端**：使用 System Prompt 强行要求返回 JSON，并提示“不要 Markdown”。
3. **兜底**：代码中必须包含清洗逻辑（去除 ``` 符号），防止 AI“画蛇添足”。
4. **结果**：最终我们得到的是一个干净的 **Java Object**，可以直接存库或返回给前端。

[下一节：🔥 赋予 AI 双手：Tool Calling (Function Calling)](04-tool-calling.md){ .md-button .md-button--primary }