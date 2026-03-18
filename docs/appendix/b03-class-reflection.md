---
title: 附录：Java 基础补给站（进阶篇）—— Class 与反射
---

# 附录：Java 基础补给站（进阶篇）—— 揭开 Class 与反射的神秘面纱

!!! quote "☕ 课前导语：框架的“读心术”是从哪来的？"
    在我们之前的补给站中，我们提到了**“注解只是一张便利贴，自己不干活，真正干活的是读取它的幕后黑手”**。
    同时在第 3 章，我们惊叹于 Jackson 工具能瞬间把一段 JSON 字符串 `{"name":"张三"}` 变成一个 `User` 对象。

    你有没有想过，这些神奇的框架究竟是怎么做到的？
    今天，我们将带你认识 Java 世界里最接近“造物主”的两种神力：**`Class` 类** 和 **反射 (Reflection)**。掌握了它们，你就能真正看懂 Spring、MyBatis 和 Tomcat 的底层原理。

---


## 📜 一、`Class` 类：万物皆有“说明书”

在 Java 中，“万物皆对象”。但你想过没有，**你写的类本身（比如 `User` 类、`Teacher` 类），是不是也是一种对象？**

答案是肯定的！在 JVM（Java 虚拟机）的眼里，每一个你写出来的类，在被加载到内存时，都会被自动包装成一个叫做 **`Class` (首字母大写)** 的特殊对象。

> **💡 生活比喻**：  
> 如果说 `User p = new User()` 制造出来的是一辆**具体的汽车**。  
> 那么 `User.class` 就是这辆汽车的**设计图纸（说明书/DNA）**。  
> 每一款车型（每一个类），在世界上只有**唯一的一份**设计图纸。这张说明书里详细记录了：这个类叫什么名字？有哪些属性？有哪些方法？头上贴了哪些便利贴（注解）？  

### 🔑 核心技能：如何拿到这本“说明书”？（面试高频考点）

既然 `Class` 是说明书，那我们怎么拿到它呢？注意，**我们不能 `new` 一个 `Class` 对象**，它是 JVM 自动生成的。我们只能“获取”它。Java 提供了三种极其经典的方法：

#### 1. 已知类名：`.class` 语法（最安全、最常用）
如果你在写代码的时候，就已经明确知道要拿哪个类的说明书，直接在类名后面加 `.class`。
```java
// 比如我们想拿 User 类的说明书
Class<?> clazz1 = User.class; 
```
*(在后面的框架开发中，当你告诉 MyBatis 要把 JSON 转成什么对象时，经常这么用)*

#### 2. 已知对象：`getClass()` 方法
如果你手上已经有一个造好的对象了，但你不知道它是拿哪张图纸造出来的，可以问问对象自己。
```java
User user = new User();
// 问 user 对象：你的设计图纸是哪张？
Class<?> clazz2 = user.getClass(); 
```

#### 3. 只有一个字符串名字：`Class.forName()`（最强大、最动态）
这是框架最喜欢的获取方式。有时候在编译代码时，你根本不知道要用什么类，只知道一个**类的全名字符串**（包名+类名）。
```java
try {
    // 只要给一个字符串，JVM 就会去内存里找对应的图纸！
    Class<?> clazz3 = Class.forName("edu.wtbu.cs.entity.User");
} catch (ClassNotFoundException e) {
    System.out.println("找不到这个类的说明书！");
}
```

!!! tip "🧠 灵魂一问：你在哪里见过 `Class.forName`？"
    回忆一下你在学 **JDBC** 的时候，写的第一行代码是什么？  
    是不是 `Class.forName("com.mysql.cj.jdbc.Driver");`？  
    当时你可能很纳闷，为什么要写这么一句奇怪的代码？现在你懂了：这行代码的意思就是**让 JVM 根据字符串名字，把 MySQL 驱动类的“说明书”加载到内存里！** ---

### 🎯 实战：用 Class 读取注解（模拟 Tomcat 扫包）

拿到“说明书”之后能干什么？在 Web 开发中，我们在类头上写一个 `@WebServlet("/login")`，Tomcat 就能知道这个类负责处理登录请求。它是怎么读出来的？看代码：

