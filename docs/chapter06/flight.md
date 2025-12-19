# 航班模块实现

## 1. 功能需求

航班模块是系统的核心业务模块，主要负责航班信息的管理和查询预订，具体功能包括：

- 航班信息管理（增删改查）
- 航班查询（按出发地、目的地、时间等条件）
- 机票预订
- 机票取消
- 航班座位管理

## 2. 数据库设计

### 2.1 航班表结构

```sql
-- 航班表
CREATE TABLE "flight" (
  "flight_id" varchar(36) NOT NULL,
  "flight_number" varchar(20) NOT NULL,
  "airline" varchar(50) NOT NULL,
  "departure" varchar(50) NOT NULL,
  "destination" varchar(50) NOT NULL,
  "departure_time" timestamp NOT NULL,
  "arrival_time" timestamp NOT NULL,
  "total_seats" int NOT NULL,
  "available_seats" int NOT NULL,
  "price" decimal(10,2) NOT NULL,
  "create_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("flight_id")
);

-- 创建索引
CREATE INDEX "idx_flight_departure" ON "flight" ("departure");
CREATE INDEX "idx_flight_destination" ON "flight" ("destination");
CREATE INDEX "idx_flight_departure_time" ON "flight" ("departure_time");
```

### 2.2 订单表结构

```sql
-- 订单表
CREATE TABLE "order" (
  "order_id" varchar(36) NOT NULL,
  "user_id" varchar(36) NOT NULL,
  "flight_id" varchar(36) NOT NULL,
  "order_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "status" varchar(20) NOT NULL, -- BOOKED, PAID, CANCELLED
  "total_amount" decimal(10,2) NOT NULL,
  PRIMARY KEY ("order_id"),
  FOREIGN KEY ("user_id") REFERENCES "user" ("user_id"),
  FOREIGN KEY ("flight_id") REFERENCES "flight" ("flight_id")
);

-- 创建索引
CREATE INDEX "idx_order_user_id" ON "order" ("user_id");
CREATE INDEX "idx_order_flight_id" ON "order" ("flight_id");
CREATE INDEX "idx_order_status" ON "order" ("status");
```

### 2.3 实体类设计

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Flight {
    private String flightId;
    private String flightNumber;
    private String airline;
    private String departure;
    private String destination;
    private Date departureTime;
    private Date arrivalTime;
    private int totalSeats;
    private int availableSeats;
    private BigDecimal price;
    private Date createTime;
    private Date updateTime;
}

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Order {
    private String orderId;
    private String userId;
    private String flightId;
    private Date orderTime;
    private String status;
    private BigDecimal totalAmount;
    // 关联的航班信息
    private Flight flight;
}
```

## 3. 功能实现

### 3.1 航班查询

#### 3.1.1 Controller层

```java
@RestController
@RequestMapping("/api/flights")
public class FlightController {
    
    @Autowired
    private FlightService flightService;
    
    @GetMapping("/search")
    public Result searchFlights(
            @RequestParam(required = false) String departure,
            @RequestParam(required = false) String destination,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date departureDate,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "10") int size) {
        
        // 构建查询条件
        FlightQuery query = new FlightQuery();
        query.setDeparture(departure);
        query.setDestination(destination);
        query.setDepartureDate(departureDate);
        query.setPage(page);
        query.setSize(size);
        
        // 执行查询
        PageResult<Flight> result = flightService.searchFlights(query);
        
        return Result.success("查询成功", result);
    }
}
```

#### 3.1.2 Service层

```java
@Service
public class FlightService {
    
    @Autowired
    private FlightMapper flightMapper;
    
    public PageResult<Flight> searchFlights(FlightQuery query) {
        // 计算分页参数
        int offset = (query.getPage() - 1) * query.getSize();
        
        // 查询数据
        List<Flight> flights = flightMapper.search(query, offset, query.getSize());
        
        // 查询总记录数
        int total = flightMapper.count(query);
        
        // 构建分页结果
        PageResult<Flight> result = new PageResult<>();
        result.setData(flights);
        result.setTotal(total);
        result.setPage(query.getPage());
        result.setSize(query.getSize());
        result.setTotalPages((int) Math.ceil((double) total / query.getSize()));
        
        return result;
    }
}
```

#### 3.1.3 Mapper层

```xml
<select id="search" resultType="com.example.flight.entity.Flight">
    SELECT * FROM flight
    <where>
        <if test="departure != null and departure != ''">
            AND departure = #{departure}
        </if>
        <if test="destination != null and destination != ''">
            AND destination = #{destination}
        </if>
        <if test="departureDate != null">
            AND DATE(departure_time) = #{departureDate}
        </if>
        AND available_seats > 0
    </where>
    ORDER BY departure_time
    LIMIT #{offset}, #{size}
</select>

