# 实验 3-1：SpringBoot RESTful API 开发 —— AI 辅助编码实战

!!! abstract "实验信息"
    * **实验学时**：2 学时
    * **实验类型**：演示性 + 设计性
    * **核心目标**：使用 AI 辅助工具，完成 Spring Boot + MyBatis 分层架构下的 RESTful API 开发。先跟随教师完成**学生模块 CRUD**（课件演示），再独立完成**图书模块 CRUD**（仿写实验）。

---

## 🧪 实验目的

1. **AI 辅助全流程开发**：掌握使用 AI 生成 SQL 建表语句、实体类、Mapper、Service、Controller 的完整工作流。
2. **Spring Boot 分层架构**：深刻理解 Controller → Service → Mapper（Dao）三层调用关系。
3. **RESTful API 设计**：掌握 `@GetMapping`、`@PostMapping`、`@PutMapping`、`@DeleteMapping` 注解的标准用法。
4. **MyBatis 整合**：理解 Mapper 接口与 XML 映射文件的绑定关系，掌握 `@Mapper` 注解。
5. **接口测试**：熟练使用 IDEA HTTP Client 或 Postman 进行 API 测试。
6. **模式迁移能力**：能够在理解一个模块后，独立将模式应用到另一个模块。

---

## 📋 实验前准备

* [x] 已完成实验 2（Servlet 与 JDBC 基础），具备数据库操作能力。
* [x] 本地 MySQL 已启动，并通过 IDEA Database 面板或 Navicat 连接。
* [x] 已了解 Spring Boot 快速入门（[01-springboot-start.md](01-springboot-start.md)）。
* [x] 已了解 RESTful API 设计规范（[03-restful-api.md](03-restful-api.md)）。
* [x] 已了解三层架构设计（[04-architecture.md](04-architecture.md)）。

---

## 👣 实验步骤

---

### 第一阶段：课件演示 —— Student 模块 CRUD（跟随教师）

教师课堂演示，学生**同步跟随操作**。此阶段的目标是理解 AI 辅助开发的标准流程，为后续独立仿写打下基础。

---

#### 步骤 1：AI 生成 SQL 建表语句与测试数据

在 IDEA 中打开 AI 助手（通义灵码 / DeepSeek / Trae），输入以下 Prompt：

!!! quote "🤖 Prompt（提示词）"
    请帮我生成一段 MySQL 建表 SQL。
    表名：`student`
    字段要求：
    1. id：主键，自增，INT 类型
    2. name：学生姓名，VARCHAR(50)，非空
    3. age：年龄，INT
    4. major：专业，VARCHAR(100)
    
    另外，请生成 5 条插入测试数据的 INSERT 语句。

1. 复制 AI 生成的 SQL，在 Navicat 或 IDEA Database Console 中执行。
2. 验证表已创建且数据已插入。

!!! success "📸 截图 1（提交物）"
    Navicat 中 student 表数据预览截图，重命名为 `student_table.png`。

---

#### 步骤 2：AI 生成 Student 实体类

!!! quote "🤖 Prompt（提示词）"
    请根据 student 表（字段：id, name, age, major），帮我生成一个 Student 实体类。
    要求：
    1. 使用 Lombok 的 @Data、@NoArgsConstructor、@AllArgsConstructor 注解
    2. 包路径：edu.wtbu.cs.demo.entity
    3. 类名：Student

将生成的代码放入 `entity/Student.java`。

---

#### 步骤 3：AI 生成 StudentMapper 接口与 XML 映射文件

!!! quote "🤖 Prompt（提示词）"
    请帮我生成 Student 模块的 MyBatis Mapper。
    1. StudentMapper 接口（包路径：edu.wtbu.cs.demo.mapper），使用 @Mapper 注解
    2. StudentMapper XML 映射文件（路径：resources/mapper/StudentMapper.xml）
    3. 实现以下方法：
       - List<Student> selectAll()：查询所有学生
       - Student selectById(Integer id)：根据 ID 查询
       - int insert(Student student)：新增学生
       - int update(Student student)：更新学生
       - int delete(Integer id)：删除学生
    4. 注意数据库字段 student_id 和 Java 属性 studentId 的驼峰映射

将生成的代码分别放入 `mapper/StudentMapper.java` 和 `resources/mapper/StudentMapper.xml`。

!!! tip "application.properties 配置"
    确保你的 `application.properties` 中已配置 MyBatis：
    ```properties
    mybatis.mapper-locations=classpath:mapper/*.xml
    mybatis.type-aliases-package=edu.wtbu.cs.demo.entity
    mybatis.configuration.map-underscore-to-camel-case=true
    ```

---

#### 步骤 4：AI 生成 StudentService

