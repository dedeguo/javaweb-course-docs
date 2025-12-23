---
title: 实验2：Java Web 核心组件与数据持久化综合实战
---
# 实验 2：Java Web 核心组件与数据持久化实战

!!! abstract "实验信息"
    * **实验学时**：4 学时
    * **实验类型**：综合性
    * **截稿时间**：第XX 周周X XX:XX
    * **核心目标**：脱离内存模拟，实现一个基于 **Servlet + Filter + JDBC (Druid) + MySQL/openGauss** 的真实用户登录系统。

---

## 🧪 实验目的

1.  **数据持久化**：掌握 JDBC 规范，使用 **Druid 连接池** 高效访问数据库。
2.  **核心交互**：熟练处理 **Request** 参数接收与 **Response** 响应跳转。
3.  **状态管理**：利用 **Session** 实现用户登录状态的保持与注销。
4.  **全局管控**：使用 **Filter** 实现全站乱码解决与登录权限拦截。
5.  **AI 赋能**：学会使用 AI 生成标准 SQL 语句及 JDBC 工具类代码。

---

## 📋 实验前准备

* [x] 已完成 [实验 1](../chapter01/lab1.md) 并熟悉 Git 流程。
* [x] 本地数据库 (openGauss/PostgreSQL) 已启动，并能通过 IDEA Database 面板连接。
* [x] 确保 `pom.xml` 中已引入 `druid` 和 `postgresql` 依赖。

---

## 👣 实验步骤

### 任务一：获取任务代码 (Fork & Clone)

1.  **Fork 仓库**：
    * 访问实验种子仓库：[https://gitee.com/javaweb-dev-tech/lab2-login-system](https://gitee.com/javaweb-dev-tech/lab2-login-system)
    * 点击 **「Fork」**，将其复制到你的 Gitee 账号下。
2.  **Clone 到本地**：
    * 将你 Fork 后的仓库 Clone 到 IDEA 中。
    * **注意**：本项目是一个空骨架，只有目录结构，核心代码需要你填充。

### 任务二：AI 辅助数据库设计

**⚡️ AI 结对编程：让 AI 帮你写 SQL**

不要手写建表语句，尝试使用 Prompt 让 AI 生成标准 SQL。

1.  打开 IDEA 侧边栏的 AI 助手（通义灵码/DeepSeek）。
2.  输入以下 Prompt（直接复制）：

    !!! quote "🤖 Prompt (提示词)"
        请帮我生成一段 PostgreSQL/openGauss 的建表 SQL。  
        表名：`t_user`  
        字段要求：  
        1. id: 主键，自增  
        2. username: 用户名，字符串，唯一，非空  
        3. password: 密码，字符串，非空  
        4. nickname: 昵称，字符串  
        
        另外，请生成 2 条插入测试数据的 SQL，其中一条用户名为 admin，密码为 123。

3.  **执行 SQL**：复制 AI 生成的代码，在 IDEA 的 Database Console 中执行，创建表并插入数据。

!!! success "📸 截图 1 (提交物)"
    将数据库表中成功插入数据的界面截图，重命名为 `db_data.png`，放入 `img` 目录。

### 任务三：封装 JDBCUtils 工具类

**⚡️ AI 结对编程：生成通用工具类**

1.  在 `src/main/resources` 下新建 `druid.properties`，填入你的数据库账号密码。
2.  在 `com.example.util` 包下新建 `JDBCUtils` 类。
3.  **使用 AI 生成代码**：
    * 在类中输入注释：`// Prompt: 使用 Alibaba Druid 连接池实现一个 JDBC工具类，包含获取连接、获取DataSource、释放资源的方法，读取 druid.properties 配置`
    * 等待 AI 生成代码并采纳。
4.  **人工审查**：检查 AI 生成的代码是否使用了 `DruidDataSourceFactory`，路径读取是否正确。

### 任务四：实现 DAO 与 Servlet 核心逻辑

此步骤需要你结合课件手动编码（可适当参考 AI，但需理解逻辑）。

1.  **编写 UserDao**：
    * 实现 `User login(String username, String password)` 方法。
    * **要求**：必须使用 `PreparedStatement` 防止 SQL 注入。
2.  **编写 LoginServlet** (`/login`)：
    * 接收表单参数。
    * 调用 DAO 验证。
    * **成功**：存入 Session (`currentUser`) -> 重定向到 `/index.jsp`。
    * **失败**：存入 Request (`msg`) -> 转发回 `/login.jsp`。
3.  **编写 LogoutServlet** (`/logout`)：
    * 销毁 Session -> 重定向回登录页。

> 📸 **截图 2**：在 `LoginServlet` 中使用了 `req.getSession()` 的代码片段截图，重命名为 `session_code.png`。

### 任务五：配置“安保系统” (Filter)

系统现在不安全，任何人都能直接访问 `/index.jsp`。我们需要加把锁。

1.  **创建 AuthFilter**：拦截路径配置为 `/*`。
2.  **编写拦截逻辑**：
    * **放行白名单**：如果请求的是 `/login.jsp`, `/login` (Servlet), 或 `/css/` 资源，直接 `chain.doFilter()`。
    * **检查 Session**：获取 `currentUser`。
    * **判断**：
        * 有人（已登录）-> 放行。
        * 没人（未登录）-> `resp.sendRedirect("/login.jsp")`。

> 📸 **截图 3**：未登录状态下，直接在浏览器地址栏输入 `http://localhost:8080/index.jsp`，被强制跳转回登录页的效果截图（保留浏览器地址栏），重命名为 `filter_test.png`。

---

## 🚀 挑战任务 (Optional - 加分项)

如果你基础较好，请尝试完成以下任意一项挑战，并在 README 中注明：

* **挑战 A：密码加密 (Security)**
    * **痛点**：数据库存明文密码是违规的。
    * **任务**：在注册或预设数据时，使用 `MD5` 或 `BCrypt` 对密码加密。登录时，将输入的密码加密后再与数据库比对。
* **挑战 B：记住我 (Cookie)**
    * **痛点**：每次关浏览器都要重登。
    * **任务**：登录成功时，创建一个存活 7 天的 Cookie 存储用户名。再次访问登录页时，自动回填用户名。
* **挑战 C：跨域支持 (CORS Filter)**
    * **任务**：新建一个 `CorsFilter`，允许前端（如 Vue/React）跨域调用你的接口。

---

## 💾 作业提交

### 1. 完善 README

打开 `README.md`，填写个人信息，并**用一句话总结**：

* JDBC 中 `PreparedStatement` 相比 `Statement` 最大的优势是什么？  
* 在本项目中，`Filter` 起到了什么作用？

### 2. Git Push

```bash
git add .
git commit -m "feat: 完成实验2，实现JDBC登录与Session拦截，学号姓名"
git push

```

### 3. 最终核验

* Gitee 仓库中包含你的完整代码。
* `img` 文件夹下有 `db_data.png`, `session_code.png`, `filter_test.png` 三张截图。

---

## ❓ 常见问题 (FAQ)

**Q: 数据库连接报错 "Connection refused"？**

> **A:** 检查 `druid.properties` 里的 url 端口是否正确（openGauss 默认可能是 5432 或 26000），以及数据库服务是否已启动。

**Q: 页面中文乱码？**

> **A:** 检查是否创建了 `EncodingFilter` 并强制设置了 `UTF-8`。

**Q: 登录成功了，但是 Session 里取不到值？**

> **A:** 检查 `LoginServlet` 里存 Key 的名字（如 `"user"`）和 `index.jsp` 里取 Key 的名字是否完全一致（大小写敏感）。
