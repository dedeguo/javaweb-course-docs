---
title: 告别 JDBC 泥潭：MyBatis 初体验
---

# 08. 告别 JDBC 泥潭：MyBatis 初体验

!!! quote "🎓 本节目标：从“手工搬砖”到“半自动化生产线”"
    在上一节中，我们学习了 JDBC 和 Druid 连接池。虽然连接池解决了性能问题，但你写代码时一定感到非常痛苦：
    不断地 `setString()` 设置参数，再不断地 `rs.getString()` 把结果一行行塞进 Java 对象里。

    如果有 100 个字段，难道要写 100 行 `get/set` 吗？
    今天，我们将引入 Java Web 开发的绝对霸主 —— **MyBatis** 框架，看看它是如何把我们从 JDBC 的泥潭中拯救出来的。

---

## 😫 第一步：认清 JDBC 的痛点

在没有 MyBatis 之前，我们查询一个用户通常是这样写的：

```java
// ❌ 传统 JDBC 的繁琐日常
String sql = "SELECT id, username, password FROM t_user WHERE id = ?";
PreparedStatement ps = conn.prepareStatement(sql);
ps.setInt(1, 1); // 痛点1：手动设置参数，容易数错问号

ResultSet rs = ps.executeQuery();
User user = null;
if (rs.next()) {
    user = new User();
    // 痛点2：手动提取结果并封装，极其枯燥且容易把列名拼错
    user.setId(rs.getInt("id"));
    user.setUsername(rs.getString("username"));
    user.setPassword(rs.getString("password"));
}

```

这些**样板代码**（Boilerplate Code）占据了我们大量的时间。而 **MyBatis (一种 ORM 框架)** 的核心使命就是：**你只管写 SQL 和定义 Java 对象，剩下的参数拼装和结果封装，我全包了！**

---

## 📦 第二步：引入 MyBatis 依赖

在你的 Maven 项目的 `pom.xml` 中，除了之前的 MySQL 驱动，我们需要新增 MyBatis 的核心包：

```xml
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.15</version> 
</dependency>

```

---

## ⚙️ 第三步：MyBatis 的核心配置

原生 MyBatis 需要一个全局配置文件，告诉它数据库在哪里。
在 `src/main/resources` 目录下新建 `mybatis-config.xml`：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "[http://mybatis.org/dtd/mybatis-3-config.dtd](http://mybatis.org/dtd/mybatis-3-config.dtd)">
<configuration>
    <settings>
        <setting name="mapUnderscoreToCamelCase" value="true"/>
    </settings>

    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/你的数据库名?serverTimezone=Asia/Shanghai"/>
                <property name="username" value="root"/>
                <property name="password" value="123456"/>
            </dataSource>
        </environment>
    </environments>

    <mappers>
        <mapper resource="mapper/UserMapper.xml"/>
    </mappers>
</configuration>

```

---

## 🗄️ 第四步：准备数据库与实体类 (Entity)

在写 MyBatis 代码之前，我们必须确保数据库表和 Java 类是一一对应的关系（这正是 ORM 思想的体现）。

### 1. 数据库建表语句

在 MySQL 中执行以下 SQL 脚本，创建用户表并插入一条测试数据：

```sql
-- 1. 创建用户表
CREATE TABLE t_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(50) NOT NULL COMMENT '密码 (本案例为演示方便使用明文，生产环境请使用 BCrypt 加密)',
    phone VARCHAR(20) COMMENT '手机号',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- 2. 插入测试数据
INSERT INTO t_user (username, password, phone) VALUES ('admin', '123456', '13800138000');

```

### 2. 编写实体类 (Java Bean)

在 `src/main/java/edu/wtbu/cs/coursedemoservlet/entity/` 目录下新建 `User.java`：

```java title="src/main/java/edu/wtbu/cs/coursedemoservlet/entity/User.java"
package edu.wtbu.cs.coursedemoservlet.entity;

import java.time.LocalDateTime;

public class User {
    private Long id;
    private String username;
    private String password;
    private String phone;
    // 注意：这里的命名是驼峰式，MyBatis 会自动将数据库的 create_time 映射到这里
    private LocalDateTime createTime; 
    private LocalDateTime updateTime;

    // TODO: 请自行生成 getter、setter 和 toString 方法。
    // 如果你安装了 Lombok 插件，可以直接在类名上方加上 @Data 注解来省略这些代码。
}

