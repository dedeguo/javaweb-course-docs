# 实验 2-2：Vibe Coding 及 Vibe Learning —— 基于 AI 辅助的图书管理系统开发

!!! abstract "实验信息"
    * **实验学时**：2 学时
    * **实验类型**：验证性 + 设计性
    * **核心目标**：使用 Trae AI IDE，通过 Vibe Learning（AI 引导学习）+ Vibe Coding（AI 辅助编码）双模式，完成一个完整的**校园图书管理系统**后端开发。

---

## 🧪 实验目的

1. **Vibe Learning**：利用 Trae AI IDE 学习 JDBC、数据库连接池、Servlet 等 Java Web 核心技术，掌握"AI 引导 + 自己编码"的高效学习模式。
2. **Vibe Coding**：通过 AI 辅助完成一个完整的后端系统开发，理解 MVC 架构、分层设计（Controller / Service / DAO）、RESTful API 设计等工程实践。
3. **Agent Skill 概念**：了解和使用 AI Agent 的 Skill 配置，为后续使用更强大的 AI 编程工具打下基础。
4. **接口测试**：掌握 Postman 接口测试方法，理解前后端分离开发中的联调流程。
5. **业务建模**：理解图书管理系统的借阅业务规则，实现完整的业务逻辑闭环。

---

## 📋 实验前准备

