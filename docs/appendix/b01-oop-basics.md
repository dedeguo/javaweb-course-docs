---
title: 附录：Java 基础补给站——从 HelloWorld 到面向对象
---

# 附录：Java 基础补给站——从 HelloWorld 到面向对象

!!! quote "☕ 课前导语：开启 Java 宇宙的大门"
    在学习高深的 Web 开发和 Servlet 之前，我们需要把地基打牢。
    很多同学可能刚接触 Java，对怎么把代码跑起来，以及代码里常说的“对象”、“封装”、“继承”感到一头雾水。
    
    别担心！这篇附录将用最简单的生活比喻，结合最基础的代码示例，带你快速通关 Java 核心语法。让我们从那句经典的问候语开始吧！

---

## 🌍 一、万物起源：HelloWorld 与编译运行

学习任何一门编程语言，我们写的第一个程序永远是输出一句 "Hello World!"。这不仅是为了向计算机世界问好，更是为了验证我们的开发环境是否配置成功。

### 1. 编写第一个 Java 程序
你可以把下面这段代码保存在一个名为 `HelloWorld.java` 的文件中。注意，**文件名必须和 `public class` 后面的名字完全一致**。

```java
/**
 * HelloWorld 类 - Java 入门示例程序
 * * 该类用于演示最基本的 Java 程序结构，通过输出"Hello World!"来验证环境配置
 * 并展示 Java 程序的入口点。
 */
public class HelloWorld {
    /**
     * 程序主入口方法
     * * 这是 Java 应用程序的标准入口点，JVM（Java虚拟机）从此处开始执行程序。
     * 该方法负责在控制台输出一条问候消息。
     *
     * @param args 命令行参数数组，允许用户在运行时传递参数（本示例未使用）
     */
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}

```

### 2. 魔法指令：编译与运行

Java 是一门**编译型语言**。计算机是看不懂你写的英文单词的，它只认识 `0` 和 `1`。所以我们需要一个“翻译官”。

打开命令行终端（CMD 或终端），进入到 `HelloWorld.java` 所在的目录，依次敲入以下两个命令：

**第一步：编译（翻译代码）**

```bash
javac HelloWorld.java

```

* **作用**：`javac` 是 Java 编译器的命令。它会把你写的 `.java` 源码文件，翻译成计算机能看懂的 `.class` 字节码文件。如果代码没写错，这行命令敲完后不会有任何提示，但文件夹里会多出一个 `HelloWorld.class` 文件。

**第二步：运行（执行程序）**

```bash
java HelloWorld

```

* **作用**：`java` 是运行命令，它会启动 JVM（Java 虚拟机）去执行刚才生成的 `.class` 文件。
* **注意**：运行的时候**不需要**加 `.class` 后缀！
* **结果**：你的屏幕上会激动人心地点亮这行字：`Hello World!`

---

## 🧑‍🤝‍🧑 二、认识对象与类：造人的图纸

在 Java 的世界里，有一句名言叫**“万物皆对象”**。

* **对象 (Object)**：现实世界中具体的某一个事物，比如“你”、“我”、“这台电脑”。
* **类 (Class)**：用来创建对象的“设计图纸”或“模具”。

让我们来看一张名为 `Person`（人）的图纸：

```java
/**
 * Person 类 - 人员信息示例类
 */
public class Person {
    // 【成员变量】：用来描述对象有什么属性（状态）
    String name;
    int age;

    // 【成员方法】：用来描述对象能做什么（行为）
    public void eat(){
        System.out.println(name + "  吃吃吃");
    }

    /**
     * 程序主入口方法 (用于测试)
     */
    public static void main(String[] args) {
        // 使用 new 关键字，根据 Person 图纸，造出了一个具体的对象 p
        Person p = new Person();
        p.name = "wuhh";
        p.age = 12;
        
        // 指挥这个对象去干活
        p.eat(); 
        System.out.println(p.age);
    }
}

```

---

## 🏭 三、类构造器 (Constructor)：对象的出厂设置

在刚才的代码中，我们造出人之后，是一步一步去设置名字和年龄的。如果属性有 100 个，那不得累死？
这个时候，我们需要**构造器**。

构造器的作用是：**在对象被 `new` 出来的那一瞬间，给对象赋予初始状态（出厂设置）。**
*它长得很像方法，但没有返回值类型，且名字必须和类名完全一样。*

### 1. 无参构造器

```java
public Person() {
}

```

* **比喻**：就像你买了一部没拆封的新手机。它是个空白的对象，需要你以后慢慢设置。如果你不写任何构造器，Java 会悄悄送你一个隐藏的无参构造器。

### 2. 有参构造器

```java
public Person(String name, int age) {
    this.name = name; // this.name 指的是对象自己的属性，后面的 name 是传进来的参数
    this.age = age;
}

```