```

---

## ⚔️ 第五步：“双剑合璧” (接口 + XML)

MyBatis 最大的特色就是不需要写实现类。我们只需要一个 **Java 接口**（菜单）和一个 **XML 文件**（菜谱）。

### 1. 接口 (UserMapper.java)

在 `src/main/java/edu/wtbu/cs/coursedemoservlet/mapper/` 目录下新建 `UserMapper.java`：

```java title="src/main/java/edu/wtbu/cs/coursedemoservlet/mapper/UserMapper.java"
package edu.wtbu.cs.coursedemoservlet.mapper;

import edu.wtbu.cs.coursedemoservlet.entity.User;

public interface UserMapper {
    // 根据 ID 查询用户
    User selectById(Long id);
}

```

### 2. XML 映射 (UserMapper.xml)

在 `src/main/resources/mapper/` 目录下新建 `UserMapper.xml`：

```xml title="src/main/resources/mapper/UserMapper.xml"
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
  PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "[http://mybatis.org/dtd/mybatis-3-mapper.dtd](http://mybatis.org/dtd/mybatis-3-mapper.dtd)">
  
<mapper namespace="edu.wtbu.cs.coursedemoservlet.mapper.UserMapper">

    <select id="selectById" resultType="edu.wtbu.cs.coursedemoservlet.entity.User">
        SELECT * FROM t_user WHERE id = #{id}
    </select>

</mapper>

```

!!! tip "神奇的 `#{id}`"
    这里的 `#{id}` 就是 MyBatis 提供的占位符。它在底层会自动帮你转换成 JDBC 的 `?` 并且安全地设置参数，彻底杜绝 SQL 注入。

---

## 🚀 第六步：见证奇迹 (执行代码)

这是本节最激动人心的时刻。让我们看看不用 `ResultSet` 是如何查出对象的！

> 📌 **完整演示代码参考**：老师已经将本节的 Demo 代码提交到了课程仓库。
> 👉 [点击查看 MyBatisDemoTest.java 源码](https://gitee.com/javaweb-dev-tech/course-demo-servlet/blob/master/src/test/java/edu/wtbu/cs/coursedemoservlet/MyBatisDemoTest.java)

你可以编写如下测试代码来运行：
```java title="src/test/java/edu/wtbu/cs/coursedemoservlet/MyBatisUserMapperTest.java"
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.junit.jupiter.api.Test;
import java.io.InputStream;

public class MyBatisUserMapperTest {

    @Test
    public void testSelect() throws Exception {
        // 1. 读取全局配置文件
        InputStream inputStream = Resources.getResourceAsStream("mybatis-config.xml");
        
        // 2. 构建 SqlSessionFactory (相当于数据库连接池工厂)
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        
        // 3. 打开一个 SqlSession (相当于拿到了 JDBC 的 Connection)
        // try-with-resources 语法，会自动关闭 session
        try (SqlSession session = sqlSessionFactory.openSession()) {
            
            // 4. 重点！通过接口获取代理对象 (MyBatis 自动生成了实现类)
            UserMapper mapper = session.getMapper(UserMapper.class);
            
            // 5. 调用方法，就像调用普通的 Java 方法一样
            // 注意：因为数据库里的 id 是 BIGINT，对应 Java 的 Long，所以传 1L
            User user = mapper.selectById(1L); 
            
            System.out.println("查询成功：");
            System.out.println("用户名: " + user.getUsername());
            System.out.println("手机号: " + user.getPhone());
        }
    }
}

```

---

## 📝 总结与展望

在这一节中，我们体验了原生 MyBatis 的运行流程：

1. `SqlSessionFactoryBuilder` 读取配置。
2. 创建 `SqlSessionFactory`。
3. 获取 `SqlSession` 并执行查询。

**你可能会吐槽**：“老师，虽然不用写 `ResultSet` 了，但是前面创建 `SqlSessionFactory` 的代码好长、好啰嗦啊！”

恭喜你，你的感觉非常敏锐！在目前的**第二章 (Servlet 阶段)**，我们必须手动管理这些对象，以理解底层原理。
但在未来的**第四章**，当我们引入了终极武器 **Spring Boot** 之后，这前 3 步啰嗦的代码将**彻底消失**，全自动化接管。敬请期待！