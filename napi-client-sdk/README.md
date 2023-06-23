# napi-client-sdk

## What is this?

- This is a client SDK which provieds a easy-to-use tool for the main project napi-hub

## How to use?

- Run Maven build command

```bash
mvn install -DskipTests
```

- Add the following dependency to your project's Maven configuration file `pom.xml`:

```xml
<dependency>
    <groupId>com.nz</groupId>
    <artifactId>napi-client-sdk</artifactId>
    <version>0.0.1</version>
</dependency>
```

- Add the following configuration to `application.yml`:
  
```yml
napi:
  client:
    access-key: YOUR_ACCESS_KEY
    secret-key: YOUR_SECRET_KEY
```

- Replace YOUR_ACCESS_KEY and YOUR_SECRET_KEY with your actual API credentials.

## Usage

- Example:

```java
NApiClient nApiClient = new NApiClient(accessKey, secretKey);
String res = nApiClient.getgetQuote();
```