#!/bin/bash

echo "Starting Nacos ..."
sudo docker run -d -p 8848:8848  -p 9848:9848 -p 9849:9849 --privileged=true -e JVM_XMS=256m -e JVM_XMX=256m -e JVM_XMN=128m -e MODE=standalone nacos/nacos-server:v2.2.3
echo "Complete!"

echo "Starting MySQL ..."
sudo docker run -d -p 3306:3306 --name mysql8 -e MYSQL_ROOT_PASSWORD=123456 -v /etc/localtime:/etc/localtime -v /etc/timezone:/etc/timezone -v ./napi-hub-backend/sql/create_table.sql:/docker-entrypoint-initdb.d/create_table.sql mysql:8
echo "Complete!"

echo "Starting Frontend ..."
sudo docker run -d -p 80:80 napi-hub-frontend:v0.0.1
echo "Complete!"

echo "Starting Backend ..."
sudo docker run -d -p 7529:7529 -p 8090:8090 -p 8123:8123 napi-hub-backend:v0.0.1
echo "Complete!"