---
title: Java 也就是个“浏览器”：HTTP Client 调用 AI
---
# 01. Java 也就是个“浏览器”：HTTP Client 调用 AI

!!! quote "🎓 本节目标：打破“AI 高不可攀”的错觉"
提到 AI 开发，很多同学脑子里想的是复杂的 Python 算法或显卡燃烧的本地部署。

```
**错！** 作为后端工程师，调用千亿参数的大模型，和你调用一个查询天气的 API **没有任何区别**。

今天我们利用 Spring Boot 3.2 推出的新武器 —— **`RestClient`**，像浏览器一样“访问” AI。

```

---

## 🌍 第一部分：本质透视——HTTP 协议

在这一章，请暂时忘掉你是个程序员，把自己想象成一个**浏览器 (Chrome/Edge)**。

当我们访问 AI 官网时，浏览器做了什么？

1. **打包**：把你输入的问题（"你好"）封装成一个 JSON 数据包。
2. **发送**：通过 HTTP 协议发给 AI 公司的服务器。
3. **等待**：服务器里的 AI 模型进行推理计算。
4. **接收**：服务器把生成的文字发回给浏览器。

**Java 也是一样的！** 我们要写的代码，本质上就是**模拟浏览器**的行为。

---

## 🛠️ 第二部分：新武器 RestClient

在 Spring Boot 3.2 之前，我们通常用 `RestTemplate`（已停止更新，处于维护模式）或 `WebClient`（这就需要引入复杂的响应式编程依赖 WebFlux）。

现在，Spring 官方推出了 **`RestClient`**：

* **同步阻塞**：代码逻辑简单，符合人类直觉（不用写 Mono/Flux）。
* **流式 API**：写起来像造句一样优雅。
* **依赖简单**：只要有 `spring-boot-starter-web` 就能用。

### 0. 引入依赖

确保你的 `pom.xml` 中 Spring Boot 版本在 **3.2.0** 以上。

```xml title="pom.xml"
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>

```

---

## 💻 第三部分：实战——给 AI 发送第一条消息

我们将调用 **ModelScope (魔搭社区)** 上的 **DeepSeek-R1** 模型（免费、且兼容 OpenAI 协议）。

### 1. 准备工作

* **API Key**: 去 [ModelScope](https://modelscope.cn) 个人中心复制 Access Token。
* **API URL**: `https://api-inference.modelscope.cn/v1/chat/completions`
* **模型 ID**: `deepseek-ai/DeepSeek-R1-0528`

### 2. 编写测试代码

在 `src/test/java` 下新建 `AiClientTest.java`。

```java title="AiClientTest.java"
package com.example.demo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestClient;

@SpringBootTest
public class AiClientTest {

    // ✅ 1. 配置参数 (真实项目中请放入 application.yml)
    private static final String API_KEY = "sk-你的Token粘贴在这里";
    private static final String API_URL = "https://api-inference.modelscope.cn/v1/chat/completions";
    
    @Test
    void testChatWithAI() {
        // ==========================================
        // 第一步：构建“浏览器” (RestClient)
        // ==========================================
        RestClient client = RestClient.builder()
                .baseUrl(API_URL)
                .defaultHeader("Authorization", "Bearer " + API_KEY) // 统一带上身份证
                .build();

        // ==========================================
        // 第二步：准备“信件内容” (JSON)
        // ==========================================
        // ModelScope/OpenAI 的标准请求格式
        String jsonBody = """
            {
                "model": "deepseek-ai/DeepSeek-R1-0528",
                "messages": [
                    {"role": "user", "content": "请用一句话解释什么是递归？"}
                ]
            }
            """;

        System.out.println("🤖 正在发送请求给 DeepSeek-R1...");

        // ==========================================
        // 第三步：发送 POST 请求并接收响应
        // ==========================================
        String response = client.post()
                .contentType(MediaType.APPLICATION_JSON) // 告诉服务器我发的是 JSON
                .body(jsonBody)                          // 塞入内容
                .retrieve()                              // 发起请求！
                .body(String.class);                     // 把结果转成 String

        // ==========================================
        // 第四步：打印结果
        // ==========================================
        System.out.println("✅ AI 回复:");
        System.out.println(response);
    }
}

```

### 3. 运行观察

运行单元测试，你会看到类似下面的 JSON 结果。
由于使用的是 **R1 (推理模型)**，你可能会在结果中看到 `<think>` 标签，这是模型在展示它的思维链（Chain of Thought）。

```json
{
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "<think>用户问的是递归的定义...我要找一个形象的比喻...</think>递归就是：在函数的定义中使用函数自身的方法。" 
      },
      "finish_reason": "stop"
    }
  ],
  "model": "deepseek-ai/DeepSeek-R1-0528",
  ...
}

```

---

## 🔍 第四部分：痛点分析

代码跑通了，但你发现了一个**大问题**了吗？

**Java 控制台打印出来的是一堆乱七八糟的 JSON 字符串！**

```json
{"choices":[{"message":{"content":"..."}}]}

```

作为程序员，我们想要的是 `递归就是...` 这几个清清爽爽的汉字，而不是这堆带括号、引号的“符号”。
而且，我们在代码里硬编码 `String jsonBody = """..."""` 也非常丑陋，万一我要动态替换问题怎么办？

这就引出了下一节的主角：

1. **JSON 解析**：如何把那一坨 JSON 自动转成 Java 对象？
2. **Prompt 模板**：如何优雅地把 `String` 拼接成 Prompt？

---

## 📝 总结

1. **工具升级**：我们使用了 Spring Boot 3.2 的 **`RestClient`**，比 JDK 原生 HttpClient 写法更简洁，且天然集成 Spring 生态。
2. **本质**：无论 AI 多强大，对后端来说，它就是一个 **POST 接口**。
3. **模型**：DeepSeek-R1 是国产强大的推理模型，通过 ModelScope 我们可以免费调用。

[下一节：提示词工程与 Java 模板](02-prompt-java.md){ .md-button .md-button--primary }