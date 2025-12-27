### 📝 A04 内容预览：Docker 容器化部署

为了方便您备课，我为您草拟了这一节的核心教学脚本和代码：

#### **1. 核心概念比喻**

* **镜像 (Image)** = **“应用光盘/ISO”**：它是只读的，里面包含了代码、JDK 和操作系统库。
* **容器 (Container)** = **“运行起来的虚拟机”**：它是基于镜像运行的实例，可以启动、停止、删除。
* **Dockerfile** = **“光盘刻录说明书”**：告诉 Docker 怎么把你的 Jar 包做成镜像。

#### **2. 标准 Dockerfile 模板 (Spring Boot)**

在项目根目录下新建 `Dockerfile` 文件：

```dockerfile
# 1. 基础镜像：使用 OpenJDK 17 (可以换成国产 Dragonwell)
FROM openjdk:17-jdk-alpine

# 2. 作者信息
LABEL maintainer="teacher_chen@wbu.edu.cn"

# 3. 挂载目录 (可选，用于日志等)
VOLUME /tmp

# 4. 复制 Jar 包：把 target 目录下的 jar 包复制进去并改名为 app.jar
# 注意：前提是先执行了 mvn package
COPY target/*.jar app.jar

# 5. 启动命令：等同于 java -jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

```

#### **3. 实战三步走**

**第一步：打包 Java 应用**

```bash
# 在 IDEA Terminal 中执行
mvn clean package -DskipTests

```

**第二步：构建 Docker 镜像 (Build)**

```bash
# 注意最后有个点 . 代表当前目录
docker build -t my-springboot-app:v1.0 .

```

**第三步：运行容器 (Run)**

```bash
# -d: 后台运行
# -p 8080:8080 : 把容器里的 8080 映射到宿主机的 8080
docker run -d -p 8080:8080 --name my-app my-springboot-app:v1.0

```

#### **4. 进阶扩展 (Docker Compose)**

*如果学生想把 **Spring Boot** 和 **OpenGauss** 一键启动，可以简单提一下 `docker-compose.yml`：*

```yaml
version: '3'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
  db:
    image: opengauss/opengauss
    environment:
      - GS_PASSWORD=SecretPassword@123

```

---

### 💡 教学建议

1. **环境问题**：学校机房可能无法连接 Docker Hub。建议在附录中补充 **“配置阿里云/网易云 Docker 镜像加速器”** 的步骤。
2. **作业结合**：期末大作业可以加一个加分项 —— **“提供 Dockerfile 并成功通过 Docker 运行项目”**。
3. **信创结合**：如果想突出信创特色，可以将 `FROM openjdk:17` 换成国产的 `FROM alibaba-dragonwell:17`（阿里龙蜥 JDK）。

您觉得这个安排是否合适？如果需要，我可以把这一节的完整 markdown 文档也写出来。