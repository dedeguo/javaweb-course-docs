# JavaWeb 开发技术MkDocs

文档地址：[https://javaweb.chende.top/](https://javaweb.chende.top/)

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

### 文档编写计划

- [ ] 账号注册：idea教育邮箱、ai工具（deepseek、豆包、kimi等）    魔塔社区、
- [ ] 第三章正文相关章节给出 Spring官网地址、中文文档地址等

扩展内容：
- [ ] Servlet 规范解读（单独扩展或者正文给出阅读链接）
- [ ] Java 基础：注解、反射、动态代理、网络等等
- [ ] Tomcat 4 源码运行项目；源码阅读；tomcat4 源码解析电子书
- [ ] Spring 深入：原理解析，源码阅读
- [ ] MyBatis 深入：原理解析，源码阅读

- [ ] Spring AI 框架尝鲜。
- [ ] MCP 原理深入
  - A1. 快速接入 OpenAI 
  - A2. 简单的 RAG 实现 

