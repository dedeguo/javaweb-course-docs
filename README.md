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

1.  **关于 `index.md` 的妙用**：
    在我的配置中，我将每个章节的第一项命名为“第X章 导读”（指向 `index.md`）。
    建议您在这个文件中放置：

      * 本章的**思维导图**（可以用 Mermaid 画）。
      * 本章的**教学目标**。
      * **重点难点**提示。
        这样学生点击顶部导航的“第二篇”时，默认就会看到这个导读页面，非常有仪式感。

2.  **AI 与信创元素的植入**：

      * 在 `chapter05/llm-api.md` 中，建议专门写一段 **“如何获取 DeepSeek API Key”** 的教程。
      * 在 `chapter04/opengauss.md` 中，可以加入您之前研究过的 **“Docker 部署 openGauss”** 的简易命令，方便有能力的学生自己折腾。

```

docs/
├── chapter2/
│   ├── 01-http-protocol.md      # 2.1 HTTP协议与开发者工具
│   ├── 02-servlet-basics.md     # 2.2 Servlet起步与生命周期
│   ├── 03-request-response.md   # 2.3 请求与响应对象详解 (Request/Response)
│   ├── 04-state-management.md   # 2.4 会话跟踪技术 (Cookie & Session)
│   ├── 05-filter-listener.md    # 2.5 过滤器与上下文 (Filter & ServletContext)
│   ├── 06-json-interaction.md   # 2.6 JSON与前后端交互
│   └── 07-comprehensive-lab.md  # 2.7 综合实验：用户登录与数据API


.
├── mkdocs.yml
└── docs/
    ├── index.md                        # 首页 -> 课程简介
    ├── roadmap.md                      # 首页 -> 学习路线与考核说明
    │
    ├── chapter01/                      # 第一篇
    │   ├── index.md                    # 第1章 Web开发基础与效能工具
    │   ├── web-bs.md                   # Web 与 B/S 架构
    │   ├── maven.md                    # Maven 与项目结构
    │   ├── git.md                      # Git 基础与课程规范
    │   ├── ai-coding.md                # AI 辅助编程入门
    │   └── experiment.md               # 实验1
    │
    ├── chapter02/                      # 第二篇
    │   ├── index.md                    # 第2章 HTTP 与会话机制
    │   ├── http.md                     # HTTP 协议详解
    │   ├── request-response.md
    │   ├── session.md
    │   ├── json.md
    │   └── experiment.md               # 实验2
    │
    ├── chapter03/                      # 第三篇
    │   ├── index.md                    # 第3章 Spring Boot 快速开发
    │   ├── project-structure.md
    │   ├── ioc-di.md
    │   ├── controller.md
    │   ├── api-test.md
    │   └── experiment.md               # 实验3
    │
    ├── chapter04/                      # 第四篇
    │   ├── index.md                    # 第4章 MyBatis + openGauss
    │   ├── mybatis.md
    │   ├── crud.md
    │   ├── transaction.md
    │   ├── opengauss.md
    │   └── experiment.md               # 实验4
    │
    ├── chapter05/                      # 第五篇
    │   ├── index.md                    # 第5章 AI 与外部 API
    │   ├── http-client.md
    │   ├── llm-api.md
    │   ├── prompt.md
    │   ├── response.md
    │   └── experiment.md               # 实验5
  
    

```