# napi-interface

## What is this?

- This subproject provides mock APIs
- No user login, No authentication, just a simple Java Spring Boot application

## APIs we provide

- POST: getUsernameByPost
- GET: hello
- GET: getQuote
- GET: getLuckyPrediction
- GET: getDailyWeather
- and more in progress

## How to use?

### Localhost

```bash
mvn package -DskipTests
java -jar ./target/napi-interface-0.0.1-SNAPSHOT.jar
```

### AWS

- Want to deploy on AWS? see [README.md](../README.md) in main project