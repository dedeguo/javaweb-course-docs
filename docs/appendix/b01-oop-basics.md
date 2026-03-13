---
title: Java 基础补给站——从 HelloWorld 到面向对象
---

# 从 HelloWorld 到面向对象

!!! quote "☕ 课前导语：开启 Java 宇宙的大门"
    在学习高深的 Web 开发和 Servlet 之前，我们需要把地基打牢。
    很多同学可能刚接触 Java，对怎么把代码跑起来，以及代码里常说的“对象”、“继承”、“构造器”感到一头雾水。
    
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
 *
 * 该类用于演示 Java 类的基本结构，包含成员变量和方法。
 * 主要用于展示面向对象编程中的对象创建和方法调用。
 */
public class Person {
    // 【成员变量】：用来描述对象有什么属性（状态）
    /** 人员姓名 */
    String name;

    /** 人员年龄 */
    int age;

    // 【无参构造器】
    public Person() {
    }

    // 【有参构造器】
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // 【成员方法】：用来描述对象能做什么（行为）
    /**
     * 吃饭方法
     *
     * 该方法用于模拟人员的进食行为，会在控制台输出当前对象的姓名
     * 及进食动作的描述信息。
     */
    public void eat(){
        System.out.println(name + "  吃吃吃");
    }

    /**
     * 程序主入口方法 (用于测试)
     */
    public static void main(String[] args) {
        // 使用 new 关键字，根据 Person 图纸，造出了一个名叫 "吴彦祖"、28岁的具体对象 p
        Person p = new Person("吴彦祖", 28);
        
        // 指挥这个对象去干活
        p.eat(); 
        System.out.println(p.age);
    }
}

```

---

## 🏭 三、类构造器 (Constructor)：对象的出厂设置

在上面的 `Person` 类中，你看到了两个长得很像方法，但**没有返回值类型**，且**名字和类名完全一样**的东西。这就是**构造器**。

构造器的作用是：**在对象被 `new` 出来的那一瞬间，给对象赋予初始状态（出厂设置）。**

### 1. 无参构造器

```java
public Person() {
}

```

* **比喻**：就像你买了一部没拆封、没激活的新手机。它是个空白的对象，名字和年龄都是空的，需要你以后慢慢设置。如果你不写任何构造器，Java 会悄悄送你一个隐藏的无参构造器。

### 2. 有参构造器

```java
public Person(String name, int age) {
    this.name = name; // this.name 指的是对象自己的属性，后面的 name 是传进来的参数
    this.age = age;
}

```

* **比喻**：就像你找工厂“私人订制”了一部手机，出厂的时候就已经刻上了你的名字（赋予了特定的初始值）。
* **用法**：`new Person("吴彦祖", 28)` 就会精准地调用这个有参构造器。

---

## 🧬 四、继承 (Inheritance)：站在巨人的肩膀上

在编程时，我们经常发现有些类之间存在“父子”或“包含”关系。
比如，**教师 (Teacher)** 首先是一个**人 (Person)**，然后他才具备教书的能力。我们不需要在 `Teacher` 类里把“姓名、年龄、吃饭”这些代码再抄一遍，只要使用 **`extends`** 关键字继承过来就行了！

```java
// Teacher 类继承了 Person 类
public class Teacher extends Person {
    
    // 教师独有的属性
    String schoolName;

    // 教师独有的方法
    public void teach() {
        System.out.println("I am a teacher in " + schoolName);
    }

    // 教师的无参构造器
    public Teacher() {
    }

    // 教师的有参构造器
    public Teacher(String name, int age, String schoolName) {
        // super 关键字代表“父类”！
        // 这句话的意思是：姓名和年龄的初始化，直接交给老爸（Person类）的有参构造器去处理
        super(name, age); 
        
        // 老爸处理不了的学校名字，自己来处理
        this.schoolName = schoolName;
    }

    public static void main(String[] args) {
        // 1. 创建一个教师对象
        Teacher teacher = new Teacher("张三", 30, "中国大学");
        
        // 2. 调用教师独有的方法
        teacher.teach(); 
        
        // 3. 见证奇迹的时刻：调用老爸传下来的方法！
        // 尽管 Teacher 类里没写 eat()，但因为继承了 Person，它天生就会吃饭！
        teacher.eat(); 
    }
}

```

### 💡 继承的核心法则：

1. **子类拥有父类非私有的所有属性和方法**（比如 `name`, `age`, `eat()`）。
2. **子类可以拥有自己的属性和方法**（比如 `schoolName`, `teach()`），实现了功能的扩展。
3. **`super` 关键字**：用于在子类中呼叫父类的构造器或方法。

---

## 🎉 结语

掌握了“类与对象”、“构造器初始化”以及“继承复用代码”的思想，你就正式跨入了 Java 面向对象编程的大门。

准备好迎接真正的挑战了吗？接下来，让我们带着这些基础知识，去征服 Web 开发的核心——**Servlet** 吧！

