---
title: 附录：Java 基础补给站——泛型与集合类
---

# 附录：Java 基础补给站——泛型与集合类：超级数组与魔法标签

!!! quote "☕ 课前导语：为什么有了数组，还要学集合？"
    在入门阶段，你肯定学过数组，比如 `String[] names = new String[5];`。
    但是数组有一个致命的缺点：**它的长度是定死的！**
    在真实的网站开发中，我们根本不知道数据库里会有多少个用户，也不知道前端会传过来多少条订单。如果用传统数组，一不小心就会报错“数组越界”。

    为了解决这个问题，Java 为我们提供了**集合框架 (Collections)** —— 它们就像是**能自动变大变小的“超级数组”**。
    同时，为了让这些超级数组装东西时更安全，Java 又引入了 **泛型 (Generics)**。今天，我们就来拿下这两个日常开发中最常用的黄金搭档！

---

## 🏷️ 一、泛型 (Generics)：收纳箱上的“专属标签”

在正式讲集合之前，我们必须先搞懂什么是**泛型**（也就是代码里经常看到的 `<T>`、`<String>`、`<User>`）。

### 1. 没有泛型的黑暗时代
想象一下，Java 提供了一个万能的“魔法收纳箱”叫 `ArrayList`。在 Java 5 之前（没有泛型），这个箱子是什么都能装的，因为它默认装的是 `Object`（所有类的老祖宗）。

```java
// ❌ 没有泛型的写法（极其危险！）
ArrayList box = new ArrayList(); 
box.add("苹果");      // 装入一个字符串
box.add(new User()); // 还能装入一个 User 对象
box.add(100);        // 还能装入一个数字

// 噩梦开始了：当你闭着眼睛从箱子里拿东西时...
String fruit = (String) box.get(1); // 报错！你以为拿到的是苹果，其实拿到了 User，强转失败！
```
这种什么都能装的箱子，导致我们在拿东西时，**必须进行危险的强制类型转换**，稍有不慎程序就会崩溃。

### 2. 泛型：给箱子贴上专属标签
**泛型**，顾名思义就是“宽泛的类型”，但在使用时，我们要把它具体化。它就像是**贴在收纳箱外面的标签**，告诉编译器：“这个箱子，只能装这种东西！”

```java
// ✅ 有了泛型的写法（安全、优雅）
// <String> 就是泛型标签，规定这个箱子只能装字符串！
ArrayList<String> box = new ArrayList<String>(); 
box.add("苹果");
// box.add(100); // 编译直接报错红线！休想把数字放进装苹果的箱子！

// 拿东西时，闭着眼睛拿，绝对安全，不需要强制转换！
String fruit = box.get(0); 
```

> **💡 核心总结**：
> 泛型 `< >` 的最大作用就是**把运行时的报错，提前到了写代码时的编译期**，并且省去了繁琐的强制类型转换。在未来的开发中，你见到的集合，100% 都会带着泛型标签！

---

## 📦 二、集合框架全景图：Java 的“三大容器”

Java 的集合框架非常庞大，但对于绝大多数开发来说，你只需要认识三个大佬：**`List`（列表）**、**`Set`（集）**、**`Map`（映射）**。

| 集合类型 | 核心特点 | 生活比喻 | 最常用的实现类 |
| :--- | :--- | :--- | :--- |
| **`List`** | **有序，可重复**。东西是怎么放进去的，拿出来还是什么顺序。 | **奶茶店排队**。有先来后到（下标），同一个人可以排两次队。 | `ArrayList` |
| **`Set`** | **无序，不可重复**。放进同样的东西，它会自动去重。 | **俱乐部 VIP 名单**。不按拼音排序，而且一个人不可能在名单上出现两次。 | `HashSet` |
| **`Map`** | **键值对 (Key-Value)**。必须成对存放，通过 Key 找 Value。 | **超市储物柜**。手牌号 (Key) 对应你的包包 (Value)。手牌号不能重复！ | `HashMap` |

---

## 🚄 三、List 详解：出场率 90% 的 ArrayList

在 Web 开发中，当我们从数据库查出“所有的用户信息”时，返回的绝对是一个 `List<User>`。
`List` 是一个接口，它最牛逼的实现类叫 **`ArrayList`**（底层就是会自动扩容的数组）。

### 🎯 ArrayList 核心实战代码

```java
import java.util.ArrayList;
import java.util.List;

public class ListDemo {
    public static void main(String[] args) {
        // 1. 创建一个只能装字符串的 List
        // 注意：左边写接口 List，右边写实现类 ArrayList，这是 Java 推荐的多态写法！
        List<String> names = new ArrayList<>();

        // 2. 增：添加元素 (按顺序排队)
        names.add("张三"); // 下标 0
        names.add("李四"); // 下标 1
        names.add("王五"); // 下标 2
        names.add("张三"); // List 允许重复，所以会有两个张三！

        // 3. 删：根据内容或下标删除
        names.remove("李四"); 

        // 4. 改：修改指定位置的元素
        names.set(1, "赵六"); // 把下标 1 的位置换成赵六

        // 5. 查：获取元素与长度
        System.out.println("第一个人是: " + names.get(0));
        System.out.println("一共排了多少人: " + names.size()); // 注意：集合求长度用 size()，不用 length！

        // 6. 遍历大招：增强 for 循环 (最常用)
        System.out.println("=== 开始点名 ===");
        for (String name : names) {
            System.out.println(name);
        }
    }
}
```