!!! quote "🤖 Prompt（提示词）"
    请帮我生成 StudentService 类。
    1. 包路径：edu.wtbu.cs.demo.service
    2. 使用 @Service 注解
    3. 使用 @Autowired 注入 StudentMapper
    4. 实现 CRUD 方法，调用 StudentMapper 的对应方法
    5. 在 selectById 中，如果 ID 不存在，抛出 RuntimeException("学生不存在")

将生成的代码放入 `service/StudentService.java`。

---

#### 步骤 5：AI 生成 StudentController —— RESTful API

这是本实验的核心产出。请输入以下 Prompt：

!!! quote "🤖 Prompt（提示词）"
    请帮我生成 StudentController 类。
    1. 包路径：edu.wtbu.cs.demo.controller
    2. 使用 @RestController 和 @RequestMapping("/api/students") 注解
    3. 使用 @Autowired 注入 StudentService
    4. 实现以下 RESTful API：

    | HTTP 方法 | 路径                  | 功能说明   |
    |-----------|----------------------|----------|
    | GET       | /api/students         | 查询所有学生 |
    | GET       | /api/students/{id}    | 根据ID查询 |
    | POST      | /api/students         | 新增学生   |
    | PUT       | /api/students/{id}    | 更新学生   |
    | DELETE    | /api/students/{id}    | 删除学生   |

    5. 所有接口返回 Result<T> 统一封装类（success/message/data）
    6. POST 和 PUT 接口使用 @RequestBody 接收 JSON

将生成的代码放入 `controller/StudentController.java`。

!!! warning "自查清单"
    - [ ] Controller 上有 `@RestController` 和 `@RequestMapping` 吗？
    - [ ] 增删改查分别匹配了 `@PostMapping`、`@DeleteMapping`、`@PutMapping`、`@GetMapping` 吗？
    - [ ] POST/PUT 参数前有 `@RequestBody` 吗？
    - [ ] 返回的是 `Result<T>` 而不是裸 Bean 吗？

---

#### 步骤 6：接口测试

##### 方式一：IDEA HTTP Client（推荐）

在项目根目录新建 `http` 文件夹，创建 `student_api.http` 文件：

!!! quote "🤖 Prompt（提示词）"
    请帮我生成 Student 模块的 API 接口测试文件（.http 格式），包含以下测试用例：
    1. 查询所有学生 GET /api/students
    2. 根据ID查询 GET /api/students/1
    3. 新增学生 POST /api/students（Body 为 JSON）
    4. 更新学生 PUT /api/students/1（Body 为 JSON）
    5. 删除学生 DELETE /api/students/1
    使用变量 {{baseUrl}} = http://localhost:8080

在 IDEA 中，点击每个请求旁的绿色运行按钮执行测试。

##### 方式二：Postman

如果使用 Postman，请手动创建以上 5 个请求，按顺序执行。

!!! success "📸 截图 2（提交物）"
    接口测试结果截图（5 个接口均返回 200），重命名为 `student_api_test.png`。

---

### 第二阶段：仿写实验 —— Book 模块 CRUD（独立完成）

你现在已经掌握了 AI 辅助开发的完整流程。接下来，**仿照 Student 模块的模式**，独立完成 Book 模块的 CRUD 开发。

!!! info "核心原则"
    **把发给 AI 的指令中的类名从 Student 换成 Book，字段从 name/age/major 换成 title/author/isbn/price**，其余流程完全一致。

---

#### 步骤 7：AI 生成 Book 模块 SQL

!!! quote "🤖 Prompt（提示词）"
    请帮我生成一段 MySQL 建表 SQL。
    表名：`book`
    字段要求：
    1. id：主键，自增，INT 类型
    2. title：书名，VARCHAR(200)，非空
    3. author：作者，VARCHAR(100)
    4. isbn：ISBN编号，VARCHAR(20)，唯一
    5. price：价格，DECIMAL(10,2)
    
    另外，请生成 5 条插入测试数据的 INSERT 语句。

执行 SQL，验证数据。

!!! success "📸 截图 3（提交物）"
    Navicat 中 book 表数据预览截图，重命名为 `book_table.png`。

---

#### 步骤 8：AI 生成 Book 实体类、Mapper、Service、Controller

**仿照 Student 模块的 Prompt 结构**，依次生成以下文件：

| 文件 | 位置 | 说明 |
|------|------|------|
| `Book.java` | `entity/` | 实体类（Lombok 注解） |
| `BookMapper.java` | `mapper/` | Mapper 接口（@Mapper） |
| `BookMapper.xml` | `resources/mapper/` | XML 映射文件 |
| `BookService.java` | `service/` | 业务层（@Service） |
| `BookController.java` | `controller/` | RESTful API（@RestController） |

