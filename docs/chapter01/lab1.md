# 实验 1：Web 环境配置与 AI 结对编程初体验

!!! abstract "实验信息"
    * **实验学时**：2 学时
    * **实验类型**：验证性
    * **截稿时间**：第XX 周周X XX:XX
    * **核心目标**：配置“本地环境 + AI 助手”，通过 **Gitee Fork 模式** 完成第一个 Spring Boot 接口的开发与提交。

---

## 🧪 实验目的

1.  **环境验证**：确保 JDK 17 、Maven、IDEA 全局配置无误。
2.  **AI 赋能**：激活 **通义灵码** 或 **DeepSeek**，体验“不写代码，只审代码”的 AI 结对编程模式。
3.  **Git 实战**：掌握 **Fork -> Clone -> Commit -> Push** 的开源协作标准流程。
4.  **接口开发**：跑通 Spring Boot 的 "Hello World"。

---

## 📋 实验前准备

* [x] 已完成 [开发环境安装](01-env-setup.md) (JDK/Maven/IDEA)。
* [x] 已注册 [Gitee 账号](https://gitee.com),记住自己的用户名密码。
* [x] 已安装 [通义灵码插件](03-ai-tools.md)。

---

## 👣 实验步骤

### 任务一：获取任务代码 (Fork & Clone)

本次实验不再手动新建项目，而是采用企业级开发常用的 **Fork 模式**。

1.  **Fork 仓库**：
    * 访问实验种子仓库：[https://gitee.com/javaweb-dev-tech/lab1](https://gitee.com/javaweb-dev-tech/lab1)
    * 点击右上角的 **「Fork」** 按钮，将项目复制到你自己的 Gitee 账号下。
2.  **Clone 到本地**：
    * 在你的 Gitee 仓库页面，点击“克隆/下载”，复制 HTTPS 地址。
    * 打开 IDEA -> `Get from VCS（克隆仓库）` -> 粘贴地址 -> `Clone`。

### 任务二：验证基础环境

在 IDEA 打开项目后，打开底部的 `Terminal` (终端)，执行以下命令并**截图**：

```bash
# 1. 验证 JDK (需显示 Dragonwell 或 build 17)
java -version

# 2. 验证 Maven (需显示 3.6+)
mvn -v

```

> 📸 **截图保存**：将截图重命名为 `env.png`，放入项目根目录下的 `img` 文件夹中（覆盖原有的占位图）。

### 任务三：AI 辅助编写接口

**⚡️ 挑战：不手写一行 Java 代码，全靠 AI 生成。**

1. **定位文件**：找到 `src/main/java/edu/wtbu/cs/lab1/` 目录（如果没有请新建）。
2. **找到类**：找到 `HelloController.java`（如果没有请新建）。
3. **AI 生成**：在类中输入以下注释（Prompt），等待通义灵码自动续写：

```java
package edu.wtbu.cs.lab1;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    // Prompt: 生成一个GET接口，路径/hello，返回 "Hello AI! 学号+姓名"
    // (光标停在这里，等待灰色建议出现，按 Tab 键采纳)
    
}

```

### 任务四：运行与验证

1. **启动项目**：运行 `Lab1Application.java`。
2. **测试接口**：浏览器访问 `http://localhost:8080/hello`。
3. **AI 解释**：选中代码，右键询问 AI：“*解释一下 @RestController 的作用*”。

> 📸 **截图保存**：

> * 将浏览器成功访问的画面截图，重命名为 `web.png`，放入 `img` 文件夹。
> * 将 AI 解释代码的对话界面截图，重命名为 `ai.png`，放入 `img` 文件夹。
> 
> 

---

## 💾 作业提交 (核心考核点)

### 1. 完善文档 (README)

双击打开项目根目录的 `README.md`，切换到“编辑模式”：

* 填写顶部的 **班级、姓名、学号**。
* 点击 IDEA 右上角的 `Preview` 按钮，检查刚才放入 `img` 文件夹的三张图片（`env.png`, `web.png`, `ai.png`）是否能在文档中正常显示。

### 2. 推送代码 (Git Push)

在终端执行以下命令，将代码同步到你的 Gitee 仓库：

```bash
# 1. 查看变更状态 (确保 img 图片和 Java 代码都被检测到)
git status

# 2. 添加到暂存区
git add .

# 3. 提交到本地仓库 (请替换为真实姓名)
git commit -m "feat: 完成实验1，学号2025xxxx 张三"

# 4. 推送到远程 Gitee
git push
```

!!! tip "🔐 首次提交需身份验证"
    当你执行 `git push` 时，如果你是第一次在本地连接 Gitee，IDEA 或系统会弹出一个**登录窗口**。
    
    * **用户名**：请填写你的 **Gitee 注册邮箱** 或 **手机号**（不是你的中文昵称！）。
    * **密码**：你的 Gitee 登录密码。
    * *注：输入成功一次后，Windows/Mac 会自动记住密码，以后提交就不需要再输了。*

### 3. 最终核验

打开**你的 Gitee 仓库网页**，如果能看到：

* [ ] 你的 `README.md` 里显示了你的个人信息。
* [ ] 页面下方的图片能正常显示（不是裂开的图标）。
* [ ] `src` 目录下有你刚才写的 Java 代码。

**恭喜！你已成功完成实验 1。** *(若学校平台需要提交，请将你的 Gitee 仓库链接提交上去)*

---

## ❓ 常见问题 (FAQ)

**Q1: 为什么图片显示不出来？**
> **A:** 请检查文件名大小写！Gitee 服务器严格区分大小写，`Env.png` 和 `env.png` 是不一样的。请统一使用小写文件名。

**Q2: 启动报错 "Port 8080 was already in use"？**
> **A:** 这说明默认端口被占用了。请修改 `src/main/resources/application.properties` 文件，添加一行 `server.port=8081`，保存后重新运行。

**Q3: Push 报错 "Permission denied"？**
> **A:** 请检查你是否误 Clone 了老师的仓库？你没有权限向老师的仓库推送代码。
> **解决方法**：请确保你 Clone 的是 **你自己 Gitee 账号下** 的仓库（URL 中包含你的用户名）。

**Q4: 密码输错了，之后一直报 "Authentication failed" 怎么办？**
> **A:** 这是因为错误的密码被 Windows/Mac 记住了。需要手动清除凭据：
>
> 1.  在电脑搜索栏输入 **"凭据管理器" (Credential Manager)**。
> 2.  点击 **"Windows 凭据"**。
> 3.  找到 `git:https://gitee.com` 这一项。
> 4.  点击 **"删除"**。
> 5.  重新执行 `git push`，系统就会弹窗让你输入新密码了。