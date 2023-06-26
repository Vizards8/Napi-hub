# Docker 镜像构建
# Base image for Java projects
FROM maven:3.8.1-jdk-8-slim AS Build_back

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

# Base image for Node project
FROM node:16.20-bullseye-slim AS Build_front

# Build the React frontend
WORKDIR /app
COPY napi-hub-frontend .
RUN yarn install && \
    yarn build

# Runtime stage
FROM ubuntu:20.04
ENV TZ=US/Eastern

# Install MySQL and create tables
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY ./napi-hub-backend/sql/create_table.sql /app/create_table.sql

# Install Java 8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Java home environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Set Java executable in PATH
ENV PATH=$PATH:$JAVA_HOME/bin

# Install Nacos
WORKDIR /app
# RUN apt-get update && \
#     apt-get install -y wget && \
#     wget https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz && \
#     tar -xzf nacos-server-2.2.3.tar.gz && \
#     rm -rf nacos-server-2.2.3.tar.gz
COPY nacos-server-2.2.3.tar.gz .
RUN tar -xzf nacos-server-2.2.3.tar.gz && \
    rm -rf nacos-server-2.2.3.tar.gz

# Install Nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Deploy frontend project
WORKDIR /usr/share/nginx/html/
USER root
COPY ./napi-hub-frontend/docker/nginx.conf /etc/nginx/sites-available/default
COPY --from=Build_front /app/dist  /usr/share/nginx/html/
EXPOSE 80

# Copy built Java artifacts from the build stage
COPY --from=Build_back /app/napi-hub-backend/target/napi-hub-0.0.1-SNAPSHOT.jar /app/napi-hub-0.0.1-SNAPSHOT.jar
COPY --from=Build_back /app/napi-gateway/target/napi-gateway-0.0.1-SNAPSHOT.jar /app/napi-gateway-0.0.1-SNAPSHOT.jar
COPY --from=Build_back /app/napi-interface/target/napi-interface-0.0.1-SNAPSHOT.jar /app/napi-interface-0.0.1-SNAPSHOT.jar

# Copy the shell script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Start the project
CMD ["sh","/app/start.sh"]