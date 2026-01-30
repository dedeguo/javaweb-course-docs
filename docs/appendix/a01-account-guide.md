---
title: 开发者账号与工具权益申请指南
---

### 📋 步骤一：激活校内电子邮箱 (核心前置步骤)

根据学校《关于邮件系统升级切换的通知》，学校邮箱已迁移至阿里企业邮，这是你证明“学生身份”的关键。

1. **登录地址**：
    * 浏览器访问：`mail.stu.wtbu.edu.cn`  。

2. **账号格式**：
    * `学号@stu.wtbu.edu.cn` (请确认您的具体学号) 。

3. **初始密码**：
    * `Wtbu` + `身份证后六位`。
    * 
    *示例*：如果身份证后六位是 243215，密码即为 `Wtbu243215` 。

4. **首次登录强制操作**：
    * 首次必须通过网页端登录，系统会强制要求你**修改新密码**后才能正常使用 。
    * *注意：后续 JetBrains 的验证邮件会发到这里，请确保能收到邮件。*

---

### 💻 步骤二：JetBrains 教育免费许可 (获取 IDEA Ultimate)

JetBrains 提供给学生的免费全家桶许可（包含 IntelliJ IDEA Ultimate 专业版），每年需续期一次。

1. **申请地址**：

    * 访问：[https://www.jetbrains.com/shop/eform/students](https://www.jetbrains.com/shop/eform/students)
    * 在官网点击菜单 `教育` -> `免费许可证` -> `面向学生`。


2. **填写表单**：

    * **Apply with**: 选择 **"University email address"** (校园邮箱)。
    * **Email address**: 填写你的校内邮箱（`...@stu.wtbu.edu.cn`）。
    * **Name**: 填写真实姓名（拼音）。


3. **邮件验证**：

    * 提交后，登录你的校内邮箱（步骤一中的邮箱），找到来自 JetBrains 的确认邮件。
    * 点击邮件中的链接（Confirm Request）。


4. **注册 JetBrains Account**：

    * 验证后，引导你创建一个 JetBrains 账号（建议直接用校内邮箱注册）。


5. **激活软件**：

    * 打开 IntelliJ IDEA，点击 `Activate` -> 选择 `JetBrains Account` -> 输入账号密码登录即可。

---

### 🤖 步骤三：魔塔社区 ModelScope (获取 AI 模型 API)

在课程的第5章中，我们需要使用魔塔社区的 API 来调用 DeepSeek 或 Qwen 模型。

1. **注册/登录**：
    * 访问：[https://www.modelscope.cn/](https://www.modelscope.cn/)
    * 点击右上角“登录/注册”。
    * 推荐使用 **支付宝** 或 **手机号** 直接快捷登录。


2. **获取 Access Token (API Key)**：
    * 登录后，点击右上角头像 -> 选择 **“个人中心”** (或者叫“我的主页”)。
    * 在左侧菜单找到 **“访问令牌” (Access Token)**。
    * 点击“新建令牌”，复制生成的 Key（以 `sk-` 开头）。
    * *用途：配置在 `application.properties` 的 `spring.ai.openai.api-key` 中。*

---

### 🐋 步骤四：DeepSeek (深度求索)

DeepSeek 官网主要用于网页端对话，辅助写代码和查错（你的“云端助教”）。

1. **访问地址**：
    * [https://chat.deepseek.com/](https://chat.deepseek.com/)


2. **注册/登录**：
    * 建议选择 **“手机号登录”** 或者 **“微信扫码”**。
    * *注：如果你需要调用 DeepSeek 官方 API 而不是魔塔社区的 API，则需要去 `platform.deepseek.com` 充值申请 Key，但课程中建议使用魔塔社区（ModelScope）提供的免费/兼容接口。*



---

### 🗺️ 步骤五：高德开放平台 (获取地图 API)

这是第五章第5节中实现 MCP（Model Context Protocol）工具调用所必需的。

1. **注册账号**：
    * 访问：[https://lbs.amap.com/](https://lbs.amap.com/)
    * 点击右上角“登录”，使用高德地图 App 扫码或手机号登录（通常与淘宝/支付宝账号互通）。


2. **开发者认证**：
    * 登录后点击“控制台”。
    * 系统会提示进行认证，选择 **“个人开发者”**。
    * 需要填写姓名、身份证号并进行支付宝实名认证（即时通过）。


3. **创建应用**：
    * 进入控制台 -> **“应用管理”** -> **“我的应用”** -> **“创建新应用”**。
    * 应用名称随意（如：`SmartBook_AI`），类型选“Web服务”或“服务端”。


4. **获取 Key**：
    * 在应用下点击“添加 Key”。
    * 服务平台选择 **“Web服务”** (注意：不是 Web 端 JS API，我们需要的是后端调用的 API)。
    * 提交后，你将获得一串 **Key**。
    * *用途：用于配置 MCP Server 的 `AMAP_MAPS_API_KEY`。*

---


### 🐈 步骤六：Gitee 码云 (代码托管)

用于提交作业（如 Lab3, Lab4 等）。

1. **注册**：
    * 访问：[https://gitee.com/](https://gitee.com/)
    * 使用手机号注册。

2. **绑定邮箱**：
    * 注册后建议在“设置”中绑定你的常用邮箱（避免手机号变动导致无法找回）。


3. **提交方式（重要⚠️）**：
    * **机房特殊环境**：由于教室电脑装有**还原卡**（重启后数据清零），配置 SSH Key 会非常麻烦且无法保存。
    * **推荐方式**：请统一使用 **HTTPS** 协议进行代码推送。
    * **注意事项**：使用 HTTPS 推送时，每次都需要验证身份，**请务必牢记你的 Gitee 账号和密码**。

4. **作业准备**：
    * Fork 老师的仓库（如 `javaweb-dev-tech/lab3`）。
    * 复制仓库的 **HTTPS 地址**，然后 Clone 到本地。

---

### 🧩 步骤七：通义灵码 (IDEA AI 插件)

阿里推出的 AI 编程插件，可以在 IDEA 里帮你解释代码、生成单元测试。

1. **安装插件**：
    * 打开 IDEA -> `Settings` -> `Plugins` -> Marketplace。
    * 搜索 `TONGYI Lingma` -> Install -> Restart IDE。


2. **登录**：
    * 重启 IDEA 后，右侧边栏会出现通义灵码图标。
    * 点击登录，会弹出一个二维码。
    * 使用 **支付宝** 或 **阿里云 App** 扫码授权登录即可。

---

### 🚀 总结：你需要收集的“密钥”清单

完成以上步骤后，请将以下信息保存在安全的记事本中（**不要上传到 Git！**）：

| 平台 | 关键信息 | 用途 |
| --- | --- | --- |
| **校内邮箱** | 账号/密码 | 接收 JetBrains 验证码 |
| **JetBrains** | 账号/密码 | 激活 IDEA |
| **ModelScope** | `sk-xxxx...` | Spring AI 连接大模型 |
| **高德开放平台** | API Key | MCP 地图工具调用 |
| **Gitee** | 账号/密码 | 推送实验代码 |