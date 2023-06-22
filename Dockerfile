# Docker 镜像构建
# Base image for Java projects
FROM maven:3.8.1-jdk-8-slim

# Install MySQL and create tables
RUN apt-get update && apt-get install -y mysql-client
COPY napi-hub-backend/sql/create_table.sql /docker-entrypoint-initdb.d/

# Build and package Java projects
COPY napi-common /app/napi-common
COPY napi-client-sdk /app/napi-client-sdk
COPY napi-hub-backend /app/napi-hub-backend
COPY napi-gateway /app/napi-gateway
COPY napi-interface /app/napi-interface
RUN cd /app/napi-common && \
    mvn install -DskipTests && \
    cd /app/napi-client-sdk && \
    mvn install -DskipTests && \
    cd /app/napi-hub-backend && \
    mvn package -DskipTests && \
    cd /app/napi-gateway && \
    mvn package -DskipTests && \
    cd /app/napi-interface && \
    mvn package -DskipTests

# Install and start Nacos
RUN wget https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz && \
    tar -xvf nacos-server-2.2.3.tar.gz && \
    cd /app/nacos/bin && \
    sh startup.sh -m standalone

# Base image for React frontend
FROM node:16.20-bullseye-slim

# Build the React frontend
COPY napi-hub-frontend /app/napi-hub-frontend
WORKDIR /app/napi-hub-frontend
RUN yarn install && \
    yarn build

# Copy the shell script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Start the project
CMD ["sh","/app/start.sh"]