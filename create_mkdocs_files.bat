@echo off
:: 设置编码为 UTF-8
chcp 65001

:: 设置根目录为 "docs"
set ROOT_DIR=docs

:: 创建文件夹结构
mkdir %ROOT_DIR%
mkdir %ROOT_DIR%\chapter01
mkdir %ROOT_DIR%\chapter02
mkdir %ROOT_DIR%\chapter03
mkdir %ROOT_DIR%\chapter04
mkdir %ROOT_DIR%\chapter05
mkdir %ROOT_DIR%\chapter06
mkdir %ROOT_DIR%\project
mkdir %ROOT_DIR%\experiments
mkdir %ROOT_DIR%\appendix

:: 创建各个章节的 Markdown 文件（根据 mkdocs.yml 中的目录结构）
echo Creating Markdown files...

:: 第 1 章
echo # 第1章 Web开发基础与效能工具 > %ROOT_DIR%\chapter01\index.md
echo ## Web与B/S架构 >> %ROOT_DIR%\chapter01\web-bs.md
echo ## Maven与项目结构 >> %ROOT_DIR%\chapter01\maven.md
echo ## Git基础与课程规范 >> %ROOT_DIR%\chapter01\git.md
echo ## AI辅助编程入门 >> %ROOT_DIR%\chapter01\ai-coding.md
echo ## 实验1：环境与AI助手配置 >> %ROOT_DIR%\chapter01\experiment.md

:: 第 2 章
echo # 第2章 HTTP与会话机制 > %ROOT_DIR%\chapter02\index.md
echo ## HTTP协议详解 >> %ROOT_DIR%\chapter02\http.md
echo ## Request / Response >> %ROOT_DIR%\chapter02\request-response.md
echo ## Cookie与Session >> %ROOT_DIR%\chapter02\session.md
echo ## JSON与数据交互 >> %ROOT_DIR%\chapter02\json.md
echo ## 实验2：Session登录实战 >> %ROOT_DIR%\chapter02\experiment.md

:: 第 3 章
echo # 第3章 Spring Boot 快速开发 > %ROOT_DIR%\chapter03\index.md
echo ## Spring Boot 项目结构 >> %ROOT_DIR%\chapter03\project-structure.md
echo ## IoC与DI 通俗理解 >> %ROOT_DIR%\chapter03\ioc-di.md
echo ## Controller与RESTful API >> %ROOT_DIR%\chapter03\controller.md
echo ## 接口测试与调试 >> %ROOT_DIR%\chapter03\api-test.md
echo ## 实验3：航班查询 API >> %ROOT_DIR%\chapter03\experiment.md

:: 第 4 章
echo # 第4章 MyBatis + openGauss > %ROOT_DIR%\chapter04\index.md
echo ## MyBatis 基础 >> %ROOT_DIR%\chapter04\mybatis.md
echo ## Mapper与CRUD >> %ROOT_DIR%\chapter04\crud.md
echo ## 事务管理 >> %ROOT_DIR%\chapter04\transaction.md
echo ## openGauss 实战 >> %ROOT_DIR%\chapter04\opengauss.md
echo ## 实验4：航班数据管理 >> %ROOT_DIR%\chapter04\experiment.md

:: 第 5 章
echo # 第5章 AI 与外部 API > %ROOT_DIR%\chapter05\index.md
echo ## Java HTTP 客户端 >> %ROOT_DIR%\chapter05\http-client.md
echo ## 大模型 API 调用流程 >> %ROOT_DIR%\chapter05\llm-api.md
echo ## Prompt 工程基础 >> %ROOT_DIR%\chapter05\prompt.md
echo ## AI 响应解析 >> %ROOT_DIR%\chapter05\response.md
echo ## 实验5：AI 旅行助手 >> %ROOT_DIR%\chapter05\experiment.md

:: 第 6 章
echo # 第6章 智能航班管理系统实战 > %ROOT_DIR%\chapter06\index.md
echo ## 项目概述 >> %ROOT_DIR%\project\index.md
echo ## 系统架构设计 >> %ROOT_DIR%\project\architecture.md
echo ## 用户模块 >> %ROOT_DIR%\project\user.md
echo ## 航班管理模块 >> %ROOT_DIR%\project\flight.md
echo ## AI 智能助手模块 >> %ROOT_DIR%\project\ai.md
echo ## 部署与演示 >> %ROOT_DIR%\project\deploy.md

:: 实验与项目指导
echo # 实验与项目指导 > %ROOT_DIR%\experiments\rules.md
echo ## Git 提交规范 >> %ROOT_DIR%\experiments\git.md
echo ## 实验报告模板 >> %ROOT_DIR%\experiments\report.md
echo ## 常见错误汇总 >> %ROOT_DIR%\experiments\faq.md

:: 附录
echo # 附录 > %ROOT_DIR%\appendix\faq.md
echo ## Java Web 常见问题 >> %ROOT_DIR%\appendix\faq.md
echo ## RESTful API 规范 >> %ROOT_DIR%\appendix\rest.md
echo ## MyBatis SQL 模板 >> %ROOT_DIR%\appendix\sql.md
echo ## AI Prompt 示例库 >> %ROOT_DIR%\appendix\prompt.md
echo ## 信创技术说明 >> %ROOT_DIR%\appendix\xinchuang.md

echo 文件创建完成！
pause