```java
import java.lang.annotation.*;

// 1. 我们自己印一张“便利贴” (自定义注解)
// RetentionPolicy.RUNTIME 极其重要！意思是这张便利贴在程序运行期间不要撕掉，留给框架看。
@Retention(RetentionPolicy.RUNTIME) 
@interface WebRoute {
    String path(); // 便利贴上允许写一个网址路径
}

// 2. 把便利贴贴在我们的类上
@WebRoute(path = "/user/login")
public class LoginServlet {
    public void doGet() {
        System.out.println("处理登录逻辑...");
    }
}

// 3. 见证奇迹的时刻：模拟框架如何读取注解！
public class FrameworkDemo {
    public static void main(String[] args) throws Exception {
        
        // 第一步：拿到 LoginServlet 的“说明书”
        // 这里我们用最动态的方式，模拟框架读取配置的过程
        Class<?> clazz = Class.forName("LoginServlet"); // 假设在当前包下

        // 第二步：看看这本说明书上，有没有贴 @WebRoute 这张便利贴？
        if (clazz.isAnnotationPresent(WebRoute.class)) {
            
            // 第三步：如果有，就把这张便利贴撕下来仔细看
            WebRoute routeAnnotation = clazz.getAnnotation(WebRoute.class);
            
            // 第四步：读取便利贴上的内容
            System.out.println("框架检测到路由配置！");
            System.out.println("当前类名：" + clazz.getSimpleName()); // 获取类名：LoginServlet
            System.out.println("映射的网址路径是：" + routeAnnotation.path()); // 获取路径：/user/login
            
            // 此时，Tomcat 就可以在底层把 "/user/login" 和 LoginServlet 绑定起来了
        }
    }
}
```

## 🩻 二、反射 (Reflection)：Java 代码的“X光机”与“手术刀”

正常情况下，我们写代码都是“正着来”的：先 `new` 一个具体的对象，然后通过点 `.` 来调用它的属性或方法（比如 `user.setName("张三")`）。
但有时候，程序在运行期间，突然收到了一段来自前端的 JSON 字符串，或者读取到了一段 XML 配置文件。程序事先根本不知道要创建什么对象，该怎么办？

这时候就需要用到 **反射 (Reflection)**。

> **💡 生活比喻**：  
> 正常写代码就像**按说明书拼乐高**，一切都是确定好的。  
> 而反射就像是一台 **X光机** 加上一套 **精密手术刀**。即使是一个完全陌生的类，只要你把它的“说明书” (`Class` 对象) 丢给反射机制，它就能在程序运行的时候：  
> 1. 无视访问权限，透视里面所有的属性和方法。  
> 2. 强行造出这个类的对象。  
> 3. 强行修改那些被 `private` 锁在保险箱里的属性。  
> 4. 像遥控器一样，动态按下某个方法的执行键。  

### 🛠️ 反射的“三大手术工具”

当你拿到 `Class` 这本说明书后，Java 在 `java.lang.reflect` 包下为你提供了三把专用的手术刀来解剖这个类：

* **`Constructor` (构造器)**：专门用来动态 `new` 创造对象。  
* **`Field` (字段/属性)**：专门用来获取或修改成员变量的值。  
* **`Method` (方法)**：专门用来动态执行类里面的行为。  

接下来，我们通过两个框架最常用的实战场景，来看看这把手术刀是怎么用的。

---

### 🎯 实战 1：动态塞值（模拟 Jackson 的 JSON 解析原理）

在第 3 章我们用了 Jackson 来解析 JSON。它是怎么把一段毫无生气的字符串 `{"name":"张三", "age":25}` 变成 Java 对象的？而且即使你的属性是 `private`，它也能放进去！这就是 `Field` 手术刀的威力。

#### 1. 准备一个被严密封装的实体类
```java
public class User {
    // 故意设为私有，且没有给 set 方法，看看反射能不能暴力破解！
    private String name;
    private int age;

    public void printInfo() {
        System.out.println("我是 " + name + "，今年 " + age + " 岁。");
    }
}
```

