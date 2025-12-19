# Windows 下 OpenGauss 数据库安装指南 (Docker 版)

OpenGauss 原生主要支持 Linux 操作系统（如 openEuler, CentOS）。在 Windows 环境下进行开发和教学时，使用 Docker 容器化部署是目前最便捷、最稳定的方案。

本教程将指导你如何在 Windows 上通过 Docker 快速搭建 OpenGauss 实验环境。

## 1. 环境准备

在开始之前，请确保你的电脑已经安装了 Docker Desktop。

!!! abstract "前置要求"
    * **操作系统**：Windows 10/11 (开启 Hyper-V 或 WSL2)
    * **软件**：[Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
    * **状态**：确保 Docker 图标在任务栏右下角显示，且状态为 Running。

## 2. 拉取镜像

打开 Windows 的 **PowerShell** 或 **CMD**（命令提示符），执行以下命令拉取官方最新镜像：

```bash
docker pull opengauss/opengauss:latest
```

## 3. 启动数据库容器

这是最关键的一步。请仔细阅读下方的参数说明，特别是**密码策略**部分。

执行以下命令启动容器：

```bash
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=OpenGauss@2025 -p 5432:5432 opengauss/opengauss:latest

```

!!! failure "高风险易错点：密码复杂度"
OpenGauss 默认的安全策略非常严格，**若密码过于简单，容器启动后会立即退出（Exited）**。

```
设置的密码 (`GS_PASSWORD`) 必须同时满足以下要求：

1.  长度至少 8 位。
2.  必须包含以下四类字符中的至少三种：
    * 大写字母 (A-Z)
    * 小写字母 (a-z)
    * 数字 (0-9)
    * 特殊字符 (如 @, #, $, %)

*示例密码：`OpenGauss@2025` 是符合要求的。*

```

**命令参数详解：**

| 参数 | 说明 |
| --- | --- |
| `--name opengauss` | 给容器起名为 opengauss，方便后续管理。 |
| `--privileged=true` | **必填**。赋予容器特权，OpenGauss 启动需要部分系统底层权限。 |
| `-d` | 后台静默运行。 |
| `-e GS_PASSWORD=...` | 设置数据库超级用户密码。 |
| `-p 5432:5432` | 端口映射。将容器内的 5432 映射到本机的 5432 端口。 |

## 4. 验证安装

在 PowerShell 中输入以下命令查看容器状态：

```bash
docker ps

```

* 如果看到 `STATUS` 列显示 `Up ...`，说明安装成功。
* 如果列表为空，或者状态显示 `Exited`，请检查是否密码设置过于简单，需删除容器 (`docker rm opengauss`) 后重试。

## 5. 连接数据库

推荐使用 **DBeaver** 或 **Data Studio** 进行连接。

### 连接参数配置

!!! info "数据库连接信息"
在数据库管理工具中新建 **PostgreSQL** 连接（OpenGauss 兼容 PG 协议），填写如下信息：

```
* **主机 (Host)**: `localhost` 或 `127.0.0.1`
* **端口 (Port)**: `5432`
* **数据库 (Database)**: `postgres` (初始默认库)
* **用户名 (Username)**: `gaussdb` (注意：默认用户不是 postgres)
* **密码 (Password)**: 你在启动命令中设置的密码 (如 `OpenGauss@2025`)

```

## 6. 进阶：命令行操作 (可选)

如果你需要进入容器内部使用 `gsql` 命令行工具，可执行以下步骤：

1. **进入容器 Shell**：
```bash
docker exec -it opengauss bash

```


2. **切换到 omm 用户并登录**：
```bash
# 切换到操作系统用户 omm
su - omm

# 登录数据库
gsql -d postgres -p 5432 -U gaussdb -W OpenGauss@2025

```


3. **常用 SQL 命令**：
* `\l` : 查看所有数据库
* `\dt` : 查看当前库的所有表
* `\q` : 退出 gsql



---

!!! tip "教学建议"
如果是用于 Java Web 课程，建议在确认连接成功后，先创建一个新的业务数据库（如 `student_db`），避免直接在默认的 `postgres` 库中操作。
