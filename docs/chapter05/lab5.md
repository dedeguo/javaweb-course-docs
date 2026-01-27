---
title: 实验 5：为“智能图书交易系统”开发 AI 客服
---
# 🧪实验 5：为“智能图书交易系统”开发 AI 客服

## 🎯 实验目标

1. **掌握框架**：从“手写 HTTP 调用”升级为使用 **Spring AI** 框架。
2. **业务连接**：使用 `@Tool` 注解，让 AI 客服能够调用后台的 `BookStoreService`。
3. **场景落地**：实现用户在聊天窗口问“《三体》还有货吗？”，AI 自动查库并回复。

## 📜 业务场景

你是“智能图书交易系统”的后端负责人。客服部门每天都要回答大量重复问题：

* “这就书多少钱？”
* “我的订单发货了吗？”

你决定利用 ModelScope 的大模型 + Spring AI，开发一个**7x24小时智能客服**，自动拦截这些基础查询请求。

---

## 🛠️ 步骤 1：引入依赖 (pom.xml)

保持与之前一致，确保引入了 Spring AI 的 BOM 和 OpenAI Starter。

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

---

## ⚙️ 步骤 2：配置 application.properties

```properties
spring.application.name=smart-book-system

# 1. 你的 ModelScope Token
spring.ai.openai.api-key=填入你的_ModelScope_Access_Token

# 2. 魔塔基础地址
spring.ai.openai.base-url=https://api-inference.modelscope.cn

# 3. 指定模型 (智能客服推荐用 Qwen2.5，逻辑能力强)
spring.ai.openai.chat.options.model=Qwen/Qwen2.5-7B-Instruct
spring.ai.openai.chat.options.temperature=0.3

```

---

## 🧠 步骤 3：编写业务服务 (Service)

我们要模拟两个核心业务数据的查询：**书籍库**和**订单库**。

新建类 `BookStoreService.java`：

```java
package com.example.demo.service;

import org.springframework.stereotype.Service;
import java.util.Map;

@Service
public class BookStoreService {

    // 1. 模拟书籍数据库 (书名 -> 详情)
    private static final Map<String, String> BOOK_DB = Map.of(
        "Java编程思想", "价格：¥99.00 | 库存：15 本 | 状态：现货",
        "三体", "价格：¥68.00 | 库存：0 本 | 状态：缺货补货中",
        "Spring实战", "价格：¥88.50 | 库存：100+ 本 | 状态：热销中"
    );

    // 2. 模拟订单数据库 (订单号 -> 状态)
    private static final Map<String, String> ORDER_DB = Map.of(
        "ORDER-2026001", "已发货，物流单号：SF12345678",
        "ORDER-2026002", "等待付款",
        "ORDER-2026003", "已取消"
    );

    /**
     * 业务方法1：查询书籍详情
     */
    public String getBookDetails(String bookName) {
        System.out.println("📚 [数据库调用] 正在查询书籍: " + bookName);
        return BOOK_DB.getOrDefault(bookName, "抱歉，系统暂无该书籍的录入信息。");
    }

    /**
     * 业务方法2：查询订单状态
     */
    public String getOrderStatus(String orderId) {
        System.out.println("📦 [数据库调用] 正在查询订单: " + orderId);
        return ORDER_DB.getOrDefault(orderId, "未找到该订单号，请核对后重试。");
    }
}

```

---

## 🔌 步骤 4：封装 AI 工具 (Tools)

将上面的业务方法暴露给 AI。注意 `@Tool` 的 `description` 一定要写清楚，这是 AI 判断何时调用的依据。

新建类 `BookTools.java`：

```java
package edu.wtbu.cs.javaweb.lab3.tool;

import com.example.demo.service.BookStoreService;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BookTools {

    @Autowired
    private BookStoreService bookStoreService;

    // 工具 1：查书
    @Tool(description = "根据书籍名称查询价格、库存和销售状态。参数是书名。")
    public String queryBook(String bookName) {
        return bookStoreService.getBookDetails(bookName);
    }

    // 工具 2：查订单
    @Tool(description = "根据订单号查询订单的当前状态和物流信息。参数是订单号（通常以 ORDER 开头）。")
    public String queryOrder(String orderId) {
        return bookStoreService.getOrderStatus(orderId);
    }
}

```

---

## 🎮 步骤 5：智能客服接口 (Controller)

新建 `CustomerServiceController.java`：

```java
package com.example.demo.controller;

import com.example.demo.tool.BookTools;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CustomerServiceController {

    private final ChatClient chatClient;

    // 注入 ChatClient.Builder 和我们的 BookTools
    public CustomerServiceController(ChatClient.Builder builder, BookTools bookTools) {
        this.chatClient = builder
                .defaultSystem("你是一个'智能图书交易系统'的专业客服。请用亲切、专业的语气回答用户的问题。如果用户询问数据，请调用工具查询。")
                .defaultTools(bookTools) // 👈 关键：挂载工具箱
                .build();
    }

    @GetMapping("/api/customer-service")
    public String chat(@RequestParam String question) {
        return chatClient.prompt()
                .user(question)
                .call()
                .content();
    }
}

```

---

## ✅ 实验验证 (见证 AI 的逻辑判断)

启动项目，模拟真实用户的提问：

**场景 1：查库存 (AI 应该调用 queryBook)**

* **请求**：`http://localhost:8080/api/customer-service?question=我想买本《三体》，请问现在有货吗？`
* **后台日志**：`📚 [数据库调用] 正在查询书籍: 三体`
* **AI 回复**：
> “您好！经查询，目前《三体》处于**缺货补货中**的状态，暂时无法购买。您可以关注一下后续的到货通知哦~”



**场景 2：查订单 (AI 应该调用 queryOrder)**

* **请求**：`http://localhost:8080/api/customer-service?question=帮我查下我的订单 ORDER-2026001 到哪了？`
* **后台日志**：`📦 [数据库调用] 正在查询订单: ORDER-2026001`
* **AI 回复**：
> “亲，您的订单 ORDER-2026001 状态为**已发货**，物流单号是 SF12345678，请您注意查收。”



**场景 3：混合/闲聊 (AI 不调用工具)**

* **请求**：`http://localhost:8080/api/customer-service?question=你好，你们店里卖咖啡吗？`
* **后台日志**：(无日志，未调用工具)
* **AI 回复**：
> “您好！我们是专业的图书交易平台，主要销售各类书籍，暂时不卖咖啡哦。如果您有想买的书，我可以帮您查询库存。”



---

## 🧩 进阶挑战 (课后作业)

在“智能图书交易系统”中，还有一个常见功能是 **“书籍推荐”**。

**挑战任务**：

1. 在 Service 中增加一个方法 `recommendBooks(String category)`，模拟返回某类别的畅销书列表（例如："计算机类" -> "Java编程思想, 深入理解JVM"）。
2. 在 Tools 中注册这个新工具。
3. **测试提问**：“我是学计算机的新手，有什么书推荐吗？”
4. 观察 AI 是否能提取出“计算机”这个关键词，并调用工具返回推荐列表。