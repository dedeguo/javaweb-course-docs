---
title: 课程简介
---
# 《Java Web开发技术》课程教学大纲（实战版｜2026 修订）

---

## 一、课程基本信息

| 项目   | 内容                                            |
| ---- | --------------------------------------------- |
| 课程名称 | Java Web开发技术（Java Web Development Technology） |
| 课程代码 | 00313                                         |
| 课程类别 | 专业必修课                                         |
| 课程学分 | 3                                             |
| 课程学时 | 48（含16学时实验）                                   |
| 授课对象 | 计算机科学与技术专业（专升本）                               |
| 先修课程 | Java程序设计、数据库原理与应用、计算机网络                       |
| 培养方案 | 2020版（2025年修订）                                |
| 开课单位 | 计算机与自动化学院                                     |

### 课程简介

Java Web开发技术是计算机科学与技术专业的一门专业必修课。针对48学时的紧凑安排，课程采用 **“Spring Boot First”** 的教学策略。

课程以构建 **"SmartBook 智能图书交易系统"** 为主线，快速通过 Web 底层原理，重点讲解 Spring Boot 企业级开发框架与 MyBatis 持久层技术。

在 AI 智能助手部分，课程引入前沿的 **MCP（Model Context Protocol）** 标准，系统讲解 **Tool Calling（工具调用）** 技术，使学生掌握从接口设计、数据库交互到 **"大模型驱动本地 Java 方法"** 的现代全栈智能开发流程。

课程使用 **Trae AI IDE** 等 AI 编程工具辅助教学，采用 **Vibe Coding** 与 **Vibe Learning** 模式，引导学生借助 AI 理解底层原理、生成样板代码、完成业务逻辑开发，实现"AI 引导 + 自主编码"的高效学习闭环。

---

## 二、课程目标

### 课程目标 1：核心原理

* 理解 B/S 架构工作原理
* 掌握 HTTP 协议与 Session 会话机制
* 理解 Spring 容器（IoC / DI）与 AOP 的基本思想

### 课程目标 2：工程能力与开发效能

* 熟练使用 Spring Boot + MyBatis 进行 RESTful API 开发
* 掌握 Maven 依赖管理
* 熟练使用 AI 辅助编程工具（Trae AI IDE、通义灵码等）进行 Vibe Coding 开发、生成单元测试并辅助 Debug

### 课程目标 3：AI 集成与智能体开发能力

* 能够熟练使用 MySQL 数据库进行开发与数据建模
* 掌握 HTTP Client 调用 AI 大模型（如 DeepSeek）并处理 JSON 数据
* 理解 MCP 架构，掌握 Tool Calling 机制，实现大模型对 Java 业务逻辑的自动调用

### 课程目标 4：综合素质

* 具备良好的代码规范意识
* 体验 AI 赋能开发范式（Vibe Coding / Vibe Learning）
* 培养解决复杂工程问题的创新思维

---

## 三、课程学时安排

### （一）理论学时安排（32 学时）

| 序号     | 章节                             | 学时     | 重点内容                                    |
| ------ | ------------------------------ | ------ | --------------------------------------- |
| 1      | 第1章 Web开发基础与效能工具               | 2      | Maven、Git、AI 使用技巧                       |
| 2      | 第2章 Web底层原理（Servlet、JDBC）      | 6      | HTTP、Servlet、Session、Filter、JDBC、Druid |
| 3      | 第3章 Spring Boot 核心与 RESTful API   | 8      | IoC/DI、RESTful API、分层架构、异常处理、AOP    |
| 4      | 第4章 数据持久化（MyBatis）            | 4      | ORM、MySQL 整合、动态 SQL、PageHelper、事务管理    |
| 5      | 第5章 AI 集成与智能体基础                | 6      | HTTP Client、Prompt、JSON Schema、Tool Calling、Spring AI、MCP |
| 6      | 第6章 综合项目：SmartBook 智能图书交易系统     | 6      | 系统设计、核心业务开发、Agent 集成、部署              |
| **合计** |                                | **32** |                                         |

### （二）实验学时安排（16 学时）

| 序号 | 实验项目                  | 学时 | 实验类型 | 要求 |
| -- | --------------------- | -- | ---- | -- |
| 1  | Web环境与 AI 助手配置        | 2  | 演示性  | 必做 |
| 2  | Servlet 核心组件与持久化综合实战（Vibe Coding） | 4  | 验证性  | 必做 |
| 3  | Spring Boot RESTful API 开发（学生+图书模块 CRUD，AI 辅助） | 4  | 演示性  | 必做 |
| 4  | MyBatis 综合实战            | 2  | 验证性  | 必做 |
| 5  | AI 智能图书导购 Agent        | 2  | 演示性  | 必做 |
| 6  | SmartBook 智能图书交易系统综合   | 2  | 综合性  | 必做 |

