#!/bin/bash

yarn start &

java -jar /app/napi-hub-backend/target/napi-hub-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod &
java -jar /app/napi-gateway/target/napi-gateway-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod &
java -jar /app/napi-interface/target/napi-interface-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
