# OpenAPIHub
> This is my personal note of how i built this project and all the technical skills I have learned during the project

- [OpenAPIHub](#openapihub)
- [Day 1](#day-1)
  - [Ant Design Pro init](#ant-design-pro-init)
  - [SpringBoot init](#springboot-init)
    - [修改](#修改)
    - [将DB本地数据导出为.sql文件](#将db本地数据导出为sql文件)
- [Day 2](#day-2)
  - [前端](#前端)
  - [后端](#后端)
    - [开发调用接口](#开发调用接口)
    - [API 签名认证](#api-签名认证)
    - [SDK 开发](#sdk-开发)
- [Day 3](#day-3)
  - [接口发布 / 下线功能](#接口发布--下线功能)
    - [后端](#后端-1)
    - [前端](#前端-1)
- [Day 4](#day-4)
  - [接口调用次数统计](#接口调用次数统计)
  - [网关](#网关)
    - [路由](#路由)
    - [负载均衡](#负载均衡)
    - [统一处理跨域](#统一处理跨域)
    - [发布控制](#发布控制)
    - [流量染色](#流量染色)
    - [统一接口保护](#统一接口保护)
    - [统一业务处理](#统一业务处理)
    - [统一鉴权](#统一鉴权)
    - [访问控制](#访问控制)
    - [统一日志](#统一日志)
    - [统一文档](#统一文档)
  - [网关的分类](#网关的分类)
  - [网关实现](#网关实现)
  - [Spring Cloud Gateway 用法](#spring-cloud-gateway-用法)
    - [核心概念](#核心概念)
    - [请求流程](#请求流程)
    - [使用](#使用)
- [Day 5](#day-5)
  - [应用网关特性](#应用网关特性)
  - [业务逻辑](#业务逻辑)
  - [具体实现](#具体实现)
- [Day 6](#day-6)
  - [问题的提出](#问题的提出)
  - [HTTP 请求](#http-请求)
  - [RPC](#rpc)
  - [Dubbo](#dubbo)
  - [Nacos](#nacos)
- [Day 7](#day-7)
  - [抽取公共项目 napi-common](#抽取公共项目-napi-common)
  - [gateway](#gateway)
  - [统计分析功能](#统计分析功能)
    - [需求](#需求)
    - [前端](#前端-2)
    - [后端](#后端-2)
  - [部署](#部署)
    - [Docker compose](#docker-compose)
    - [Dockerfile](#dockerfile)


# Day 1

[Ant Design Pro - 官方 doc 看这个](https://pro.ant.design/docs/getting-started/)

## Ant Design Pro init

```bash
npm i @ant-design/pro-cli -g
pro create myapp
```

* 选 umi@4
* yarn: 安装依赖
* yarn start: 启动项目
* yarn i18n-remove: 移除国际化
  * 报错参考：https://blog.csdn.net/baidu_38126306/article/details/129116391
* 前端代码生成: 
  * 将 openApi 规范的 json -> `config.ts` -> openApi -> schemaPath
  * oneapi 插件自动生成在 `services` 下
* 更改登录页请求地址: 
  * `requestErrorConfig.ts` + baseUrl
* 修改登录逻辑:
  * `User\Login\index.tsx`: handleSubmit()
  * 传参，调用的 login 函数，返回值，都要改
* 设置用户登录状态到全局登录变量:
  * `app.tsx` -> getInitialState
* 传入权限信息:
  * `access.ts`

## SpringBoot init

* annotation：自己写的注解，只允许某个角色访问
* aop：
  * AuthInterceptor.java：请求统一权限校验
  * LogInterceptor.java：全局日志记录
* config:
  * CosClientConfig.java: 上传文件的配置
* esdao：访问 Elasticsearch
* job：定时任务
  * cycle：周期
  * once：单次
* manager：通用的域下沉，把通用的 service 抽象出来
* wxmp：可以独立使用，操作微信公众号的接口

### 修改

* 创建 `create_table.sql`
* DB 对着表右键 MybatisX-Gen 
* 添加 `InterfaceInfo` 相关 service, controller, entity, mapper
  
### 将DB本地数据导出为.sql文件

* IDEA 对着 DB 右键，Export Data to File -> SQL inserts
* 如需表结构，勾选 `Add table definition (DDL)`

# Day 2

## 前端

* 页面组件修改：新建框，修改框，删除操作

## 后端

### 开发调用接口

* [Hutool](https://hutool.cn/docs/#/)
* HTTP 工具类: https://hutool.cn/docs/#/http/Http%E5%AE%A2%E6%88%B7%E7%AB%AF%E5%B7%A5%E5%85%B7%E7%B1%BB-HttpUtil

### API 签名认证

* 本质：签发签名，使用签名
* 为什么需要：保证安全性，不是谁都能调
* 和账户密码的区别：这是无状态的，只要这次你带了，是对的，就允许调用
* 实现：通过 header 传递参数
  * 参数 1: accessKey: 调用的标识 userA, userB（复杂、无序、无规律）
  * 参数 2: secretKey: 密钥（复杂、无序、无规律）该参数不能放到请求头中
  * 参数 3: 用户请求参数
  * 参数 4: sign
  * 防重放 (Replay Attack)：
    * Todo: 还没写
    * 参数 5: 
      * 加 nonce 随机数，只能用一次
      * 服务器端保留收到的 nonce，视为已使用，下次再收到相同的 nonce，会拒绝该请求
      * 一段时间清除过期的 nonce，那么，该 nonce 又可用了
    * 参数 6: 加 timestamp 时间戳，校验时间戳是否过期，记得使用例如 Unix 标准时间戳
* 过程：
  * 用户参数 + 密钥 => 签名生成算法（MD5、HMac、Sha1） => 不可解密的值 Sign
  * abc + abcdefgh => sajdgdioajdgioa
  * 验证？
    * 服务端用一模一样的参数和算法去生成签名，只要和用户传的的一致，就正确
* **实践**：
  * ?accessKey: 查库是否相等
  * nonce: 是否在合理的区间中，如：我生成四位，那这里也应该是四位
  * timestamp: 和当前时间相差多久，例如5分钟
  * sign: 查库得到 secretKey，然后拼接用户参数，生成 Sign，查看是否相等

### SDK 开发

* 好处: 开发者引入之后，可以直接在 application.yml 中写配置，自动创建客户端，执行上述过程，在请求头中添加参数 4 - 6
* 新建项目: lombok + Spring Configuration Processor
* spring-boot-configuration-processor: 自动生成配置的代码提示
* @ConfigurationProperties: 创建一个用于绑定配置属性的类，这些配置属性可以从 `application.yml` 中读取，并自动注入到应用程序中
* 删除 `pom.xml` 中 `<build>` 标签下的内容
* 编写配置类:

  ```java
  
  @Configuration
  @ConfigurationProperties(prefix = "yuapi.client")
  @Data
  @ComponentScan
  public class YuApiClientConfig {

      /**
      * appId
      */
      private String appId;

      /**
      * 秘钥
      */
      private String appSecret;

      /**
      * 用户 id
      */
      private String userId;

      @Bean
      public YuApiClient yuApiClient() {
          return new YuApiClient(appId, appSecret, userId);
      }
  }
  ```

* 注册配置类：
  * resources/META_INF/spring.factories：

    ```
    # spring boot starter
    org.springframework.boot.autoconfigure.EnableAutoConfiguration=com.yupi.yuapiclientsdk.YuApiClientConfig
    ```

* `maven install`: 将项目的构建结果安装到本地Maven仓库
* 在其他项目的 `pom.xml` 中通过 `<dependency>` 引入

# Day 3

## 接口发布 / 下线功能

### 后端

* `InterfaceInfoController`:
  * "/online": 发布
    * DTO 添加对应的 `IdRequest`
    * 校验该接口是否存在
    * 判断该接口是否可以调用
    * 修改 status -> 1
  * "/offline": 下线
    * DTO 添加对应的 `IdRequest`
    * 校验该接口是否存在
    * 修改 status -> 0
  * "/invoke": 模拟调用
    * DTO 添加对应的 `InterfaceInfoInvokeRequest.java`
    * 配合下面前端的在线模拟调用
  * 尽量把传入的参数都封装成对象，而且每个 controller 方法，单独封装，除非完全相同。这样，前端就知道要传哪些数据，而不是在整个 entity 中大海捞针
* `UserServiceImpl`:
  * 注册时自动分配 accessKey, secretKey

### 前端

* 查看接口文档：经典动态路由
* 在线调用：
  * 请求参数的类型，直接用 json
  
    ```json
    [
      {"name": "username", "type": "string"}
    ]
    ```

* 实践: 
  * 前端将用户输入的请求参数和要测试的接口 id 发给平台后端
  * (在调用前可以做一些校验)
  * 平台后端去调用模拟接口
* Todo: 
  * 可以针对不同的请求头或者接口类型来设计界面和表单，给用户更好的体验。(参考 swagger、postman、knife4j)
  * 判断该接口是否可以调用时由固定方法名改为根据测试地址来调用
  * 用户测试接口固定方法名改为根据测试地址来调用
  * 模拟接口改为从数据库校验 accessKey

# Day 4

## 接口调用次数统计

* 创建新的表 `user_interface_info`
* 用户每次调用接口成功，次数 + 1
  * 添加在 `UserInterfaceInfoServiceImpl`
* 给用户分配或者用户自主申请接口调用次数
* 问题: 
  * 每个方法都要写这个逻辑，很麻烦
  * 并且需要接口开发者自己去添加统计代码，不合理
* 解决：
  * AOP:
    * 优点: 独立于接口，在每个接口调用后统计次数 + 1
    * 缺点: 只存在于单个项目中，如果每个团队要开发自己的模拟接口，那么都要写一个切面，不合理
  * 网关

## 网关

* 路由
* 负载均衡
* 统一鉴权
* 跨域
* 统一业务处理（缓存）
* 访问控制
* 发布控制
* 流量染色
* 接口保护
  * 限制请求
  * 信息脱敏
  * 降级（熔断）
  * 限流：学习令牌桶算法、学习漏桶算法，学习一下 RedisLimitHandler
  * 超时时间
* 统一日志
* 统一文档

### 路由

* 起到转发的作用，比如有接口 A 和接口 B，网关会记录这些信息，根据用户访问的地址和参数，转发请求到对应的接口（服务器 / 集群）
* /a => 接口A
* /b => 接口B
* https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-path-route-predicate-factory

### 负载均衡

* 在路由的基础上
* /c => 服务 A / 集群 A（随机转发到其中的某一个机器）
* uri 从固定地址改成 lb:xxxx

### 统一处理跨域

* 网关统一处理跨域，不用在每个项目里单独处理
* https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#cors-configuration

### 发布控制

* 灰度发布，比如上线新接口，先给新接口分配 20% 的流量，老接口 80%，再慢慢调整比重
* https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-weight-route-predicate-factory

### 流量染色

* 给请求（流量）添加一些标识，一般是设置请求头中，添加新的请求头
* https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-addrequestheader-gatewayfilter-factory
* 全局染色：https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#default-filters

### 统一接口保护

* 限制请求：
  * https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#requestheadersize-gatewayfilter-factory
* 信息脱敏：
  * https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-removerequestheader-gatewayfilter-factory
* 降级（熔断）：
  * https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#fallback-headers
* 限流：
  * https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-requestratelimiter-gatewayfilter-factory
* 超时时间：
  * https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#http-timeouts-configuration
* 重试（业务保护）：
  * https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-retry-gatewayfilter-factory

### 统一业务处理

* 把一些每个项目中都要做的通用逻辑放到上层（网关），统一处理，比如本项目的次数统计

### 统一鉴权

* 判断用户是否有权限进行操作，无论访问什么接口，我都统一去判断权限，不用重复写。

### 访问控制

* 黑白名单，比如限制 DDOS IP

### 统一日志

* 统一的请求、响应信息记录

### 统一文档

* 将下游项目的文档进行聚合，在一个页面统一查看
* 建议用：https://doc.xiaominfo.com/docs/middleware-sources/aggregation-introduction

## 网关的分类

* 全局网关（接入层网关）：作用是负载均衡、请求日志等，不和业务逻辑绑定
* 业务网关（微服务网关）：会有一些业务逻辑，作用是将请求转发到不同的业务 / 项目 / 接口 / 服务
* 参考文章：https://blog.csdn.net/qq_21040559/article/details/122961395

## 网关实现

* Nginx（全局网关）、Kong 网关（API 网关，Kong：https://github.com/Kong/kong），编程成本相对高一点
* Spring Cloud Gateway（取代了 Zuul）性能高、可以用 Java 代码来写逻辑，适于学习
* 网关技术选型：https://zhuanlan.zhihu.com/p/500587132

## Spring Cloud Gateway 用法

* 去看官网：https://spring.io/projects/spring-cloud-gateway/
* 官方文档：https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/

### 核心概念

* 路由 Route：根据什么条件，转发请求到哪里
* 断言 Predicate：一组规则、条件，用来确定如何转发路由
* 过滤器 Filter：对请求进行一系列的处理，比如添加请求头、添加请求参数

### 请求流程

* 客户端发起请求
* Handler Mapping：根据断言 predicate ，去将请求转发到对应的路由
* Web Handler：处理请求（一层层经过过滤器 filter）
* 实际调用服务
![Spring Cloud Gateway](https://docs.spring.io/spring-cloud-gateway/docs/3.1.7/reference/html/images/spring_cloud_gateway_diagram.png)

### 使用

* 配置式（方便、规范）
  * 简化版
  * 全称版
* 编程式（灵活、相对麻烦）
* 建议使用时开启日志，方便查看路由跳转去哪了

  ```yml
  logging:
    level:
      org:
        springframework:
          cloud:
            gateway: trace
  ```

* Predicate: 

  * https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#gateway-request-predicates-factories
  * After 在 xx 时间之后
  * Before 在 xx 时间之前
  * Between 在 xx 时间之间
  * 请求类别
  * 请求头（包含 Cookie）
  * 查询参数
  * 客户端地址
  * 权重

* Filter: 

  * https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#global-filters
  * 基本功能：对请求头、请求参数、响应头的增删改查
  * 添加请求头
  * 添加请求参数
  * 添加响应头
  * 降级
  * 限流
  * 重试
  * 使用，引入如下依赖:

    ```xml
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-circuitbreaker-reactor-resilience4j</artifactId>
    </dependency>
    ```

# Day 5

## 应用网关特性

* 路由（转发请求到模拟接口项目）
* 统一鉴权（accesskey, secretKey）
* 统一业务处理（每次请求接口后，接口调用次数 +1）
* 访问控制（黑白名单）
* 流量染色（记录请求是否为网关来的）
* 统一日志（记录每次的请求和响应日志）

## 业务逻辑

* 用户发送请求到 API 网关
* 请求日志
* (黑白名单)
* 用户鉴权（判断 ak、sk 是否合法）
* 请求的模拟接口是否存在？
* 请求转发，调用模拟接口
* 响应日志
* 调用成功，接口调用次数 + 1
* 调用失败，返回一个规范的错误码

## 具体实现

* 写在 `napi-gateway` 项目中
* 转发：
  * 对所有请求地址是 /api/** 的地址进行转发 -> http://localhost:8123/api/** 
  * 修改 `application.yml`，即可转发
* 业务逻辑：
  * 使用 GlobalFilter（编程式），全局请求拦截处理（类似 AOP）
    * `ServerWebExchange exchange` 中可以取到 request 和 response
    * 引入 `napiclientsdk` 使用 `SignUtils` 做用户鉴权
    * 添加上述的业务逻辑
      * 因为网关项目没引入 MyBatis 等操作数据库的类库，如果该操作较为复杂，可以由 backend 增删改查项目提供接口，我们直接调用，不用再重复写逻辑了
        * HTTP 请求（用 HTTPClient、用 RestTemplate、Feign）
        * RPC（Dubbo）
    * 问题提出
      * 预期是等模拟接口调用完成，才记录响应日志、统计调用次数
      * 但现实是 chain.filter 方法立刻返回了，直到 filter 过滤器 return 后才调用了模拟接口
      * 原因：chain.filter 是异步操作，理解为前端的 promise
      * 解决方案：利用 response 装饰者，增强原有 response 的处理能力
      * 参考博客：https://blog.csdn.net/qq_19636353/article/details/126759522
  * Todo:
    * 因为已经抽成 common 项目了，所以 gateway 现阶段无法直接拷贝

# Day 6

## 问题的提出

* 网关项目如何调用其他项目的方法
* 解决办法：
  * 复制代码和依赖、环境
  * HTTP 请求（提供一个接口，供其他项目调用）
  * RPC
  * 把公共的代码打个 jar 包，其他项目去引用（客户端 SDK）

## HTTP 请求

* 提供方开发一个接口（地址、请求方法、参数、返回值）
* 调用方使用 HTTP Client 之类的代码包去发送 HTTP 请求

## RPC

* 作用：像调用本地方法一样调用远程方法
* 与 HTTP 调用的区别：
  * 对开发者更透明，减少了很多的沟通成本
  * RPC 向远程服务器发送请求时，未必要使用 HTTP 协议，比如还可以用 TCP / IP，性能更高。（内部服务更适用）
* 实现：Dubbo 框架，GRPC，TRPC

## Dubbo

* https://dubbo.incubator.apache.org/zh/docs3-v2/java-sdk/quick-start/spring-boot/
* 使用方法：
  * Spring Boot 代码（注解 + 编程式）：写 Java 接口，服务提供者和消费者都去引用这个接口
  * IDL（接口调用语言）：创建一个公共的接口定义文件，服务提供者和消费者读取这个文件。优点是跨语言，所有的框架都认识
* Dubbo 使用的是 Triple 协议，是基于 HTTP2 的开放协议
  * 与 gRPC 互通，多语言，网关友好，等等，详见官方文档

## Nacos

* 先下载并启动 Nacos Server:
  * https://nacos.io/zh-cn/docs/quick-start.html
  * `startup.cmd -m standalone`
  * **启动项目时，Nacos 需要一直保持开启**
* Nacos Spring Boot 快速开始: https://nacos.io/zh-cn/docs/quick-start-spring-boot.html

# Day 7

## 抽取公共项目 napi-common

* 目的是让方法、实体类在多个项目间复用，减少重复编写
* 服务抽取：
  * 数据库中查是否已分配给用户秘钥（根据 accessKey 拿到用户信息，返回用户信息，为空表示不存在）
  * 从数据库中查询模拟接口是否存在（请求路径、请求方法、请求参数，返回接口信息，为空表示不存在）
  * 接口调用次数 + 1 invokeCount（accessKey、secretKey（标识用户），请求接口路径）
* 步骤：
  * 新建干净的 maven 项目，只保留必要的公共依赖
  * 抽取 service 和实体类
  * install 本地 maven 包
  * 让服务提供者引入 common 包，测试是否正常运行
  * 让服务消费者引入 common 包

## gateway

* gateway 项目需要实现无数据库启动，因为 springboot 默认连接数据库
  * pom 中移除与数据库相关的依赖，如 spring-data，druid
  * 再加上 @SpringBootApplication(exclude = {xxx})

## 统计分析功能

### 需求

* 各接口的总调用次数占比（饼图）取调用最多的前 3 个接口，从而分析出哪些接口没有人用（降低资源、或者下线），高频接口（增加资源、提高收费）

### 前端

* ECharts：https://echarts.apache.org/zh/index.html（推荐）
* ECharts-react：https://github.com/hustcc/echarts-for-react
* AntV：https://antv.vision/zh（推荐，相对复杂但功能强大）
* BizCharts

### 后端

* SQL：select interfaceInfoId, sum(totalNum) as totalNum from user_interface_info group by interfaceInfoId order by totalNum desc limit 3;

## 部署

* 前端：参考之前用户中心或伙伴匹配系统的上线方式
* 后端：
  * backend 项目：web 项目，部署 spring boot 的 jar 包（对外的）
  * gateway 网关项目：web 项目，部署 spring boot 的 jar 包（对外的）
  * interface 模拟接口项目：web 项目，部署 spring boot 的 jar 包（不建议对外暴露的）

### Docker compose

* 编写 docker-compose.yml
* 编写多个 Dockerfile
* 可以统一管理，一条指令统一启动
* 网络联通性还有待考量，localhost 会找 docker 内部的对应端口，显然找不到，只能填写具体 ip，并且打开所有端口 (3306 8848 9848 9849 8090 8123)，除了 7529不做限制(前端发送的请求都不是本机 ip )，其他可以限制为本机 ip

### Dockerfile

* 编写一个 Dockerfile
* 