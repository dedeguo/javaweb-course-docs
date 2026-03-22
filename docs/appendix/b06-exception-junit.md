---
title: 附录：Java 基础补给站——异常与 JUnit
---

# 附录：Java 基础补给站——异常处理与 JUnit 单元测试：驯服 Bug 的猛兽

!!! quote "☕ 课前导语：为什么控制台总是一片爆红？"
    刚学 Java 时，你一定经历过这样的绝望：代码写得好好的，一运行，控制台突然喷出一大堆**红色的英文字母**，程序直接罢工。
    在编程世界里，这种导致程序崩溃的意外情况，我们称之为 **异常 (Exception)**。

    如果我们不去管它，只要发生一次异常，整个 Web 服务器（比如 Tomcat）可能就会死机。今天，我们将学习如何像一个老练的猎手一样 **捕捉异常**，并且学习使用 **JUnit 单元测试**，在代码上线前把 Bug 扼杀在摇篮里！

---

## 💣 一、认识异常：程序世界里的“交通事故”

在 Java 中，所有的“意外情况”都是一个对象，它们都有一个共同的老祖宗：`Throwable`。它有两个极其不同的儿子：

1. **`Error` (错误 - 绝症)**：比如 `OutOfMemoryError`（内存撑爆了）。这种属于 JVM 虚拟机层面的灾难，就像汽车发动机直接爆炸，你写的代码救不了，只能重启。
2. **`Exception` (异常 - 可治愈的疾病)**：这是我们今天要讲的主角。它又分为两派：
    * **编译时异常 (Checked Exception)**：代码还没运行，编译器就画红线逼着你处理（比如前一节学的文件读写 `IOException`）。**就像开车上路前，交警强制你必须系安全带，不系不让走。**
    * **运行时异常 (RuntimeException)**：写代码时不报错，一运行才原形毕露。**就像开车在路上突然扎到了钉子，事先无法预料。**

> 🏆 **新手必知的三大常见运行时异常 (踩坑排行榜)：**  
> 1. `NullPointerException` (空指针异常)：你试图去调用一个为 `null` 的对象的方法。（稳居排行榜第一，万恶之源！）  
> 2. `ArithmeticException` (算术异常)：比如你拿一个数除以 0。  
> 3. `IndexOutOfBoundsException` (索引越界异常)：数组只有 3 个元素，你非要拿第 4 个。  

---

## 🚑 二、异常处理：try-catch-finally 救援队

遇到异常，我们不能让程序直接死掉，我们需要一套紧急救援方案。

```java
public class ExceptionDemo {
    public static void main(String[] args) {
        System.out.println("1. 汽车平稳行驶中...");

        // 【try】：把你觉得可能会出意外的代码，放进 try 块里（事故多发地段）
        try {
            int result = 10 / 0; // 突然除以 0，发生车祸！(抛出 ArithmeticException)
            System.out.println("2. 这行代码永远不会被执行到了");
        } 
        // 【catch】：派出的救援车。只有 try 里面抛出了对应的异常，才会执行 catch 里的代码
        catch (ArithmeticException e) {
            System.out.println("💥 发生算术异常啦！原因：" + e.getMessage());
            // 救援措施：比如把错误记录到日志里，或者给用户返回一个友好的提示
        } 
        // 【finally】：无论有没有出车祸，最后都必须执行的收尾工作（打扫战场）
        finally {
            System.out.println("🧹 无论是否发生异常，我都会执行！通常用来关闭 I/O 流或数据库连接。");
        }

        // 因为异常被 catch 抓住了，所以程序没有崩溃，继续往下走！
        System.out.println("3. 汽车修好，继续上路！");
    }
}
```

### 📣 主动惹事：throw 和 throws
除了被动捕捉，我们还可以主动抛出异常来阻止非法操作。

* **`throw`**：在方法内部，自己造一个异常对象扔出去。（“我不管了，直接引爆！”）
* **`throws`**：写在方法名旁边，警告调用这个方法的人。（“我这个方法可能会爆炸，你要调用的话，自己提前准备好 `try-catch` 救援队！”）

```java
// 方法声明处使用 throws 警告调用者
public void setAge(int age) throws RuntimeException {
    if (age < 0) {
        // 方法内部使用 throw 主动抛出异常对象
        throw new RuntimeException("年龄不能是负数！");
    }
    this.age = age;
}
```

