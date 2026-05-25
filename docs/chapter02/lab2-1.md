# 实验 2-1：基于 Servlet 的用户认证功能实现

!!! abstract "实验信息"
    * **实验学时**：2 学时（实验 2 的前置环节）
    * **实验类型**：验证性 + 设计性
    * **核心目标**：掌握 Servlet 创建、Session 管理、JSON 交互，实现完整的用户注册、登录、信息获取、退出登录功能。

---

## 🧪 实验目的

1. **掌握 Servlet 的创建方法**：能够独立新建 Servlet 类并使用 `@WebServlet` 注解映射路径。
2. **掌握 doPost 方法处理请求**：能够处理 HTTP POST 请求，读取 JSON 请求体。
3. **掌握 Session 的使用**：能够使用 Session 保存和获取用户信息，实现登录态保持。
4. **掌握 JSON 数据处理**：能够使用 Jackson 解析请求 JSON 和返回 JSON 格式响应。
5. **理解前后端数据流**：理解从前端表单提交，到后端处理，再到页面响应的完整流程。

!!! warning "重要说明"
    本实验使用**模拟数据**（内存中的假数据），**不涉及数据库和 JDBC**。目的是让你在引入数据库之前，先专注于 Servlet 和 Session 的核心用法。

---

## 📋 实验前准备

* [x] 已完成 [实验 1](../chapter01/lab1.md)，熟悉 Git Fork/Clone 流程。
* [x] 理解 HTTP 协议基础（[01. HTTP 协议与开发者工具](01-http-protocol.md)）。
* [x] 理解 Servlet 生命周期（[02. Servlet 起步与生命周期](02-servlet-basics.md)）。
* [x] 已安装 Postman（用于 API 接口测试）。

---

## 👣 实验步骤

### 任务一：获取项目模板

