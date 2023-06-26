#!/bin/bash

echo "Starting napi-interface..."
nohup java -jar /app/napi-interface/target/napi-interface-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >napi-interface.out 2>&1 &
sleep 10
echo "Complete!"

echo "Starting napi-hub..."
nohup java -jar  -Xms256m -Xmx256m -Xmn128m  /app/napi-hub-backend/target/napi-hub-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >napi-hub.out 2>&1 &
sleep 40
echo "Complete!"

# echo "Starting napi-gateway..."
# nohup java -jar  -Xms256m -Xmx256m -Xmn128m /app/napi-gateway/target/napi-gateway-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >napi-gateway.out 2>&1 &
# sleep 40
# echo "Complete!"

echo "All projects have been started!"

/bin/bash