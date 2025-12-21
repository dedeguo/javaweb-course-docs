---
title: Cookie 与 Session
---

# Cookie 与 Session：HTTP“健忘”，登录状态怎么办？

!!! quote "本节金句"
    HTTP 不记得你是谁，但业务必须记得你是谁 —— 这就是会话机制存在的原因。

---

## 1. 先把关系说清楚

- **Cookie**：浏览器保存的一小段键值对数据，后续请求会自动携带（由浏览器管理）
- **Session**：服务器端保存的一段“会话数据”（由服务器管理）

它们通常配合使用：

1. 登录成功后，服务器创建/获取 Session，并把用户信息放进去
2. 服务器把 Session 的标识（常见：`JSESSIONID`）通过 `Set-Cookie` 发给浏览器
3. 浏览器后续请求自动带上 Cookie
4. 服务器通过 Cookie 找到对应 Session，从而“认出你”

---

## 2. 用一个比喻记住（课堂最推荐）

!!! note "健身房储物柜模型"
    - **Session**：健身房的“储物柜”（柜子里放你的物品=用户信息），由健身房保管  
    - **Cookie（JSESSIONID）**：你手里的“柜子钥匙”（只是一串编号）  
    - 你下次来，出示钥匙 → 健身房找到柜子 → 认出你

---

## 3. 你必须会看的两个 Header

=== "登录成功后（响应）"
    ```http
    HTTP/1.1 200 OK
    Set-Cookie: JSESSIONID=ABCDEF123456; Path=/; HttpOnly
    ```

=== "后续访问（请求）"
    ```http
    GET /api/me HTTP/1.1
    Cookie: JSESSIONID=ABCDEF123456
    ```

---

## 4. Servlet 中怎么用（示意）

=== "登录：写入 Session"
    ```java
    HttpSession session = request.getSession(); // 没有则创建
    session.setAttribute("currentUser", "admin");
    ```

=== "鉴权：读取 Session"
    ```java
    HttpSession session = request.getSession(false); // 没有则返回 null
    if (session == null || session.getAttribute("currentUser") == null) {
        // 未登录
    }
    ```

=== "退出登录：销毁 Session"
    ```java
    HttpSession session = request.getSession(false);
    if (session != null) {
        session.invalidate();
    }
    ```

---

## 5. 课堂常见坑（一定要提醒学生）

### 5.1 Session 里放什么、不放什么

- 适合放：`userId`、用户名等**必要信息**
- 不适合放：大对象、敏感信息（明文密码）、超长列表（占内存）

### 5.2 “我登录了但怎么又掉了？”

常见原因：

- Session 超时（服务器配置）
- 浏览器清理了 Cookie
- 使用了不同浏览器/无痕窗口导致 Cookie 不共享

---

[下一节：JSON 与数据交互](json.md){ .md-button .md-button--primary }
