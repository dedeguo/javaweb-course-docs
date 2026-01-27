---
title: 简化开发：拥抱Spring AI框架
---

# 05. 框架篇：拥抱 Spring AI (简化开发)

!!! quote "从造轮子到用轮子"
    在上一节（04），我们为了实现 Tool Calling，手写了 HTTP 请求、手写了 JSON Schema 字符串、手写了 JSON 解析逻辑……写得是不是有点心累？
    
    今天，我们介绍 Spring 官方出品的 **Spring AI** 框架。它就像 MyBatis 之于 JDBC，帮我们封装了所有繁琐的底层细节，并且我们将使用国内开源的 **ModelScope (魔塔社区)** 作为我们的 AI 算力来源。

---

## 1. 为什么要用 Spring AI？

让我们看看 **“手写版”** vs **“Spring AI 版”** 的代码对比：

### 🆚 对比：调用 AI

* **手写版 (HTTP Client)**：
```java
// 1. 构建 JSON 字符串 (容易拼错)
String jsonBody = "{\"model\":\"Qwen/Qwen2.5-7B-Instruct\", \"messages\":[...]}";
// 2. 发送 POST 请求
HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).POST(...).build();
// 3. 解析响应 JSON (痛苦面具)
JsonNode response = objectMapper.readTree(body);
String content = response.get("choices").get(0).get("message").get("content").asText();

```


* **Spring AI 版**：
```java
// 只需要一行代码！
String content = chatClient.prompt("讲个笑话").call().content();

```

---

## 2. 快速接入 ModelScope (魔塔社区)

Spring AI 目前已经发布了正式版本，我们需要引入 **BOM (Bill of Materials)** 来管理版本，并添加 **OpenAI Starter**。

!!! warning "为什么是 OpenAI Starter？"
    你可能会问：“老师，我们不是用 ModelScope 吗？为什么要引 OpenAI 的包？”
    
    还记得第 5 章说的吗？ModelScope、DeepSeek、Moonshot 等国产大模型，都完美兼容 **OpenAI 接口协议**。
    所以，**只要引入 OpenAI Starter，就可以连接几乎所有的国产大模型！**


### 第一步：引入依赖 (Maven)

注意：这里我们使用最新的 **1.0.0** 版本，它已发布到 Maven 中央仓库，无需配置额外的 `<repositories>`。

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.ai</groupId>
            <artifactId>spring-ai-bom</artifactId>
            <version>1.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>
</dependencies>
```

### 第二步：魔法配置 (application.yml)

这是最关键的一步。我们不需要写任何 Java 代码来配置 Client，只需要在 `application.properties` 中填空。

!!! tip "ModelScope 配置指南"
    * **Base URL**: 使用魔塔免费推理接口 `https://api-inference.modelscope.cn`。
    * **Model**: 推荐使用通义千问 `Qwen/Qwen2.5-7B-Instruct`，它在魔塔上表现稳定且支持工具调用。

```properties
# 1. 你的 ModelScope Access Token (去魔塔官网个人中心免费获取)
spring.ai.openai.api-key= 填入你的_ModelScope_Access_Token 

# 2. 魔塔的兼容接口地址
spring.ai.openai.base-url=https://api-inference.modelscope.cn

# 3. 指定模型 (使用通义千问开源版)
spring.ai.openai.chat.options.model=Qwen/Qwen2.5-7B-Instruct
spring.ai.openai.chat.options.temperature=0.7
```

---

## 3. 核心功能实战

Spring AI 提供了一个极其优雅的接口：**`ChatClient`**。

### 💻 功能一：简单对话

在 Controller 中注入 `ChatClient.Builder`。

```java
@RestController
@RequestMapping("/ai")
public class AiController {

    private final ChatClient chatClient;

    public AiController(ChatClient.Builder builder) {
        // 构建一个默认的 Client，Spring AI 会自动读取 application.properties或application.yml 配置
        this.chatClient = builder.build();
    }

    @GetMapping("/chat")
    public String chat(@RequestParam String msg) {
        return chatClient.prompt()
                .user(msg)
                .call()     // 发起调用
                .content(); // 获取文本内容
    }
}

```

### 🌊 功能二：流式输出 (Stream)

在第 5 章开头，我们只能傻等 AI 生成完。现在，实现 **“打字机效果”** 只需要把 `.call()` 改为 `.stream()`。

```java
    /**
     * 流式调用：返回 Reactive 的 Flux<String>
     */
    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> streamChat(@RequestParam String msg) {
        return chatClient.prompt()
                .user(msg)
                .stream() // 👈 关键点：开启流式模式
                .content();
    }

```

### 🛠️ 功能三：自动 Tool Calling (进阶)

这是最震撼的地方。你不再需要手写 JSON Schema，Spring AI 会自动扫描你的 Java 代码生成工具描述！

**1. 定义工具 (Java Bean)**

直接写一个实现了 BookTools。

```java
import org.springframework.ai.tool.annotation.Tool;

@Slf4j
@Component
public class BookTools {

    @Autowired
    private BookService bookService;

    @Tool(description ="查询图书价格")
    public double queryPriceTool(String bookName){
        log.info("BookTools 查询图书价格：{}",bookName);
        return bookService.queryPrice(bookName);
    }
}

```

**2. 调用工具**

```java

@Slf4j
@SpringBootTest
public class ToolAgentTest {

    @Autowired
    BookTools bookTools;

    @Autowired
    ChatClient.Builder builder;

    @Test
    void testSpringAIToolCalling(){
        ChatClient chatClient = builder.build();
        String content =chatClient
                .prompt("《Java 编程思想》 这本书多少钱？")
                .tools(bookTools)
                .call()
                .content();
        log.info("🤖 AI 回复：" +content);
        //输出示例
        //🤖 AI 回复：《Java 编程思想》这本书的价格是 99.0 元。
    }
}

```


**幕后流程**：
Spring AI 会自动解析 `BookTools` 类中带有 `@Tool` 注解的方法。它会提取方法签名（参数名 `bookName`、类型 `String`）和注解描述，将其自动转换为 JSON Schema 发送给 ModelScope 的 Qwen 模型。当模型决定调用工具时，Spring AI 会拦截请求，自动映射参数并执行 Java 方法，最后将执行结果回传给模型。
---

## 4. 总结

回顾一下，从第 04 节的手工实现，到本节的 Spring AI 实现：

| 功能 | 手动版 (第 04 节) | Spring AI 版 (本节) |
| --- | --- | --- |
| **配置** | 硬编码 URL 和 Key | `application.yml` 统一管理 |
| **请求** | 手写 Map 拼 JSON | `.user("msg")` 链式调用 |
| **工具定义** | 手写 JSON 字符串 | 注册 Java `@Bean` |
| **流式响应** | 极其复杂 | `.stream()` 一键开启 |

## 🔌 预告：MCP 协议

既然大家都在手写 Tool Calling，每家公司的写法都不一样（OpenAI 一套，Claude 一套），有没有一个**通用标准**？
如果我写好了一个“查天气的工具”，能不能让所有的 AI 直接即插即用，不用每次都写 Schema？

这就是下一节的主角 —— **MCP (Model Context Protocol)**，未来的 AI USB 接口。

[下一节：未来的标准：MCP (Model Context Protocol) 简介](05-mcp-intro.md){ .md-button .md-button--primary }