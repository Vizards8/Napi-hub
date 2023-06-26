#!/bin/bash

# Current working directory
current_dir=$(pwd)

echo -e "\e[1;31m=============== Pull image nacos/nacos-server:v2.2.3 ===============\e[0m"
echo "Pull image nacos/nacos-server:v2.2.3 ..."
sudo docker pull nacos/nacos-server:v2.2.3
echo -e "\e[1;32m Complete! \e[0m"

echo -e "\e[1;31m=============== Pull image mysql:8 ===============\e[0m"
sudo docker pull mysql:8
echo -e "\e[1;32m Complete! \e[0m"

echo -e "\e[1;31m=============== Docker build frontend ===============\e[0m"
cd ./napi-hub-frontend
sudo docker build -t napi-hub-frontend:v0.0.1 .
cd "$current_dir"
echo -e "\e[1;32m Complete! \e[0m"

echo -e "\e[1;31m=============== Docker build backend ===============\e[0m"
sudo docker build -t napi-hub-backend:v0.0.1 .
echo -e "\e[1;32m Complete! \e[0m"