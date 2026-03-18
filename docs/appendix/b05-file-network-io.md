---
title: 附录：Java 基础补给站——文件与网络 I/O
---

# 附录：Java 基础补给站——文件与网络 I/O：打通数据的任督二脉

!!! quote "☕ 课前导语：为什么程序需要 I/O？"
    在之前的学习中，我们造过对象，存过集合。但你有没有发现一个致命问题：**只要程序一关，或者电脑一重启，数据就全丢了！** 这是因为我们之前写的数据，全都保存在**内存**里，而内存是临时记忆。

    如果想让数据永久保存（比如写进硬盘的文本里），或者把数据发送给地球另一端的电脑（比如发微信），我们就必须打破 Java 程序的边界，去和外部世界打交道。
    这就是我们今天要攻克的难关：**I/O (Input / Output，输入与输出)**。

---

## 🌊 一、万物皆是“流 (Stream)”

在 Java 眼里，无论是读写硬盘文件，还是通过网线发送数据，本质上都是一样的：**数据的流动**。Java 把这种流动抽象成了一个极其形象的概念——**流 (Stream)**。

> **💡 生活比喻：神奇的水管**
> 想象一下，你的 Java 程序是一个大水池。
> * **Input (输入流)**：就是接在外面的一根**进水管**。通过它，你可以把硬盘里的文本、网络上的图片“抽”进你的程序里。
> * **Output (输出流)**：就是接在外面的一根**出水管**。通过它，你可以把程序里的计算结果“排”到硬盘或网络中去。
> 
> **⚠️ 永远记住一个核心基准点**：输入还是输出，是**以你的 Java 程序（内存）为中心**来判断的！
> 读文件到程序 = Input；程序写数据到文件 = Output。

---

## 📁 二、文件 I/O：和硬盘做朋友

Java 的 `java.io` 包里有四大家族，其实极其好记，按“管子粗细”分为两类：

1. **字节流 (Byte Stream)**：万能的细水管（每次滴一滴水）。能传输任何东西，尤其是**图片、视频、音乐**。
   * 鼻祖：`InputStream` / `OutputStream`
2. **字符流 (Character Stream)**：专门运送文本的粗水管（每次运一个字符）。只适合读写**文本文档 (`.txt`, `.md`, `.java`)**，它能自动解决中文乱码问题。
   * 鼻祖：`Reader` / `Writer`

### 🎯 实战：用字符流读写文本文件

在实际开发中，读写配置文本是非常常见的操作。我们来看一个最经典的读写示例，这里我们用到了高级的包装管 `BufferedReader` 和 `BufferedWriter`，它们自带“水桶（缓冲区）”，效率极高！

```java
import java.io.*;

public class FileIODemo {
    public static void main(String[] args) {
        //在这个D:\\Dev路径下新建text.txt文件
        String filePath = "D:\\Dev\\test.txt";

        // ------------------ 【写数据 (Output)】 ------------------
        // try-with-resources 语法：写在括号里的流，用完会自动关掉水龙头，防止资源泄露！
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            
            writer.write("Hello, Java Web!");
            writer.newLine(); // 优雅地换行
            writer.write("I/O 就像接水管，其实很简单。");
            
            System.out.println("写入文件成功！去 D:\\Dev 看看吧！");
            
        } catch (IOException e) {
            System.out.println("写文件失败：" + e.getMessage());
        }

        // ------------------ 【读数据 (Input)】 ------------------
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            
            System.out.println("=== 开始读取文件内容 ===");
            String line;
            // readLine() 是一次吸一口水（读一整行），直到吸不出水（返回 null）为止
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            
        } catch (IOException e) {
            System.out.println("读文件失败：" + e.getMessage());
        }
    }
}
```

---

## 🌐 三、网络 I/O：两台电脑怎么聊天？

如果把文件 I/O 比作“一个人自己写日记”，那么网络 I/O 就是“两个人打电话”。
要在网络上找到另一个人并通话，你需要两样东西：
1. **IP 地址**：能找到地球上的哪台电脑（比如 `192.168.1.100` 或 `localhost`）。
2. **端口号 (Port)**：能找到那台电脑上的哪个程序（比如 Tomcat 默认占着 `8080` 这个门牌号）。

