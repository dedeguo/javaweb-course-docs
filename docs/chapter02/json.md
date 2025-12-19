---
title: JSON 与数据交互
---

# JSON 与数据交互：让前端与 AI “听得懂”你的接口

在前后端分离、以及 AI 工具调用（Tool Calling）场景下，后端最常返回的数据格式就是 **JSON**。

---

## 1. JSON 是什么（够用版）

JSON（JavaScript Object Notation）是一种轻量、易读的文本数据格式：

- 对象（Object）：`{}`，由键值对组成
- 数组（Array）：`[]`，由多个元素组成

```json
{
  "id": 1,
  "name": "WUH -> PEK",
  "price": 680,
  "tags": ["direct", "morning"]
}
```

---

## 2. 两个关键词：序列化 / 反序列化

- **序列化（Serialization）**：Java 对象 → JSON 字符串（发出去）
- **反序列化（Deserialization）**：JSON 字符串 → Java 对象（接进来）

---

## 3. Jackson（Spring Boot 默认内置）

Spring Boot 默认使用 Jackson 完成 JSON 转换。你需要知道两件事：

1. Controller 返回对象 → Spring 自动转 JSON
2. 请求 Body 是 JSON → Spring 自动转 Java 对象（第 3 章会系统讲）

### ObjectMapper 示例（理解用，不强制记）

```java
ObjectMapper mapper = new ObjectMapper();

// Java -> JSON
String json = mapper.writeValueAsString(Map.of("code", 0, "message", "ok"));

// JSON -> Java
Map<?, ?> data = mapper.readValue(json, Map.class);
```

---

## 4. 统一返回结构（建议从现在就养成习惯）

下面是一种常见的返回结构（示意）：

```json
{
  "code": 0,
  "message": "ok",
  "data": { "userId": 1, "username": "admin" }
}
```

它的价值是：前端/AI 只要统一判断 `code` 就能决定下一步怎么做。

---

## 5. 课堂练习：让 AI 解释 JSON，但你来验收

!!! question "练习"
    把下面提示词发给 AI，并检查它输出的内容是否是合法 JSON（注意引号、逗号、括号）：

    ```text
    请给出“航班查询接口”的 JSON 响应示例，要求包含：航班号、起飞/到达城市、起飞时间、价格、是否直飞。
    再解释每个字段的含义，并给出字段命名建议（驼峰 or 下划线）。
    ```

---

[进入实验2：Session 登录实战](experiment.md){ .md-button .md-button--primary }