#### 2. 编写反射黑客工具 (模拟 Jackson 底层)
```java
import java.lang.reflect.Field;
import java.util.Map;
import java.util.HashMap;

public class MyJsonParser {

    /**
     * 这是一个万能转换器，利用反射将 Map (模拟的JSON) 转换为任意 Java 对象
     * @param jsonMap 模拟前端传来的 JSON 数据 (如 {"name":"张三", "age":25})
     * @param clazz 你想把它变成什么类的说明书 (如 User.class)
     */
    public static <T> T parseJsonToObject(Map<String, Object> jsonMap, Class<T> clazz) throws Exception {
        
        // 1. 【造对象】查阅说明书，让 JVM 凭空造一个对象出来 (相当于 new User())
        T obj = clazz.getDeclaredConstructor().newInstance();

        // 2. 【X光透视】扫描这个类的所有属性 (不管 public 还是 private)
        Field[] fields = clazz.getDeclaredFields();

        for (Field field : fields) {
            String fieldName = field.getName(); // 获取属性名，比如 "name"

            // 3. 看看 JSON 里有没有对应这个属性名的值
            if (jsonMap.containsKey(fieldName)) {
                
                // ⚠️ 暴力破解警报！
                // 因为属性是 private 私有的，正常情况不准改。
                // setAccessible(true) 的意思就是：不管三七二十一，用手术刀把保险柜撬开！
                field.setAccessible(true);
                
                // 4. 【强行赋值】把 JSON 里的值，强行塞进 obj 对象的这个属性里
                field.set(obj, jsonMap.get(fieldName));
            }
        }
        
        return obj; // 5. 返回加工完毕的完整对象
    }

    public static void main(String[] args) throws Exception {
        // 假设这是前端发来的 JSON 被解析成了 Map
        Map<String, Object> fakeJson = new HashMap<>();
        fakeJson.put("name", "张三");
        fakeJson.put("age", 25);

        // 调用我们的万能工具
        User user = parseJsonToObject(fakeJson, User.class);
        user.printInfo(); // 成功输出：我是 张三，今年 25 岁。
    }
}
```

---

### 🎯 实战 2：动态执行方法（模拟 Tomcat 请求转发原理）

我们在浏览器输入 `http://localhost:8080/login`，Tomcat 就能准确地去执行 `LoginServlet` 里的 `doGet()` 方法。Tomcat 在编写源码的时候，根本不可能认识你写的类！它是怎么调用你的方法的？靠的是 `Method` 手术刀。

```java
import java.lang.reflect.Method;

public class TomcatSimulator {
    public static void main(String[] args) throws Exception {
        // 假设 Tomcat 通过读取配置文件或注解，知道了用户想访问的类和方法名
        String className = "LoginServlet"; // 假设在当前包下
        String methodName = "doGet";       // Servlet 常用方法

        System.out.println("Tomcat 接收到请求，开始寻找对应的代码...");

        // 1. 【拿说明书】根据字符串加载类
        Class<?> clazz = Class.forName(className);

        // 2. 【造对象】由于方法必须由对象来执行，所以先造一个 Servlet 实例
        Object servletInstance = clazz.getDeclaredConstructor().newInstance();

        // 3. 【找方法】在说明书里找出那个名叫 "doGet" 的方法
        // 如果这个方法有参数，还需要在后面填上参数的类型，比如 .getDeclaredMethod("doGet", HttpServletRequest.class, HttpServletResponse.class)
        Method targetMethod = clazz.getDeclaredMethod(methodName);

        // 4. 【按下遥控器】动态执行这个方法！
        // invoke (召唤/调用) 的意思是：让 servletInstance 这个对象，去执行 targetMethod 这个方法
        System.out.println("Tomcat 准备执行方法：");
        targetMethod.invoke(servletInstance); 
    }
}
```
*(假设你之前写了一个 `LoginServlet` 类里面有个 `public void doGet()` 方法，这段代码就能完美运行并打印出你的业务逻辑。)*

---

## 🚀 总结：给新手的忠告

在这篇进阶补给站中，你见识了 Java 世界中最强大的“黑魔法”：

1. **`Class` 类**：代表了类的说明书，利用它，我们可以像 Tomcat 一样**动态扫描和读取注解**。
2. **反射 (Reflection)**：它是框架的绝对灵魂。有了它，框架就能在运行时**动态创建对象 (`newInstance`)、暴力破解私有属性 (`Field`) 并动态执行方法 (`Method`)**。

**🚨 最后的忠告**：  
反射虽然强大，就像能够打破常规的超能力。但在我们日常写普通的业务代码（比如写个借书逻辑、算个购物车总价）时，**绝对不要自己去用反射**！  
因为反射有两大缺点：  
1. **破坏封装**：把辛辛苦苦设计的 `private` 变得形同虚设，容易引发安全问题。  
2. **性能较慢**：反射绕过了编译器的优化，是在运行期动态解析的，执行速度比普通的 `new` 对象要慢得多。  

这些底层的黑魔法，请放心地交给 Spring、MyBatis 和 Tomcat 这种“大基建框架”去施展吧！你只需要理解它们是怎么做到的，这就是从“码农”向“架构师”跨越的第一步。