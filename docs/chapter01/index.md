---
title: 第1章 Web开发基础与效能工具
---
# Java Web开发技术

## 课程简介

《Java Web开发技术》是计算机科学与技术专业的核心课程，旨在帮助学生掌握 **Java Web开发** 的核心技能，深入了解 **Spring Boot** 和 **MyBatis** 等流行框架，熟练运用 **RESTful API** 设计与开发。同时，课程将结合 **信创国产化技术栈**（龙蜥 OS + openGauss 数据库），并通过项目驱动式学习，帮助学生在现代企业级开发环境中提升实际开发能力。课程最后，学生将通过构建 **智能航班管理系统** 项目，将所学知识应用于真实的开发环境中。

本课程采用 **“Spring Boot 优先”** 的教学模式，侧重于企业级开发框架的实战应用，并通过集成 **AI 大模型接口**，让学生在实际项目中体验到前沿技术的应用。

## 课程目标

通过本课程的学习，学生将能够：

- **理解并掌握 Web 开发的基础知识**：包括 HTTP 协议、Session 会话机制、Spring 容器（IoC/DI）和 AOP 等核心原理。
- **熟练使用 Spring Boot 和 MyBatis 进行开发**：掌握 RESTful API 设计，能够快速开发企业级 Web 应用。
- **掌握信创国产化技术栈**：能够使用国产数据库 **openGauss**，并集成 **AI 大模型 API**，如 DeepSeek。
- **具备工程化开发能力**：通过实际的项目开发，培养学生的团队合作与工程化思维。

## 学习路线图

以下是课程的学习路线图，展示了每个模块的学习内容及其顺序：

```mermaid
graph TD
    %% 定义样式
    classDef foundation fill:#e1f5fe,stroke:#0288d1,stroke-width:2px,color:#01579b;
    classDef core fill:#fff3e0,stroke:#ff9800,stroke-width:2px,color:#e65100;
    classDef advanced fill:#e8f5e9,stroke:#43a047,stroke-width:2px,color:#1b5e20;
    classDef project fill:#f3e5f5,stroke:#8e24aa,stroke-width:2px,color:#4a148c,stroke-dasharray: 5 5;

    %% 注意：这里必须加引号，否则会被冒号和竖线截断
    Start(("起点: Java SE 基础")) --> P1

    subgraph "夯实基础 (Foundation)"
        P1["第一篇 | 开发环境与效能工具"] -->|"Maven/Git/IDEA"| P2
        P2["第二篇 | Web 底层原理"]
        P2 -->|"HTTP/Tomcat/Servlet"| Gate1{"基础考核"}
    end

    Gate1 -->|通过| P3

    subgraph "核心框架 (Core Framework)"
        P3["第三篇 | Spring Boot 核心开发"] -->|"IOC/AOP/RESTful"| P4
        P4["第四篇 | 数据持久化与信创"]
        P4 -->|"MyBatis/数据库/国产化适配"| Gate2{"框架考核"}
    end

    Gate2 -->|掌握| P5

    subgraph "高阶赋能与实战 (Advanced & Practice)"
        P5["第五篇 | AI 集成与接口调用"] -->|"OpenAI/LangChain4j"| P6
        P6["第六篇 | 综合项目实战"]
        P6 -->|"全栈开发/部署"| End(("课程结业"))
    end

    %% 应用样式
    class P1,P2 foundation;
    class P3,P4 core;
    class P5 advanced;
    class P6 project;
```