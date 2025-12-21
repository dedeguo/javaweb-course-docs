### 📅 第二章：Web核心原理与Servlet实战

#### 1. 总体设计思路

* **由表及里**：先通过浏览器（HTTP）看现象，再通过Java（Servlet）看本质。
* **现代视角**：不讲过时的JSP页面渲染，直接引入JSON，确立“前后端分离”的数据交互意识。
* **AI 融合**：教会学生如何把看不见的HTTP协议，复制给AI去解释。

---

#### 2. MkDocs 目录结构规划

在你的 `docs` 目录下，建议新建 `chapter2` 文件夹。

```text
docs/
├── chapter2/
│   ├── 01-http-protocol.md      # 2.1 HTTP协议与开发者工具
│   ├── 02-servlet-basics.md     # 2.2 Servlet起步与生命周期
│   ├── 03-request-response.md   # 2.3 请求与响应对象详解 (Request/Response)
│   ├── 04-state-management.md   # 2.4 会话跟踪技术 (Cookie & Session)
│   ├── 05-filter-listener.md    # 2.5 过滤器与上下文 (Filter & ServletContext)
│   ├── 06-json-interaction.md   # 2.6 JSON与前后端交互
│   └── 07-comprehensive-lab.md  # 2.7 综合实验：用户登录与数据API
```

对应的 `mkdocs.yml` 配置：

```yaml
nav:
  - 第二篇｜Web 底层原理:   # Web核心与Servlet
      - 第2章 导读: chapter02/index.md
      - HTTP协议与开发者工具: chapter02/01-http-protocol.md
      - Servlet起步与生命周期: chapter02/02-servlet-basics.md    
      - 请求与响应对象详解: chapter02/03-request-response.md
      - 会话跟踪技术 (Cookie & Session): chapter02/04-state-management.md
      - 过滤器与上下文 (Filter & ServletContext): chapter02/05-filter-listener.md
      - JSON与前后端交互: chapter02/06-json-interaction.md
      - 实验2：用户登录与数据API: chapter02/lab2.md

```

建议将原来的“Servlet 核心”拆解，形成一个循序渐进的学习路径：

这是一个非常扎实的教学安排。对于“专升本”的学生来说，第二章是**分水岭**：他们将从“Java基础（SE）”跨越到“Web开发（EE）”。
这一章的核心教学目标应该是：**理解“请求-响应”模型**，并掌握Java如何处理这一模型。
我为你规划了第二章的详细大纲，不仅包含了传统的知识点，还融合了你强调的**AI辅助学习**路径，以及为后续Spring Boot打基础的**JSON处理**。
---

#### 3. 各小节详细内容规划 (Content Outline)

这里为你提供每一节的**核心知识点**、**难点解析**以及**AI 互动环节**的设计。

##### **2.1 HTTP协议图解 (The Language of Web)**

* **核心内容**：
* **BS架构**：浏览器与服务器的关系。
* **F12大法**：教会学生使用 Chrome DevTools 的 Network 面板（这是吃饭的家伙）。
* **请求（Request）**：
* 请求行（GET/POST的区别，URL传参 vs Body传参）。
* 请求头（User-Agent, Content-Type）。


* **响应（Response）**：
* 状态码（200 OK, 404 Not Found, 500 Internal Error, 405 Method Not Allowed）。
* MIME Type（这也是为后面返回JSON做铺垫）。


* **🤖 AI 互动时刻**：
> “复制一段浏览器抓包的 Raw HTTP 报文，发送给 AI，让它逐行解释每一行代表什么意思。”



##### **2.2 Servlet核心规范 (The Engine)**

* **核心内容**：
* **Hello Servlet**：快速实现一个 `extends HttpServlet`。
* **注解配置**：重点讲解 `@WebServlet`（不再重点讲 web.xml，除非为了讲历史）。
* **生命周期**：`init()` -> `service()` -> `destroy()`。重点讲 **单例多线程** 特性（这是很多学生的盲区）。
* **两大对象**：
* `HttpServletRequest`：怎么拿参数？(`getParameter`)
* `HttpServletResponse`：怎么回数据？(`getWriter().write`)




* **⚠️ 避坑指南**：
* 中文乱码问题（`setCharacterEncoding`），这是新手必坑，必须在教材里红字标出。



#### **2.3 请求与响应对象详解 (Request & Response)**

* **核心逻辑**：输入（Input）与输出（Output）。
* **HttpServletRequest (输入)**：
* **获取参数**：`getParameter()` (处理 URL/Form 表单) vs `getInputStream()` (处理 JSON/文件，**重点**)。
* **域对象 (Scope)**：Request 域的生命周期（一次请求）。
* **转发 (Forward)**：`getRequestDispatcher().forward()`，强调“服务器内部跳转，URL 不变”。


* **HttpServletResponse (输出)**：
* **回写数据**：`getWriter().write()`。
* **重定向 (Redirect)**：`sendRedirect()`，强调“客户端重新发起，URL 改变”。
* **响应头设置**：`setContentType("application/json;charset=utf-8")`。


