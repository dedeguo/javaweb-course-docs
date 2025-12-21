---
title: Request / Response
---

# Request / Response：你写接口时到底收到了什么、又返回了什么

本节不追求写出复杂 Servlet 项目，而是把 **Request/Response 的底层概念**讲清楚：后面你用 Spring Boot 写 Controller 时，本质上仍然在处理它们。

---

## 1. Request 里有什么（最常用 4 类信息）

### 1.1 请求参数（Query / Form）

- Query：`/api/flights?from=WUH&to=PEK`
- Form：表单提交（`application/x-www-form-urlencoded`）

### 1.2 请求头（Headers）

常见有：

- `Content-Type`：请求体格式（JSON/表单）
- `Accept`：客户端希望返回的格式
- `Cookie`：会话标识（与 Session 相关）

### 1.3 请求体（Body）

常见为 JSON：

```json
{"from":"WUH","to":"PEK"}
```

### 1.4 请求路径与方法

- 方法：GET/POST/PUT/DELETE
- 路径：`/api/flights`

---

## 2. Response 要做什么（让客户端“看得懂”）

后端响应的核心是三件事：

1. **状态码**：告诉客户端成功/失败
2. **响应头**：告诉客户端返回的数据类型（`Content-Type`）
3. **响应体**：返回数据（通常是 JSON）

---

## 3. Servlet 视角（理解用，不要求记细节）

在 Servlet 规范中：

- `HttpServletRequest`：读取请求
- `HttpServletResponse`：写入响应

=== "读取参数/请求头"
    ```java
    String from = request.getParameter("from");
    String userAgent = request.getHeader("User-Agent");
    ```

=== "写入 JSON（示意）"
    ```java
    response.setContentType("application/json;charset=UTF-8");
    response.getWriter().write("{\"code\":0,\"message\":\"ok\"}");
    ```

!!! warning "本章不要陷入“手写一堆 Servlet”"
    你要掌握的是：Request/Response 里有什么、怎么读、怎么回；复杂工程结构交给第 3 章的 Spring Boot。

---

## 4. Spring Boot 视角（你以后真正写的样子）

Spring MVC 会帮你做两件事：

- 把 HTTP 请求映射到方法（`@GetMapping/@PostMapping`）
- 把返回值自动序列化为 JSON（Jackson）

```java
@GetMapping("/api/ping")
public Map<String, Object> ping() {
    return Map.of("code", 0, "message", "ok");
}
```

---

## 5. 常见问题（课堂高频）

### 5.1 中文乱码

优先检查：

- 响应是否声明了 `charset=UTF-8`
- 客户端发送的 `Content-Type` 是否正确

### 5.2 400 / JSON 解析失败

优先检查：

- Body 是否是合法 JSON（括号、引号、逗号）
- `Content-Type` 是否为 `application/json`

---

[下一节：Cookie 与 Session（解决登录状态）](session.md){ .md-button .md-button--primary }