* [x] 已完成 [实验 2-1](lab2-1.md)，掌握 Servlet 创建与 Session 管理等基础技能。
* [x] 已安装 [Trae AI IDE](https://www.trae.cn/) 并登录账号。
* [x] 已安装 Postman（用于 API 接口测试）。
* [x] 本地 MySQL 已启动并创建数据库 `book_management`（或使用实验提供的远程数据库）。
* [x] Java 和 Maven 命令行可直接调用（验证：`java -version`、`mvn -version`）。

---

## 🗺️ 项目结构预览

```
lab2_2/
├── vibe_learning/                             # 模块 1：Vibe Learning 学习环境
│   ├── .trae/skills/                          # 预置的 AI Agent Skills
│   │   ├── ai-assisted-jdbc-learning/          # JDBC 学习引导 Skill（8 步结构化工作流）
│   │   └── frontend-design/                    # 前端 UI 设计 Skill
│   ├── src/main/java/                          # 学生练习代码目录
│   └── pom.xml
│
├── book_template/                              # 模块 2：图书管理系统模板工程
│   ├── src/main/java/                          # 后端 Java 代码（学生在此开发）
│   ├── src/main/webapp/                        # 前端页面（已提供，无需修改）
│   │   ├── user/                               # 用户端页面
│   │   ├── admin/                              # 管理员端页面
│   │   └── js/common.js                        # 公共 API 工具模块（Fetch API）
│   ├── src/main/resources/db.properties        # 数据库配置文件
│   ├── doc/ui界面设计/                          # UI 设计参考图
│   ├── API.md                                  # API 接口文档（重要）
│   ├── 项目需求及设计文档.md                     # 完整的需求和设计说明（重要）
│   ├── A-校园图书管理系统.postman_collection.json # Postman 测试集合
│   └── pom.xml
│
└── README.md
```

---

## 👣 实验步骤

---

### 模块 1：Vibe Learning —— AI 引导学习 JDBC 与 Servlet

#### 任务一：配置 Agent Skill

**什么是 Agent Skill？**

Agent Skill 是 AI 编程助手的可复用能力模块。每个 Skill 定义一个 `SKILL.md` 文件，描述 AI 在特定场景下的行为模式。配置完成后，只需简短指令即可触发专业工作流。

**实验已预置的 Skill**：

| Skill 名称 | 文件 | 用途 |
|-----------|------|------|
| AI 辅助 JDBC 学习 | `ai-assisted-jdbc-learning/SKILL.md` | 8 步结构化工作流引导学习 Java Web 开发 |
| 前端 UI 设计 | `ui-ux-pro-max/SKILL.md` | 生成高质量、独特风格的前端界面 |

**验证步骤**：

1. 用 Trae AI IDE 打开 `vibe_learning` 目录。
2. 在 Trae 的 AI 对话框中输入 `/skills`（或对应指令）查看 Skill 列表。
3. 确认上述两个 Skill 已正确加载。

!!! success "📸 截图 1（提交物）"
    Trae 中 Skill 列表加载成功的截图，重命名为 `skill_loaded.png`。

---

#### 任务二：AI 引导学习 JDBC 与数据库连接池

利用 `ai-assisted-jdbc-learning` Skill，按照 **"概念讲解 → 最小示例 → 代码讲解 → 引导重构 → 代码审核 → 工程化升级 → 练习生成 → 作业审核"** 的 8 步循环完成以下学习路径：

| 步骤 | 学习内容 | 关键 API |
|------|---------|----------|
| 1 | JDBC 基础 | `Connection`、`Statement`、`ResultSet` |
| 2 | PreparedStatement | 参数化查询，防止 SQL 注入 |
| 3 | DAO 模式 | 数据访问对象模式，分离数据库操作与业务逻辑 |
| 4 | 数据库连接池 | Druid 连接池的概念与使用 |

!!! quote "🤖 Prompt（提示词）"
    请使用 ai-assisted-jdbc-learning Skill，引导我学习 JDBC 和数据库连接池。

---

#### 任务三：图书模块 CRUD 独立练习

在 `vibe_learning` 项目中，独立完成以下练习：

1. 使用 AI 生成 SQL 建表语句，创建 `books` 表（字段：id, title, author, isbn, category, total_copies, available_copies）。
2. 使用 AI 生成插入测试数据的 SQL。
3. 使用 JDBC 实现图书的增删改查（DAO 层）。
4. 使用 Servlet 实现图书列表和详情查询的 API。
5. 使用 Druid 连接池优化数据库连接。

---

#### 任务四：使用 Skill 优化前端 UI

使用 `ui-ux-pro-max` Skill 快速生成专业风格的界面。

!!! quote "🤖 Prompt"
    使用技能 ui-ux-pro-max，帮我修改登录页 login.html 的风格，采用正式、简洁的官方风格。

操作步骤：

1. 在 Trae AI 对话框中输入上述 Prompt。
2. 等待 AI 生成并预览修改后的页面效果。
3. 满意后应用到实际项目中。

!!! success "📸 截图 2（提交物）"
    AI 生成 UI 优化的前后对比截图，重命名为 `ui_optimize.png`。

---

### 模块 2：Vibe Coding —— 图书管理系统后端开发

!!! info "说明"
    若在之前的课程中已完成图书管理系统后端开发，可以使用自己之前的代码为基础继续。请使用 AI 生成你项目的 API 接口文档，并依据该文档生成 Postman 接口测试集合（JSON 文件），导入到 Postman 中进行接口测试。

---

#### 任务五：数据库设计与建表

**数据库选择（二选一）**：

| 方式 | 适用场景 | 说明 |
|------|---------|------|
| 本地数据库（推荐） | 已安装 MySQL 8.0+ | 性能更好，开发调试方便 |
| 远程数据库 | 未安装 MySQL | 使用实验提供的数据库服务器 |

**本地数据库配置**：

```sql
CREATE DATABASE book_management DEFAULT CHARACTER SET utf8mb4;
```

**远程数据库配置**：

| 配置 | 主机 | 端口 | 用户名 | 密码 | 数据库 |
|------|------|------|--------|------|--------|
| 校园网 | `10.50.79.225` | `3306` | `user_学号` | `学号` | `app_学号` |
| 外网 | `8.140.216.36` | `29206` | `user_学号` | `学号` | `app_学号` |

**需要创建的三张表**（参照 `项目需求及设计文档.md` 附录 B）：

| 表名 | 说明 |
|------|------|
| `users` | 用户表（存储管理员和普通用户） |
| `books` | 图书表（含多复本管理：`total_copies`、`available_copies`） |
| `borrow_records` | 借阅记录表 |

!!! quote "🤖 Prompt（提示词）"
    根据以下需求，帮我生成完整的 MySQL 建表 SQL：
    - users 表：id（主键自增）、username（唯一）、password、name、email、role（admin/user）
    - books 表：id（主键自增）、title、author、isbn、category、total_copies、available_copies
    - borrow_records 表：id（主键自增）、user_id（外键）、book_id（外键）、borrow_date、due_date、return_date、status（borrowing/returned/overdue）
    并插入初始数据（默认管理员 admin/123456 和 5 本测试图书）。

!!! success "📸 截图 3（提交物）"
    数据库建表完成后，Navicat/DBeaver 中三张表的 ER 视图截图，重命名为 `db_schema.png`。

---

#### 任务六：项目配置及初始化

1. **使用 Trae AI IDE 打开 `book_template` 目录**（用于 AI 辅助编程）。
2. **同时使用 IDEA 打开项目**（用于运行调试）。
3. **配置数据库连接**：编辑 `src/main/resources/db.properties`。

    ```properties
    # 本地 MySQL 配置
    jdbc.url=jdbc:mysql://localhost:3306/book_management?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
    jdbc.username=root
    jdbc.password=你的MySQL密码
    jdbc.driver=com.mysql.cj.jdbc.Driver
    ```

---

#### 任务七：使用 Trae AI IDE 生成后端代码（核心）

这是本实验的核心环节。你需要借助 AI 完成全部后端代码的开发。

**需要完成的内容**：

| 层级 | 文件 | 说明 |
|------|------|------|
| DAO | `UserDao.java` | 用户数据访问（登录验证、注册、查询） |
| DAO | `BookDao.java` | 图书数据访问（CRUD、搜索、复本管理） |
| DAO | `BorrowDao.java` | 借阅数据访问（借阅、归还、记录查询） |
| Servlet | `LoginServlet.java` | 用户登录 |
| Servlet | `RegisterServlet.java` | 用户注册 |
| Servlet | `BookServlet.java` | 图书管理（Action 分发模式） |
| Servlet | `BorrowServlet.java` | 借阅管理（借书/还书） |
| Filter | `AuthFilter.java` | 登录权限拦截 |
| 全部 | 25+ 个 API 接口 | 参照 `API.md` 文档 |

**操作步骤**：

1. 在 Trae AI IDE 中，将 `API.md` 和 `项目需求及设计文档.md` 的内容提供给 AI 作为上下文。
2. 输入核心 Prompt：

    !!! quote "🤖 Prompt"
        根据项目需求及设计文档.md 中的需求及设计，以及 API.md 接口文档，帮我完成后端所有功能开发。技术栈：Java 17 + Servlet（Jakarta 6.0）+ JDBC + MySQL。项目结构参照已有的 Controller-Service-DAO 分层。

3. 观察 Trae 右侧窗口的代码生成过程，逐个审查并采纳 AI 生成的代码。
4. 在 IDEA 中运行项目，调试生成的代码。

!!! success "📸 截图 4（提交物）"
    Trae AI IDE 生成代码过程的截图（对话界面），重命名为 `vibe_coding.png`。

---

#### 任务八：关键技术要点理解

以下内容可借助 AI Skill 学习，但必须自己理解和实现。

**1. Session 认证**

登录后将用户信息存入 Session，后续请求通过 Filter 检查 Session 有效性。管理员接口额外检查 `role == "admin"`。

**2. 密码加密**

使用 MD5 对密码进行加密存储（教学简化方案）：

```java
String encryptedPassword = MD5Utils.md5(password);
```

**3. 借阅业务规则**

```
借阅检查流程：
 1. 用户是否已登录？          → 未登录返回 401
 2. 当前借阅数 < 5？          → 已达上限返回 400
 3. 有无超期未还记录？         → 有超期记录返回 400
 4. 图书可借复本 > 0？        → 无复本返回 400
 5. 校验通过                 → 创建借阅记录，available_copies - 1

归还流程：
 1. 查找借阅记录（status = 'borrowing'）
 2. 更新 status = 'returned'，return_date = NOW()
 3. 图书 available_copies + 1
```

**4. 删除限制**

* 有借阅记录的用户不可删除。
* 有借阅记录的图书不可删除（`available_copies < total_copies`）。
* 管理员账号不可删除。

**5. 编码规范**

```java
req.setCharacterEncoding("UTF-8");
resp.setContentType("application/json;charset=UTF-8");
```

---

#### 任务九：Postman 接口测试

1. **导入测试集合**：
    * 打开 Postman → Import → 选择 `book_template/A-校园图书管理系统.postman_collection.json`。
    * 新建 Environment，配置以下变量：
        * `ip` = `localhost`
        * `port` = `8080`
        * `context` = `/book`

2. **按顺序测试**：

    | 模块 | 测试接口 |
    |------|---------|
    | 认证 | 注册 → 登录 → 验证 Session → 退出 |
    | 图书（用户） | 浏览 → 搜索 → 查看详情 |
    | 借阅 | 借书 → 查看我的借阅 → 还书 |
    | 管理（admin） | 图书 CRUD → 用户管理 → 借阅记录管理 |

!!! success "📸 截图 5（提交物）"
    Postman 中完成全部接口测试的 Runner 汇总结果截图，重命名为 `postman_summary.png`。

!!! success "📸 截图 6（提交物）"
    浏览器访问图书管理系统，登录后图书列表页面截图，重命名为 `browser_books.png`。

---

## 🚀 挑战任务（Optional - 加分项）

### 挑战 A：超期检测

在借阅归还接口中实现自动超期检测：如果 `return_date > due_date`，标记为逾期并计算逾期天数。

### 挑战 B：借阅历史分页

在借阅记录查询接口中实现分页功能（`page`、`size` 参数 + LIMIT 分页）。

### 挑战 C：密码加密升级

使用 `BCrypt` 替代 `MD5` 进行密码加密存储与验证。

---

## 💾 作业提交

### 提交内容

1. **完整项目代码**（`book_template` 目录下的全部后端实现）。
2. **截图文件**，放入 `img` 目录：

    | 文件名 | 内容说明 |
    |--------|----------|
    | `skill_loaded.png` | Trae Skill 加载成功截图 |
    | `ui_optimize.png` | AI 生成 UI 优化对比截图 |
    | `db_schema.png` | 数据库三张表结构截图 |
    | `vibe_coding.png` | Trae AI IDE 生成代码对话截图 |
    | `postman_summary.png` | Postman 接口测试汇总结果 |
    | `browser_books.png` | 浏览器图书列表页面截图 |

### 学习通提交

将项目压缩为 ZIP（包含 `vibe_learning` 练习代码和 `book_template` 完整代码），上传至学习通对应作业入口。学习通提交的**实验报告**需额外包含：

* 与 AI 的对话截图
* SQL 建表及插入测试数据语句
* 图书模块核心代码
* Postman 或 IDEA HTTP Client 接口测试截图

---

## 📚 相关资源

* [实验 2-2 仓库](https://gitee.com/javaweb-dev-tech/lab2_2)（模板工程与完整 README）
* [实验 2-1：基于 Servlet 的用户认证功能实现](lab2-1.md)（本章前置实验）
* [👉 实验 2：核心组件与持久化综合实战](lab2.md)（本章综合大实验）
* [Trae AI IDE 官方网站](https://www.trae.cn/)