* **🖼️ 图解建议**：
* 建议插入一张 **Forward vs Redirect** 的对比图，这是经典面试题也是易错点。



#### **2.4 会话跟踪技术 (Cookie & Session)**

* **核心逻辑**：HTTP 是无状态的，如何记住“我是谁”？
* **Cookie**：
* 客户端存储。
* **实战**：查看浏览器 F12 Application 面板中的 Cookies。


* **Session**：
* 服务器端存储。
* **原理**：`JSESSIONID` 的流转机制（这是核心考点）。
* **API**：`setAttribute()`, `getAttribute()`, `invalidate()`。


* **🤖 AI 思考题**：
> “现在的 App 和小程序开发常用 Token (JWT)，它和 Session 有什么区别？请 AI 助手用‘去澡堂洗澡’的例子打比方解释。”（Session 是前台登记表，Token 是手牌）。


#### **2.5 过滤器与上下文 (Filter & ServletContext)**

这一节是**架构思维**的启蒙。

* **ServletContext (全局上下文)**：
* **Scope**：整个 Web 应用只有一个，所有用户共享。
* **用途**：读取全局配置、读取资源文件 (`getResourceAsStream`)。


* **Filter (过滤器)**：
* **设计模式**：责任链模式 (Chain of Responsibility)。
* **必学场景 1 (解决乱码)**：`EncodingFilter`（虽然 Spring Boot 帮我们做了，但原理要懂）。
* **必学场景 2 (跨域 CORS)**：现代前后端分离必不可少，在这里讲 Filter 此时添加 `Access-Control-Allow-Origin` 头最合适。
* **必学场景 3 (登录拦截)**：判断 Session 是否存在，不存在则踢回登录页。

* **🖼️ 图解建议**：
* 插入一张 Filter Chain 的流程图：Request -> Filter1 -> Filter2 -> Servlet -> Response。


#### **2.6 JSON 与前后端交互**
（保持之前的规划，引入 Jackson/Fastjson，实现 Object 转 JSON String）

* **核心内容**：
* **为什么是 JSON**：对比 XML，强调 JSON 是现代 Web API 的标准。
* **Java Bean 与 JSON 的转换**：序列化（Object -> String）与反序列化（String -> Object）。
* **工具库引入**：推荐引入 **Jackson**（Spring Boot 默认）或 **Fastjson2**（阿里出品，国内流行）。
* **实操**：编写一个 Servlet，输出 `Content-Type: application/json`，并返回一个学生对象的 JSON 字符串。

* **🤖 AI 互动时刻**：
> “给 AI 一个复杂的 Java 类，让它自动生成对应的 JSON 示例数据；或者反过来，给 JSON 让 AI 生成 Java 类。”


#### **2.7 综合实验：简易用户管理系统**

将上述知识点串联起来。

* **功能设计**：
1. **登录 API**：接收 JSON 账号密码 -> 校验 -> 存入 `Session`。
2. **过滤器**：拦截 `/api/user/*` 开头的请求，检查 `Session`，未登录返回 401。
3. **查询 API**：登录后才能访问，从 `ServletContext` 或模拟数据库获取用户列表，返回 JSON。







### 4. 这里的教学逻辑亮点（供参考）

1. **弱化 JSP，强化 API**：
传统的教材第二章通常会讲 JSP 语法。我建议**完全跳过或仅作为了解**。直接教 Servlet 输出 JSON。这样学生在学到 Vue/React 或后面做毕设时，思维是无缝衔接的（前后端分离）。
2. **工具先行**：
在讲 HTTP 时，不是死记硬背，而是教他们看 **Network 面板**。在讲接口时，教他们用 **Postman/Apifox**。这是职业教育的特点——重工具、重实战。
3. **AI 作为“翻译官”**：
初学者很难理解 HTTP 报文和 Java 代码的对应关系。你可以引导学生：“把这行 Java 代码 `response.setStatus(404)` 发给 AI，问它这会通过 HTTP 协议告诉浏览器什么？”



---

### 💡 针对“专升本”学生的教学话术建议

1. **关于 Request/Response**：
* 不要只讲 API。要强调：**Request 就是 HTTP 请求报文的 Java 包装类**，**Response 就是 HTTP 响应报文的 Java 包装类**。你操作对象，Tomcat 帮你生成报文。


2. **关于 Context (上下文)**：
* 可以用“共享白板”做比喻：Request 是你那张纸（只有你自己看，一次性的），Session 是你的储物柜（只有你能打开，长期的），ServletContext 是教室黑板（全班都能看）。


3. **关于 Filter**：
* 比喻成“安检门”。进地铁（Servlet）之前，必须先过安检（Filter）。安检可以拒绝你进入（拦截），也可以给你的包贴个标签（修改请求）。



### 🚀 下一步 你现在可以做什么？

1. **撰写 2.1 节** 关于 HTTP 协议结合 Chrome Network 面板的 Markdown 草稿。
2. 或者，为你生成 **2.4 节实战 Demo** 的完整代码（包含 `pom.xml` 和 Servlet 代码）。

你需要哪一个？
