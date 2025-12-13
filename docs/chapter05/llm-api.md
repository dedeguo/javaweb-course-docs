---
title: 大模型 API 调用流程
---

# 大模型 API 调用流程

> 面向 Java 初学者的“一次就上手”指南：拿到 Key → 发起请求 → 解析返回 → 处理异常 → 封装复用。

---

## 学习目标

- 了解大模型 API 的通用调用流程与关键术语（model、messages、temperature、stream）。
- 能在 Java 中用 `HttpClient` 发送请求，并用 `Jackson` 解析 JSON 响应。
- 掌握 API Key 安全、超时与重试、流式响应和错误处理的最佳实践。

---

## 1. 获取 API Key（以 DeepSeek 为例）

提示：不同厂商入口相似，核心是“注册账号 → 创建应用或密钥 → 把 Key 配到本地/服务器的环境变量中”。

1) 注册并创建 Key  
- 访问 DeepSeek 官网，完成注册与实名认证。
- 进入控制台中新建密钥（API Key）。

2) 本地安全配置  
- macOS/Linux：在 `~/.zshrc` 或 `~/.bashrc` 添加一行并生效：
  ```bash
  export DEEPSEEK_API_KEY="你的Key"
  ```
- Windows（PowerShell）：
  ```powershell
  setx DEEPSEEK_API_KEY "你的Key"
  ```

3) 应用内读取  
- 推荐通过环境变量或配置文件读取，避免把 Key 写死到代码库。

!!! warning "切勿提交密钥到 Git"
    把 `.env`、`application-*.yml` 等敏感配置加入 `.gitignore`。

---

## 2. 通用请求结构与参数

多数大模型对话接口遵循“消息列表（messages）”格式：

```json
{
  "model": "deepseek-chat",
  "messages": [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user",   "content": "用100字解释什么是RESTful"}
  ],
  "temperature": 0.7,
  "stream": false
}
```

- model：模型名称，不同厂商命名不同。
- messages：按顺序组织对话。常见角色：system、user、assistant。
- temperature：采样温度，越高越发散，越低越保守。
- stream：是否启用流式输出（边生成边返回）。

---

## 3. Java 代码示例：非流式调用

示例依赖：

```xml
<!-- Maven: Jackson JSON -->
<dependency>
  <groupId>com.fasterxml.jackson.core</groupId>
  <artifactId>jackson-databind</artifactId>
  <version>2.17.1</version>
></dependency>
```

示例使用 JDK 11+ 自带的 `HttpClient` 发送 POST 请求，并用 `Jackson` 解析 JSON。

```java
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class DeepSeekClientSimple {
    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final String API_KEY = System.getenv("DEEPSEEK_API_KEY");
    // 示例端点与模型名称按厂商文档填写
    private static final String ENDPOINT = "https://api.deepseek.com/chat/completions";
    private static final String MODEL = "deepseek-chat";

    public static void main(String[] args) throws Exception {
        if (API_KEY == null || API_KEY.isBlank()) {
            throw new IllegalStateException("请先配置环境变量 DEEPSEEK_API_KEY");
        }

        String body = """
        {\n" +
                "  \"model\": \"" + MODEL + "\",\n" +
                "  \"messages\": [\n" +
                "    {\"role\": \"system\", \"content\": \"You are a helpful assistant.\"},\n" +
                "    {\"role\": \"user\",   \"content\": \"用100字解释什么是RESTful\"}\n" +
                "  ],\n" +
                "  \"temperature\": 0.7,\n" +
                "  \"stream\": false\n" +
                "}\n";

        HttpClient http = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(ENDPOINT))
                .header("Authorization", "Bearer " + API_KEY)
                .header("Content-Type", "application/json")
                .timeout(Duration.ofSeconds(30))
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> resp = http.send(request, HttpResponse.BodyHandlers.ofString());

        if (resp.statusCode() / 100 != 2) {
            throw new RuntimeException("调用失败, status=" + resp.statusCode() + ", body=" + resp.body());
        }

        // 解析 JSON，提取模型输出
        JsonNode root = MAPPER.readTree(resp.body());
        // 常见结构：choices[0].message.content（不同厂商略有差异）
        String content = root.path("choices").path(0).path("message").path("content").asText("");
        System.out.println("LLM 回复：\n" + content);
    }
}
```

---

## 4. 流式输出（Server-Sent Events, SSE）

当 `stream=true` 时，服务端会按“事件流”逐步推送增量内容。Java 需逐行读取并拼接：

```java
// 伪代码：构建请求时把 stream 设为 true，然后按行读取响应体
// 具体字段如 data: {"choices":[{"delta":{"content":"..."}}]} 根据厂商文档解析
HttpResponse<InputStream> resp = http.send(request, HttpResponse.BodyHandlers.ofInputStream());
try (BufferedReader reader = new BufferedReader(new InputStreamReader(resp.body()))) {
    String line;
    StringBuilder sb = new StringBuilder();
    while ((line = reader.readLine()) != null) {
        if (line.startsWith("data:")) {
            String json = line.substring(5).trim();
            if ("[DONE]".equals(json)) break;
            JsonNode node = MAPPER.readTree(json);
            String delta = node.path("choices").path(0).path("delta").path("content").asText("");
            System.out.print(delta); // 边到边打印
            sb.append(delta);
        }
    }
}
```

!!! tip "何时使用流式？"
    - 需要“边生成边展示”的聊天体验或长文本生成时更友好。
    - 复杂接口调试更困难，建议先在非流式模式下把请求结构跑通再切换。

---

## 5. 错误处理与重试

- 客户端错误（4xx）：
  - 401/403：检查 Key 是否正确、是否过期，或是否放在了 `Authorization: Bearer {key}`。
  - 400：请求体字段不合法（model 不存在、messages 结构错误）。
- 服务端错误（5xx）：
  - 实现指数退避重试（如 500/502/503/504）。
  - 在业务上设置幂等保障，避免重复扣费或重复写入。
- 超时与取消：
  - 为 `HttpRequest`/`HttpClient` 设置合理 `timeout`，在控制器层提供取消/超时兜底。

示例：简单的重试包装（伪代码）

```java
String callWithRetry(Supplier<String> caller) {
    int max = 3; long backoff = 500; // ms
    for (int i = 1; ; i++) {
        try { return caller.get(); }
        catch (Exception e) {
            if (i >= max) throw e;
            try { Thread.sleep(backoff); } catch (InterruptedException ignored) {}
            backoff *= 2;
        }
    }
}
```

---

## 6. 最佳实践清单（面向课程项目）

- Key 安全：使用环境变量或配置中心；永不写死在仓库。
- 配置化：把 `endpoint`、`model`、`timeout`、`temperature`、是否 `stream` 等做成配置项。
- 统一封装：抽象 `AIClient`/`LLMService`，在 Controller 中只处理业务输入输出。
- 监控与限流：记录调用耗时与错误码，必要时做调用频率限制。
- 响应解析：定义 DTO，使用 `Jackson` 绑定而非“手搓字符串”。
- 单元测试：对解析逻辑、重试逻辑、超时逻辑做可控的单测（可用 MockWebServer）。

---

## 7. 练习与思考

1) 把上面的非流式示例改造成方法 `String ask(String prompt)` 并支持传入 `temperature`。  
2) 在 `stream=true` 模式下，封装一个回调 `onDelta(String delta)` 以便前端逐步渲染。  
3) 设计一个“AI 旅行助手”接口：输入目的地与天数，输出 JSON 行程，要求校验字段完整性并给出报错提示。

---

参考链接：请以实际厂商文档为准（端点、字段、返回结构可能更新）。
