---
title: 数据桥梁：JSON 与前后端交互
---
# 🔗 数据桥梁：JSON 与前后端交互

!!! quote "从“各自为政”到“通用语言”"
    如果说 Java 是后端的“方言”，JavaScript 是前端的“母语”，那么 **JSON (JavaScript Object Notation)** 就是 Web 世界的 **“普通话”**。
    
    在前后端分离的架构中，我们不再由后端直接生成 HTML 页面，而是通过 JSON 数据流进行沟通。掌握 JSON，就是掌握了现代 Web 开发的 **“外交礼仪”**。

---

## 📦 什么是 JSON？

JSON 是一种轻量级的数据交换格式。虽然它名字里带有 "JavaScript"，但它其实是**独立于语言**的文本格式。

### 核心语法图解

JSON 的世界非常简单，只有两种基本结构：

=== "🧱 对象 (Object)"
    **“键值对”的集合**。由花括号 `{}` 包裹。

    * **场景**：描述一个具体的实体（如一个学生、一本书）。
    * **规则**：Key 必须是双引号包裹的字符串。

    ```json
    {
      "id": 1001,
      "name": "陈同学",
      "isLeader": true,
      "skills": {             // 嵌套对象
        "lang": "Java",
        "level": "Master"
      }
    }
    ```

=== "🚃 数组 (Array)"
    **“有序”的值列表**。由方括号 `[]` 包裹。

    * **场景**：描述一组数据（如班级名单、购物车列表）。
    * **规则**：元素之间用逗号分隔。

    ```json
    [
      "Spring Boot",
      "Vue.js",
      "MySQL"
    ]
    ```

## 🛠️ 后端军火库：Java 如何处理 JSON？

在 Java 中，我们不仅要会写代码，还要会**选工具**。我们将 Java 对象 (POJO) 转为 JSON 的过程称为 **序列化**，反之称为 **反序列化**。

### 主流工具选型

| 工具 | 厂商/来源 | 特点 | 课程推荐指数 |
| --- | --- | --- | --- |
| **Jackson** | FasterXML | **Spring Boot 默认御用**。功能最强，稳定性最高，国际标准。 | ⭐⭐⭐⭐⭐ (默认) |
| **Fastjson2** | **阿里巴巴** | **国产信创之光**。极致性能，专门针对国内高并发场景优化，API 对中文开发者友好。 | ⭐⭐⭐⭐ (进阶) |
| **Gson** | Google | 简单易用，但在处理复杂泛型时稍显吃力。 | ⭐⭐⭐ |

!!! tip "💡 老师的建议"
    初学者请直接使用 **Jackson**，因为 Spring Boot 已经内置了它，**零配置**即可使用。等到需要追求极致性能时（如处理亿级流量），再考虑切换到国产的 **Fastjson2**。

---

## ⚡ 自动化魔法：Spring Boot 的“隐形转换”

在 Spring Boot 中，你**不需要**手动调用 `json.toString()`。框架通过 `HttpMessageConverter` 机制，帮我们实现了“全自动”交互。

### 场景演示：发送与接收

=== "📤 发送数据 (后端 -> 前端)"
    **核心注解：** `@RestController`

    只要在一个类上加上这个注解，Spring Boot 就会明白：“这个类里所有方法的返回值，都要转成 JSON 给前端，而不是跳转页面。”

    ```java
    @RestController
    public class StudentController {

        @GetMapping("/student/info")
        public Student getStudent() {
            // 你只管返回 Java 对象
            Student stu = new Student(1, "张三", "软件工程");
            
            // Spring Boot 自动帮你转成 JSON：
            // {"id":1, "name":"张三", "major":"软件工程"}
            return stu; 
        }
    }
    ```

=== "📥 接收数据 (前端 -> 后端)"
    **核心注解：** `@RequestBody`

    当用户提交表单数据时，加上这个注解，Spring Boot 会自动把 JSON 字符串“倒进”你的 Java 对象里。

    ```java
    @PostMapping("/student/add")
    // @RequestBody 自动将 JSON 映射为 Student 对象
    public Result addStudent(@RequestBody Student student) {
        
        System.out.println("收到名字：" + student.getName());
        return Result.success("保存成功");
    }
    ```

---

## 🗣️ 前端视角：浏览器怎么说？

虽然我们主修后端，但也必须看懂前端的代码。现代前端（Vue/React）主要通过 **Fetch API** 或 **Axios** 与我们交互。

