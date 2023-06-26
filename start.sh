#!/bin/bash

set -e

# Start MySQL
echo "Starting MySQL ..."
service mysql start
mysql < /app/create_table.sql
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';"
sleep 3
service mysql status
echo "Complete!"

# Start Nacos
echo "Starting Nacos ..."
bash /app/nacos/bin/startup.sh -m standalone
sleep 3

# Start Java Projects
echo "Starting napi-interface..."
nohup java -jar /app/napi-interface-0.0.1-SNAPSHOT.jar >napi-interface.out 2>&1 &
sleep 10

echo "Starting napi-hub..."
nohup java -jar /app/napi-hub-0.0.1-SNAPSHOT.jar >napi-hub.out 2>&1 &
sleep 40

# echo "Starting napi-gateway..."
# nohup java -jar /app/napi-gateway-0.0.1-SNAPSHOT.jar >napi-gateway.out 2>&1 &
# sleep 40

# Start Nginx
echo "Starting Nginx ..."
nginx -g "daemon off;"

echo "Complete successfully!"

# 不加这一行会导致容器反复重启
/bin/bash