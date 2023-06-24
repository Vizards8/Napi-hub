#!/bin/bash

echo "Starting Nacos..." &&
nohup bash /app/nacos/bin/startup.sh -m standalone >nacos.out 2>&1 &
sleep 30

echo "Starting napi-interface..."
nohup java -jar /app/napi-interface-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >napi-interface.out 2>&1 &
sleep 30

echo "Starting napi-hub..."
nohup java -jar /app/napi-hub-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >napi-hub.out 2>&1 &
sleep 30

echo "Starting napi-gateway..."
nohup java -jar /app/napi-gateway-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >napi-gateway.out 2>&1 &
sleep 30

echo "Starting napi-hub-frontend..."
cd /app/napi-hub-frontend
nohup yarn start >napi-hub-frontend.out 2>&1 &
sleep 30

echo "All projects have been started!"