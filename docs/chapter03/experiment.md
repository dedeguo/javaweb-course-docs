# 实验3：航班查询 API 

---

## 📂 目录结构建议

```yaml
- 第三篇｜Spring Boot 核心与 RESTful API:
    - 第3章 导读: chapter03/index.md
    - 01. 框架革命：Spring Boot 快速入门      # 对比 Servlet，感受“自动装配”的魔力
    - 02. 核心原理：IOC 容器与依赖注入 (DI)     # 难点：通过“管家”的比喻讲清楚控制反转
    - 03. 接口规范：RESTful 风格与统一响应      # 重点：@GetMapping, @PathVariable, Result<T>
    - 04. 架构设计：分层解耦 (Controller-Service-Dao) # 工程化：代码怎么放才不乱
    - 05. 全局兜底：异常处理与 AOP 简介        # 实战：@RestControllerAdvice
    - 实验 3：构建标准化的 RESTful 后端系统     # 综合实战

```

---

## ⏱️ 详细课时安排 (8 学时)

### 第一讲：Spring Boot 启航与 IOC 思想 (2 学时)

* **目标**：跑通第一个 Spring Boot 应用，理解“对象不再由我 new，而是由 Spring 给”。
* **核心内容**：
1. **痛点回顾**：Servlet 需要配置 `web.xml`、Tomcat 版本不兼容、依赖冲突等噩梦。
2. **Hello Spring Boot**：
* 利用 IDEA Spring Initializr 快速创建项目。
* 解释 `pom.xml` 中的 `spring-boot-starter-parent`（父工程管理依赖）。
* 解释 `@SpringBootApplication`（启动类的作用）。


3. **IOC (控制反转) 与 DI (依赖注入)**：
* **比喻**：以前吃饭要自己买菜做饭 (new Object)，现在去餐厅点菜，后厨直接端给你 (@Autowired)。
* **注解实战**：`@Component` (注册Bean) 与 `@Autowired` (注入Bean)。




* **AI 辅助点**：让 AI 解释“什么是控制反转”，并生成一段 `@Autowired` 的示例代码。

### 第二讲：RESTful 接口设计与规范 (2 学时)

* **目标**：不仅会写接口，还要写出**符合大厂规范**的接口。
* **核心内容**：
1. **RESTful 风格**：
* 动词对应：GET(查), POST(增), PUT(改), DELETE(删)。
* 路径参数：`/users/{id}` (使用 `@PathVariable`)。


2. **Spring MVC 常用注解**：
* `@RequestMapping` vs `@GetMapping`。
* `@RequestParam` (URL参数) vs `@RequestBody` (JSON参数)。


3. **统一响应结构 (Result<T>)**：
* **痛点**：不能直接返回 `Student` 对象，要返回 `{ code: 200, msg: "success", data: {...} }`。
* **实战**：手写一个泛型 `Result` 类。




* **AI 辅助点**：输入实体类，让 AI 生成一套标准的 RESTful 接口定义（Controller 层代码）。

### 第三讲：三层架构与 Lombok 神器 (2 学时)

* **目标**：告别“所有代码写在 Controller 里”的也就是面条代码，掌握分层解耦。
* **核心内容**：
1. **三层架构拆解**：
* **Controller (表现层)**：只负责收参数、校验、返回 Result。
* **Service (业务层)**：核心逻辑（如：转账判断余额、库存扣减）。
* **Dao/Mapper (持久层)**：只负责 SQL 交互（本章暂用模拟数据或 JDBCUtils）。


2. **Lombok 插件**：
* 引入 `lombok` 依赖。
* 注解：`@Data` (getter/setter/toString), `@Builder` (链式构建), `@Slf4j` (日志)。


3. **实战重构**：将上一章的 `LoginServlet` 重构为 `LoginController` -> `UserService` -> `UserDao`。



### 第四讲：全局异常处理与综合实战 (2 学时)

* **目标**：给系统装上“安全气囊”，无论发生什么错误，都能返回优雅的 JSON。
* **核心内容**：
1. **全局异常处理**：
* 使用 `@RestControllerAdvice` 和 `@ExceptionHandler`。
* 捕获 `Exception`，返回 `{ code: 500, msg: "系统繁忙" }`，而不是满屏的堆栈信息。


2. **AOP (面向切面) 概念引入** (选讲)：
* 简单演示如何打印所有接口的耗时（不深究原理，只看效果）。


3. **实验 3 启动与讲解**。



---

## 🧪 实验 3 设计预览

**实验名称**：构建标准化的 RESTful 后端系统

**场景**：开发一个简单的“图书管理系统 (Library API)”后端。

**任务**：

1. **环境**：Spring Boot 3.x + JDK 17。
2. **依赖**：Lombok, Spring Web。
3. **需求**：
* 设计 `Book` 实体 (id, name, author, price)。
* 实现 **Controller-Service-Dao** 三层架构。
* 完成 **CRUD 接口**：
* `POST /books` (新增图书)
* `GET /books/{id}` (查询单本)
* `PUT /books` (修改信息)
* `DELETE /books/{id}` (删除图书)


* **统一规范**：所有接口必须返回 `Result<T>` 格式。
* **异常拦截**：当查询 ID 不存在时，抛出自定义异常 `BusinessException`，并被全局拦截器捕获，返回特定错误码。



**AI 结合点**：

* Prompt: *"我是后端开发新手，请帮我检查我的 Controller 代码是否符合 RESTful 规范？"*
* Prompt: *"请帮我生成一个基于 Spring Boot 的全局异常处理类，能够捕获 NullPointerException 并返回 JSON。"*

---

陈老师，这个规划是否符合您的预期？如果没问题，我可以开始为您撰写 **`01-springboot-start.md`** 的正文。