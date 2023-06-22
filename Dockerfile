# Docker 镜像构建
# Base image for Java projects
FROM maven:3.8.1-jdk-8-slim AS build

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

# Runtime stage
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Eastern

# Install Wget
RUN apt-get update && \
    apt-get install -y wget

# Install MySQL and create tables
RUN apt-get update && \
    apt-get install -y mysql-server
COPY mysql_init.sh /app/mysql_init.sh
RUN chmod +x /app/mysql_init.sh && \
    sh /app/mysql_init.sh
COPY napi-hub-backend/sql/create_table.sql /docker-entrypoint-initdb.d/

# Install and start Nacos
RUN wget https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz && \
    tar -xvf nacos-server-2.2.3.tar.gz && \
    rm nacos-server-2.2.3.tar.gz

# Install Java 8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk

# Set Java home environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Set Java executable in PATH
ENV PATH=$PATH:$JAVA_HOME/bin

# Install Node.js 16, npm, and Yarn
RUN apt-get update && \
    apt-get install apt-transport-https curl ca-certificates software-properties-common && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    node -v && \
    npm -v && \
    yarn -v

# Build the React frontend
COPY napi-hub-frontend /app/napi-hub-frontend
WORKDIR /app/napi-hub-frontend
RUN yarn install && \
    yarn build
EXPOSE 8000

# Copy built Java artifacts from the build stage
COPY --from=build /app/napi-hub-backend/target/napi-hub-0.0.1-SNAPSHOT.jar /app/napi-hub-0.0.1-SNAPSHOT.jar
COPY --from=build /app/napi-gateway/target/napi-gateway-0.0.1-SNAPSHOT.jar /app/napi-gateway-0.0.1-SNAPSHOT.jar
COPY --from=build /app/napi-interface/target/napi-interface-0.0.1-SNAPSHOT.jar /app/napi-interface-0.0.1-SNAPSHOT.jar

# Copy the shell script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Start the project
CMD ["sh","/app/start.sh"]