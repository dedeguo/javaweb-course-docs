---
title: HTTP 协议详解
---

# HTTP 协议详解：看懂报文，才会调试

!!! quote "本节金句"
    你写的每一个后端接口，本质上都是：**接收 HTTP 请求 → 处理 → 返回 HTTP 响应**。

---

## 1. HTTP 是什么（够用版）

HTTP（HyperText Transfer Protocol）是客户端（浏览器/Apifox/手机 App）与服务器之间的通信协议，核心特点有两点：

- **请求-响应**：客户端发起请求，服务器返回响应。
- **无状态**：协议本身“不记得你是谁”，登录状态需要 Cookie/Session 等机制支持（下一节讲）。

---

## 2. 请求报文长什么样

一个 HTTP 请求通常由三部分组成：**请求行 + 请求头 + 请求体（可选）**。

```http
POST /api/login HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Accept: application/json
User-Agent: Mozilla/5.0

{"username":"admin","password":"123"}
```

你需要能快速定位这些信息：

- **方法（Method）**：`GET / POST / PUT / DELETE ...`
- **路径（Path）**：`/api/login`（不含域名与端口）
- **Content-Type**：请求体格式（常见：`application/json`）
- **Body**：请求体内容（JSON/表单）

---

## 3. URL 与参数（常见踩坑）

```text
http://localhost:8080/api/flights?from=WUH&to=PEK&page=1
```

- `/api/flights`：路径
- `from/to/page`：查询参数（Query String）

!!! tip "看到 404，先看路径"
    `404 Not Found` 的第一嫌疑人就是：**路径写错** 或 **后端没有映射到该路径**。

---

## 4. 响应报文长什么样

响应通常由三部分组成：**状态行 + 响应头 + 响应体（可选）**。

```http
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8

{"code":0,"message":"ok","data":{"id":1,"username":"admin"}}
```

### 必会状态码（调试第一入口）

- `200 OK`：成功
- `400 Bad Request`：请求不合法（常见：参数/JSON 格式错误）
- `401 Unauthorized`：未登录/鉴权失败
- `403 Forbidden`：有身份但无权限
- `404 Not Found`：接口不存在/路径不对
- `500 Internal Server Error`：服务端异常（看日志堆栈）

---

## 5. 课堂练习：用 Apifox/Postman “看一眼就懂”

!!! question "练习 1：读一次真实报文"
    用 Apifox/Postman 对任意接口发起请求并截图，要求截图里能看到：
    1) 请求方法与 URL；2) `Content-Type`；3) 状态码；4) 响应体。

!!! question "练习 2：让 AI 生成报文（但你来验收）"
    把下面提示词发给 AI，并检查它输出的报文是否结构完整：

    ```text
    请模拟一个 HTTP POST 请求报文：场景是“用户注册”，Body 使用 JSON，包含 username/password/phone。
    同时模拟一个成功响应与一个失败响应，并解释每一行的含义。
    ```

---

## 6. 小结

- 调试接口先看四件事：**方法、路径、状态码、Content-Type**
- 能读懂请求三件套：**URL + Headers + Body**
- 记住一句话：**接口问题 ≈ HTTP 问题 + 代码日志问题**

[下一节：Request / Response 对象怎么用](request-response.md){ .md-button .md-button--primary }
