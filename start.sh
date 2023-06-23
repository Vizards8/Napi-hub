#!/bin/bash

sh /app/nacos/bin/startup.sh -m standalone

java -jar /app/napi-interface-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
java -jar /app/napi-gateway-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
java -jar /app/napi-hub-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod

cd /app/napi-hub-frontend
yarn start