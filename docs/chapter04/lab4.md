---
title: 实验 4：数据落地——从内存 Map 到 MySQL
---

# 实验 4：数据落地——从内存 Map 到 MySQL

!!! abstract "实验信息"
    * **实验学时**：4 学时
    * **实验类型**：综合性
    * **截稿时间**：第XX 周周X XX:XX
    * **核心目标**：移除实验 3 中的“假 Dao”层，整合 **MyBatis** + **MySQL**，并使用 **PageHelper** 实现带分页的模糊查询。

---

## 🧪 实验目的

1.  **真枪实弹**：彻底告别 `static Map`，实现数据的持久化存储（重启服务器数据不丢）。
2.  **ORM 实战**：掌握 **MyBatis** 的 XML 开发流程（Entity -> Mapper Interface -> XML）。
3.  **动态 SQL**：学会使用 `<if>` 和 `<where>` 标签实现多条件灵活搜索。
4.  **插件应用**：掌握 **PageHelper** 分页插件，解决海量数据展示问题。

---

## 📋 实验前准备

* [x] 已完成 [实验 3](../chapter03/lab3.md)（已有 BookController 和 BookService）。
* [x] 本地已安装 **MySQL** 数据库。
* [x] IDEA 已安装 **MyBatisX** 插件（强烈推荐，方便跳转）。

---

## 👣 实验步骤

### 任务一：准备数据库环境

我们不再用 Java 代码 `new Book(...)` 了，而是先在数据库建表。

1.  **连接数据库**：使用 Navicat 或 IDEA Database 工具连接你的 MySQL。
2.  **执行 SQL 脚本**：创建表并预置一些测试数据。

```sql
-- 1. 建表
DROP TABLE IF EXISTS t_book;
CREATE TABLE t_book (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '图书ID',
    title VARCHAR(100) NOT NULL COMMENT '书名',
    author VARCHAR(50) NOT NULL COMMENT '作者',
    price DECIMAL(10, 2) NOT NULL COMMENT '价格',
    stock INT DEFAULT 100 COMMENT '库存',
    publish_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书表';

-- 2. 插入测试数据 (多整点，方便测分页)
INSERT INTO t_book (title, author, price) VALUES 
('Java编程思想', 'Bruce Eckel', 108.00),
('深入理解Java虚拟机', '周志明', 99.00),
('Spring Boot实战', 'Craig Walls', 68.50),
('高性能MySQL', 'Baron', 128.00),
('三体', '刘慈欣', 38.00),
('活着', '余华', 25.00),
('百年孤独', '马尔克斯', 45.00);

```

### 任务二：引入“三剑客”依赖

修改 `pom.xml`，引入 MyBatis、数据库驱动和分页插件。

```xml
<dependencies>
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>3.0.3</version>
    </dependency>
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <scope>runtime</scope>
    </dependency>
    <!--   PageHelper 分页插件-->
    <dependency>
        <groupId>com.github.pagehelper</groupId>
        <artifactId>pagehelper-spring-boot-starter</artifactId>
        <version>2.1.0</version>
    </dependency>

</dependencies>

```

### 任务三：配置 application.properties

告诉 Spring Boot 数据库在哪里，以及 XML 文件存在哪里。

```properties
# === 数据库连接 ===
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost:3306/smart_book?serverTimezone=Asia/Shanghai&characterEncoding=utf-8&useSSL=false
spring.datasource.username=你的账号
spring.datasource.password=你的密码

# === MyBatis 配置 ===
# 别名包：XML 里可以直接写 "Book" 而不用写全路径
#mybatis.type-aliases-package=edu.wtbu.cs.javaweb.lab3.entity
# 打印 SQL：开发必备，方便调试
mybatis.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl
# XML 路径：非常重要！
mybatis.mapper-locations=classpath:mapper/*.xml

```

### 任务四：大清洗——重构 Dao 层

这是最关键的一步。我们需要**删除**之前的“假 Dao”，建立真正的 MyBatis Mapper。

1. **删除文件**：❌ 删除 `dao/BookDao.java` 类（那个用 Map 模拟的类）。
2. **新建接口**：✅ 在 `mapper` 包下新建接口 `BookMapper.java`。

```java
@Mapper // 👈 别忘了这个注解
public interface BookMapper {
    
    // 1. 根据 ID 查询
    Book selectById(Integer id);

    // 2. 复杂查询：支持根据书名模糊搜索
    // 如果 keyword 为 null，查所有；如果不为 null，查包含 keyword 的书
    List<Book> selectByCondition(String keyword);
    
    // 3. 新增
    int insert(Book book);
    
    // 4. 删除
    int deleteById(Integer id);
    
    // 5. 修改
    int update(Book book);
}

```

### 任务五：编写 XML 映射文件 (动态 SQL)

