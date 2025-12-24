# JavaWeb 开发技术MkDocs

https://dedeguo.github.io/javaweb-course-docs/

### 本地运行mkdocs
```bash
# 激活环境
conda activate mkdocs_env
# 安装依赖
pip install mkdocs mkdocs-material

mkdocs --version
# 本地运行
mkdocs serve
```

### 评论功能

使用giscus https://giscus.app/zh-CN  
只在特定页面关闭评论，例如希望在“首页”或“关于”页面关闭评论，可以在该 Markdown 文件的头部（Front matter）添加：
```
---
hide:
  - feedback # 这会隐藏底部的反馈（如果有）
---
```
### 目录结构

```yml

 - 第四篇｜数据持久化 MyBatis 与信创数据库:
      - 第4章 导读: chapter04/index.md
      - 01. ORM 思想与 MyBatis 初探:  chapter04/01-orm-intro.md
      - 02. 整合信创数据库 (Spring Boot + openGauss): chapter04/02-integrate-gauss.md
      - 03. Mapper 接口与 XML 映射:   chapter04/03-mapper-xml.md
      - 04. MyBatis 的杀手锏：动态 SQL:  chapter04/04-dynamic-sql.md
      - 05. 插件生态：PageHelper 分页查询:  chapter04/05-pagehelper.md
      - 06. 事务管理：@Transactional 与 ACID:  chapter04/06-transaction.md
      - 实验4：数据落地——从内存 Map 到 openGauss:  chapter04/lab4.md`

- 第三篇｜Spring Boot 核心开发:
      - 第3章 导读: chapter03/index.md
      - 01. 框架革命：Spring Boot 快速入门 : chapter03/01-springboot-start.md
      - 02. 核心原理：IOC 容器与依赖注入 (DI): chapter03/02-ioc-di.md
      - 03. 接口规范：RESTful 风格与统一响应: chapter03/03-restful-api.md
      - 04. 架构设计：分层解耦 (Controller-Service-Dao):  chapter03/04-architecture.md
      - 05. 全局兜底：异常处理与 AOP 简介:  chapter03/05-exception-aop.md        
      - 06. 生产级基石：日志管理与单元测试: chapter03/06-test-logging.md
      - 实验3：构建标准化的 RESTful 后端系统:  chapter03/lab3.md     
- 第二篇｜Web 底层原理:  
      - 第2章 导读: chapter02/index.md
      - 01.HTTP 协议与调试工具: chapter02/01-http-protocol.md
      - 02. Servlet 基础: chapter02/02-servlet-basics.md    
      - 03. 请求与响应 (Req & Resp): chapter02/03-request-response.md
      - 04. JSON 数据交互: chapter02/04-json-interaction.md  
      - 05. 会话与状态 (Session): chapter02/05-state-management.md 
      - 06. 过滤器与监听器: chapter02/06-filter-listener.md
      - 07. JDBC 与连接池 (JDBC & Druid): chapter02/07-jdbc-core.md
      - 实验 2：Web 核心综合实战: chapter02/lab2.md
- 第一篇｜开发环境与效能工具: 
      - 第1章 导读: chapter01/index.md
      - 01.开发环境安装: chapter01/01-env-setup.md
      - 02.工程化基石：Git 版本控制与协作: chapter01/02-maven-git.md
      - 03.AI 结对编程 : chapter01/03-ai-tools.md
      - 实验1：Web环境与AI助手配置: chapter01/lab1.md
    

```