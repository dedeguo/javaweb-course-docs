# 国产化（信创）环境搭建

- [ ] OS
- [ ] JDK
- [ ] MAVEN
- [ ] DB
- [ ] Vscode
- [ ] Git

## OS -  Anolis OS 8.10

安装后账号：jzxy/jzxyjzxy0101

在 VMware 虚拟机中安装 Anolis OS (龙蜥操作系统) 8.10 的过程与安装 CentOS 8 非常相似，因为 Anolis OS 是 CentOS 的 100% 兼容替代版。

以下是详细的步骤指南：

### 第一步：下载镜像 (ISO)

首先需要获取 Anolis OS 8.10 的安装镜像。

  * **官方镜像站下载：** [OpenAnolis 镜像站](https://mirrors.openanolis.cn/anolis/8.10/isos/GA/x86_64/)
  * **推荐文件：** 选择 `AnolisOS-8.10-x86_64-dvd.iso` (约 17GB，包含完整软件包)。

-----

### 第二步：创建 VMware 虚拟机

1.  **新建虚拟机**：打开 VMware Workstation，点击 `文件` -\> `新建虚拟机` -\> 选择 `典型(推荐)`。
2.  **安装来源**：选择 `稍后安装操作系统`。
3.  **操作系统选择**：
      * **客户机操作系统**：选择 `Linux`。
      * **版本**：选择 `CentOS 8 (64-bit)`。*(注：因为 Anolis 8 是 CentOS 8 的衍生版，VMware 无法直接识别 Anolis，选 CentOS 8 兼容性最好)*。
4.  **命名与位置**：给虚拟机起个名字（如 `Anolis-8.10`），并选择存放路径。
5.  **磁盘容量**：建议至少 **40GB**（根据你的实际需求调整），选择 `将虚拟磁盘拆分成多个文件`。
6.  **硬件配置 (自定义硬件)**：
      * **内存**：建议 **4GB** 或以上。
      * **处理器**：建议 **2核** 或以上。
      * **新 CD/DVD (SATA)**：选择 `使用 ISO 映像文件`，然后点击`浏览`找到你刚才下载的 Anolis OS 8.10 ISO 文件。
      * **网络适配器**：通常选择 `NAT` 模式（方便虚拟机直接上网）。
7.  点击 `完成`。

-----

### 第三步：开始安装

1.  **启动虚拟机**：点击 `开启此虚拟机`。
2.  **引导菜单**：鼠标点击虚拟机黑屏区域（锁定焦点），用键盘方向键上/下选择第一项 `Install Anolis OS 8`，按回车。
3.  **语言选择**：等待加载图形界面，建议左侧搜索 `Chinese` 选择 `中文` -\> `简体中文 (中国)`，点击 `继续`。

### 第四步：系统配置（关键步骤）

在“安装信息摘要”界面，你需要配置带有黄色感叹号⚠️的项：

1.  **安装目的地 (磁盘分区)**：
      * 点击进入，确保你的 40GB 虚拟硬盘被选中（打钩）。
      * **存储配置**：如果不需要特殊分区，选择 `自动` 即可。
      * 点击左上角 `完成`。
2.  **软件选择** (重要)：
      * **带 GUI 的服务器**：如果你需要图形桌面（类似 Windows），选这个。
      * **服务器** 或 **最小安装**：如果你是做服务器开发/运维，习惯用命令行，选 `最小安装` (Minimal Install) 最省资源。
      * *建议新手选择“带 GUI 的服务器”以避免上手困难。*
3.  **网络和主机名**：
      * 点击进入，点击右上角的开关，将 `以太网 (ens33)` 状态改为 **打开**。
      * 此时你应该能看到获取到了 IP 地址。
      * 底部 `主机名` 可以修改为你喜欢的名字（如 `anolis-server`），点击 `应用`，然后点击 `完成`。
4.  **用户设置**：
      * **根密码 (Root Password)**：设置超级管理员密码。如果密码太简单，需要点击两次 `完成` 才能强制保存。
      * **创建用户**：建议创建一个普通用户（如 `user`），并勾选 `将此用户设为管理员`。

### 第五步：安装与重启

1.  所有配置完成后，右下角的 `开始安装` 按钮会变亮，点击它。
2.  等待进度条走完（取决于电脑性能，通常需要 5-10 分钟）。
3.  安装完成后，点击右下角的 `重启系统`。

-----

### 第六步：安装后的初始化与 VMware Tools

重启后，你需要接受许可证协议（如果是图形界面安装）：

1.  点击 `许可证信息` -\> 勾选 `我同意许可协议` -\> `完成` -\> `结束配置`。
2.  登录系统。

**安装 Open-VM-Tools (替代 VMware Tools)：**
为了让虚拟机支持**剪贴板共享**、**自动适应屏幕大小**和**文件拖拽**，强烈建议安装 open-vm-tools（官方推荐替代原生 VMware Tools）。

打开终端（Terminal），执行以下命令：

```bash
# 1. 更新软件源缓存
sudo yum makecache

# 2. 安装 open-vm-tools 和桌面支持包
sudo yum install -y open-vm-tools open-vm-tools-desktop

# 3. 重启虚拟机生效
reboot
```

重启后，你的虚拟机应该可以随意最大化窗口，且分辨率会自动适应了。


## JDK21

## MAVEN 安装及配置镜像加速

## DB openGauss
在 Anolis OS 8.10 (兼容 CentOS 8/RHEL 8) 上安装 openGauss，对于个人学习、毕业设计或单机开发，最推荐使用 **极简版 (Lite Edition)**。

极简版不需要编写复杂的 XML 配置文件，安装过程只需要一行命令，且包含数据库核心功能。

以下是 **openGauss 5.0.0 (LTS)** 极简版的安装流程：

### 第一步：准备工作（Root 用户操作）

1.  **安装依赖包**
    Anolis 8 默认可能缺少一些 openGauss 运行所需的库，请先执行以下命令：

    ```bash
    sudo dnf install -y libaio-devel flex bison ncurses-devel glibc-devel patch redhat-lsb-core python3 net-tools
    ```

2.  **配置 Python 环境**
    openGauss 的安装脚本通常需要 `python` 命令，而 Anolis 8 默认只有 `python3`。需要建立软链接：

    ```bash
    # 如果输入 python --version 报错，则执行下面这句
    sudo ln -s /usr/bin/python3 /usr/bin/python
    ```

3.  **关闭防火墙（可选，方便连接）**

    ```bash
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    sudo setenforce 0
    # 修改 /etc/selinux/config 将 SELINUX=enforcing 改为 disabled (需重启生效，暂时不重启也能装)
    ```

### 第二步：创建专用账户

**注意：** openGauss 强制要求**不能**使用 root 用户安装和运行。

1.  **创建用户组和用户**

    ```bash
    sudo groupadd dbgrp
    sudo useradd -g dbgrp -u 1000 -d /home/omm omm
    ```

2.  **设置密码**

    ```bash
    sudo passwd omm
    ```

3.  **创建安装目录并授权**

    ```bash
    sudo mkdir -p /opt/software/openGauss
    # 将目录权限给 omm 用户
    sudo chown -R omm:dbgrp /opt/software
    sudo chmod -R 755 /opt/software
    ```

### 第三步：下载与解压

1.  **切换到 omm 用户**
    后续所有操作必须使用 `omm` 用户！

    ```bash
    su - omm
    ```

2.  **下载安装包**
    您可以去 [openGauss 官网下载页](https://opengauss.org/zh/download/) 获取下载链接。这里以 x86\_64 极简版为例（请在 omm 用户下执行）：

    ```bash
    cd /opt/software/openGauss

    # 下载 5.0.0 LTS 极简版 (链接可能随版本更新变化，建议官网核对)
    wget https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/x86_64/openGauss-5.0.0-CentOS-64bit.tar.bz2
    ```

3.  **解压**

    ```bash
    tar -jxf openGauss-5.0.0-CentOS-64bit.tar.bz2
    ```

    *(解压后你会看到 `simpleInstall` 目录或 `install.sh` 脚本)*

### 第四步：执行安装

确保您仍在 `/opt/software/openGauss/simpleInstall` 目录下（或者是解压后的根目录，取决于版本结构）。

执行安装脚本（`-w` 后面是数据库密码，**要求强密码**：必须包含大小写字母、数字和符号，长度\>8）：

```bash
cd /opt/software/openGauss/simpleInstall

# 格式：sh install.sh -w "您的强密码"
sh install.sh -w "OpenGauss@123"
```

  * 如果安装成功，屏幕最后会显示：`install successfully!`
  * 如果提示 `command not found` 或依赖缺失，请回到第一步检查 `libaio` 和 `python` 是否就绪。

### 第五步：验证与使用

1.  **验证进程**

    ```bash
    ps -ef | grep gaussdb
    ```

2.  **连接数据库**
    使用 `gsql` 客户端连接（默认端口 5432）：

    ```bash
    gsql -d postgres -p 5432
    ```

      * 如果提示 `gsql: command not found`，说明环境变量没生效，执行 `source ~/.bashrc` 或手动执行 `/opt/software/openGauss/bin/gsql ...`。

3.  **常用操作**
    进入数据库后：

    ```sql
    -- 查看版本
    SELECT version();
    -- 创建新用户
    CREATE USER myuser WITH PASSWORD 'User@1234';
    -- 退出
    \q
    ```

### 附：如何允许远程连接（Navicat/DBeaver）

默认情况下，openGauss 只允许本地连接。如果您的 Anolis 是虚拟机，想用宿主机的 Navicat 连接，需要修改配置：

1.  **修改 pg\_hba.conf** (在数据目录 data/single\_node 下)

    ```bash
    vi /opt/software/openGauss/data/single_node/pg_hba.conf
    ```

    在文件末尾添加一行（允许所有 IP 连接）：

    ```
    host    all             all             0.0.0.0/0               sha256
    ```

2.  **修改 postgresql.conf**

    ```bash
    vi /opt/software/openGauss/data/single_node/postgresql.conf
    ```

    找到 `listen_addresses`，将其修改为：

    ```
    listen_addresses = '*'
    ```

    找到 `password_encryption_type`，确保是 1 (MD5) 或 2 (SHA256)。Navicat 较新版本支持 SHA256，旧版本可能需要 MD5。

3.  **重启数据库**

    ```bash
    gs_ctl restart -D /opt/software/openGauss/data/single_node/
    ```

## vscode 远程到系统

安装vscode 插件:Visual Studio Code Remote Explorer


```
Host AnolisOS-8.10-jzxy
    HostName 192.168.110.168
    User jzxy
```