1. **下载项目**：
    * 访问实验仓库：[https://gitee.com/javaweb-dev-tech/lab2_1](https://gitee.com/javaweb-dev-tech/lab2_1)
    * 点击 **「克隆/下载」**，下载 ZIP 到本地，或使用 Git Clone 拉取。

2. **打开项目**：
    * 启动 IntelliJ IDEA，选择 `Open`，打开下载的 `lab2_1` 目录。
    * 等待 Maven 依赖下载完成。

3. **项目结构预览**：

    ```
    src/main/java/edu/wtbu/cs/book/
    ├── controller/
    │   ├── LoginServlet.java        ✅ 已完成（参考代码）
    │   ├── RegisterServlet.java     ❌ 待实现
    │   ├── GetUserServlet.java      ❌ 待实现
    │   └── LogoutServlet.java       ❌ 待创建（新建类）
    ├── entity/
    │   └── User.java                ✅ 已完成
    └── util/
        ├── JsonUtils.java           ✅ 已完成
        ├── MD5Utils.java            ✅ 已完成
        └── MockUserStore.java       ✅ 已完成

    src/main/webapp/
    ├── login.html                   ✅ 已完成
    ├── register.html                ✅ 已完成
    ├── home.html                    ✅ 已完成
    └── WEB-INF/
        └── web.xml                  ✅ 已完成
    ```

---

### 任务二：理解示例代码 —— LoginServlet

LoginServlet 是已提供的参考实现，你的第一个任务是**看懂它**。

1. **打开 LoginServlet**（`controller/LoginServlet.java`），借助 AI 理解代码流程。

    !!! quote "🤖 Prompt（提示词）"
        请作为一名 Java Web 资深讲师，帮我逐行解释这段 LoginServlet 代码：
        1. 每一步在做什么？为什么这么做？
        2. `req.setCharacterEncoding("UTF-8")` 和 `resp.setContentType("application/json;charset=UTF-8")` 分别解决什么问题？
        3. 为什么要用 `BufferedReader` 逐行读取，而不是直接用 `req.getParameter()`？
        4. `JsonUtils.parseJson()` 做了什么？
        5. `MD5Utils.md5()` 的作用是什么？

2. **理解 MockUserStore**（`util/MockUserStore.java`）：
    * `static {}` 静态代码块在类加载时执行，初始化模拟用户数据。
    * `Map<String, User>` 用键值对在内存中存储用户，`username` 作为 key。
    * `findByUsername(username)` 从 Map 中查询用户。
    * `addUser(user)` 向 Map 中添加用户。

3. **完成 Session 存储**（LoginServlet 中最后一个 TODO）：

    在 LoginServlet 的第 71-75 行附近，找到以下代码并补全：

    ```java
    // 7. 登录成功 - 存入 Session
    // TODO: 请在此处将用户信息存入 Session

    System.out.println("用户登录成功：" + username);
    ```

    **需要替换为**：

    ```java
    // 7. 登录成功 - 存入 Session
    HttpSession session = req.getSession();
    session.setAttribute("currentUser", user);
    session.setMaxInactiveInterval(30 * 60); // 30分钟超时
    System.out.println("用户登录成功：" + username);
    ```

    !!! tip "Session 核心 API 速记"
        | 方法 | 说明 |
        |------|------|
        | `req.getSession()` | 获取当前 Session，不存在则新建 |
        | `session.setAttribute(key, value)` | 向 Session 存储数据 |
        | `session.getAttribute(key)` | 从 Session 读取数据 |
        | `session.setMaxInactiveInterval(秒)` | 设置超时时间 |
        | `session.invalidate()` | 销毁 Session（退出登录） |

---

### 任务三：实现注册功能 —— RegisterServlet

打开 `RegisterServlet.java`，参照 LoginServlet 的模式，实现以下流程：

**功能要求**：

1. 接收前端 JSON 数据（`username`、`name`、`password`、`email`）
2. 校验参数是否为空
3. 检查用户名是否已存在（调用 `MockUserStore.findByUsername()`）
4. 密码使用 `MD5Utils.md5()` 加密后存入
5. 创建 User 对象，调用 `MockUserStore.addUser()` 添加
6. 返回 JSON 响应（成功/失败）

**参考代码框架**：

```java
@WebServlet(name = "registerServlet", value = "/api/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        // 1. 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        // 2. 读取 JSON 请求体
        Map<String, String> params = readJsonBody(req);
        String username = params.get("username");
        String name = params.get("name");
        String password = params.get("password");
        String email = params.get("email");

        Map<String, Object> result = new HashMap<>();

        // 3. 参数校验
        if (username == null || username.isEmpty() || 
            password == null || password.isEmpty()) {
            result.put("success", false);
            result.put("message", "用户名和密码不能为空");
            resp.getWriter().write(JsonUtils.toJson(result));
            return;
        }

        // 4. 检查用户名是否已存在
        if (MockUserStore.findByUsername(username) != null) {
            result.put("success", false);
            result.put("message", "用户名已存在");
            resp.getWriter().write(JsonUtils.toJson(result));
            return;
        }

        // 5. 创建新用户
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setName(name);
        newUser.setPassword(MD5Utils.md5(password));
        newUser.setEmail(email);
        newUser.setRole("user");
        newUser.setUserType("student");

        // 6. 添加到模拟数据库
        MockUserStore.addUser(newUser);

        result.put("success", true);
        result.put("message", "注册成功");
        resp.getWriter().write(JsonUtils.toJson(result));
    }
}
```

!!! tip "思路启发"
    如果你不确定怎么写，可以把 LoginServlet 的代码和上面的框架一起发给 AI：
    
    !!! quote "🤖 Prompt"
        请参考 LoginServlet 的代码风格和 JsonUtils/MockUserStore 的 API，帮我补全 RegisterServlet 中的 `readJsonBody()` 方法和 `doPost()` 方法的完整实现。

---

### 任务四：实现获取当前用户 —— GetUserServlet

打开 `GetUserServlet.java`，实现登录状态下的用户信息获取：

**功能要求**：

1. 从 Session 中获取 `currentUser` 属性
2. 如果为空（未登录），返回 `{"success": false, "message": "未登录"}`
3. 如果已登录，返回 `{"success": true, "data": {用户信息}}`

**参考实现**：

```java
@WebServlet(name = "getUserServlet", value = "/api/user")
public class GetUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        Map<String, Object> result = new HashMap<>();
        HttpSession session = req.getSession(false); // 不新建 Session

        if (session == null || session.getAttribute("currentUser") == null) {
            result.put("success", false);
            result.put("message", "未登录");
        } else {
            User user = (User) session.getAttribute("currentUser");
            result.put("success", true);
            result.put("data", user);
        }

        resp.getWriter().write(JsonUtils.toJson(result));
    }
}
```

!!! warning "注意"
    `req.getSession(false)` 与 `req.getSession()` 的区别：
    - `getSession()` = 如果没有 Session 就**新建**一个（用于登录）
    - `getSession(false)` = 如果没有 Session 就返回 **null**（用于查询状态）

---

### 任务五：实现退出登录 —— LogoutServlet

**新建** `LogoutServlet.java`（右键 `controller` 包 → `New` → `Java Class`）。

**功能要求**：

1. 获取当前 Session
2. 移除 `currentUser` 属性（或直接销毁 Session）
3. 返回 `{"success": true, "message": "已退出登录"}`

**参考实现**：

```java
@WebServlet(name = "logoutServlet", value = "/api/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate(); // 销毁整个 Session
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "已退出登录");
        resp.getWriter().write(JsonUtils.toJson(result));
    }
}
```

---

### 任务六：接口测试

#### 6.1 启动 Tomcat

1. 在 IDEA 右上角点击 `Add Configuration` → `Tomcat Server` → `Local`。
2. 在 `Deployment` 选项卡中，点击 `+` → `Artifact`，选择 `lab2_1:war exploded`。
3. 设置 `Application context` 为 `/book`。
4. 点击运行。

#### 6.2 Postman 测试

!!! success "📸 截图 1（提交物）"
    以下四个接口的 Postman 测试成功截图，重命名为 `postman_login.png`、`postman_register.png`、`postman_user.png`、`postman_logout.png`。

**测试顺序**：

| 步骤 | 接口 | 方法 | 测试内容 |
|------|------|------|----------|
| 1 | `/api/register` | POST | 注册新用户（Body: JSON），验证返回 `success: true` |
| 2 | `/api/login` | POST | 用刚注册的账号登录，验证返回 `success: true` |
| 3 | `/api/user` | GET | 获取当前用户信息，验证返回用户名和角色 |
| 4 | `/api/logout` | POST | 退出登录，验证返回 `success: true` |
| 5 | `/api/user` | GET | 再次获取用户，验证返回 `未登录` |

**注册接口 Body 示例**：

```json
{
    "username": "test001",
    "name": "张三",
    "password": "123456",
    "email": "zhangsan@example.com"
}
```

**登录接口 Body 示例**：

```json
{
    "username": "test001",
    "password": "123456"
}
```

#### 6.3 浏览器界面测试

!!! success "📸 截图 2（提交物）"
    浏览器测试截图，重命名为 `browser_test.png`。

1. 打开浏览器，访问 `http://localhost:8080/book/login.html`。
2. 用默认账号 `admin / 123456` 登录，验证跳转到 `home.html` 并显示用户名。
3. 点击注册链接，注册新用户后重新登录验证。
4. 点击退出登录，验证返回登录页。

---

## 🚀 挑战任务（Optional - 加分项）

### 挑战 A：Git 提交

将你完成的代码推送到 Gitee 远程仓库。

1. **Fork 仓库**：访问 [https://gitee.com/javaweb-dev-tech/lab2_1](https://gitee.com/javaweb-dev-tech/lab2_1)，点击 **「Fork」**。
2. **关联远程仓库**：
    ```bash
    git remote add myfork https://gitee.com/你的用户名/lab2_1.git
    ```
3. **提交并推送**：
    ```bash
    git add .
    git commit -m "feat: 完成实验2-1，实现用户注册、登录、获取信息、退出功能"
    git push myfork master
    ```

### 挑战 B：密码加密验证

在不查看 `MD5Utils.java` 源码的情况下，自己编写一个 MD5 工具方法并成功用于注册和登录的密码处理流程。

---

## 💾 作业提交

### 提交内容

1. 完整项目代码（包含四个 Servlet 的实现）。
2. 截图文件，放入 `img` 目录：

    | 文件名 | 内容说明 |
    |--------|----------|
    | `postman_login.png` | Postman 登录成功截图 |
    | `postman_register.png` | Postman 注册成功截图 |
    | `postman_user.png` | Postman 获取用户信息截图 |
    | `postman_logout.png` | Postman 退出登录截图 |
    | `browser_test.png` | 浏览器测试截图 |

### 学习通提交

将项目压缩为 ZIP，上传至学习通对应作业入口。

---

## 📚 相关资源

* [实验 2-1 仓库](https://gitee.com/javaweb-dev-tech/lab2_1)（模板工程与完整 README）
* [实验 2-2：Vibe Coding 及 Vibe Learning](https://gitee.com/javaweb-dev-tech/lab2_2)（后续实验：AI 辅助图书管理系统开发）
* [👉 实验 2：核心组件与持久化综合实战](lab2.md)（本章综合大实验）