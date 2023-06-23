# napi-hub-backend

## What is this?

- This subproject provides backend support for the webpage
- Functionalities:
  - User login, logout and register
  - Get APIs' infomation
  - Get invoke count of each API
  - and other business logic required in user authentication

## How to use?

### Localhost

```bash
mvn package -DskipTests
java -jar ./target/napi-hub-0.0.1-SNAPSHOT.jar
```

### AWS

- Want to deploy on AWS? see [README.md](../README.md) in main project