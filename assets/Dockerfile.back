# Base image for Java projects
FROM maven:3.8.1-jdk-8-slim

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

# Copy the shell script
COPY docker_start_backend.sh /app/docker_start_backend.sh
RUN chmod +x /app/docker_start_backend.sh

EXPOSE 7529 8090 8123 

# Start the project
CMD ["bash","/app/docker_start_backend.sh"]