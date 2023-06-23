# napi-gateway

## What is this?

- API gateway of the whole project
- Functionalities:
  - Request parameter validation
  - API request counter
  - API rate limiting
  - Signature-based authentication
  - Logging

## How to use?

### Localhost

```bash
mvn package -DskipTests
java -jar ./target/napi-gateway-0.0.1-SNAPSHOT.jar
```

### AWS

- Want to deploy on AWS? see [README.md](../README.md) in main project