---

## 🗺️ 四、Map 详解：根据名字找人的 HashMap

当你需要通过一个唯一的标识（比如学号、身份证号、订单号）去快速查找对应的信息时，千万不要用 List 从头到尾去遍历，那太慢了！这时候就该 **`Map`** 登场了。

`Map` 存储的是 **键值对 (Key-Value)**。`Key` 就是储物柜的手牌，`Value` 就是储物柜里的东西。

### 🎯 HashMap 核心实战代码

```java
import java.util.HashMap;
import java.util.Map;

public class MapDemo {
    public static void main(String[] args) {
        // 1. 创建一个 Map，规定 Key 必须是 String(学号)，Value 必须是 Integer(分数)
        Map<String, Integer> scores = new HashMap<>();

        // 2. 增/改：放入数据用 put()
        scores.put("S001", 95);
        scores.put("S002", 88);
        scores.put("S003", 76);
        // 注意：Key 是绝对不能重复的！如果往相同的 Key 放东西，会把原来的覆盖掉！
        scores.put("S001", 100); // S001 的分数从 95 被改写成了 100

        // 3. 删：根据 Key 丢弃数据
        scores.remove("S003");

        // 4. 查：根据 Key 快速获取 Value
        Integer score = scores.get("S001");
        System.out.println("S001 的分数是: " + score);
        
        // 查不到会返回 null
        System.out.println("S009 的分数是: " + scores.get("S009")); 

        // 5. 遍历：拿到所有的钥匙 (KeySet)，然后一把把去开箱子找东西
        System.out.println("=== 成绩单 ===");
        for (String key : scores.keySet()) {
            Integer value = scores.get(key);
            System.out.println("学号: " + key + "，分数: " + value);
        }
    }
}
```

---

## 🚀 五、实战结合：集合在 Web 开发中的化身

你可能会问：学了这么多，在马上要学的 Servlet、Spring Boot 等 Web 框架里，集合到底是怎么用的？

只要你把下面这两条“神级映射规则”刻在脑子里，你就能无缝搞定所有的前后端数据交互！

### 1. 数据库多行结果映射 = `List<Java对象>`

在绝大多数后端业务中，我们最常干的事情就是去数据库里查数据。

* **核心映射逻辑**：当你在数据库执行 `SELECT * FROM student` 时，可能会查出 100 个学生的信息。后端的持久层框架（如 MyBatis）会自动把每一行数据封装成一个 `Student` 对象，然后把这 100 个对象统统塞进一个 `List<Student>` 里交给你。
* **集合特点**：通常使用 `ArrayList`，它的底层是数组，虽然增删相对较慢，但**查询和遍历速度极快**，完美契合数据库“一次查询，多次读取”的场景。

**💻 Web 典型场景代码演示：**
```java
// 场景：从数据库查询所有学生的信息，并准备传递给前端
public List<Student> getAllStudents() {
    // 1. 准备一个空列表，用来装学生对象
    List<Student> studentList = new ArrayList<>();
    
    // 2. 伪代码：执行 SQL "SELECT * FROM student"
    // 3. 将结果集逐条遍历，封装成 Student 对象并加入 List
    // studentList.add(new Student("张三", 20)); ...
    
    // 4. 返回包含所有数据的集合
    return studentList; 
}
```

### 2. JSON 数据结构映射 = `List` 与 `Map` 的组合

在前后端分离的时代，前端网页和后端 Java 之间交流的“唯一官方语言”就是 **JSON**。而 JSON 的数据结构，与 Java 集合有着天衣无缝的对应关系：

* JSON 里的**数组 `[ ... ]`** ➡️ 到了 Java 里，就会被解析成 **`List`**。
* JSON 里的**对象 `{ ... }`** ➡️ 到了 Java 里，通常被解析成具体的实体类；但如果没有定义实体类，它就会被解析成 **`Map<String, Object>`**（JSON 的属性名就是 Map 的 Key，属性值就是 Value）。

**💻 Web 典型场景代码演示：用 Map 灵活封装零散数据**

* **集合特点**：Map 通过 Key 快速定位到 Value，且 Key 不可重复。
* **应用痛点**：有时候，我们登录成功后只是想返回几个零散的数据给前端（比如用户名、Token 凭证、登录时间）。如果专门为此去写一个实体类（JavaBean）显得太臃肿了。此时，`Map` 就是最完美的“万能对象”：

```java
// 场景：灵活组装不需要复用的响应数据
public Map<String, Object> getLoginResponse() {
    Map<String, Object> responseData = new HashMap<>();
    
    // 像装配零件一样，把需要的数据放进 Map 里
    responseData.put("username", "admin");
    responseData.put("token", "jwt-token-string-xxx");
    responseData.put("loginTime", new Date());
    
    // 最终，Web 框架会自动将这个 Map 转换成如下的 JSON 格式返回给前端：
    // {
    //   "username": "admin",
    //   "token": "jwt-token-string-xxx",
    //   "loginTime": "2025-11-20T10:00:00.000+00:00"
    // }
    return responseData;
}
```

---

你看，我们学的所有底层基础（对象、泛型、List、Map），其实全都是在为后面的企业级实战做铺垫。现在，带上你的 `List` 和 `Map`，去 Web 世界大展拳脚吧！