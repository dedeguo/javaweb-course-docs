---
title: 课程简介
---
# 《Java Web开发技术》课程教学大纲（实战版｜2025 修订）

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

课程以构建 **“AI赋能的航班管理系统”** 为主线，快速通过 Web 底层原理，重点讲解 Spring Boot 企业级开发框架与 MyBatis 持久层技术。

在 AI 智能助手部分，课程引入前沿的 **MCP（Model Context Protocol）** 标准，系统讲解 **Tool Calling（工具调用）** 技术，使学生掌握从接口设计、数据库交互到 **“大模型驱动本地 Java 方法”** 的现代全栈智能开发流程。

学生将在 **信创环境（龙蜥 OS + Dragonwell JDK + openGauss）** 下完成开发与部署实践。

---

## 二、课程目标

### 课程目标 1：核心原理

* 理解 B/S 架构工作原理
* 掌握 HTTP 协议与 Session 会话机制
* 理解 Spring 容器（IoC / DI）与 AOP 的基本思想

### 课程目标 2：工程能力与开发效能

* 熟练使用 Spring Boot + MyBatis 进行 RESTful API 开发
* 掌握 Maven 依赖管理
* 熟练使用 AI 辅助编程工具（通义灵码、Cursor 等）生成样板代码、单元测试并辅助 Debug

### 课程目标 3：信创与 AI 集成能力

* 能够连接国产数据库 openGauss 进行开发
* 掌握 HTTP Client 调用 AI 大模型（如 DeepSeek）并处理 JSON 数据
* 理解 MCP 架构，掌握 Tool Calling 机制，实现大模型对 Java 业务逻辑的自动调用

### 课程目标 4：综合素质

* 具备良好的代码规范意识
* 体验国产软硬件生态
* 培养解决复杂工程问题的创新思维

---

## 三、课程学时安排

### （一）理论学时安排（32 学时）

| 序号     | 章节                             | 学时     | 重点内容                                    |
| ------ | ------------------------------ | ------ | --------------------------------------- |
| 1      | 第1章 Web开发基础与效能工具               | 2      | Maven、Git、AI 使用技巧                       |
| 2      | 第2章 Web底层原理（HTTP 与会话）          | 6      | Request/Response、Session/Cookie、Servlet |
| 3      | 第3章 Spring Boot 快速开发           | 8      | IoC/DI、RESTful API、Controller           |
| 4      | 第4章 数据持久化（MyBatis + openGauss） | 4      | ORM、CRUD、事务管理                           |
| 5      | 第5章 AI 集成与智能体基础                | 6      | RestTemplate、DeepSeek、MCP、Tool Calling  |
| 6      | 第6章 综合项目：智能航班系统                | 6      | 业务逻辑串联、部署                               |
| **合计** |                                | **32** |                                         |

### （二）实验学时安排（16 学时）

| 序号 | 实验项目                  | 学时 | 实验类型 | 要求 |
| -- | --------------------- | -- | ---- | -- |
| 1  | Web环境与 AI 助手配置        | 2  | 演示性  | 必做 |
| 2  | Servlet 登录与接口测试       | 2  | 验证性  | 必做 |
| 3  | Spring Boot 航班 API 开发 | 4  | 演示性  | 必做 |
| 4  | MyBatis 对接 openGauss  | 2  | 验证性  | 必做 |
| 5  | AI 智能助手集成             | 2  | 演示性  | 必做 |
| 6  | 智能航班系统综合              | 4  | 综合性  | 必做 |

---

## 四、教学内容与要求

### 第1章 Web开发基础与效能工具（2 学时）

**目标**：建立工程化开发认知，学会使用 AI 工具辅助学习与编码。

* Java Web 开发整体认知
* Servlet 规范简介
* Maven 依赖管理（pom.xml）
* 快速环境搭建（JDK / Maven / IDEA / Tomcat）
* AI 工具介绍：DeepSeek、Kimi、豆包
* 开发效能插件：Lombok、MyBatisX
* 通义灵码：生成代码、单元测试与代码解释

### 第2章 Web 底层原理：Servlet 与 HTTP（6 学时）

* Servlet 生命周期
* 登录/注册 Demo
* HTTP 协议与 Request/Response
* Cookie 与 Session 机制
* JSON 数据格式与 Jackson
* **删减说明**：不讲 JSP、不讲 Servlet 高级标签

### 第3章 Spring Boot 核心与 RESTful API（8 学时）

* Spring Boot 约定大于配置
* IoC / DI（@Autowired、@Service）
* MVC 核心注解
* RESTful API 设计规范
* 统一返回结果封装
* 接口测试（Postman / Apifox）

### 第4章 数据持久化：MyBatis 与信创数据库（4 学时）

* ORM 思想
* MyBatis 整合 Spring Boot
* openGauss 数据库连接
* Mapper 接口与映射
* 事务管理（@Transactional）

### 第5章 AI 集成与智能体基础：MCP 与 Tool Calling（6 学时）

* Prompt 工程
* Java HTTP 客户端
* DeepSeek / OpenAI API 调用
* Markdown 数据解析
* Tool Calling 原理与 JSON Schema
* MCP：Context / Tools / Resources
* 意图识别搜索实战

### 第6章 综合项目：智能航班管理系统（6 学时）

* 系统设计与 E-R 图
* 用户模块与权限拦截
* 航班查询与预订
* AI 旅行助手模块
* Maven 打包与龙蜥 OS 部署

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
* 私有云 / 服务器 openGauss 环境
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
**时间**：2025.12
