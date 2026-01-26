---
title: 整合数据库 (Spring Boot + MySQL)
---

# 02. 整合数据库 (Spring Boot + MySQL)

!!! quote "🚀 本节目标：掌握行业标准"
    在 Java Web 开发领域，**MySQL** 是当之无愧的王者。它拥有最庞大的社区、最成熟的生态，是几乎所有互联网公司的面试必考题。
    
    虽然我们应当关注国产数据库的崛起（见下文），但作为初学者，**精通 MySQL 是你叩开大厂之门的基石**。
    
    本节我们将实战演示如何将 Spring Boot + MyBatis 连接到 **MySQL 8.0** 数据库。

---

## 📊 第一步：行业视野——国产数据库群雄逐鹿

在开始使用 MySQL 之前，作为新时代的计算机学生，你也需要了解国内数据库市场的风起云涌。随着**“信创” (信息技术应用创新)** 成为国家战略，以下这些国产数据库正在核心领域逐渐替代传统数据库。

*(注：了解即可，这有助于你面试时展现广阔的技术视野)*

| 数据库 | 厂商/背景 | 特点 | 适用场景 | 兼容体系 |
| --- | --- | --- | --- | --- |
| **openGauss** | **华为** | 开源、高性能、AI自治 | 政务、金融、电力 | **PostgreSQL** |
| **OceanBase** | 蚂蚁集团 | 分布式、曾在TPC-C霸榜 | 支付宝、银行核心 | MySQL / Oracle |
| **TiDB** | PingCAP | 存算分离、水平扩容 | 互联网、海量数据 | MySQL |
| **达梦 (DM)** | 达梦数据 | 老牌劲旅、完全自主 | 党政机关、军工 | Oracle |
| **人大金仓** | 人大/CETC | 学院派、擅长地理信息 | 电子政务、能源 | Oracle / PG |

!!! info "💡 为什么课程选择 MySQL？"
    尽管国产数据库势头强劲，但它们大多兼容 MySQL 或 PostgreSQL 协议。**学好 MySQL，你就掌握了数据库的通用语言**，未来迁移到 OceanBase 或 TiDB 也是轻而易举。

---

## 📦 第二步：引入 Maven 依赖

我们要引入两个核心包：

1. **MyBatis Starter**：Spring Boot 官方整合包。
2. **MySQL Connector/J**：官方 JDBC 驱动包。

在 `pom.xml` 的 `<dependencies>` 中添加：

```xml
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

```

---

## ⚙️ 第三步：配置 application.properties

Spring Boot 的约定大于配置，让我们只需几行代码就能搞定连接。

```properties title="src/main/resources/application.properties"
# ==========================================
# 💾 数据库连接配置 (MySQL)
# ==========================================

# 1. 驱动类名 (MySQL 8.0+ 推荐使用 cj 包)
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# 2. 连接地址
# 格式：jdbc:mysql://IP:端口/库名?参数
# ⚠️注意：serverTimezone 必须设置，否则时间可能会差8小时
spring.datasource.url=jdbc:mysql://localhost:3306/course_demo?serverTimezone=Asia/Shanghai&characterEncoding=utf-8&useSSL=false

# 3. 账号密码 (请修改为你自己的)
spring.datasource.username=root
spring.datasource.password=123456

# ==========================================
# ⚡ 连接池配置 (Druid - 可选，若未引入Druid依赖则默认使用HikariCP)
# ==========================================
# 如果你使用了 druid-spring-boot-starter，可以保留以下配置
# spring.datasource.type=com.alibaba.druid.pool.DruidDataSource

# ==========================================
# 🍄 MyBatis 核心配置
# ==========================================
# 1. 开启驼峰映射 (重要！让 user_id 自动对应 userId)
mybatis.configuration.map-underscore-to-camel-case=true

# 2. 指定 Mapper XML 的位置
mybatis.mapper-locations=classpath:mapper/*.xml

# 3. 打印 SQL 日志 (开发环境必开，方便调试)
# 注意：将 com.example... 改为你实际的包名
logging.level.edu.wtbu.cs.course.dao=DEBUG

```

---

## 🏗️ 第四步：Docker 快速安装 (推荐)

如果你不想在电脑上安装繁重的 MySQL 软件，强烈建议使用 **Docker** 启动。

```bash
# 1. 拉取镜像 (使用 8.0 版本，稳定且主流)
docker pull mysql:8.0

# 2. 启动容器
# -p 3306:3306 映射端口
# -e MYSQL_ROOT_PASSWORD 设置 root 密码
docker run -d \
  --name mysql01 \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=123456 \
  mysql:8.0

```

---

## 🧪 第五步：连通性测试

我们暂时不写业务代码，先写一个单元测试，看看 Spring Boot 能不能成功把 `DataSource` 注入进来。

```java title="src/test/java/.../ConnectionTest.java"
@SpringBootTest
class ConnectionTest {

    // 自动注入配置好的数据源
    @Autowired
    private DataSource dataSource;

    @Test
    void testConnection() throws SQLException {
        // 1. 打印数据源类型
        // Spring Boot 2.x+ 默认使用 HikariDataSource，如果你引入了 Druid 则是 DruidDataSource
        System.out.println("数据源类型: " + dataSource.getClass());

        // 2. 尝试获取连接
        Connection connection = dataSource.getConnection();
        System.out.println("✅ MySQL 连接成功！连接对象: " + connection);

        // 3. 归还连接
        connection.close();
    }
}

```

**预期输出日志**：

```text
数据源类型: class com.zaxxer.hikari.HikariDataSource (或者 Druid)
...
✅ MySQL 连接成功！连接对象: com.mysql.cj.jdbc.ConnectionImpl@1234abc

```

---

## 📝 总结

通过本节，我们完成了：

1. **认知升级**：了解了国产数据库现状，明确了 MySQL 的核心地位。
2. **环境搭建**：配置了 MyBatis 和 MySQL 8.0 驱动。
3. **连接测试**：成功让 Spring Boot 握手 MySQL 数据库。

**下一步预告**：
环境通了，接下来就是 MyBatis 的主场。下一节我们将学习如何定义 **Mapper 接口**，并用 XML 编写 SQL 语句，把数据库里的数据真正查出来。

[下一节：Mapper 接口与 XML 映射](03-mapper-xml.md){ .md-button .md-button--primary }

