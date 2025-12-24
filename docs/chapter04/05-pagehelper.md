---
title: 插件生态：PageHelper 分页查询
---
# 05. 插件生态：PageHelper 分页查询

!!! quote "想象一下：如果你打开淘宝..."
如果淘宝把所有 10 亿件商品一次性全部加载到你的手机屏幕上，会发生什么？

```
1.  **手机爆炸**：内存溢出（OOM）。
2.  **网络瘫痪**：下载这几 TB 数据需要好几年。
3.  **老板发火**：数据库服务器瞬间崩溃。

所以，**“分页查询”**（每次只查 10 条）是后端开发的**生存必备技能**。本节我们将介绍 MyBatis 生态中最著名的分页插件 —— **PageHelper**。

```

---

## 🆚 第一步：物理分页 vs 逻辑分页 (面试必问)

在学习插件之前，必须懂原理。实现分页有两种流派：

| 特性 | 逻辑分页 (内存分页) | 物理分页 (数据库分页) |
| --- | --- | --- |
| **原理** | 把所有数据（比如 100万条）都查到 Java 内存里，然后用代码截取第 10-20 条。 | 在 SQL 语句末尾加上 `LIMIT` 关键字，数据库只返回这 10 条数据。 |
| **优点** | 通用性强（不依赖数据库方言）。 | **性能极高**，内存占用极小。 |
| **缺点** | **性能灾难**！数据量大时直接 OOM。 | 不同的数据库语法不同（MySQL 用 `LIMIT`, Oracle 用 `ROWNUM`）。 |
| **结论** | ❌ **坚决抵制** | ✅ **企业级标准** |

**PageHelper 的魔法**：
它让我们在 Java 代码中写起来像“逻辑分页”一样简单，但底层自动帮我们转换成最高效的“物理分页” SQL。

---

## 📦 第二步：引入依赖

PageHelper 专门为 Spring Boot 提供了 Starter 包。

```xml title="pom.xml"
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper-spring-boot-starter</artifactId>
    <version>2.1.0</version>
</dependency>

```

---

## 🪄 第三步：见证奇迹时刻

### 1. 痛苦的过去 (不使用插件)

如果没有 PageHelper，你需要在 Mapper XML 里手写计算公式：

```xml
<select id="findByPage">
    SELECT * FROM t_user LIMIT #{offset}, #{pageSize}
</select>

```

你还需要在 Java 里算 `offset = (pageNum - 1) * pageSize`... 想想都头大。

### 2. 优雅的现在 (使用插件)

**我们完全不动 Mapper 和 XML！** 保持原样：

```xml
<select id="findAll" resultType="User">
    SELECT * FROM t_user
</select>

```

**在 Service 或 Controller 中加入一行魔法代码：**

```java title="UserService.java"
public PageInfo<User> findUserByPage(int pageNum, int pageSize) {
    // 1. 🪄 开启分页 (魔法就在这一行)
    // 只要执行了这行，紧跟在它后面的第一条 SQL 就会被自动拦截
    PageHelper.startPage(pageNum, pageSize);

    // 2. 正常查询 (看起来是查所有，实际被改写了)
    List<User> userList = userMapper.findAll();

    // 3. 封装结果 (PageInfo 包含了 total, pages 等所有前端需要的信息)
    return new PageInfo<>(userList);
}

```

### 3. 原理解析

当你调用 `PageHelper.startPage(1, 10)` 时，插件把分页参数存入了 **ThreadLocal**（线程本地变量）。
当 `userMapper.findAll()` 执行时，PageHelper 的**拦截器**会偷偷把 SQL 从：
`SELECT * FROM t_user`
变成：
`SELECT * FROM t_user LIMIT 10 OFFSET 0`
同时，它还会自动多执行一条 `SELECT COUNT(*)` 语句来计算总条数。

---

## 📡 第四步：响应数据结构

前端收到 `PageInfo` 对象后，会看到非常规范的 JSON 数据：

```json
{
  "pageNum": 1,       // 当前页
  "pageSize": 10,     // 每页几条
  "size": 10,         // 当前页实际几条
  "total": 105,       // 总记录数 (最重要！前端用来算页码条)
  "pages": 11,        // 总页数
  "list": [           // 真正的数据列表
    { "id": 1, "username": "admin", ... },
    { "id": 2, "username": "test", ... }
  ],
  "isFirstPage": true,
  "isLastPage": false
}

```

---

## 🤖 特别篇：AI 帮你重构代码

!!! tip "🚀 场景：老代码改造"
有时候你接手了一个老项目，发现里面全是 `findAll()`，老板让你把它们全部改成即插即用的分页接口。

```
手动改很累，交给 AI 吧！

```

**👨‍💻 工程师职责**：找到需要改造的 Service 方法。

**🤖 AI 职责**：生成分页封装代码。

!!! example "🔮 复制此 Prompt 给 AI"
"我正在使用 Spring Boot 和 PageHelper。
请帮我把下面的普通查询方法，改造成**分页查询方法**。

```
**原始代码**：
```java
public List<User> search(String name) {
    return userMapper.findByName(name);
}
```

**要求**：
1.  方法参数增加 `int pageNum`, `int pageSize`。
2.  使用 `PageHelper.startPage`。
3.  返回类型改为 `PageInfo<User>`。
4.  请解释为什么 `PageHelper.startPage` 必须写在 SQL 查询的第一行前面。"

```

---

## ⚠️ 避坑指南 (严厉警告)

PageHelper 非常好用，但有一个**致命隐患**，请务必背诵：

!!! warning "💀 致命死穴：分页污染"
`PageHelper.startPage()` 的原理是使用 `ThreadLocal`。
**它只对紧随其后的 第一条 SQL 语句生效！**

```
**❌ 错误写法**：
```java
PageHelper.startPage(1, 10);
// ⚠️ 中间插入了其他代码，如果不小心抛出异常...
if (param == null) {
    throw new RuntimeException("参数错误"); 
}
List<User> list = userMapper.findAll();
```
**后果**：如果在查询之前抛了异常，`startPage` 设置的分页参数没有被消费掉。**这個线程复用给下一个请求时，下一个请求明明没想分页，却莫名其妙被分页了！**

**✅ 安全写法**：
始终保持 `startPage` 和 `mapper` 查询紧紧挨在一起，中间不要有任何逻辑代码。

```

---

## 📝 总结

| 核心类 | 作用 | 备注 |
| --- | --- | --- |
| `PageHelper` | 工具类 | 核心方法 `startPage(page, size)`。 |
| `PageInfo` | 结果封装类 | 包含 `total`, `list` 等信息，直接返回给前端。 |
| **物理分页** | 核心思想 | 利用 SQL 的 `LIMIT`，保护数据库。 |

[下一节：事务管理：@Transactional 与 ACID](06-transaction.md){ .md-button .md-button--primary }
}