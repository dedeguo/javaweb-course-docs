# 用户模块实现

## 1. 功能需求

用户模块是系统的基础模块，主要负责用户的身份认证和信息管理，具体功能包括：

- 用户注册
- 用户登录
- 用户信息查询
- 用户信息修改
- 密码修改

## 2. 数据库设计

### 2.1 用户表结构

```sql
-- 用户表
CREATE TABLE "user" (
  "user_id" varchar(36) NOT NULL,
  "username" varchar(50) NOT NULL,
  "password" varchar(100) NOT NULL,
  "email" varchar(100) NOT NULL,
  "create_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("user_id")
);

-- 创建唯一索引
CREATE UNIQUE INDEX "idx_user_username" ON "user" ("username");
CREATE UNIQUE INDEX "idx_user_email" ON "user" ("email");
```

### 2.2 实体类设计

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private String userId;
    private String username;
    private String password;
    private String email;
    private Date createTime;
    private Date updateTime;
}
```

## 3. 功能实现

### 3.1 用户注册

#### 3.1.1 Controller层

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @PostMapping("/register")
    public Result register(@RequestBody RegisterRequest request) {
        // 参数校验
        if (StringUtils.isEmpty(request.getUsername()) || StringUtils.isEmpty(request.getPassword())) {
            return Result.error("用户名和密码不能为空");
        }
        
        // 注册用户
        userService.register(request);
        return Result.success("注册成功");
    }
}
```

#### 3.1.2 Service层

```java
@Service
public class UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
    
    public void register(RegisterRequest request) {
        // 检查用户名是否已存在
        User existingUser = userMapper.findByUsername(request.getUsername());
        if (existingUser != null) {
            throw new BusinessException("用户名已存在");
        }
        
        // 检查邮箱是否已存在
        if (userMapper.findByEmail(request.getEmail()) != null) {
            throw new BusinessException("邮箱已存在");
        }
        
        // 创建新用户
        User user = new User();
        user.setUserId(UUID.randomUUID().toString());
        user.setUsername(request.getUsername());
        // 密码加密
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setEmail(request.getEmail());
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());
        
        // 保存到数据库
        userMapper.insert(user);
    }
}
```

### 3.2 用户登录

#### 3.2.1 Controller层

```java
@PostMapping("/login")
public Result login(@RequestBody LoginRequest request) {
    // 登录验证
    User user = userService.login(request.getUsername(), request.getPassword());
    
    // 生成JWT令牌
    String token = JwtUtil.generateToken(user.getUserId());
    
    // 构建响应
    Map<String, Object> data = new HashMap<>();
    data.put("token", token);
    data.put("user", user);
    
    return Result.success("登录成功", data);
}
```

#### 3.2.2 Service层

```java
public User login(String username, String password) {
    // 根据用户名查询用户
    User user = userMapper.findByUsername(username);
    if (user == null) {
        throw new BusinessException("用户名或密码错误");
    }
    
    // 验证密码
    if (!passwordEncoder.matches(password, user.getPassword())) {
        throw new BusinessException("用户名或密码错误");
    }
    
    return user;
}
```

### 3.3 用户信息查询

```java
@GetMapping("/me")
public Result getUserInfo(@RequestHeader("Authorization") String token) {
    // 从令牌中获取用户ID
    String userId = JwtUtil.getUserIdFromToken(token.replace("Bearer ", ""));
    
    // 查询用户信息
    User user = userService.getUserById(userId);
    
    return Result.success("查询成功", user);
}
```

## 4. 安全设计

### 4.1 密码加密

使用BCryptPasswordEncoder对用户密码进行加密存储，确保密码安全。

### 4.2 JWT认证

采用JWT（JSON Web Token）进行身份认证，避免了传统Session的存储压力。

### 4.3 请求拦截

使用Spring Security的拦截器对需要认证的接口进行保护，确保只有登录用户才能访问。

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/users/register", "/api/users/login").permitAll()
                .anyRequest().authenticated()
            )
            .addFilterBefore(new JwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}
```

## 5. 接口测试

可以使用Postman或Apifox等工具对用户模块的接口进行测试，主要测试以下接口：

- POST /api/users/register - 用户注册
- POST /api/users/login - 用户登录
- GET /api/users/me - 获取当前用户信息
- PUT /api/users/me - 更新用户信息
- PUT /api/users/password - 修改密码

## 6. 常见问题及解决方案

### 6.1 密码加密后无法验证

**问题**：用户注册时密码已加密，但登录时验证失败。

**解决方案**：确保注册和登录使用相同的密码编码器实例，并且加密算法一致。

### 6.2 JWT令牌过期

**问题**：令牌过期后无法访问受保护的接口。

**解决方案**：实现令牌刷新机制，或者在前端检测令牌过期并引导用户重新登录。

### 6.3 用户名重复注册

**问题**：用户可以使用相同的用户名进行注册。

**解决方案**：在数据库中为用户名字段添加唯一索引，并在Service层进行重复检查。