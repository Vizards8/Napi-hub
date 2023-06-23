#!/bin/bash

nohup sh /app/nacos/bin/startup.sh -m standalone &

nohup java -jar /app/napi-interface-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod &
nohup java -jar /app/napi-gateway-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod &
nohup java -jar /app/napi-hub-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod &

cd /app/napi-hub-frontend
nohup yarn start &