在 Java 中，我们用 **`Socket`（套接字）** 来建立网络连接，它就像电话机的听筒。一旦电话接通，**网络底层用的依然是我们刚才学过的 `InputStream` 和 `OutputStream`！**

### 🎯 实战：手写一个极简版聊天室

网络通信需要两个人：服务端（等电话的人）和客户端（打电话的人）。

**1. 服务端程序 (Server)**：运行后会一直阻塞，傻傻地等待别人连进来。
```java
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class MyServer {
    public static void main(String[] args) throws IOException {
        // 1. 在 8888 端口开启监听（坐等电话接通）
        ServerSocket server = new ServerSocket(8888);
        System.out.println("服务端已启动，正在 8888 端口等待连接...");

        // 2. 电话终于响了，接起电话，拿到专门和对方通话的听筒 (Socket)
        Socket socket = server.accept(); 
        System.out.println("有客户端连进来了！");

        // 3. 从听筒里接一根输入水管，听听对方说了什么
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        System.out.println("客户端说：" + reader.readLine());

        // 4. 给对方回话
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        writer.write("你好，客户端！这里是服务端，我已经收到你的消息。");
        writer.newLine();
        writer.flush(); // 把水管里的水立刻压出去！

        socket.close();
        server.close();
    }
}
```

**2. 客户端程序 (Client)**：主动拨号找服务端。
```java
import java.io.*;
import java.net.Socket;

public class MyClient {
    public static void main(String[] args) throws IOException {
        // 1. 拨号！连接本机的 8888 端口
        Socket socket = new Socket("localhost", 8888);

        // 2. 接一根输出水管，给服务端发消息
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        writer.write("哈喽服务端，我是初学 Java 的小萌新！");
        writer.newLine();
        writer.flush(); // 发送！

        // 3. 接一根输入水管，听听服务端回了什么
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        System.out.println("服务端回复：" + reader.readLine());

        socket.close();
    }
}
```
*(💡 测试方法：先运行 `MyServer` 的 main 方法，再运行 `MyClient` 的 main 方法，体会两个程序隔空对话的奇妙！)*

---

## 🚀 四、实战结合：I/O 在 Web 开发中的化身

学完了文件和网络 I/O，你可能会问：这和我们马上要学的 Web 开发、Tomcat 到底有什么关系？

关系太大了！**整个 Java Web 的底层，全是依靠我们今天讲的 I/O 流支撑起来的。**

### 1. Tomcat 本质上就是一个巨大的 `MyServer`
你天天在浏览器里输入 `http://localhost:8080`，其实你的浏览器就是一个客户端（`MyClient`）。
**Tomcat 内部正是运行着一个 `ServerSocket(8080)`**。当浏览器连上 Tomcat 时，Tomcat 就会用 `InputStream` 读取浏览器发来的网址，然后用 `OutputStream` 把一段 HTML 代码或 JSON 数据顺着网线“流”回你的浏览器显示出来。

### 2. Servlet 里的 `request` 和 `response` 就是包装过的水管
在马上要学的 Servlet 中，你会看到这句极其经典的代码：
```java
// 往前端浏览器输出一句 "Hello Web"
response.getWriter().write("Hello Web");
```
眼熟吗？这里的 `getWriter()` 返回的，正是一个被 Tomcat 包装得非常高级的**字符输出流 (`Writer`)**！

### 3. 文件上传的本质：网络流 ➡️ 硬盘流
如果在网站里做“用户上传头像”功能，底层的逻辑是什么？  
1. 浏览器通过**网络输入流**，把图片数据一点点发给后端的 Java 程序。  
2. Java 程序立刻接上一根**文件输出流 (`FileOutputStream`)**，把收到的数据一点点写入到服务器的 D 盘里。  

---

你看，所有的魔法拆解到底层，都是基础的代码。掌握了 I/O 这套“水管理论”，未来 Web 开发中的各种数据传输，对你来说都不再是黑盒！