```javascript
// 1. 序列化：把 JS 对象变成 JSON 字符串
const jsonString = JSON.stringify({ name: "李四" });

// 2. 发送请求
fetch('/student/add', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' }, // 必须告诉后端：我发的是 JSON
    body: jsonString
});

```

---

## 🚧 避坑指南：常见的“翻车”现场

即便有自动转换，新手也常会遇到一些尴尬的情况。请使用以下 **注解 (Annotation)** 来精准控制 JSON 的样式。

### 场景 1：日期变成了“外星文”

> **现象**：数据库里的 `2025-12-20`，传给前端变成了 `1766203200000` (时间戳) 或者 `[2025,12,20]`。

**✅ 解决方案：** 使用 `@JsonFormat` 规范格式。

```java
public class Event {
    // 强制转换为：年-月-日 时:分:秒 (并修正时区)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
}

```

### 场景 2：把密码泄露给了前端

> **现象**：查询用户信息的接口，把 `password` 字段也原封不动地返回给了浏览器，这是重大安全事故！

**✅ 解决方案：** 使用 `@JsonIgnore` 隐藏秘密。

```java
public class User {
    private String username;
    
    @JsonIgnore // 无论何时，这个字段都不会被转成 JSON 发送出去
    private String password;
}

```

---


## 📐 行业规范：统一响应结构

在真实的企业开发中，后端不会直接返回一个裸的 `Student` 对象或 `List` 集合。为了方便前端处理异常和逻辑判断，我们需要给数据穿上一层 **“标准制服”**。

!!! info "建议从现在养成习惯"
无论业务成功还是失败，接口返回的 JSON 结构都应保持一致。这样前端或 AI Agent 只需要判断 `code` 的值，就能知道下一步是弹窗报错还是展示数据。

**标准的 JSON 响应示例：**

```json
{
  "code": 200,          // 状态码：200 表示成功，500 表示系统错误，401 表示未登录
  "message": "操作成功", // 提示信息：用于直接展示给用户看
  "data": {             // 数据载体：真正的数据在这里，可以是对象，也可以是数组
    "userId": 1001,
    "username": "admin",
    "role": "TEACHER"
  },
  "timestamp": 1703123456789
}

```

---
## 💻 课堂实战：AI 辅助接口设计

作为未来的“超级开发者”，你不必从零开始构思 JSON 结构。让我们用 AI 来加速这个过程。

!!! question "练习：设计航班查询接口"
    请打开 **DeepSeek** 或 **Kimi**，发送以下提示词。
    
    **你的任务**：作为“代码审查员”，检查 AI 生成的 JSON 是否合法（重点检查：引号是否闭合、逗号是否正确、字段命名是否规范）。

    **复制以下提示词：**
    ```text
    请按照 RESTful 规范，设计一个“航班查询接口”的 JSON 响应数据示例。

    要求包含以下字段：
    1. 航班号 (flightNo)
    2. 起飞/到达城市 (origin/destination)
    3. 起飞时间 (departureTime)
    4. 票价 (price)
    5. 是否直飞 (isDirect)

    请同时给出每个字段的类型定义建议（如 String, BigDecimal, Boolean），并解释为什么这样命名。
    ```
    
---

## ⚡ 生产力飞跃：从 JSON 到 Java Bean

当你从前端或第三方接口拿到一段复杂的 JSON 数据时，**千万不要手动去写 Java 类**！那既浪费时间又容易写错类型。

请呼叫你的 **“对话型军师” (DeepSeek)** 完成逆向工程。

!!! tip "📋 提问模板 (复制给 AI)"
    **场景**：你拿到了一段 JSON，需要生成对应的 Java POJO 类。

    ```markdown
    我有一段 JSON 数据：
    [这里粘贴你的 JSON 数据...]

    请帮我生成对应的 Java Bean 类（POJO）。

    开发规范要求：
    1. 使用 Lombok 的 @Data 注解简化代码。
    2. 字段名使用驼峰命名法（CamelCase）。
    3. 对于日期时间字段，请自动加上 Jackson 的 @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") 注解。
    4. 如果有嵌套对象，请尽量使用内部类或者独立的类结构清晰展示。
    ```

---

!!! warning "📝 课后作业"
    打开你的 IDEA，完成以下 **AI 辅助编程** 挑战：

    1.  **生成实体**：呼叫 **通义灵码**，生成一个 `Course` 类（建议包含 `courseName`, `credit`, `teacher` 等字段）。
    2.  **编写接口**：编写一个 `CourseController`，实现一个能返回 `List<Course>` 的 GET 接口。
    3.  **验证结果**：启动项目，在浏览器中访问该接口，检查返回的 JSON 数据格式是否正确。

---