---

## 🧪 三、JUnit 单元测试：告别满屏的 main 方法

在学习异常之前，每次我们写完一个方法想测试一下，都要去改一遍 `public static void main`，测试完再删掉。如果一个类有 10 个方法，测试起来极其痛苦。

**JUnit** 就是为了解决这个问题而生的。它是 Java 程序员最爱的“质检工具”。

### 1. 引入 JUnit 依赖 (Maven)
因为我们用的是 Maven 项目，在 `pom.xml` 中引入 JUnit 5 的依赖：
```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.10.0</version>
    <scope>test</scope>
</dependency>
```

### 2. 实战：怎么写单元测试？

首先，我们来写一个被测试的业务类 —— **`Calculator` (计算器)**。
你可以把它建在 `src/main/java` 目录下：

```java
// 被测试的业务类：计算器
public class Calculator {
    
    // 加法
    public int add(int a, int b) {
        return a + b;
    }
    
    // 除法 (注意：这里如果 b 是 0，就会抛出前面学的 ArithmeticException 异常！)
    public int divide(int a, int b) {
        return a / b;
    }
}
```

接下来，我们不需要写 `main` 方法，只需要在 `src/test/java` 目录下新建一个测试类，并在测试方法上贴一个 **`@Test` 注解**！

```java
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

// 专门用来质检 Calculator 类的测试类
public class CalculatorTest {

    // 只要贴了 @Test，这个方法就可以独立运行！(点击方法左侧的绿色小箭头即可运行)
    @Test
    public void testAdd() {
        Calculator calc = new Calculator();
        int result = calc.add(2, 3);
        
        // ❌ 以前的土办法：用肉眼看打印结果
        // System.out.println(result); 

        // ✅ 高级的质检办法：断言 (Assertions)
        // 第一个参数是“我期望的结果是 5”，第二个参数是“实际算出来的 result”
        Assertions.assertEquals(5, result, "加法逻辑错误！");
        
        System.out.println("✅ 测试通过，加法逻辑完美！");
    }
    
    // 你可以写无数个 @Test 方法，互不干扰
    @Test
    public void testDivide() {
        Calculator calc = new Calculator();
        // 如果这里写 calc.divide(10, 0)，运行这个测试方法就会爆红，提醒你处理异常！
        int result = calc.divide(10, 2); 
        
        Assertions.assertEquals(5, result, "除法逻辑错误！");
        System.out.println("✅ 测试通过，除法逻辑完美！");
    }
}
```

**断言 (`Assertions`) 的魅力**：如果期望值和实际值一样，测试旁边会亮起**绿灯**（通过）；如果不一致，或者代码抛出了异常没有处理，测试就会亮起**红灯**（失败）。未来在企业开发中，每次提交代码，系统都会自动跑一遍所有标了 `@Test` 的方法，只要有一个红灯，代码就不准上线！

---

## 🚀 四、实战结合：异常与测试在 Web 中的化身

在马上要学习的 Web 开发（比如 Spring Boot 阶段），这两把武器会直接改变你的代码结构。

### 1. 全局异常处理（化腐朽为神奇）
在做网站时，如果在 Service 业务层代码里出现了“除以 0”或者“数据库连不上”的异常，总不能把那堆红色的英文代码直接显示在用户的网页上吧？
在后端的 Web 框架中，我们会写一个**“全局异常处理器（GlobalExceptionHandler）”**。它就像一张大网，捕获项目中所有抛出的异常，然后把它们转换成一段温柔的 JSON 数据返回给前端：
```json
{
  "code": 500,
  "message": "亲，服务器开小差了，请稍后再试~"
}
```

### 2. 为什么不用 Tomcat 做测试？
以后你写的 Web 程序，启动一次 Tomcat 服务器可能需要好几秒。如果你只是想测试一下 MyBatis 查询数据库的 SQL 语句写得对不对，每次都启动服务器，太浪费生命了！
有了 **JUnit**，你只需要写一个 `@Test` 方法，直接单独跑那一段查询数据库的代码，连 Tomcat 都不用启动，瞬间出结果，这就是高级程序员的高效秘诀。
