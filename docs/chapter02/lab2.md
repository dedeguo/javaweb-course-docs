# 实验 2：Java Web 核心组件与数据持久化实战

!!! abstract "实验信息"
* **实验学时**：4 学时
* **实验类型**：综合性
* **截稿时间**：第XX 周周X XX:XX
* **核心目标**：实现一个基于 **Servlet + Filter + JDBC (Druid)** 的完整系统，包含**用户登录**与**用户管理 (CRUD)** 模块。

---

## 🧪 实验目的

1. **数据持久化**：掌握 JDBC 规范，使用 **Druid 连接池** 高效访问数据库。
2. **核心交互**：熟练处理 **Request** 参数接收与 **Response** 响应跳转。
3. **MVC 设计模式**：掌握基于 **Action 分发** 的 Servlet 写法（仿照 BookServlet）。
4. **全局管控**：使用 **Filter** 实现全站乱码解决与登录权限拦截。
5. **AI 赋能**：学会使用 AI 生成标准 SQL 语句及 CRUD 样板代码。

---

## 📋 实验前准备

* [x] 已完成 [实验 1](../chapter01/lab1.md) 并熟悉 Git 流程。
* [x] 本地数据库 (MySQL) 已启动，并能通过 IDEA Database 面板连接。
* [x] 确保 `pom.xml` 中已引入 `druid`、`mysql` 和 `jstl` 依赖。

---

## 👣 实验步骤

### 任务一：获取任务代码 (Fork & Clone)

