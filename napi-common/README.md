# napi-common

## What is this?

- This is the subprject which contains some common utils for other subprojects
- I designed this subproject for better code reusability and simplicity
- Also, this subproject can be used in any other projects

## How to use?

- Run Maven build command

```bash
mvn install -DskipTests
```

- Add the following dependency to other project's Maven configuration file `pom.xml` (already done):

```xml
<dependency>
    <groupId>com.nz</groupId>
    <artifactId>napi-common</artifactId>
    <version>0.0.1</version>
</dependency>
```