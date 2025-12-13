---
title: Java HTTP 客户端
---

# Java HTTP 客户端

> 三板斧：构造请求、发送、解析。以 JDK 11+ `HttpClient` 为主线，补充 OkHttp 选择建议。

## 基本用法（JDK HttpClient）

```java
HttpClient http = HttpClient.newHttpClient();

HttpRequest req = HttpRequest.newBuilder()
        .uri(URI.create("https://httpbin.org/post"))
        .header("Content-Type", "application/json")
        .POST(HttpRequest.BodyPublishers.ofString("{\"hello\":\"world\"}"))
        .build();

HttpResponse<String> resp = http.send(req, HttpResponse.BodyHandlers.ofString());
System.out.println(resp.statusCode());
System.out.println(resp.body());
```

要点：
- `GET` 使用 `GET()` 或不写方法（默认 GET）。
- `POST` 发送 JSON 记得加 `Content-Type: application/json`。
- `timeout`、`redirect`、`proxy`、`cookie` 等可在 `HttpClient`/`HttpRequest` 上配置。

## 超时与重试

```java
HttpClient http = HttpClient.newBuilder()
        .connectTimeout(Duration.ofSeconds(10))
        .build();

HttpRequest req = HttpRequest.newBuilder()
        .uri(URI.create("https://api.example.com"))
        .timeout(Duration.ofSeconds(20))
        .build();
```

重试建议封装在业务工具类中，对 5xx/超时做指数退避。

## JSON 解析（Jackson）

```java
ObjectMapper mapper = new ObjectMapper();
JsonNode root = mapper.readTree(resp.body());
String value = root.path("data").path("name").asText();
```

或定义 DTO：

```java
public record UserDto(String id, String name) {}
UserDto u = mapper.readValue(resp.body(), UserDto.class);
```

## 何时用 OkHttp？

- 需要更灵活的连接池、拦截器生态、WebSocket/SSE 支持时可选。
- 在 Android 端或已有 OkHttp 生态项目中更合适。

## 调试技巧

- 浏览器/Apifox 先拉通请求，再搬到 Java 代码。
- 开启服务端/客户端日志，排查 4xx/5xx 与编码问题。