* **比喻**：就像你找工厂“私人订制”了一部手机，出厂的时候就已经刻上了特定信息。
* **用法**：以后造人只需要一句代码：`Person p = new Person("wuhh", 12);` 即可精准调用。

---

## 🛡️ 四、封装 (Encapsulation)：保护你的隐私与财产

在前面的例子中，我们在外部可以通过 `p.age = -10;` 随意修改对象的年龄。人的年龄怎么可能是负数呢？这就是数据不安全！
面向对象的第一大特性——**封装**，就是为了解决这个问题。

### 1. 什么是封装？

把对象的属性藏起来（变为私有），不让外界直接访问；同时提供公共的方法，让外界按照我们定好的规矩来访问或修改。

> **💡 生活比喻**：
> 银行里的 **ATM 机** 就是封装的完美体现。银行不可能把钱（属性）直接摊在桌子上让你拿。它把钱锁在保险柜里（`private` 私有化），然后提供了一个插卡和输密码的插口（`public` 公共方法）。你只有输入正确的密码，才能通过合法的渠道取到钱。

### 2. 封装的两大步：private 与 get/set

让我们对 `Person` 类进行一次“安全升级”：

```java
public class Person {
    // 1. 第一步：使用 private (私有) 关键字修饰属性
    // 这样别人在类的外面就再也不能使用 p.name 或 p.age 直接访问了
    private String name;
    private int age;

    public Person() {}

    // 2. 第二步：提供公共的 (public) get 方法（允许别人读取）
    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    // 3. 第三步：提供公共的 (public) set 方法（允许别人修改，并在里面加安检逻辑）
    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        // 在 set 方法里加上安检逻辑，防止瞎填数据
        if (age < 0 || age > 150) {
            System.out.println("警告：输入的年龄不合法！");
        } else {
            this.age = age; // 只有合法的数据才允许赋值
        }
    }

    public static void main(String[] args) {
        Person p = new Person();
        // ❌ p.age = -10; // 报错！age 是私有的，拿不到了
        
        // ✅ 必须通过规范的接口(set方法)来操作
        p.setAge(-10); // 控制台会打印：警告：输入的年龄不合法！
        p.setAge(18);  // 合法，成功赋值
        
        System.out.println("这个人的年龄是：" + p.getAge());
    }
}

```

!!! tip "开发小贴士：实体类的标配"
    在马上要学习的 Web 开发中，我们会用对象来接收前端网页传过来的表单数据。**“所有属性全部 `private`，并提供标准的 `getter` 和 `setter` 方法”**，这是 Java 后端开发的铁律！未来我们还可以用 `@Data` 注解让系统自动帮我们生成这些繁琐的 `get/set` 代码。

---

## 🧬 五、继承 (Inheritance)：站在巨人的肩膀上

在编程时，我们经常发现有些类之间存在“父子”或“包含”关系。
比如，**教师 (Teacher)** 首先是一个**人 (Person)**，然后他才具备教书的能力。我们不需要在 `Teacher` 类里把“姓名、年龄、吃饭”这些代码再抄一遍，只要使用 **`extends`** 关键字继承过来就行了！

```java
// Teacher 类继承了 Person 类
public class Teacher extends Person {
    
    // 教师独有的属性
    private String schoolName;

    // 教师独有的方法
    public void teach() {
        // 因为父类的 name 是 private 的，所以要用 getName() 来获取
        System.out.println(this.getName() + " is a teacher in " + schoolName);
    }

    // 教师的无参构造器
    public Teacher() {
    }

    // 教师的有参构造器
    public Teacher(String name, int age, String schoolName) {
        // super 关键字代表“父类”！
        // 这句话的意思是：姓名和年龄的初始化，直接交给老爸（Person类）的有参构造器去处理
        // 注意：如果你要在 Person 里使用这段代码，请确保 Person 已经写好了对应的有参构造器
        super(name, age); 
        
        // 老爸处理不了的学校名字，自己来处理
        this.schoolName = schoolName;
    }

    public static void main(String[] args) {
        // 1. 创建一个教师对象
        Teacher teacher = new Teacher("张三", 30, "中国大学");
        
        // 2. 调用教师独有的方法
        teacher.teach(); 
    }
}

```

### 💡 继承的核心法则：

1. **子类拥有父类非私有的所有属性和方法**。
2. **子类可以拥有自己的属性和方法**（比如 `schoolName`, `teach()`），实现了功能的扩展。
3. **`super` 关键字**：用于在子类中呼叫父类的构造器或方法。

---

## 🎉 结语

掌握了“类与对象”、“构造器”、“保护数据的封装”以及“继承复用代码”的思想，你就正式跨入了 Java 面向对象编程的大门。

准备好迎接真正的挑战了吗？接下来，让我们带着这些基础知识，去征服 Web 开发的核心——**Servlet** 吧！

