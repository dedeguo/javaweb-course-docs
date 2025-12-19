# 实验1：Web环境与AI助手配置

!!! abstract "实验信息"
    * **实验学时**：2 学时
    * **实验类型**：验证性/设计性
    * **截稿时间**：第 2 周周日 23:59
    * **核心目标**：完成“本地开发环境 + AI 结对编程助手”的初始化，并跑通第一个 Java Web 接口。

---

## 🧪 实验目的

1.  **环境就绪**：完成 Dragonwell JDK 17、IntelliJ IDEA、Maven 的安装与全局配置。
2.  **AI 赋能**：安装并激活 **通义灵码 (Tongyi Lingma)** 或其他 AI 编程插件，体验 AI 代码生成与解释功能。
3.  **工程跑通**：创建一个基于 Spring Boot 的 Web 项目，实现 "Hello World" 接口的运行与访问。
4.  **工具规范**：完成 Git 初始化，掌握基本的 `commit` 操作。

---

## 📋 实验前准备

请确保你已经阅读并完成了以下章节的配置：
* [x] [开发环境秒级就绪 (JDK/Maven/Idea)](env-setup.md)
* [x] [工程化基石 (Maven/Git)](maven-git.md)
* [x] [你的 AI 编程搭档 (账号注册)](ai-tools.md)

---

## 👣 实验步骤

### 任务一：验证基础环境

打开命令行 (CMD/PowerShell) 或 IDEA 的 Terminal，依次执行以下命令，截图保存（**截图 A**）：

```bash
# 1. 验证信创 JDK 版本
java -version
# 预期输出：Alibaba Dragonwell ... build 17...

# 2. 验证 Maven 及阿里云镜像
mvn -v
# 预期输出：Apache Maven 3.9.x ...
```

### 任务二：创建 Spring Boot 项目

我们使用 **Spring Initializr** 快速构建项目。

1. **新建项目**：打开 IDEA -> `New Project` -> `Spring Initializr` (或访问 start.spring.io)。
2. **填写元数据 (Metadata)**：
* **Name**: `lab1-hello`
* **Type**: Maven
* **Language**: Java
* **Group**: `com.example` (或你的学号)
* **JDK**: 17 (Dragonwell)


3. **选择依赖 (Dependencies)**：
* 搜索并勾选 **Spring Web** (这是 Web 开发的核心)。
* 搜索并勾选 **Lombok** (简化代码)。


4. **点击 Create**，等待 Maven 自动下载依赖（观察右下角进度条，得益于阿里云镜像，速度应该很快）。

### 任务三：编写 Hello World 接口

在 `src/main/java/com/example/lab1hello` 包下，新建一个类 `HelloController.java`。

**⚡️ 挑战：使用 AI 生成代码**

不要手写！尝试在类中输入 `//` 注释，让通义灵码帮你生成：

```java
package com.example.lab1hello;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    // 提示词：生成一个GET请求接口，访问路径是 /hello，返回 "Hello AI World! 学号+姓名"
    // (光标停在这里，等待 AI 自动续写代码，按 Tab 键采纳)
    @GetMapping("/hello")
    public String sayHello() {
        return "Hello AI World! 2025001 张三"; // 请替换为你自己的信息
    }
}

```

### 任务四：运行与 AI 交互 (重点)

1. **启动项目**：点击 `Lab1HelloApplication` 类左侧的绿色三角 ▶️ 运行。
2. **浏览器测试**：访问 `http://localhost:8080/hello`，确保看到你的名字。截图保存（**截图 B**）。
3. **AI 深度对话**：
* 选中 `HelloController` 的全部代码。
* 右键选择 **通义灵码 / AI 助手** -> **解释代码 (Explain Code)**。
* 或者在 DeepSeek/豆包中提问：“*请向我解释 Spring Boot 中 @RestController 和 @GetMapping 的作用是什么？*”
* 将 AI 的回答截图保存（**截图 C**）。



---

## 💾 提交规范 (考核点)

本次实验无需提交复杂的报告文档，重点考核 **Git 提交规范**。

### 1. Git 提交

在项目根目录下，执行以下 Git 命令：

```bash
# 初始化仓库
git init

# 添加所有文件（注意检查 .gitignore 是否忽略了 target/ 目录）
git add .

# 提交代码 (严禁使用 "first commit" 这种无意义的备注)
git commit -m "feat: 完成Lab1环境配置，实现Hello接口 by 张三"

```

### 2. 成果物上传

请将以下内容打包上传至学习通/课程平台：

1. **截图 A**：CMD 环境验证截图（含 Dragonwell 和 Maven 版本）。
2. **截图 B**：浏览器成功访问 `localhost:8080/hello` 的截图。
3. **截图 C**：你与 AI 助手的对话截图（证明你学会了用 AI 解释代码）。
4. **(可选)**：Git Log 截图。

!!! warning "避坑指南"
* **端口冲突**：如果启动报错 `Port 8080 was already in use`，请在 `application.properties` 中添加 `server.port=8081`，然后重新运行。
* **Maven 爆红**：如果依赖下载失败，请点击 IDEA 右侧 Maven 面板的“刷新”图标 (Reload All Maven Projects)。

---

**🎉 恭喜！你已经完成了第一次全栈开发体验。**