---
title: 整合信创数据库 (Spring Boot + openGauss)
---

# 02. 整合信创数据库 (Spring Boot + openGauss)

!!! quote "🇨🇳 本节目标：拥抱国产化浪潮"
    在过去，Java 教程的标配是 MySQL 或 Oracle。

    但随着**“信创” (信息技术应用创新)** 成为国家战略，金融、电力、政务等核心领域的数据库正在全面国产化。掌握国产数据库开发能力，已成为计算机专业学生的**核心竞争力**。

    本节我们将把目光转向国内，实战演示如何将 Spring Boot + MyBatis 连接到华为开源的 **openGauss** 数据库。
---

## 📊 第一步：国产数据库群雄逐鹿

在开始写代码前，你需要了解当今中国数据库市场的“五虎上将”。它们不再是“备胎”，而在核心领域挑起了大梁。

| 数据库 | 厂商/背景 | 特点 | 适用场景 | 兼容体系 |
| --- | --- | --- | --- | --- |
| **openGauss** | **华为** | 开源、高性能、AI自治 | 政务、金融、电力 | **PostgreSQL** |
| **OceanBase** | 蚂蚁集团 | 分布式、曾在TPC-C霸榜 | 支付宝、银行核心 | MySQL / Oracle |
| **TiDB** | PingCAP | 存算分离、水平扩容 | 互联网、海量数据 | MySQL |
| **达梦 (DM)** | 达梦数据 | 老牌劲旅、完全自主 | 党政机关、军工 | Oracle |
| **人大金仓** | 人大/CETC | 学院派、擅长地理信息 | 电子政务、能源 | Oracle / PG |



### 🔍 深度解读：什么是 openGauss？

**openGauss** 是一款企业级开源关系型数据库，源于 PostgreSQL 9.2.4，但华为在此基础上进行了大规模的**内核级改造**（修改代码量超过 70%）。它不仅仅是“另一个 PG”，更具备以下核心优势：

1. **高性能 (High Performance)**：引入了 **NUMA 架构适配**和**算子深度优化**，在多核并发场景下，性能远超原生 PostgreSQL 和 MySQL。
2. **AI 原生 (AI-Native)**：这是它最酷的地方。openGauss 内置了 AI 引擎，支持**自调优**（自动推荐最佳参数）、**自诊断**（自动分析慢 SQL 原因）。
3. **高安全 (High Security)**：支持全密态计算，是国内首个通过 CC EAL4+ 认证的数据库。


!!! info "📚 课外阅读：官方文档 (建议收藏)"
    官方文档是学习技术的源头活水。关于 openGauss 的安装、SQL 语法及高级特性，建议大家养成查阅官方手册的习惯。

    * **官方网站**: [https://opengauss.org/zh/](https://opengauss.org/zh/)
    * **开发者文档**: [https://docs.opengauss.org/zh/](https://docs.opengauss.org/zh/)
  

---


## 📦 第二步：引入 Maven 依赖

我们要引入两个核心包：

1. **MyBatis Starter**：Spring Boot 官方整合包。
2. **openGauss JDBC**：官方驱动包。

在 `pom.xml` 的 `<dependencies>` 中添加：

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>3.0.3</version>
</dependency>

<dependency>
    <groupId>org.opengauss</groupId>
    <artifactId>opengauss-jdbc</artifactId>
    <version>5.0.0</version>
</dependency>

```
!!! warning "避坑指南：驱动下载失败怎么办？"
    由于 openGauss 是基于 PostgreSQL 开发的，**在紧急情况下**（比如 Maven 镜像库里找不到 openGauss 驱动），你可以临时使用 `org.postgresql:postgresql` 驱动替代！
    
    * **URL 写法**: `jdbc:postgresql://...`

    **但在本课程中，为了体现“信创”规范，请优先使用 `org.opengauss` 原生驱动。**
---

## ⚙️ 第三步：配置 application.properties

Spring Boot 的约定大于配置，让我们只需几行代码就能搞定连接。

```properties title="src/main/resources/application.properties"
# ==========================================
# 💾 数据库连接配置 (openGauss)
# ==========================================

# 1. 驱动类名 (注意是 opengauss 包下的)
spring.datasource.driver-class-name=org.opengauss.Driver

# 2. 连接地址
# 格式：jdbc:opengauss://IP:端口/库名?参数
# ⚠️注意：必须指定 currentSchema，否则可能会连到系统表里去
spring.datasource.url=jdbc:opengauss://localhost:5432/postgres?currentSchema=public

# 3. 账号密码 (请修改为你自己的)
spring.datasource.username=gaussdb
spring.datasource.password=SecretPassword@123

# ==========================================
# ⚡ 连接池配置 (Druid)
# ==========================================
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
spring.datasource.druid.initial-size=5
spring.datasource.druid.max-active=20

# ==========================================
# 🍄 MyBatis 核心配置
# ==========================================
# 1. 开启驼峰映射 (重要！让 user_id 自动对应 userId)
mybatis.configuration.map-underscore-to-camel-case=true

# 2. 指定 Mapper XML 的位置
mybatis.mapper-locations=classpath:mapper/*.xml

# 3. 打印 SQL 日志 (开发环境必开，方便调试)
logging.level.com.example.usermanager.dao=DEBUG

```

---

## 🏗️ 第四步：Docker 快速安装 (推荐)

如果你不想在电脑上安装庞大的数据库软件，强烈建议使用 **Docker** 启动 openGauss。

*(陈老师推荐：这是最干净、最快速的安装方式)*

```bash
# 1. 拉取镜像 (使用 enmotech 封装的镜像，比官方更易用)
docker pull enmotech/opengauss:5.0.0

# 2. 启动容器
# -p 5432:5432 映射端口
# --privileged=true 必须加，否则可能启动失败
docker run -d \
  --name opengauss \
  -p 5432:5432 \
  --privileged=true \
  -e GS_PASSWORD=SecretPassword@123 \
  enmotech/opengauss:5.0.0

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
        // 1. 打印数据源类型，验证是否使用了 Druid
        System.out.println("数据源类型: " + dataSource.getClass());

        // 2. 尝试获取连接
        Connection connection = dataSource.getConnection();
        System.out.println("✅ openGauss 连接成功！连接对象: " + connection);

        // 3. 归还连接
        connection.close();
    }
}

```

**预期输出日志**：

```text
数据源类型: class com.alibaba.druid.pool.DruidDataSource
...
✅ openGauss 连接成功！连接对象: org.opengauss.jdbc.PgConnection@1234abc

```

---

## 📝 总结

通过本节，我们完成了：

1. **认知升级**：了解了国产数据库 openGauss 的地位与 PostgreSQL 的渊源。
2. **环境搭建**：配置了 MyBatis 和 openGauss 驱动。
3. **连接测试**：成功让 Spring Boot 握手信创数据库。

**下一步预告**：
环境通了，接下来就是 MyBatis 的主场。下一节我们将学习如何定义 **Mapper 接口**，并用 XML 编写 SQL 语句，把数据库里的数据真正查出来。

[下一节：Mapper 接口与 XML 映射](https://www.google.com/search?q=03-mapper-xml.md){ .md-button .md-button--primary }
}