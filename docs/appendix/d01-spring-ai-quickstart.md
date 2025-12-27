# 附录 A：Spring AI 框架尝鲜 - 01. 快速接入 OpenAI

!!! quote "🚀 本节目标：从“手搓 HTTP”到“框架自动化”"
在第 5 章中，我们为了让 Java 和 AI 对话，写了 `RestClient`，拼了 JSON 字符串，还自己处理了解析。这就像用 JDBC 手写 SQL。

```
现在，欢迎来到 **Spring AI** 的世界。它就像 **MyBatis/Hibernate**，帮我们封装了一切底层细节。

我们将演示如何**不改一行 Java 代码**，只改配置文件，就能切换不同的 AI 模型（OpenAI, DeepSeek, Qwen）。

```

---

## 📦 第一步：引入依赖 (Maven)

Spring AI 目前还在快速迭代中，我们需要引入 **BOM (Bill of Materials)** 来管理版本，并添加 **OpenAI Starter**。

!!! warning "为什么是 OpenAI Starter？"
你可能会问：“老师，我们不是用 ModelScope 吗？为什么要引 OpenAI 的包？”

```
还记得第 5 章说的吗？ModelScope、DeepSeek、Moonshot 等国产大模型，都完美兼容 **OpenAI 接口协议**。
所以，**只要引入 OpenAI Starter，就可以连接几乎所有的国产大模型！**

```

```xml title="pom.xml"
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.ai</groupId>
            <artifactId>spring-ai-bom</artifactId>
            <version>1.0.0-M1</version> <type>pom</type>
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
        <artifactId>spring-ai-openai-spring-boot-starter</artifactId>
    </dependency>
</dependencies>

<repositories>
    <repository>
        <id>spring-milestones</id>
        <name>Spring Milestones</name>
        <url>https://repo.spring.io/milestone</url>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </repository>
</repositories>

```

---

## ⚙️ 第二步：魔法配置 (application.yml)

这是 Spring AI 最迷人的地方。你不需要写 `RestClient`，只需要在配置文件里填空。

我们将配置连接到 **ModelScope** 的免费推理服务。

```yaml title="src/main/resources/application.yml"
spring:
  ai:
    openai:
      # 1. 你的 ModelScope Access Token (去官网复制)
      api-key: sk-xxxxxxxxxxxxxxxxxxxxxxxx
      
      # 2. ModelScope 的兼容接口地址
      base-url: https://api-inference.modelscope.cn 
      
      # 3. 指定模型 (Qwen 或 DeepSeek)
      chat:
        options:
          # 推荐使用通义千问2.5或 DeepSeek-R1
          model: Qwen/Qwen2.5-7B-Instruct
          # model: deepseek-ai/DeepSeek-R1-0528 
          temperature: 0.7

```

---

## 💻 第三步：一行代码调用 (ChatClient)

Spring AI 提供了一个极其优雅的接口：**`ChatClient`**。它支持链式调用（Fluent API），写代码就像说话一样自然。

### 1. 注入与构建

在 Spring Boot 3.2+ 中，我们推荐使用 `ChatClient.Builder` 来构建客户端。

```java title="AiController.java"
@RestController
@RequestMapping("/ai")
public class AiController {

    private final ChatClient chatClient;

    // Spring AI 自动注入 Builder，我们用它构建一个默认的 client
    public AiController(ChatClient.Builder builder) {
        this.chatClient = builder.build();
    }

    /**
     * 最简单的调用：接收字符串，返回字符串
     */
    @GetMapping("/chat")
    public String chat(@RequestParam String msg) {
        // 这一行代码完成了：构建请求 -> 发送 HTTP -> 解析 JSON -> 提取 Content
        return chatClient.prompt()
                .user(msg)
                .call()
                .content();
    }
}

```

### 2. 测试效果

启动项目，访问浏览器：
`http://localhost:8080/ai/chat?msg=给我讲个程序员的笑话`

**响应：**

> “一个程序员去买肉，对老板说：给我来 1000 克肉。老板说：你要 1 公斤？程序员怒道：不！是 1024 克！”

---

## 🌊 第四步：流式输出 (Stream)

在第 5 章，我们只能傻等 AI 生成完所有文字，再一次性返回（Loading 转圈圈）。
现在，用 Spring AI 实现 **“打字机效果”** 只需要改一个词：把 `.call()` 改为 `.stream()`。

```java
    /**
     * 流式调用：像 ChatGPT 一样一个个字往外蹦
     * 返回类型是 Flux<String> (Reactive 响应式流)
     */
    @GetMapping(value = "/stream", produces = "text/event-stream;charset=UTF-8")
    public Flux<String> streamChat(@RequestParam String msg) {
        return chatClient.prompt()
                .user(msg)
                .stream() // 👈 关键点：开启流式模式
                .content();
    }

```

访问这个接口，你会发现浏览器里的文字是一个接一个“吐”出来的，体验瞬间提升！

---

## 📝 总结：Spring AI 到底强在哪？

回顾一下，如果我们用第 5 章的方法实现上述功能，需要做多少事？

| 功能 | 第 5 章 (手动版) | 附录 A (Spring AI 版) |
| --- | --- | --- |
| **配置** | 硬编码 URL 和 Key | `application.yml` 配置 |
| **请求** | 手写 `Map` 拼 JSON Body | `.user("msg")` 自动封装 |
| **解析** | 手写 Jackson 解析 `choices[0]` | `.content()` 自动提取 |
| **切换模型** | 修改代码里的 JSON 字段 | 修改 yaml 里的 `model` 属性 |
| **流式响应** | 极其复杂 (处理 Buffer) | `.stream()` 一键开启 |

这就是**框架**的力量。当然，理解了第 5 章的原理，你才能真正看懂 Spring AI 底层在帮你做什么。

[下一节：简单的 RAG 实现 (让 AI 读懂你的教材)](https://www.google.com/search?q=a2-simple-rag.md){ .md-button .md-button--primary }