**Book 模块接口规范**（与 Student 保持一致）：

| HTTP 方法 | 路径                | 功能说明   |
|-----------|--------------------|----------|
| GET       | `/api/books`        | 查询所有图书 |
| GET       | `/api/books/{id}`   | 根据ID查询 |
| POST      | `/api/books`        | 新增图书   |
| PUT       | `/api/books/{id}`   | 更新图书   |
| DELETE    | `/api/books/{id}`   | 删除图书   |

!!! warning "注意"
    * 发给 AI 的 Prompt 中，**所有 `Student`/`student`/`students` 替换为 `Book`/`book`/`books`**。
    * 字段名从 `name/age/major` 替换为 `title/author/isbn/price`。

---

#### 步骤 9：Book 模块接口测试

仿照步骤 6，创建 `book_api.http` 测试文件（或使用 Postman），测试 5 个接口。

!!! success "📸 截图 4（提交物）"
    Book 模块接口测试结果截图（5 个接口均返回 200），重命名为 `book_api_test.png`。

---

## 🚀 挑战任务（Optional - 加分项）

### 挑战 A：参数校验

为 Book 模块的新增和更新接口添加 `@Valid` 参数校验：
- 书名不能为空
- ISBN 格式校验
- 价格必须 > 0

### 挑战 B：分页查询

修改 `GET /api/books` 接口，支持分页参数 `page` 和 `size`，返回分页结果（总条数、当前页数据）。

### 挑战 C：条件搜索

新增 `GET /api/books/search` 接口，支持按书名模糊搜索、按作者筛选。

---

## 📝 实验报告要求

学习通提交的实验报告需包含以下内容：

| 序号 | 内容 | 说明 |
|------|------|------|
| 1 | **AI 对话截图** | 与 AI 对话生成 Student 和 Book 模块代码的截图 |
| 2 | **SQL 建表语句** | student 表和 book 表的完整建表 SQL |
| 3 | **SQL 测试数据** | 插入测试数据的 INSERT 语句 |
| 4 | **核心代码** | Book 模块的实体类、Mapper 接口/XML、Service、Controller 完整代码 |
| 5 | **接口测试截图** | IDEA HTTP Client 或 Postman 中 5 个接口的测试结果截图 |

---

## 💾 作业提交

### 提交内容

1. **完整项目代码**（包含 Student 模块和 Book 模块的全部实现）。
2. **截图文件**，放入 `img` 目录：

    | 文件名 | 内容说明 |
    |--------|----------|
    | `student_table.png` | student 表数据预览 |
    | `student_api_test.png` | Student 模块 5 个接口测试结果 |
    | `book_table.png` | book 表数据预览 |
    | `book_api_test.png` | Book 模块 5 个接口测试结果 |

### 学习通提交

* 将项目压缩为 ZIP 上传至学习通对应作业入口。
* 实验报告（Word/PDF）需包含上述 5 项内容。

---

## ❓ 常见问题（FAQ）

**Q1：Mapper XML 找不到，报错 `Invalid bound statement`？**

> **A：** 检查以下几点：
> - `application.properties` 中 `mybatis.mapper-locations` 路径是否正确（注意是 `classpath:mapper/*.xml`）。
> - Mapper XML 文件是否放在了 `src/main/resources/mapper/` 目录下。
> - Mapper XML 中的 `namespace` 是否与 Mapper 接口的全限定名一致。

**Q2：POST 新增时，接收到的对象属性全是 null？**

> **A：** 检查 Controller 方法参数前是否加了 `@RequestBody` 注解。没有它，Spring 不会解析请求体中的 JSON。

**Q3：IDEA HTTP Client 怎么用？**

> **A：** 
> 1. 在项目根目录新建 `http` 文件夹。
> 2. 新建 `.http` 文件，写入请求内容（如 `GET http://localhost:8080/api/students`）。
> 3. 点击行号旁的绿色运行按钮即可执行。

**Q4：发给 AI 的 Prompt 不生效，生成的代码不对？**

> **A：** 
> - 把 Prompt 写得更具体：字段名、表名、包路径都要明确。
> - 分步骤发送 Prompt：先建表，再实体类，再 Mapper，再 Service，最后 Controller。
> - 如果某一步不满意，追加修正指令，如 "请把 insert 方法的返回值改成 int"。

---

## 📚 相关资源

* [Spring Boot 快速入门](01-springboot-start.md)
* [IOC 容器与依赖注入](02-ioc-di.md)
* [RESTful API 设计规范](03-restful-api.md)
* [三层架构设计](04-architecture.md)
* [👉 实验 3：构建标准化的 RESTful 后端系统](lab3.md)（本章综合实验）