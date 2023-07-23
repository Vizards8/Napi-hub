# 数据库初始化
-- 创建库
drop database if exists napi;
create database if not exists napi;

-- 切换库
use napi;

-- 用户表
create table if not exists user
(
    id           bigint auto_increment comment 'id' primary key,
    userName     varchar(256)                           null comment '用户昵称',
    userAccount  varchar(256)                           not null comment '账号',
    userAvatar   varchar(1024)                          null comment '用户头像',
    gender       tinyint                                null comment '性别',
    userRole     varchar(256) default 'user'            not null comment '用户角色：user / admin',
    userPassword varchar(512)                           not null comment '密码',
    `accessKey` varchar(512) not null comment 'accessKey',
    `secretKey` varchar(512) not null comment 'secretKey',
    createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete     tinyint      default 0                 not null comment '是否删除',
    constraint uni_userAccount
        unique (userAccount)
) comment '用户';

-- 接口信息
create table if not exists napi.`interface_info`
(
    `id` bigint not null auto_increment comment '主键' primary key,
    `name` varchar(256) not null comment '名称',
    `description` varchar(256) null comment '描述',
    `url` varchar(512) not null comment '接口地址',
    `requestParams` text not null comment '请求参数',
    `requestHeader` text null comment '请求头',
    `responseHeader` text null comment '响应头',
    `status` int default 0 not null comment '接口状态（0-关闭，1-开启）',
    `method` varchar(256) not null comment '请求类型',
    `userId` bigint not null comment '创建人',
    `createTime` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `updateTime` datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `isDelete` tinyint default 0 not null comment '是否删除(0-未删, 1-已删)'
) comment '接口信息';

-- 用户调用接口关系表
create table if not exists napi.`user_interface_info`
(
    `id` bigint not null auto_increment comment '主键' primary key,
    `userId` bigint not null comment '调用用户 id',
    `interfaceInfoId` bigint not null comment '接口 id',
    `totalNum` int default 0 not null comment '总调用次数',
    `leftNum` int default 0 not null comment '剩余调用次数',
    `status` int default 0 not null comment '0-正常，1-禁用',
    `createTime` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `updateTime` datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `isDelete` tinyint default 0 not null comment '是否删除(0-未删, 1-已删)'
) comment '用户调用接口关系';

INSERT INTO napi.user (id, userName, userAccount, userAvatar, gender, userRole, userPassword, accessKey, secretKey, isDelete) VALUES (1, null, 'laphi', null, null, 'admin', 'c0c4c8912c5b196837770b77283caf29', 'yupi', 'abcdefgh', 0);

insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('getUsernameByPost', 'Get Username by POST', 'http://localhost:8123/api/name/user', '[{"name":"username", "type": "string"}]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'POST', '1');
insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('quote', 'Empower Your Day with the Quote of the Day!', 'http://localhost:8123/api/quote', '[]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'GET', '1');
insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('lucky', 'Unlock Your Fortunate Future: Embrace the Lucky Predictions!', 'http://localhost:8123/api/lucky', '[]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'GET', '1');
insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('hello', 'Test API', 'http://localhost:8123/api/hello', '[]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'GET', '1');
insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('hello1', 'Test API', 'http://localhost:8123/api/hello1', '[]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'GET', '1');
insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('hello2', 'Test API', 'http://localhost:8123/api/hello2', '[]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'GET', '1');
insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('hello3', 'Test API', 'http://localhost:8123/api/hello3', '[]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'GET', '1');
insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('hello4', 'Test API', 'http://localhost:8123/api/hello4', '[]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'GET', '1');
insert into napi.`interface_info` (`name`, `description`, `url`, `requestParams`, `requestHeader`, `responseHeader`, `status`, `method`, `userId`) values ('hello5', 'Test API', 'http://localhost:8123/api/hello5', '[]', '{"Content-Type": "application/json"}', '{"Content-Type": "application/json"}', 1, 'GET', '1');

insert into napi.`user_interface_info` (`userId`, `interfaceInfoId`, `totalNum`, `leftNum`, `status`, `isDelete`) values (1, 1, 5, 999, 0, 0);
insert into napi.`user_interface_info` (`userId`, `interfaceInfoId`, `totalNum`, `leftNum`, `status`, `isDelete`) values (1, 2, 3, 999, 0, 0);
insert into napi.`user_interface_info` (`userId`, `interfaceInfoId`, `totalNum`, `leftNum`, `status`, `isDelete`) values (1, 3, 1, 999, 0, 0);