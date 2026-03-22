---
title: 09. 综合实战：基于 Servlet 的图书管理 CRUD
---

# 09. 综合实战：基于 Servlet 的图书管理 CRUD 详解

!!! quote "☕ 课前导语：是时候大显身手了！"
    前面我们零碎地学习了 Tomcat 原理、Servlet 接收请求、JSP 渲染页面以及 MyBatis 查数据库。这就好比我们分别学会了切菜、生火和调味。
    
    今天，我们将把这些招式融会贯通，做出一道真正的大菜：**SmartBook 系统的核心功能 —— 图书的增删改查 (CRUD)**。
    我们将剖析课程案例仓库中的前端页面（`book.jsp`、`book_form.jsp`）和后端调度中心（`BookServlet`），带你真正感受经典的 **MVC 架构** 是如何完美运转的！

> 📌 **本节源码位置**：老师已将完整的 Demo 提交到代码仓库。
> 后端核心代码 👉 [点击查看 BookServlet.java](https://gitee.com/javaweb-dev-tech/course-demo-servlet/blob/master/src/main/java/edu/wtbu/cs/coursedemoservlet/BookServlet.java)

---

## 🏛️ 一、大局观：MVC 架构与“餐厅运转指南”

在真正写代码之前，我们必须先理解什么是 **MVC 设计模式**。
在我们的图书管理模块中，如果把整个 Web 应用比作一家**豪华餐厅**：

1. **V (View - 视图层)**：前端的 `book.jsp` 和 `book_form.jsp`。
    * **角色**：餐厅的菜单和精美的摆盘。负责把数据漂亮地展示给用户，并接收用户的点击和输入。
2. **C (Controller - 控制层)**：后端的 `BookServlet.java`。
    * **角色**：餐厅的大堂经理。负责在前台（JSP）和后厨（数据库）之间来回传话、分配任务。
3. **M (Model - 模型层)**：我们的 `Book` 实体类和 `BookDao/BookMapper`。
    * **角色**：餐厅的后厨和仓库。负责真正地去数据库里炒菜（增删改查数据）。

---

## 🎨 二、前端页面大揭秘 (View)

我们为图书模块准备了两个 JSP 页面。为什么要两个？因为**“展示列表”**和**“填写表单”**是完全不同的交互场景。

### 1. 列表展示页：`book.jsp`
这是用户进店看到的第一眼：一个包含所有图书的表格。

**核心逻辑解析：**

* **JSTL 循环展示**：页面里没有死板的假数据，而是使用了 `<c:forEach>` 标签，遍历大堂经理（Servlet）送过来的 `bookList`，并用 EL 表达式 `${book.title}` 把书名、作者等信息填到表格里。  
* **暗藏玄机的按钮**：每一行数据的末尾，都有“编辑”和“删除”按钮。它们的本质是超链接，**并在网址后面悄悄带上了这本书的身份证号（ID）**！  
  ```html
  <a href="book?action=toEdit&id=${b.id}" class="btn btn-edit">编辑</a>
  <a href="book?action=delete&id=${b.id}" class="btn btn-del" onclick="return confirm('确定删除吗？')">删除</a>
  ```

### 2. 添加与修改页：`book_form.jsp`
这是一个神奇的页面！**新增图书**和**修改图书**，用的其实是同一个 JSP 文件！它是怎么做到的？

**核心逻辑解析：**

* **智能的表单回显**：如果 Servlet 传过来了一个 `book` 对象，EL 表达式 `${book.title}` 就会把旧数据填进输入框（这就是修改）；如果没有传，输入框就是空的（这就是新增）。
* **表单的动态提交路径**：根据有没有传过来 `book` 对象，表单提交的 `action` 也会自动变化。
  ```html
  <form action="book?action=${empty book ? 'add' : 'update'}" method="post">
      
      <input type="hidden" name="id" value="${not empty book ? book.id : ''}" />
      
      书名：<input type="text" name="title" value="${book.title}" />
      <button type="submit">保存</button>
  </form>
  ```
* **隐形的魔法（隐藏域）**：这是整个页面最关键的一行代码！  
  ```html
  <input type="hidden" name="id" value="${book != null ? book.id : ''}" />
  ```
  **为什么需要隐藏域？** 当用户修改完书名点击“保存”时，后端只收到一个书名是没用的，必须知道要修改**哪一本书**。隐藏域就是为了把图书的 ID 悄悄传给后端！

---

## 🧠 三、中枢神经：BookServlet (Controller)

到了最激动人心的后端环节。在以前，有些初学者会写 5 个 Servlet（比如 `AddServlet`、`DeleteServlet` 等）。这太啰嗦了！

现在，我们只用一个 `@WebServlet("/book")`，通过接收前端传来的 **`action` 参数**，来决定大堂经理要分配什么任务。

### 1. 路由分发中心
在 `BookServlet` 的 `service`（或 `doGet/doPost`）方法中，我们第一步就是获取 `action`：
```java
String action = request.getParameter("action");
if (action == null) {
    action = "list"; // 默认动作是查询列表
}

// 根据 action 指令，调用不同的处理方法 (这就是框架底层路由的雏形！)
switch (action) {
            case "list":
                list(req, resp);
                break;
            case "add":// 点击“新增”按钮，跳转到空白表单页
                add(req, resp);
                break;
            case "delete":// 点击“删除”按钮时触发
                delete(req, resp);
                break;
            case "toEdit": //点击“编辑”按钮，带着旧数据跳转到表单页
                toEdit(req, resp);
                break;
            case "update": // 提交修改
                update(req, resp);
                break;
}
```

### 2. CRUD 动作全解析

大堂经理（BookServlet）在分配完任务后，具体是怎么干活的呢？

* **📖 查 (List)**：`list`
    * 去后厨（Dao 层）把所有图书捞出来：`List<BookEntity> books = bookDao.findAll();`
    * **塞入包裹**：`req.setAttribute("books", books);`
    * **请求转发 (Forward)** 给 `book.jsp` 让它去摆盘展示。

* **🗑️ 删 (Delete)**：`delete`
    * 拿到前端超链接传来的 ID：`Long id = Long.valueOf(req.getParameter("id"));`
    * 叫后厨销毁这本书：`bookDao.delete(id);`
    * **重定向 (Redirect)** 到列表页，让页面刷新！

* **✏️ 改与增 (ShowForm & Save)**

    * 当 action 是 `edit` 时，先根据 ID 查出这本书，塞进 request，转发给 `book_form.jsp` 做**数据回显**。
    * 当用户在表单里填好数据点击提交（`action=update`）时，Servlet 拿到所有输入框的值组装成一个 `Book` 对象。
    * **判断玄机**：检查隐藏域里传来的 `id`。如果 `id` 为空，说明是**新增**，调用 `bookDao.insert(book)`；如果 `id` 有值，说明是**修改**，调用 `bookDao.update(book)`。

---

## 💥 四、避坑指南：转发与重定向的生死抉择

在 `BookServlet` 的源码中，你会发现一个非常奇妙的现象：

* 凡是**查询数据跳转到 JSP 页面**（如 `list`, `toEdit`），用的都是：
  `request.getRequestDispatcher("book.jsp").forward(request, response);`
* 凡是**对数据库做了修改（增、删、改）**（如 `add`, `update`, `delete`），用的都是：
  `response.sendRedirect("book?action=list");`

!!! warning "高能预警：为什么要区别对待？"
    如果在 `add` 成功后，也使用 `forward` 直接跳到 `book.jsp`，你会发现网址栏依然停留在 `book?action=add`。
    此时如果用户手贱**按了一下 F5 刷新网页**，浏览器就会再次发送一次 `add` 请求，导致**数据库里被插入了两本一模一样的书**（表单重复提交 Bug）！
    
    **铁律：只要改变了数据库的状态（增、删、改），最后一步绝对不能用转发，必须用 `sendRedirect` 重定向到查询列表！**（这在行业内被称为 **PRG 模式**：Post-Redirect-Get）。

---

## 🚀 五、总结

在这堂实战课中，我们体验了一个标准 Web 功能的完整生命周期。  
前端发出指令 `?action=xxx` 👉 `Servlet` 识别指令并联系数据库 👉 数据库返回结果 👉 `Servlet` 将结果塞进 request 👉 `JSP` 渲染出华丽的页面。

虽然我们现在写 `Servlet` 还要手动处理烦人的 `request.getParameter()` 和路由分发，但在不久的将来，当我们引入 **Spring Boot** 之后，这些啰嗦的代码将会被瞬间简化。不过，正因为有了今天在泥泞中手写 Servlet 的经历，未来你才能真正看懂 Spring 框架那华丽魔法背后的本质！
