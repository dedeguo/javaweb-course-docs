---
title: 接口规范：RESTful 风格与统一响应
---
# 3. 接口规范：RESTful 风格与统一响应

!!! quote "本节目标"
    在之前的学习中，我们的接口设计非常随性：  
    `http://localhost:8080/getUser?id=1`  
    `http://localhost:8080/deleteUser?id=1`
    
    这种“动词+名词”的 URL 设计在现代开发中被称为“野路子”。
    本节我们将学习全球通用的 **RESTful 风格**，并制定一套**统一响应标准**，让你的 API 看起来像大厂出品一样专业。

---

## 🌎 第一步：什么是 RESTful 风格？

**REST (Representational State Transfer)** 是一种软件架构风格。它的核心思想是：**把网络上的所有事物都看作“资源” (Resource)**。

### 1. 核心规则：看 URL 识意图

* **资源 (名词)**：URL 中**只包含名词**，表示你要操作什么资源。
* **动作 (动词)**：操作的类型由 **HTTP 请求方法** (GET/POST...) 决定，不要写在 URL 里。

### 2. 对比：野路子 vs RESTful

假设我们要操作“用户 (User)”资源：

| 操作类型 | ❌ 野路子写法 (URL 含动词) | ✅ RESTful 写法 (URL 纯名词) | HTTP 方法 |
| :--- | :--- | :--- | :--- |
| **查询**所有用户 | `/getAllUsers` | `/users` | **GET** |
| **查询**单个用户 | `/getUser?id=1` | `/users/1` | **GET** |
| **新增**用户 | `/addUser` | `/users` | **POST** |
| **修改**用户 | `/updateUser` | `/users` | **PUT** |
| **删除**用户 | `/deleteUser?id=1` | `/users/1` | **DELETE** |



### 3. Spring Boot 中的对应注解

Spring MVC 完美支持 RESTful，提供了与 HTTP 方法一一对应的注解：

* `@GetMapping`: 查询
* `@PostMapping`: 新增
* `@PutMapping`: 修改
* `@DeleteMapping`: 删除

---

## 🔧 第二步：参数接收的三种姿势

在 RESTful 风格中，参数的位置决定了我们用什么注解来接收。

### 1. 路径参数 (@PathVariable)
**场景**：参数是 URL 路径的一部分，通常用于 ID。
* URL: `/users/10`
* 注解: `@PathVariable`

```java
@GetMapping("/users/{id}") // {id} 是占位符
public User getById(@PathVariable Integer id) {
    return userService.getById(id);
}

```

### 2. 查询参数 (@RequestParam)

**场景**：传统的 `?key=value` 形式，通常用于分页、搜索条件。

* URL: `/users?page=1&size=10`
* 注解: `@RequestParam`

```java
@GetMapping("/users")
public List<User> getList(
    @RequestParam(defaultValue = "1") Integer page,
    @RequestParam(defaultValue = "10") Integer size
) {
    return userService.getList(page, size);
}

```

### 3. 请求体参数 (@RequestBody)

**场景**：提交复杂的 JSON 数据，通常用于新增或修改。

* URL: `/users` (Method: POST)
* Body: `{"name": "Jack", "age": 20}`
* 注解: `@RequestBody`

```java
@PostMapping("/users")
public User save(@RequestBody User user) {
    // Spring 会自动把 JSON 转成 User 对象
    return userService.save(user);
}

```

!!! warning "新人易错点"
    **`@RequestBody` 不能漏！**
    如果你前端传的是 JSON，而后端没加这个注解，你接到的 `User` 对象所有属性都会是 `null`。

---

## 📦 第三步：统一响应结构 (Result)

### 1. 为什么要统一响应？

如果前端收到的数据各式各样：

* 成功时返回一个 `User` 对象。
* 失败时返回一个字符串 `"查询失败"`。
* 报错时返回一堆 Tomcat 的错误日志。

前端工程师会崩溃的。我们需要约定一个**“通用的快递盒”**，无论成功失败，外包装格式永远一致。

### 2. 设计 Result<T> 类

一个标准的响应结构通常包含三个字段：

* **code**: 状态码 (200 成功, 500 失败)。
* **msg**: 提示信息 ("操作成功", "参数错误")。
* **data**: 真正的数据 (可能是对象，也可能是 List)。

```java title="Result.java (企业级通用模板)"
@Data // Lombok 生成 getter/setter
public class Result<T> {
    private Integer code; // 业务状态码
    private String msg;   // 提示信息
    private T data;       // 数据载体 (泛型)

    // 快速构建成功响应
    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.code = 200; // 约定 200 代表成功
        result.msg = "success";
        result.data = data;
        return result;
    }

    // 快速构建失败响应
    public static <T> Result<T> error(String msg) {
        Result<T> result = new Result<>();
        result.code = 500; // 约定 500 代表失败
        result.msg = msg;
        return result;
    }
}

```

### 3. 改造 Controller

现在，我们的接口不再返回裸数据，而是返回 `Result` 包装器。

```java
@RestController
@RequestMapping("/books")
public class BookController {

    @GetMapping("/{id}")
    public Result<Book> getBook(@PathVariable Integer id) {
        Book book = bookService.findById(id);
        if (book != null) {
            return Result.success(book);
        } else {
            return Result.error("未找到该图书");
        }
    }
}

```

**前端收到的 JSON：**

```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "id": 1,
    "title": "Java编程思想",
    "price": 99.0
  }
}

```

---
## 🤖 第四步：AI 辅助编程

RESTful 的增删改查（CRUD）代码非常模板化，这是 AI 最擅长的领域。

!!! question "让 AI 生成 CRUD 接口"
    **Prompt**:
    > "我有一个实体类 `Student` (id, name, age)。请基于 Spring Boot，帮我生成一个符合 RESTful 风格的 Controller 类。  
    > 要求：  
    > 1. 使用 `@RestController` 和 `@RequestMapping`。  
    > 2. 包含 增、删、改、查(单个)、查(列表) 5个接口。  
    > 3. 所有接口的返回值都使用 `Result<T>` 统一封装。  
    > 4. 使用 `@PathVariable` 和 `@RequestBody` 正确接收参数。"

---

## 📝 总结

1.  **RESTful 风格**：资源（名词）+ 动词（HTTP 方法）。
    * GET (查), POST (增), PUT (改), DELETE (删)。
2.  **注解三剑客**：
    * `@PathVariable`: 拿 URL 路径里的值 (`/users/1`)。
    * `@RequestParam`: 拿问号后面的值 (`?page=1`)。
    * `@RequestBody`: 拿 JSON 数据。
3.  **统一响应**：永远返回 `Result<T>`，让前后端沟通更顺畅。

**下一步**：
现在我们的接口外观已经非常漂亮了，但是代码全堆在 `Controller` 里（面条代码）。  
如何按照**“三层架构”**将业务逻辑解耦？如何利用 Lombok 消除样板代码？  
下一节，我们将学习 **架构设计：分层解耦与 Lombok 神器**。

[下一节：架构设计：分层解耦 (Controller-Service-Dao)](https://www.google.com/search?q=04-architecture.md){ .md-button .md-button--primary }