<select id="count" resultType="int">
    SELECT COUNT(*) FROM flight
    <where>
        <if test="departure != null and departure != ''">
            AND departure = #{departure}
        </if>
        <if test="destination != null and destination != ''">
            AND destination = #{destination}
        </if>
        <if test="departureDate != null">
            AND DATE(departure_time) = #{departureDate}
        </if>
        AND available_seats > 0
    </where>
</select>
```

### 3.2 机票预订

#### 3.2.1 Controller层

```java
@PostMapping("/book")
public Result bookFlight(@RequestBody BookRequest request, @RequestHeader("Authorization") String token) {
    // 从令牌中获取用户ID
    String userId = JwtUtil.getUserIdFromToken(token.replace("Bearer ", ""));
    
    // 执行预订
    Order order = flightService.bookFlight(userId, request.getFlightId());
    
    return Result.success("预订成功", order);
}
```

#### 3.2.2 Service层

```java
@Transactional
public Order bookFlight(String userId, String flightId) {
    // 1. 检查航班是否存在
    Flight flight = flightMapper.findById(flightId);
    if (flight == null) {
        throw new BusinessException("航班不存在");
    }
    
    // 2. 检查航班是否有可用座位
    if (flight.getAvailableSeats() <= 0) {
        throw new BusinessException("航班已满");
    }
    
    // 3. 创建订单
    Order order = new Order();
    order.setOrderId(UUID.randomUUID().toString());
    order.setUserId(userId);
    order.setFlightId(flightId);
    order.setOrderTime(new Date());
    order.setStatus("BOOKED");
    order.setTotalAmount(flight.getPrice());
    
    // 4. 保存订单
    orderMapper.insert(order);
    
    // 5. 更新航班可用座位数
    flightMapper.updateAvailableSeats(flightId, flight.getAvailableSeats() - 1);
    
    // 6. 关联航班信息
    order.setFlight(flight);
    
    return order;
}
```

### 3.3 机票取消

```java
@Transactional
public void cancelOrder(String orderId, String userId) {
    // 1. 查询订单
    Order order = orderMapper.findById(orderId);
    if (order == null) {
        throw new BusinessException("订单不存在");
    }
    
    // 2. 检查订单是否属于当前用户
    if (!order.getUserId().equals(userId)) {
        throw new BusinessException("无权取消该订单");
    }
    
    // 3. 检查订单状态
    if (!"BOOKED".equals(order.getStatus())) {
        throw new BusinessException("只有已预订的订单才能取消");
    }
    
    // 4. 更新订单状态
    order.setStatus("CANCELLED");
    orderMapper.update(order);
    
    // 5. 恢复航班可用座位数
    Flight flight = flightMapper.findById(order.getFlightId());
    flightMapper.updateAvailableSeats(order.getFlightId(), flight.getAvailableSeats() + 1);
}
```

## 4. 事务管理

航班预订和取消操作涉及多个数据库表的修改，需要使用事务来确保数据的一致性。在Spring Boot中，可以使用`@Transactional`注解来管理事务。

```java
@Transactional(rollbackFor = Exception.class)
public Order bookFlight(String userId, String flightId) {
    // 业务逻辑
    // 如果发生异常，事务会自动回滚
}
```

## 5. 并发控制

在高并发情况下，可能会出现多个用户同时预订同一航班的情况，导致超卖问题。可以采用以下方式解决：

1. **乐观锁**：在航班表中添加版本号字段，更新时检查版本号
2. **悲观锁**：使用数据库的行锁机制
3. **Redis分布式锁**：在分布式环境下使用

这里使用乐观锁来解决并发问题：

```sql
-- 增加版本号字段
ALTER TABLE "flight" ADD COLUMN "version" int NOT NULL DEFAULT 0;

-- 更新可用座位时检查版本号
UPDATE "flight" 
SET available_seats = available_seats - 1, version = version + 1 
WHERE flight_id = ? AND version = ?;
```

## 6. 接口测试

主要测试以下接口：

- GET /api/flights/search - 航班查询
- POST /api/flights/book - 机票预订
- PUT /api/orders/{orderId}/cancel - 机票取消
- GET /api/orders - 获取用户订单列表

## 7. 性能优化

1. **索引优化**：为查询条件中的字段添加索引
2. **缓存优化**：使用Redis缓存热门航班信息
3. **分页优化**：合理设置分页参数，避免一次性查询大量数据
4. **异步处理**：对于非实时操作，可以使用异步处理提高系统响应速度

## 8. 常见问题及解决方案

### 8.1 超卖问题

**问题**：多个用户同时预订同一航班时，可能导致可用座位数变为负数。

**解决方案**：使用乐观锁或悲观锁进行并发控制。

### 8.2 航班查询性能差

**问题**：当航班数据量较大时，查询速度慢。

**解决方案**：添加合适的索引，使用分页查询，考虑使用搜索引擎如Elasticsearch。

### 8.3 事务回滚失败

**问题**：事务中的某些操作失败时，其他操作没有回滚。

**解决方案**：确保所有可能抛出异常的操作都在事务管理范围内，并设置`rollbackFor = Exception.class`。