1. **Fork 仓库**：
* 访问实验种子仓库：[https://gitee.com/javaweb-dev-tech/lab2](https://gitee.com/javaweb-dev-tech/lab2)
* 点击 **「Fork」**，将其复制到你的 Gitee 账号下。


2. **Clone 到本地**：
* 将你 Fork 后的仓库 Clone 到 IDEA 中。



### 任务二：AI 辅助数据库设计

**⚡️ AI 结对编程：让 AI 帮你写 SQL**

不要手写建表语句，尝试使用 Prompt 让 AI 生成标准 SQL。

1. 打开 IDEA 侧边栏的 AI 助手（通义灵码/DeepSeek）。

2. 输入以下 Prompt（直接复制）：

    !!! quote "🤖 Prompt (提示词)"
        请帮我生成一段 MySQL 的建表 SQL。  
        表名：`t_user`  
        字段要求：  
        1. id: 主键，自增  
        2. username: 用户名，字符串，唯一，非空  
        3. password: 密码，字符串，非空  
        4. nickname: 昵称，字符串  
          
        另外，请生成 2 条插入测试数据的 SQL，其中一条用户名为 admin，密码为 123。  

3. **执行 SQL**：复制 AI 生成的代码，在 IDEA 的 Database Console 中执行，创建表并插入数据。

!!! success "📸 截图 1 (提交物)"
    将数据库表中成功插入数据的界面截图，重命名为 `db_init.png`，放入 `img` 目录。

### 任务三：配置连接池与理解 JDBCUtils

**⚡️ AI 助读：从“写代码”到“懂代码”**

本项目已为你预置了标准的 `JDBCUtils` 工具类，你的任务是配置它，并利用 AI 搞懂它的原理和用法。

1.  **配置数据库参数**：
    * 打开 `src/main/resources/druid.properties` 文件。
    * **关键动作**：修改 `url` 中的数据库名为你自己的（例如 `lab2_db`），并填入正确的 `username` 和 `password`。

2.  **AI 代码讲解 (Code Explanation)**：
    * 打开 `edu.wtbu.cs.javaweb.lab2.util.JDBCUtils` 类。
    * **选中所有代码**，向 AI 助手发送以下 Prompt，理解其初始化过程：
    
    !!! quote "🤖 Prompt (提示词)"
        请作为一名 Java 资深架构师，帮我分析这段 JDBCUtils 代码：  
        1. **核心原理**：`static` 静态代码块在什么时候执行？为什么要在这里初始化连接池？  
        2. **关键类**：`DruidDataSourceFactory` 相比传统的 `DriverManager` 有什么优势？  
        3. **用法指导**：如果我要在 `UserDao` 中执行 SQL 查询，应该如何调用这个类？请给出一个简单的调用示例。  

3.  **验证配置**：
    * 在 `src/test/java` 下（或直接在 `JDBCUtils` 中写一个 `main` 方法），调用 `JDBCUtils.getConnection()`。
    * 如果控制台不报错且能打印出连接对象信息，说明配置成功。 


### 任务四：实现登录/注销逻辑 (Login Module)

此步骤是系统的入口。

1.  **编写 UserDao**：
    * 实现 `User login(String username, String password)` 方法。

2.  **编写 LoginServlet** (`/login`)：
    * 接收表单参数 -> 调用 DAO 验证。
    * **成功**：存入 Session (`currentUser`) -> 重定向到 `/user?action=list` (登录后直接进列表页)。
    * **失败**：存入 Request (`msg`) -> 转发回 `/login.jsp`。

3.  **编写 LogoutServlet** (`/logout`)：
    * 销毁 Session -> 重定向回登录页。

### 任务五：实现用户管理 CRUD (User Module) 🌟核心

**目标**：仿照课程 Demo 中的 `BookServlet`，实现对用户的增删改查。  
**执行基础 SQL**：运行图书模块需要导入数据库。在数据库工具（如 DBeaver/Navicat）中运行项目目录下的 sql/book.sql 文件，创建数据库并导入图书示例数据。  
**设计模式**：使用 **Action 分发模式**，即一个 Servlet 处理所有与 User 相关的请求。
URL 示例：`/user?action=list`, `/user?action=add`, `/user?action=delete&id=1`

**⚡️ AI 结对编程：生成 CRUD 代码**

1. **完善 UserDao**：
向 AI 发送指令：
> "请在 UserDao 中补充 findAll(), add(User user), delete(int id), findById(int id), update(User user) 方法，使用 JDBC 操作 t_user 表。"


2.  **创建 UserServlet**：
    向 AI 发送指令（参考 Prompt）：

    !!! quote "🤖 Prompt (提示词)"
        请参考以下 BookServlet 的设计模式，帮我生成一个 UserServlet：

        **模式参考**：
        ```java
        // 伪代码参考
        protected void service(...) {
            String action = req.getParameter("action");
            if("list".equals(action)) list(req, resp);
            else if("add".equals(action)) add(req, resp);
            else if("delete".equals(action)) delete(req, resp);
            // ... 其他方法
        }
        ```

        **要求**：
        
        1.  路径映射为 `/user`。
        2.  实现 `list`, `add`, `delete`, `toEdit`, `update` 五个方法。
        3.  调用 `UserDao` 进行数据操作。
        4.  列表页转发到 `/user_list.jsp`，新增/修改页转发到 `/user_form.jsp`。
> 📸 **截图 2**： AI 生成代码的过程截图, 重命名为 `ai_coding.png `。

3. **编写 JSP 页面**：

    * `user_list.jsp`：使用 JSTL `<c:forEach>` 遍历展示用户列表，包含“删除”和“修改”按钮。
    * `user_form.jsp`：用于新增和修改（可共用），表单提交到 `/user?action=add` 或 `/user?action=update`。

> 📸 **截图 3**：现有图书模块运行截图，重命名为 `book_list.png`。
> 📸 **截图 4**：用户列表页面截图（包含多条数据），重命名为 `user_crud.png`。

### 任务六：配置“安保系统” (Filter)

系统需要加把锁，防止未登录用户直接访问用户管理功能。

1. **创建 AuthFilter**：拦截路径配置为 `/*`。
2. **编写拦截逻辑**：

    * **白名单放行**：`/login.jsp`, `/login`, `/css/`, `/js/`。
    * **检查 Session**：
    * 有 `currentUser` -> 放行。
    * 无 `currentUser` -> 跳转回 `/login.jsp`。

> 📸 **截图 5**：在未登录状态下，直接在地址栏输入 `/user?action=list` 并回车，截图自动跳转回登录页面的效果（若能显示“请先登录”的提示信息更佳），重命名为 `login_filter.png`。

---

## 🚀 挑战任务 (Optional - 加分项)

* **挑战 A：密码加密 (Security)**
* 使用 `MD5` 或 `BCrypt` 对密码加密存储与验证。


* **挑战 B：分页查询 (Pagination)**
* 在 `UserServlet` 的 `list` 方法中实现分页逻辑（LIMIT offset, size）。

---

## 💾 作业提交

### 1. 完善 README

打开 `README.md`，填写个人信息，并**用一句话总结**：

* 为什么在 Servlet 中要使用 `action` 参数进行分发，而不是为每个功能（增删改查）写一个单独的 Servlet？

### 2. Git Push

```bash
git add .
git commit -m "feat: 完成实验2，实现用户管理CRUD与权限拦截"
git push

```

### 3. 最终核验

* Gitee 仓库中包含完整代码。
* `img` 文件夹下有 `db_init.png`, `ai_coding.png`,  `book_list.png.png`，`user_crud.png` 四张截图。