---
title: 实验 5：为“智能图书交易系统”开发 AI 客服
---

# 实验 5：为“智能图书交易系统”开发 AI 客服

!!! abstract "实验信息"
    * **实验学时**：4 学时
    * **实验类型**：综合性
    * **截稿时间**：第XX 周周X XX:XX
    * **核心目标**：集成 **Spring AI** 框架，利用 **Function Calling (工具调用)** 技术，让 AI 大模型能够连接本地业务数据，实现一个“查库存、查订单”的智能客服。

---

## 🧪 实验目的

1.  **框架升级**：从传统的 CRUD 开发升级为 **AI Native** 开发，掌握 Spring AI 的核心用法。
2.  **工具调用**：理解并实践 **Tool/Function Calling**，让 AI 拥有“双手”。
3.  **场景落地**：解决大模型“幻觉”问题，让 AI 基于事实数据回答业务问题（如库存、订单状态）。

---

## 📋 实验前准备

* [x] 已完成 [实验 4](lab4.md)（项目环境正常运行）。
* [x] 持有 **ModelScope (魔搭社区)** 的 API Key。
* [x] 了解 Spring AI 的基本使用。

---

## 👣 实验步骤

### 任务一：引入 Spring AI 依赖

我们需要在现有的 `pom.xml` 中添加 Spring AI 的支持。

1.  **添加 BOM (版本管理)**：在 `<dependencyManagement>` 中添加。
2.  **添加 Starter**：在 `<dependencies>` 中添加。

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.ai</groupId>
            <artifactId>spring-ai-bom</artifactId>
            <version>1.0.0</version> <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<dependencies>
    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>
</dependencies>

```

!!! tip "Maven 刷新"
    修改完 `pom.xml` 后，别忘了点击 IDEA 右上角的 **Maven 刷新图标**，等待依赖下载完成。

### 任务二：配置大模型连接

修改 `src/main/resources/application.properties`，配置 AI 连接信息。

```properties
# === Spring AI 配置 ===
# 1. 你的 ModelScope Token (请去魔搭社区申请)
spring.ai.openai.api-key=sk-xxxxxxxxxxxxxxxxxxxxxxxxx

# 2. 魔塔基础地址 (兼容 OpenAI 协议)
spring.ai.openai.base-url=[https://api-inference.modelscope.cn](https://api-inference.modelscope.cn)

# 3. 指定模型 (智能客服推荐用 Qwen2.5，逻辑能力强)
spring.ai.openai.chat.options.model=Qwen/Qwen2.5-7B-Instruct
spring.ai.openai.chat.options.temperature=0.3

```

### 任务三：编写模拟业务服务 (Mock Service)

为了演示 AI 如何调取数据，我们需要模拟“库存”和“订单”两个业务场景。

在 `edu.wtbu.cs.course.service` 包下新建 `BookStoreService.java`：

```java
package edu.wtbu.cs.course.service;

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

### 任务四：封装 AI 工具 (Tools)

这是最关键的一步。我们需要将 Java 方法通过 `@Tool` 注解暴露给 AI，让它知道这个方法是干什么用的。

在 `edu.wtbu.cs.course.tool` 包（需新建）下新建 `BookTools.java`：

```java
package edu.wtbu.cs.course.tool;

import edu.wtbu.cs.course.service.BookStoreService;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BookTools {

    @Autowired
    private BookStoreService bookStoreService;

    // 工具 1：查书
    // description 非常重要！AI 根据它来决定是否调用此方法
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

### 任务五：编写智能客服控制器

新建 `edu.wtbu.cs.course.controller.AiToolController.java`，将 AI 与前端请求连接起来。

```java
package edu.wtbu.cs.course.controller;

import edu.wtbu.cs.course.tool.BookTools;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AiToolController {

    private final ChatClient chatClient;

    // 构造器注入：Spring AI 自动配置好的 Builder + 我们的工具类
    public AiController(ChatClient.Builder builder, BookTools bookTools) {
        this.chatClient = builder
                .defaultSystem("你是一个'智能图书交易系统'的专业客服。请用亲切、专业的语气回答用户的问题。如果用户询问数据，请调用工具查询。")
                .defaultTools(bookTools) // 👈 关键：挂载工具箱
                .build();
    }

    @GetMapping("/ai/chat")
    public String chat(@RequestParam String question) {
        return chatClient.prompt()
                .user(question)
                .call()
                .content();
    }
}

```

---

## 💾 作业提交

### 1. 验证截图

请在 `LAB5_README.md` 中附上以下 **3 张截图**，证明 AI 成功调用了你的 Java 代码：

1. **库存查询**：
* 浏览器访问：`http://localhost:8080/ai/chat?question=我想买本《三体》，请问现在有货吗？`
* 截图要求：浏览器显示 AI 回复“缺货补货中”，且 IDEA 控制台打印出 `📚 [数据库调用]...` 日志。


2. **订单查询**：
* 浏览器访问：`http://localhost:8080/ai/chat?question=帮我查下我的订单 ORDER-2026001 到哪了？`
* 截图要求：浏览器显示 AI 回复物流单号，且 IDEA 控制台打印出 `📦 [数据库调用]...` 日志。


3. **普通闲聊**：
* 浏览器访问：`http://localhost:8080/ai/chat?question=给我讲个程序员的笑话`
* 截图要求：AI 正常回复笑话，**控制台不应有数据库调用日志**（证明 AI 判断出不需要调用工具）。



### 2. 代码推送

```bash
git add .
git commit -m "feat: lab5 完成AI客服开发，学号+姓名"
git push

```

---

## ❓ 常见问题 (FAQ)

**Q1: 启动报错 `Access Denied` 或 `401 Unauthorized`？**

> **A:** 检查 `application.properties` 中的 `api-key` 是否正确，或者 Token 是否已过期。

**Q2: AI 回答了问题，但没有调用我的 Java 方法？**

> **A:**
> 1. 检查 `BookTools` 类上是否有 `@Component` 注解。
> 2. 检查方法上是否有 `@Tool` 注解，且 `description` 描述是否清晰。
> 3. 检查 `AiController` 中是否调用了 `.defaultTools(bookTools)`。
> 
> 

**Q3: 报错 `Bean definition not found`？**

> **A:** 确保所有新增的类（Service, Tool, Controller）都在启动类 `CourseDemoApplication` 所在的包或子包下。