在 `src/main/resources` 下新建文件夹 `mapper`，并在其中新建 `BookMapper.xml`。

**⚡️ 挑战：使用 `<if>` 标签实现动态搜索**

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" 
"[http://mybatis.org/dtd/mybatis-3-mapper.dtd](http://mybatis.org/dtd/mybatis-3-mapper.dtd)">

<mapper namespace="com.example.lab3.mapper.BookMapper">

    <select id="selectById" resultType="Book">
        SELECT * FROM t_book WHERE id = #{id}
    </select>

    <select id="selectByCondition" resultType="Book">
        SELECT * FROM t_book
        <where>
            <if test="keyword != null and keyword != ''">
                AND title LIKE concat('%', #{keyword}, '%')
            </if>
        </where>
        ORDER BY id DESC
    </select>

    <insert id="insert" useGeneratedKeys="true" keyProperty="id">
        INSERT INTO t_book (title, author, price)
        VALUES (#{title}, #{author}, #{price})
    </insert>

    </mapper>

```

### 任务六：升级 Service 层 (分页黑科技)

修改 `BookService.java`，注入新的 Mapper，并加入分页逻辑。

```java
@Service
public class BookService {

    @Autowired
    private BookMapper bookMapper; // 注入接口，MyBatis 自动代理

    // 改造：增加分页参数 pageNum, pageSize
    public PageInfo<Book> getList(Integer pageNum, Integer pageSize, String keyword) {
        
        // 1. 开启分页 (魔法就在这一行)
        // PageHelper 会自动在下一条 SQL 后面拼接 LIMIT 语句
        PageHelper.startPage(pageNum, pageSize);
        
        // 2. 执行查询 (看起来是查所有，实际被拦截了)
        List<Book> list = bookMapper.selectByCondition(keyword);
        
        // 3. 封装分页结果 (包含 total, pages, list 等信息)
        return new PageInfo<>(list);
    }
    
    // ... 其他方法的调用也从 oldDao 改为 bookMapper
}

```

### 任务七：改造 Controller 接口

修改 `BookController.java` 的查询接口。

```java
@GetMapping
public Result<PageInfo<Book>> getList(
    @RequestParam(defaultValue = "1") Integer page,
    @RequestParam(defaultValue = "5") Integer size,
    @RequestParam(required = false) String keyword // 允许不传
) {
    PageInfo<Book> pageInfo = bookService.getList(page, size, keyword);
    return Result.success(pageInfo);
}

```

---

## 🤖 AI 辅助调试

如果遇到 XML 报错或 SQL 查不出数据，可以问 AI。

!!! question "让 AI 帮你找 XML 错误"
    **Prompt**:
    > "我正在运行 Spring Boot + MyBatis 项目，控制台报错：`Invalid bound statement (not found): com.example.mapper.BookMapper.selectByCondition`。
    > 请列出可能的原因（比如 namespace、xml路径配置等），并教我如何排查。"

---

## 💾 作业提交

### 1. 完善文档 (README)及验证截图

双击打开项目根目录的 `LAB4_README.md`，切换到“编辑模式”：

* 填写顶部的 **班级、姓名、学号**。
* 点击 IDEA 右上角的 `Preview` 按钮，检查刚才放入 `img` 文件夹的三张图片。在 `README.md` 中以下 **3 张截图**能在文档中正常显示：

    1. **数据库数据**：DataGrip/Navicat 中 `t_book` 表的数据截图。
    2. **无参分页**：浏览器访问 `http://localhost:8080/books?page=1&size=3`，截图 JSON 结果（应显示前 3 条，且 `total` 为 7）。
    3. **模糊搜索**：浏览器访问 `http://localhost:8080/books?keyword=Java`，截图 JSON 结果（应只显示带 "Java" 的书）。

### 2. 代码推送

```bash
git add .
git commit -m "feat: lab4 完成MyBatis集成与分页，学号+姓名"
git push

```

---

## ❓ 常见问题 (FAQ)

**Q1: 报错 `Invalid bound statement (not found)`？**

> **A:** 这是 MyBatis 最经典的错误！请检查三点：
> 1. `application.properties` 里的 `mybatis.mapper-locations` 路径写对了吗？
> 2. XML 里的 `namespace` 是否完全等于 Mapper 接口的全类名？
> 3. XML 里的 `id` 是否完全等于 Mapper 接口的方法名？
> 
> 

**Q2: 数据库连不上？**

> **A:** 检查 `application.properties` 里的 url、username、password。确保 openGauss 服务已启动。如果是在虚拟机里，确保防火墙放行了 5432 端口。

**Q3: 分页不起作用，查出了全部？**

> **A:** `PageHelper.startPage(...)` **必须** 紧贴着查询方法调用。如果中间隔了其他代码，或者查询方法没走 MyBatis，分页就会失效。