---

## 四、教学内容与要求

### 第1章 Web开发基础与效能工具（2 学时）

**目标**：建立工程化开发认知，学会使用 AI 工具辅助学习与编码。

* Java Web 开发整体认知
* Servlet 规范简介
* Maven 依赖管理（pom.xml）
* 快速环境搭建（JDK / Maven / IDEA / Tomcat）
* AI 工具介绍：DeepSeek、Trae AI IDE
* 开发效能插件：Lombok、MyBatisX
* AI 辅助编程：Vibe Coding 与 Vibe Learning 模式

### 第2章 Web 底层原理：Servlet 与 JDBC（6 学时）

* Servlet 生命周期
* HTTP 协议与 Request/Response
* JSON 数据格式与 Jackson
* Cookie 与 Session 机制
* 过滤器与监听器（Filter & Listener）
* JDBC 核心与 Druid 连接池
* Servlet CRUD 综合实战（含 Vibe Coding 实验）
* **删减说明**：不讲 JSP、不讲 Servlet 高级标签
* **实验资源**：
  * [实验 2-1：基于 Servlet 的用户认证功能实现](https://gitee.com/javaweb-dev-tech/lab2_1)（Session 登录/注册/登出）
  * [实验 2-2：Vibe Coding 及 Vibe Learning](https://gitee.com/javaweb-dev-tech/lab2_2)（AI 辅助图书管理系统开发）

### 第3章 Spring Boot 核心与 RESTful API（8 学时）

* Spring Boot 约定大于配置
* IoC / DI（@Autowired、@Service）
* MVC 核心注解
* RESTful API 设计规范
* **AI 辅助开发实验（学生模块 CRUD）**：
  * 使用 AI 生成 SQL 建表语句（student 表：id, name, age, major）及测试数据
  * 使用 AI 生成实体类、Mapper 接口/XML、Service、Controller
  * 实现完整 RESTful API：
    * `GET /api/students` → 查询所有
    * `GET /api/students/{id}` → 查询单个
    * `POST /api/students` → 新增
    * `PUT /api/students/{id}` → 更新
    * `DELETE /api/students/{id}` → 删除
  * 使用 IDEA HTTP Client 或 Postman 进行接口测试
  * **图书模块（Book）CRUD**：仿照学生模块，由学生独立使用 AI 完成 Book 实体类、Mapper、Service、Controller 的完整开发
* 三层架构设计（Controller-Service-Dao）
* 统一返回结果封装
* 全局异常处理与 AOP 简介
* 单元测试（JUnit 5）与日志管理（SLF4J）
* 接口测试（IDEA HTTP Client / Postman）
* **实验报告要求**：AI 对话截图、SQL 建表及测试数据语句、核心代码、接口测试截图

### 第4章 数据持久化：MyBatis 与事务管理（4 学时）

* ORM 思想
* MyBatis 整合 Spring Boot + MySQL
* Mapper 接口与 XML 映射
* 动态 SQL（if、where、foreach）
* PageHelper 分页插件
* 事务管理（@Transactional）

### 第5章 AI 集成与智能体基础：MCP 与 Tool Calling（6 学时）

* Java HTTP 客户端
* Prompt 工程
* DeepSeek / OpenAI API 调用
* 结构化输出与 JSON Schema 解析
* Tool Calling 原理与 JSON Schema 定义
* Spring AI 框架接入
* MCP：Context / Tools / Resources
* 意图识别与智能体实战

### 第6章 综合项目：SmartBook 智能图书交易系统（6 学时）

* 系统需求分析与建模（用例图、ER 图）
* 用户模块与权限拦截
* 图书发布、搜索与交易核心业务
* AI 智能图书导购 Agent 集成
* Maven 打包与 Tomcat 部署

---

## 五、考核方式

### 1. 考核构成

* 平时成绩：40%
* 期末考试：60%

### 2. 平时成绩（40%）

* 课堂表现 / 考勤：30%
* 作业与实验（Git 提交记录）：40%
* AI 应用报告：30%

### 3. 期末考试（60%）

* 形式：机考（闭卷）
* 内容：选择题、填空题、编程题

---

## 六、教学资源保障

* 电子教材与补充文档
* 远程 MySQL 数据库服务器
* 前端模板（Vue / HTML + jQuery）
* 魔塔社区 API Key（每日 2000 次）
* Git 仓库：码云高校版

---

## 七、推荐教材与参考资料

### 推荐教材

* 刘雄华，宋文哲，孙仕轶. **Java Web开发技术**. 华中科技大学出版社，2022.

### 参考资料

* 黑马程序员. *Java Web程序设计任务教程（第2版）*. 人民邮电出版社，2021.
* 明日科技. *Java Web从入门到精通（第3版）*. 清华大学出版社，2019.

---

**编写人**：陈德
**审核人**：
**时间**：2026.05
