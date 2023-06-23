# API Open Platform

## How to use

### Localhost

- Follow the README.md in 6 subprojects

### AWS

- Build Docker Image

```bash
sudo docker build -t napi:v0.0.1 .
```

- I have wrote `start.sh`, it will automatically run when docker run and start all the subprojects

```bash
sudo docker run -p 8000:8000 name:v0.0.1
```
