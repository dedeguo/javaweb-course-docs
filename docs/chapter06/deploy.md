# 系统部署

## 1. 部署概述

智能航班管理系统需要在信创环境下部署，使用国产操作系统、JDK和数据库。本章将详细介绍系统的打包和部署过程。

## 2. 部署环境准备

### 2.1 操作系统

- **龙蜥 OS (Anolis OS)** 8.x 版本
- 确保系统已安装必要的依赖包

### 2.2 JDK

- **Dragonwell JDK** 17.x 版本
- 配置 JAVA_HOME 环境变量

### 2.3 数据库

- **openGauss** 3.1.x 版本
- 创建数据库和用户

### 2.4 Web服务器

- **Tomcat** 10.x 版本（可选，Spring Boot内置Tomcat）

## 3. 项目打包

### 3.1 配置Maven

在项目的pom.xml文件中配置打包插件：

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <version>3.2.0</version>
            <configuration>
                <mainClass>com.example.flight.Application</mainClass>
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### 3.2 执行打包命令

在项目根目录下执行以下命令：

```bash
# 清理并打包
mvn clean package -DskipTests
```

打包成功后，在target目录下会生成一个可执行的jar文件：`flight-system-1.0.0.jar`

## 4. 数据库初始化

### 4.1 创建数据库

登录openGauss数据库，执行以下SQL命令：

```sql
-- 创建数据库
CREATE DATABASE flight_system ENCODING 'UTF8';

-- 创建用户
CREATE USER flight_user WITH PASSWORD 'Flight@123';

-- 授权
GRANT ALL PRIVILEGES ON DATABASE flight_system TO flight_user;
```

### 4.2 初始化表结构

使用生成的SQL脚本初始化数据库表结构：

```bash
# 使用gsql命令执行SQL脚本
gsql -d flight_system -U flight_user -p 5432 -f sql/init.sql
```

## 5. 系统部署

### 5.1 方式一：直接运行jar包

这是最简单的部署方式，Spring Boot内置了Tomcat服务器：

```bash
# 运行jar包
java -jar flight-system-1.0.0.jar --spring.profiles.active=prod
```

### 5.2 方式二：使用systemd管理服务

为了方便管理，可以使用systemd将应用注册为系统服务：

1. 创建服务配置文件

```bash
vi /etc/systemd/system/flight-system.service
```

2. 配置服务内容

```ini
[Unit]
Description=Flight System
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/java/bin/java -jar /opt/flight-system/flight-system-1.0.0.jar --spring.profiles.active=prod
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

3. 启动服务

```bash
# 重新加载systemd配置
systemctl daemon-reload

# 启动服务
systemctl start flight-system

# 设置开机自启
systemctl enable flight-system

# 查看服务状态
systemctl status flight-system
```

### 5.3 方式三：部署到外部Tomcat

如果需要部署到外部Tomcat服务器：

1. 修改pom.xml，将打包方式改为war

```xml
<packaging>war</packaging>
```

2. 修改启动类，继承SpringBootServletInitializer

```java
@SpringBootApplication
public class Application extends SpringBootServletInitializer {
    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }
    
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

3. 打包并部署到Tomcat的webapps目录

```bash
# 打包 nmvn clean package -DskipTests

# 复制到Tomcat的webapps目录
cp target/flight-system-1.0.0.war /usr/local/tomcat/webapps/
```

## 6. 配置文件

### 6.1 环境配置

在项目中创建不同环境的配置文件：

- `application.yml` - 默认配置
- `application-dev.yml` - 开发环境配置
- `application-prod.yml` - 生产环境配置

### 6.2 生产环境配置示例

```yaml
server:
  port: 8080
  servlet:
    context-path: /flight-system

spring:
  datasource:
    url: jdbc:opengauss://localhost:5432/flight_system
    username: flight_user
    password: Flight@123
    driver-class-name: org.opengauss.Driver
  
  mybatis:
    mapper-locations: classpath:mapper/*.xml
    type-aliases-package: com.example.flight.entity

# 大模型API配置
deepseek:
  api:
    url: https://api.deepseek.com/chat/completions
    key: your-api-key

# JWT配置
jwt:
  secret: your-secret-key
  expiration: 3600000
```

