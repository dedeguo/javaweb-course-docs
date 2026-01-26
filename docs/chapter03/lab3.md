---
title: 实验3：构建标准化的 RESTful 后端系统
---

# 实验 3：构建标准化的 RESTful 后端系统

!!! abstract "实验信息"
    * **实验学时**：4 学时
    * **实验类型**：综合性
    * **截稿时间**：第XX 周周X XX:XX
    * **核心目标**：基于 **Spring Boot**，遵循 **三层架构** (Controller-Service-Dao) 编写一个符合大厂规范的 RESTful API 系统，并引入 **Lombok** 和 **全局异常处理**。

---

## 🧪 实验目的

1.  **框架入门**：熟练掌握 Spring Boot 项目的启动与注解配置 (`@SpringBootApplication`)。
2.  **架构设计**：深刻理解 **IOC** 与 **DI**，实现代码的分层解耦 (`@Autowired`, `@Service`).
3.  **接口规范**：能够设计符合 **RESTful** 风格的接口，并使用 **Result<T>** 统一响应格式。
4.  **健壮性**：掌握 `@RestControllerAdvice`，实现全局异常拦截，拒绝裸奔。
5.  **效率工具**：熟练使用 **Lombok** 消除样板代码。

---

## 📋 实验前准备

* [x] 已完成实验 1 (环境配置) 与实验 2 (JDBC基础)。
* [x] IDEA 已安装 **Lombok** 插件（新版 IDEA 默认集成，老版本需手动安装）。
* [x] 了解 HTTP 协议基础与 JSON 格式。

---

## 👣 实验步骤

### 任务一：获取骨架代码 (Fork & Clone)

为了统一规范，请基于老师提供的种子仓库开始。

1.  **Fork 仓库**：
    * 访问仓库：[https://gitee.com/javaweb-dev-tech/lab3](https://gitee.com/javaweb-dev-tech/lab3)
    * 点击 **「Fork」**，复制到你的 Gitee 账号下。
2.  **Clone 到本地**：
    * 在 IDEA 中使用 `Get from VCS` 克隆你的仓库。
    * **注意**：等待 Maven 自动下载依赖（观察右下角进度条），直到 `pom.xml` 不爆红。

### 任务二：构建实体与 Dao 层 (模拟数据)

**⚡️ AI 结对编程：Lombok 实体生成**

1.  **新建实体类**：在 `entity` 包下新建 `Book` 类。
2.  **AI 生成**：输入以下 Prompt 让 AI 帮你写代码：
    
    !!! quote "🤖 Prompt (复制给 AI)"
        请帮我写一个 Java 实体类 `Book`。  
        字段：id (Integer), title (String), author (String), price (Double)。  
        要求：使用 Lombok 的 `@Data`, `@NoArgsConstructor`, `@AllArgsConstructor` 注解简化代码。

3.  **编写 Dao 层**：在 `dao` 包下新建 `BookDao`。
    * *注：本实验暂时脱离数据库，使用静态 `Map` 模拟数据存储，重点练习分层架构。*
    * **代码参考**：
    
    ```java
    @Repository
    public class BookDao {
        // 模拟数据库：Key是ID，Value是书对象
        private static Map<Integer, Book> db = new ConcurrentHashMap<>();
        
        static {
            db.put(1, new Book(1, "Java编程思想", "Bruce Eckel", 99.0));
            db.put(2, new Book(2, "三体", "刘慈欣", 58.0));
        }
        
        // 请补充：getAll(), getById(), save(), delete() 等方法
        public List<Book> getAll() { return new ArrayList<>(db.values()); }
        // ...
    }
    ```

### 任务三：实现 Service 业务层

**要求**：严禁在 Controller 直接调 Dao！必须经过 Service。

1.  在 `service` 包下新建 `BookService`。
2.  使用 `@Service` 标记该类。
3.  使用 `@Autowired` (或构造器注入) 将 `BookDao` 注入进来。
4.  **业务逻辑要求**：
    * 在 `getById(Integer id)` 方法中，如果查不到数据（Dao 返回 null），请抛出一个自定义异常 `throw new RuntimeException("图书不存在");`。

### 任务四：实现 RESTful Controller

这是本次实验的核心。请在 `controller` 包下新建 `BookController`。

**⚡️ AI 结对编程：生成标准接口**

!!! quote "🤖 Prompt (复制给 AI)"
    我需要一个 `BookController`，基于 Spring Boot。  
    请帮我生成符合 RESTful 风格的 CRUD 接口代码：  
    1. 基础路径：`/books`  
    2. 查询所有：GET `/books`  
    3. 查询单个：GET `/books/{id}`  
    4. 新增图书：POST `/books` (接收 JSON)  
    5. 删除图书：DELETE `/books/{id}`  
    
    **重要要求**：  
    1. 不要直接返回 Bean，所有接口必须返回 `Result<T>` 统一封装类。  
    2. 使用 `@Autowired` 注入 `BookService`。  

**验收标准**：
你需要手动引入我们在课程中讲过的 `Result<T>` 工具类（放入 `common` 包），并确保 Controller 调用它。

> 📸 **截图 1**：启动项目，使用 Postman 或 浏览器 访问 `http://localhost:8080/books`，将返回的 JSON 数据截图，重命名为 `api_test.png`。

### 任务五：配置全局异常处理 (安全气囊)

刚才在 Service 层抛出的 `RuntimeException` 如果不处理，前端会收到 500 错误。

1.  在 `common` 包下新建 `GlobalExceptionHandler`。
2.  使用 `@RestControllerAdvice` 注解。
3.  编写 `@ExceptionHandler(Exception.class)` 方法，捕获异常，并返回 `Result.error("系统繁忙: " + e.getMessage())`。

> 📸 **截图 2**：访问一个不存在的 ID（如 `http://localhost:8080/books/999`），观察浏览器是否返回了统一的 JSON 错误提示（而不是 Whitelabel Error Page）。截图重命名为 `exception.png`。

---

## 💾 作业提交

### 1. 完善 README

打开 `README.md`，填写个人信息，并**用一句话回答**：
* 为什么我们在 Controller 和 Dao 之间非要加一层 Service？有什么好处？

### 2. 代码推送

```bash
# 1. 检查状态
git status

# 2. 提交代码 (记得替换姓名)
git add .
git commit -m "feat: 完成实验3-RESTful系统，学号+姓名"

# 3. 推送
git push

```

### 3. 最终核验

* [ ] Gitee 仓库中有完整的 `src` 代码。
* [ ] `img` 文件夹下有 `api_test.png` 和 `exception.png`。
* [ ] `README.md` 已更新。

---

## ❓ 常见问题 (FAQ)

**Q1: 注入失败，报错 `required a bean of type 'xxx' that could not be found`？**

> **A:** 99% 的原因是忘了加注解。
> * 检查 Dao 类头上有没有 `@Repository`。
> * 检查 Service 类头上有没有 `@Service`。
> * 检查启动类 `@SpringBootApplication` 是否在所有包的顶层（它只会扫描同级及子包）。
> 
> 

**Q2: 接口报 404？**

> **A:** 检查 Controller 头上有没有 `@RequestMapping("/books")`，以及启动日志中是否打印了 Mapping 映射路径。

**Q3: 新增图书时，接收到的对象属性全是 null？**

> **A:** 检查 Controller 的 `save` 方法参数前，是不是忘了加 **`@RequestBody`**！没有它，Spring 不会解析 JSON。
