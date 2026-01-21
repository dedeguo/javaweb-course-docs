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

     **场景**：描述一本具体的书。  
     **规则**：Key 必须是双引号包裹的字符串。  

    ```json
    {
    "id": 1001,
    "title": "Java编程思想",
    "price": 108.00,
    "isAvailable": true,
    "author": {             // 嵌套对象
      "name": "Bruce Eckel",
      "country": "USA"
      }
    }
    ```

=== "🚃 数组 (Array)"
    **“有序”的值列表**。由方括号 `[]` 包裹。

    **场景**：描述图书的标签列表。  
    **规则**：元素之间用逗号分隔。 

    ```json
     [
       "计算机",
       "编程语言",
       "经典教材"
     ]
    ```

---

## 🛠️ 后端军火库：Java 如何处理 JSON？

在 Java 中，我们不仅要会写代码，还要会**选工具**。我们将 Java 对象 (POJO) 转为 JSON 的过程称为 **序列化**，反之称为 **反序列化**。

### 1. 引入 Jackson (Maven)

**Jackson** 是 Java 界的 JSON 霸主，也是 Spring Boot 默认内置的核心库。现在我们需要手动引入它。

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.15.2</version>
</dependency>

```

### 2. 序列化 (Java -> JSON)

假设后台查到了一本 `Book`，需要发给前端展示。

```java
// 1. 准备数据 (模拟从数据库查出)
Book book = new Book("Java核心技术", 99.00);
book.setAuthor("Horstmann");

// 2. 创建核心转换器 (ObjectMapper 是 Jackson 的核心)
ObjectMapper mapper = new ObjectMapper();

// 3. 转换！
String json = mapper.writeValueAsString(book);

System.out.println(json); 
// 输出结果: {"title":"Java核心技术","price":99.0,"author":"Horstmann"}

```

### 3. 反序列化 (JSON -> Java)

假设前端发来了一个 JSON（例如用户要把书加入购物车），你要把它变回 Java 对象。

```java
String json = "{\"title\":\"算法导论\",\"price\":128.0}";

ObjectMapper mapper = new ObjectMapper();

// 告诉它要把 json 转成哪个类的对象 (Book.class)
Book book = mapper.readValue(json, Book.class);

System.out.println("书名：" + book.getTitle()); // 输出: 算法导论

```

---

## ⚡ 实战：Servlet 中的 JSON 交互

让我们抛弃 Spring Boot 的魔法，看看在 **原生 Servlet** 中如何实现前后端数据交互。

### 场景：返回“热销图书列表”

我们需要做三件事：

1. **设置 Content-Type**：告诉浏览器“我给你的是 JSON，不是 HTML”。
2. **获取输出流**。
3. **写入 JSON 字符串**。

```java
@WebServlet("/api/books/hot")
public class HotBooksServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 1. ✅ 关键：设置响应头，告诉浏览器这是 JSON
        resp.setContentType("application/json;charset=utf-8");
        
        // 2. 准备数据 (模拟 SmartBook 数据库中的热销榜)
        List<Book> list = new ArrayList<>();
        list.add(new Book(101, "深入理解Java虚拟机", 89.0));
        list.add(new Book(102, "高性能MySQL", 79.0));
        
        // 3. 转成 JSON 字符串
        ObjectMapper mapper = new ObjectMapper();
        String jsonString = mapper.writeValueAsString(list);
        
        // 4. 写回浏览器
        resp.getWriter().write(jsonString);
    }
}

```

---

## 🗣️ 前端视角：如何消费 API？

虽然我们主修后端，但也必须看懂前端的代码。现代前端（Vue/React）主要通过 **Fetch API** 与我们交互。

创建一个 `book_list.jsp` 文件：

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<body>
    <h2>📚 SmartBook 热销榜</h2>
    <button onclick="loadBooks()">刷新列表</button>
    <ul id="bookList"></ul>

    <script>
        function loadBooks() {
            // 1. 发起请求
            fetch('/demo/api/books/hot')
                .then(response => response.json()) // 把响应文本转成 JS 对象
                .then(data => {
                    // 2. 拿到数据 (data 是一个数组)，更新页面
                    const ul = document.getElementById("bookList");
                    ul.innerHTML = ""; // 清空旧数据
                    
                    data.forEach(book => {
                        // 动态添加 li 标签
                        const li = document.createElement("li");
                        li.innerText = "《" + book.title + "》 - ￥" + book.price;
                        ul.appendChild(li);
                    });
                });
        }
    </script>
</body>
</html>

```

---

## 🚧 避坑指南：常见的“翻车”现场

手动处理 JSON 时，新手常遇到的坑：

### 场景 1：日期变成了“外星文”

> **现象**：图书的 `publishDate` (出版日期) 是 `Date` 类型，默认转成 JSON 会变成一个长整数（时间戳），如 `16999999999`。

**✅ 解决方案**：让 Jackson 听话。

```java
// 方法一：在字段上加注解 (推荐)
public class Book {
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date publishDate;
}

// 方法二：配置全局 ObjectMapper
mapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd"));

```

### 场景 2：循环引用报错

> **现象**：`Category` (分类) 里有 `List<Book>`，`Book` 里又有 `Category`。转 JSON 时会死循环报错。

**✅ 解决方案**：在其中一端加上 `@JsonIgnore`，让它转换时忽略这个字段。

```java
public class Category {
    private String name;
    
    @JsonIgnore // 转 JSON 时，不要把该分类下的书都带出来，防止死循环
    private List<Book> books;
}

```

---
## 💻 课堂实战：AI 辅助接口设计

作为未来的“超级开发者”，你不必从零开始构思 JSON 结构。让我们用 AI 来加速这个过程。

!!! question "练习：设计“图书详情”接口"
    请打开 **DeepSeek** 或 **Kimi**，发送以下提示词。
    
    **你的任务**：作为“代码审查员”，检查 AI 生成的 JSON 是否合法（重点检查：引号是否闭合、逗号是否正确）。
    
    **复制以下提示词：**
    ```text
    请按照 RESTful 规范，设计一个“图书详情查询接口”的 JSON 响应数据示例。
    背景：二手书交易平台 SmartBook。
    
    要求包含以下字段：
    1. 图书ID (id)
    2. 书名 (title)
    3. 卖家信息 (seller: 包含昵称和信誉分)
    4. 售价 (price)
    5. 图片列表 (images)
    6. 上架时间 (createTime)
    
    请同时给出 Java Bean 的定义建议。
    ```

---

## ⚡ 生产力飞跃：从 JSON 到 Java Bean

当你从前端或第三方接口拿到一段复杂的 JSON 数据时，**千万不要手动去写 Java 类**！那既浪费时间又容易写错类型。

还记得刚才 AI 帮你生成的**“图书详情 JSON”**吗？现在，请呼叫你的 **“对话型军师” (DeepSeek)** 完成逆向工程。

!!! tip "📋 提问模板 (复制给 AI)"
    **场景**：将上一题生成的 JSON 快速转换为 Java 代码。

    ```markdown
    我有一段 SmartBook 的图书详情数据 JSON：
    [这里粘贴你刚才生成的 JSON 数据...]

    请帮我生成对应的 Java Bean 类（POJO）。
    要求使用 Jackson 注解处理日期格式，并使用 Lombok 的 @Data 注解。
    ```