## 7. 日志配置

配置日志文件路径和级别：

```yaml
logging:
  level:
    com.example.flight: INFO
  file:
    name: /opt/flight-system/logs/flight-system.log
    max-size: 10MB
    max-history: 10
```

## 8. 安全配置

### 8.1 防火墙配置

开放应用端口：

```bash
# 开放8080端口
firewall-cmd --permanent --add-port=8080/tcp

# 重新加载防火墙配置
firewall-cmd --reload
```

### 8.2 HTTPS配置

为了提高安全性，建议配置HTTPS：

```yaml
server:
  port: 443
  ssl:
    key-store: classpath:keystore.p12
    key-store-password: your-password
    key-store-type: PKCS12
    key-alias: tomcat
```

## 9. 监控与维护

### 9.1 应用监控

可以使用Spring Boot Actuator监控应用状态：

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: always
```

访问 `http://localhost:8080/flight-system/actuator/health` 查看应用健康状态

### 9.2 日志查看

查看应用日志：

```bash
# 实时查看日志
tail -f /opt/flight-system/logs/flight-system.log

# 查看错误日志
grep -i error /opt/flight-system/logs/flight-system.log
```

### 9.3 常见问题排查

1. **数据库连接失败**
   - 检查数据库服务是否启动
   - 检查数据库连接配置是否正确
   - 检查数据库用户权限

2. **应用启动失败**
   - 查看应用日志，定位错误原因
   - 检查端口是否被占用
   - 检查依赖是否完整

3. **API调用失败**
   - 检查网络连接
   - 检查API Key是否正确
   - 检查API调用频率限制

## 10. 性能优化

### 10.1 数据库优化

- 创建合适的索引
- 优化SQL查询语句
- 配置连接池参数

### 10.2 应用优化

- 启用缓存
- 异步处理非核心业务
- 优化JVM参数

```bash
# 优化JVM参数示例
java -Xms2g -Xmx4g -jar flight-system-1.0.0.jar
```

### 10.3 服务器优化

- 调整系统内核参数
- 配置TCP连接参数
- 启用Gzip压缩

## 11. 扩展部署

### 11.1 集群部署

如果系统需要支持高并发，可以考虑集群部署：

1. 部署多个应用实例
2. 使用Nginx作为负载均衡
3. 配置会话共享

### 11.2 Docker容器化部署

使用Docker容器化部署应用：

1. 创建Dockerfile

```dockerfile
FROM anolis-registry.cn-hangzhou.cr.aliyuncs.com/openanolis/dragonwell:17

WORKDIR /app

COPY target/flight-system-1.0.0.jar /app/

EXPOSE 8080

CMD ["java", "-jar", "flight-system-1.0.0.jar", "--spring.profiles.active=prod"]
```

2. 构建Docker镜像

```bash
docker build -t flight-system:1.0.0 .
```

3. 运行Docker容器

```bash
docker run -d -p 8080:8080 --name flight-system flight-system:1.0.0
```

## 12. 部署验证

部署完成后，验证系统是否正常运行：

1. 访问应用首页：`http://localhost:8080/flight-system`
2. 测试用户注册和登录功能
3. 测试航班查询和预订功能
4. 测试AI智能助手功能

如果所有功能都能正常使用，说明系统部署成功。

## 13. 总结

本章详细介绍了智能航班管理系统在信创环境下的部署过程，包括环境准备、项目打包、数据库初始化、系统部署、监控维护和性能优化等内容。通过本章的学习，你应该能够独立完成系统的部署和维护工作。

部署是软件开发流程中的重要环节，良好的部署方案可以提高系统的可靠性、安全性和性能。希望你在实际项目中能够灵活运用本章所学的知识，为系统选择合适的部署方案。