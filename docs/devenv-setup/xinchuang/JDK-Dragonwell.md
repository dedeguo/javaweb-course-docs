下面给你一份**「国产 JDK 从选择 → 下载 → 安装 → 配置 → 验证」的完整流程**，覆盖 **Linux（AnolisOS / Rocky / CentOS / Ubuntu）和 Windows**，同时也符合 **信创/国产化场景**，你在教学或项目里都能直接用。

---

## 一、先选一个合适的国产 JDK（结论先给你）

目前**主流、稳定、认可度高**的国产 JDK 主要这几家：

| 国产 JDK                    | 推荐度   | 说明                     |
| ------------------------- | ----- | ---------------------- |
| **Dragonwell（龙井 JDK，阿里）** | ⭐⭐⭐⭐⭐ | 最主流，基于 OpenJDK，阿里生产级验证 |
| **Tencent Kona JDK**      | ⭐⭐⭐⭐  | 腾讯出品，性能优化好             |
| **Huawei BiSheng JDK**    | ⭐⭐⭐⭐  | 华为信创体系常用               |
| **openEuler JDK**         | ⭐⭐⭐   | 偏政企 / openEuler 生态     |

👉 **个人 & 教学 & 企业通用首选：Dragonwell 8 / 11 / 17**

---

## 二、下载国产 JDK（以 Dragonwell 为例）

### 1️⃣ 选择版本建议

* **Java 8**：传统项目 / 教学最稳
* **Java 11**：LTS，企业新项目推荐
* **Java 17**：新项目 / Spring Boot 3+

> 如果你在教 Java Web / Spring Boot
> 👉 **Dragonwell 8 + Dragonwell 17** 最合适

---

### 2️⃣ 下载地址（官方）

Dragonwell 官方 GitHub Release（推荐）
👉 [https://github.com/alibaba/dragonwell8/releases](https://github.com/alibaba/dragonwell8/releases)
👉 [https://github.com/alibaba/dragonwell11/releases](https://github.com/alibaba/dragonwell11/releases)
👉 [https://github.com/alibaba/dragonwell17/releases](https://github.com/alibaba/dragonwell17/releases)

下载文件名一般类似：

```text
Alibaba_Dragonwell_8.17.17_x64_linux.tar.gz
Alibaba_Dragonwell_17.0.9_x64_linux.tar.gz
```

---

## 三、Linux 安装配置流程（AnolisOS / Rocky / CentOS / Ubuntu 通用）

### 1️⃣ 上传或下载到服务器

```bash
cd /opt
sudo mkdir -p /opt/java
sudo chown $USER:$USER /opt/java
```

上传或下载到 `/opt/java`

---

### 2️⃣ 解压

```bash
cd /opt/java
tar -zxvf Alibaba_Dragonwell_17*.tar.gz
```

解压后目录类似：

```text
/opt/java/dragonwell-17.0.9
```

---

### 3️⃣ 配置环境变量（推荐方式）

编辑全局环境变量：

```bash
sudo nano /etc/profile.d/java.sh
```

写入：

```bash
export JAVA_HOME=/opt/java/dragonwell-17.0.9
export PATH=$JAVA_HOME/bin:$PATH
```

生效：

```bash
source /etc/profile
```

---

### 4️⃣ 验证安装

```bash
java -version
```

正确输出示例：

```text
openjdk version "17.0.9"
Alibaba Dragonwell 17.0.9
```

---

## 四、可选：多 JDK 共存（教学/开发常见）

如果你想 **Java 8 + Java 17 共存**：

### 1️⃣ 使用 alternatives（推荐）

```bash
sudo alternatives --install /usr/bin/java java /opt/java/dragonwell-8.17.17/bin/java 8
sudo alternatives --install /usr/bin/java java /opt/java/dragonwell-17.0.9/bin/java 17
```

切换版本：

```bash
sudo alternatives --config java
```

---

## 五、Windows 安装国产 JDK（适合学生）

### 1️⃣ 下载 Windows 版（zip 或 exe）

Dragonwell Windows 版本同样在 GitHub Releases：

```text
Alibaba_Dragonwell_17.0.9_x64_windows.zip
```

---

### 2️⃣ 解压到目录

例如：

```text
D:\Java\dragonwell-17
```

---

### 3️⃣ 配置环境变量

**系统变量 → 新建**

* `JAVA_HOME = D:\Java\dragonwell-17`

**Path 里新增**

```text
%JAVA_HOME%\bin
```

---

### 4️⃣ 验证

```bat
java -version
```

---

## 六、国产 JDK + Maven / Spring Boot 兼容性

✔ **完全兼容 Maven / Gradle**
✔ **Spring Boot 2.x / 3.x 正常使用**
✔ **IDEA / Eclipse 完全支持**

### Maven 示例（无需特殊配置）

```bash
mvn -v
```

输出中能看到：

```text
Java version: 17.0.9, vendor: Alibaba
```

---

## 七、在“信创/国产化”场景中如何表述（很重要）

如果你用于：

* 教学大纲
* 课程思政
* 项目申报
* 信创说明

可以这样写（可直接用）：

> 本课程 Java 开发环境采用 **国产 JDK（Alibaba Dragonwell）**，
> 基于 OpenJDK 规范，兼容 Java SE 标准，
> 已在大规模生产环境验证，符合国产化与信创技术路线要求。

---

## 八、常见问题

### Q1：国产 JDK 和 Oracle JDK 有区别吗？

* API 层面：**完全一致**
* 授权：国产 JDK **免费、无版权风险**
* 性能：多数场景 **不弱于 Oracle**

### Q2：能否用于生产？

✔ Dragonwell / Kona / BiSheng **大量生产使用**

### Q3：是否影响学生就业？

❌ 不影响
👉 Java 标准一致，学生会一个，等于都会

---

## 九、我给你的最终建议（结合你背景）

你现在是：

* 教学 + 实验环境
* AnolisOS / Ubuntu / Windows
* Java Web / Spring Boot

👉 **推荐统一方案：**

* **服务器/虚拟机**：Dragonwell 17
* **学生电脑**：Dragonwell 8 或 17
* **教学文档统一写：国产 JDK（Dragonwell）**


