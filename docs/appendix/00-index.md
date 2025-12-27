# 附录：进阶资源与内功修炼
这份附录规划将原有的零散资源进行了体系化梳理，既保留了**“信创国产化”**的特色，又兼顾了**“底层原理”**（源码）和**“前沿技术”**（AI）。

为了方便学生自学和查阅，我建议将附录分为 **五大板块**。以下是为您设计的详细目录结构及文件名规划：


### 📚 附录：进阶资源与内功修炼

#### **附录 A：信创开发环境与工具链**

> *定位：解决“环境搭建难”的问题，统一班级开发基准。*

* **A01. 基于 VMware 的国产化环境搭建**: `appendix/a01-vmware-kylin.md`
* 内容：手把手教安装 KylinOS（麒麟）/ UOS，配置网络与 SSH。
  - （银河麒麟所有版本+中标麒麟+向日葵+百度云盘+微信+谷歌）资源下载 https://ak.cueany.cn/502.html
* **A02. Docker 容器化部署：让 Spring Boot 随处运行**: `appendix/a02-docker-deploy.md`
* 核心：Docker 基础概念（镜像 vs 容器），编写 Dockerfile，构建与运行。

* **A03. OpenGauss 数据库安装与配置指南**: `appendix/a03-opengauss-setup.md`
* 内容：Docker 安装 vs 源码安装，Navicat/DataGrip 连接配置。

* **A04. 常用开发工具清单 (IDEA插件/Maven镜像)**: `appendix/a04-devtools.md`
* 内容：阿里云 Maven 镜像配置、Lombok、MyBatisX 等必装插件。VMware、 Docker



#### **附录 B：Java 高级特性补给站**

> *定位：为学习 Spring 和 MyBatis 扫清语法障碍（很多学生学不懂框架是因为不懂反射）。*

* **B01. 魔法的起源：Java 反射机制 (Reflection)**: `appendix/b01-reflection.md`
* 核心：`Class.forName`，如何动态调用方法。


* **B02. 框架的灵魂：注解 (Annotation) 与元编程**: `appendix/b02-annotation.md`
* 核心：如何自定义 `@Log` 注解并生效。


* **B03. 偷天换日：动态代理 (Dynamic Proxy)**: `appendix/b03-proxy.md`
* 核心：JDK 代理 vs CGLIB，这是 Spring AOP 的基石。


* **B04. 网络编程基石：Socket 与 HTTP 协议**: `appendix/b04-network-basics.md`
* 核心：TCP 三次握手简述，手动写一个最简单的 Web Server。



#### **附录 C：源码级内功修炼 (硬核)**

> *定位：满足学有余力的“学霸”，深入理解 Web 容器和框架原理。*

* **C01. Servlet 规范核心解读 (3.1/4.0)**: `appendix/c01-servlet-spec.md`
* 内容：生命周期图解，`web.xml` 标签含义速查。


* **C02. 手写 Tomcat：从 Tomcat 4 源码看容器原理**: `appendix/c02-tomcat4-source.md`
* **亮点**：提供 Tomcat 4.1.12 (最适合学习的经典版本) 源码运行包。
* 内容：Connector 与 Container 的连接，一个请求是如何到达 Servlet 的。


* **C03. Spring IOC/AOP 核心源码导读**: `appendix/c03-spring-core.md`
* 内容：`BeanDefinition` 加载流程，`ApplicationContext` 启动过程概览。


* **C04. MyBatis 源码解析：SQL 是如何执行的**: `appendix/c04-mybatis-source.md`
* 内容：`SqlSession`，`Executor`，以及 Mapper 接口是如何被代理的。



#### **附录 D：Spring AI 框架尝鲜 (未来技术)**

> *定位：拓展视野，让学生接触最新的 AI 开发模式（原第6章内容移入）。*


* **D01. 快速接入 OpenAI / 国产大模型**: `appendix/d01-spring-ai-quickstart.md`
* 内容：Spring AI 配置，ChatClient 使用，对接 DeepSeek/Qwen。


* **D02. 简单的 RAG 实现：让 AI 读懂教材**: `appendix/d02-simple-rag.md`
* 内容：向量数据库简介，实现“课程助教”问答机器人。



#### **附录 E：职业视野与资源库**

> *定位：从学校到职场的过渡，提供就业指导和参考资料。*

* **E01. 2024-2025 Java Web 开发全景研究报告**: `appendix/e01-industry-report.md`
* 内容：当前企业主流技术栈（Spring Cloud Alibaba, K8s 等）概览。


* **E02. 精选 Java Web 开源项目库**: `appendix/e02-opensource-projects.md`
* 内容：推荐 5-10 个适合练手的 Gitee/Github 项目（如若依 RuoYi 等），按难度分级。



---

### 💡 陈老师的特别建议 (关于 Tomcat 4)

您提到的 **"Tomcat 4 源码"** 是一个非常棒的切入点！

* **为什么是 Tomcat 4？** 现在的 Tomcat 10+ 代码太复杂，全是 NIO 和异步。而 Tomcat 4 是最经典的 **BIO 模型**，结构极其清晰（StandardServer -> Service -> Connector -> Engine -> Host -> Context -> Wrapper）。
* **怎么教？** 建议在 **C02** 节中，提供一个**“可以直接在 IDEA 里运行的 Tomcat 4 简化版 demo”**。
* **价值**：学生如果能断点调试一次 `socket.accept()` 到 `servlet.service()` 的过程，他对 Web 开发的理解将超越 90% 的应届生。

您觉得这个目录结构是否符合您的教学预期？如果确认，我们可以开始着手填充具体内容。