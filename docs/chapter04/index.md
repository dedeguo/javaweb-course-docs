---
title: 第4章 导读｜数据持久化与信创
---
这份目录规划非常符合**“信创国产化”**和**“企业级实战”**的教学方向。

第四章是整个后端开发中最关键的转折点：**从“面向对象”真正跨越到“面向关系型数据库”**。

为了让学生平滑过渡，同时突出 **openGauss (高斯数据库)** 的信创特色，我建议在原有的知识点上增加 **“动态 SQL”** 和 **“分页插件”** 这两个必考点。

以下是为您优化的目录结构及详细内容规划：

---



### 📂 第四篇｜数据持久化：MyBatis 与信创数据库

* **第4章 导读**: `chapter04/index.md`
* *核心比喻*：如果 JDBC 是“手动挡赛车”，MyBatis 就是“自动挡跑车”。


* **01. ORM 思想与 MyBatis 初探**: `chapter04/01-orm-intro.md`
* *重点*：什么是 ORM？为什么说 MyBatis 是“半自动”ORM？（对比 Hibernate/JPA）


* **02. 整合信创数据库 (Spring Boot + openGauss)**: `chapter04/02-integrate-gauss.md`
* *重点*：Maven 依赖、`application.yml` 配置、openGauss 驱动兼容性。


* **03. Mapper 接口与 XML 映射**: `chapter04/03-mapper-xml.md`
* *重点*：`@Mapper` 注解、`namespace` 绑定、ResultMap 解决字段名不一致问题（`user_id` -> `userId`）。


* **04. MyBatis 的杀手锏：动态 SQL**: `chapter04/04-dynamic-sql.md`
* *重点*：`<if>`, `<where>`, `<foreach>` 标签。这是 JDBC 做不到的，也是 MyBatis 最强大的地方。


* **05. 插件生态：PageHelper 分页查询**: `chapter04/05-pagehelper.md`
* *重点*：物理分页 vs 逻辑分页，如何在 Spring Boot 中一键实现分页。


* **06. 事务管理：@Transactional 与 ACID**: `chapter04/06-transaction.md`
* *重点*：转账场景模拟，演示“原子性”，讲解 Spring 声明式事务。


* **实验4：数据落地——从内存 Map 到 openGauss**: `chapter04/lab4.md`
* *任务*：彻底改造第三章的 `UserDao`，接入真实数据库。



---

### 💡 各小节内容设计建议 (Teacher Chen's Notes)

#### 1. 导读 (`index.md`)

* **痛点回顾**：还记得 JDBC 里拼字符串写 SQL 的痛苦吗？还记得手动封装 `ResultSet` 的繁琐吗？
* **引入**：MyBatis 帮我们完成了 90% 的脏活累活，我们只需要专注 SQL 本身。

#### 2. 整合信创数据库 (`02-integrate-gauss.md`)

* **信创特色**：这里要专门强调 **openGauss** 的连接配置，因为它和 MySQL 略有不同（虽然兼容 PG 协议）。
* **配置示例**：
```yaml
spring:
  datasource:
    # ⚠️ 注意：openGauss 使用 PostgreSQL 驱动
    driver-class-name: org.opengauss.Driver 
    # 或者 org.postgresql.Driver (视版本而定)
    url: jdbc:opengauss://localhost:5432/postgres
    username: gaussdb
    password: SecretPassword@123
mybatis:
  mapper-locations: classpath:mapper/*.xml
  configuration:
    map-underscore-to-camel-case: true # 开启驼峰映射

```



#### 3. 动态 SQL (`04-dynamic-sql.md`)

* **教学价值**：这是 MyBatis 区别于其他 ORM 最亮眼的功能。
* **场景**：用户搜索时，有时只输名字，有时只输电话，有时都输。
* **代码**：
```xml
<select id="search" resultType="User">
  SELECT * FROM t_user
  <where>
    <if test="username != null">AND username like #{username}</if>
    <if test="phone != null">AND phone = #{phone}</if>
  </where>
</select>

```



#### 4. 事务管理 (`06-transaction.md`)

* **教学法**：不要只讲概念。
* **反面教材**：演示没有事务时，A 扣钱了，报错了，B 没加钱 —— **钱丢了！**
* **正面教材**：加上 `@Transactional`，报错后 A 的钱自动回滚。

#### 5. 实验 4 (`lab4.md`)

* **核心任务**：
1. 建表脚本 (`user.sql`)。
2. 删除 `ConcurrentHashMap` 的模拟代码。
3. 编写 `UserMapper` 接口。
4. 编写 `UserMapper.xml`。
5. Service 层调用 Mapper。



---

### ❓ 关键决策点

**问题：是否要讲 MyBatis-Plus (MP)？**

* **建议**：在**本章不讲，或者只作为“扩展阅读”提一句**。
* **理由**：MyBatis-Plus 封装得太好了，学生如果直接学 MP，会完全不懂 SQL 是怎么执行的，也不懂什么是 ResultMap。
* **策略**：先让学生在第4章痛苦地写一下 XML，感受 SQL 的力量。等到期末大作业或者进阶章节，再引入 MP 作为“效率神器”。

您觉得这个安排是否合理？如果没有问题，我可以帮您先撰写 **“02. 整合信创数据库 (Spring Boot + openGauss)”** 这一节，把环境先配通。
