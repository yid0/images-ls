# Overview

This project aims to provide a list of lightweight Docker images for popular tools and software, with a focus on performance.

## [Pythopine](python-alpine/README.md) - Less than 55 MB

This Docker image contains Python and pip installed on Alpine Linux.

- **Compressed size**: Less than 25 MB
- **Uncompressed size**: Less than 55 MB

## [Fastpine](fastapi-alpine/README.md) - Less than 100 MB

This Docker image runs FastAPI with [pythopine](python-alpine/README.md) a lightweight Python image based on Alpine Linux.

- **Compressed size**: Less than 30 MB
- **Uncompressed size**: Less than 100 MB

### Usage

To use this image in your projects (e.g., for build stages), you can use the following Dockerfile snippet:

    FROM yidoughi/fastapi-alpine:latest

    ARG PORT=8000
    ENV PORT=${PORT}

    ARG WORKERS=1
    ENV WORKERS=${WORKERS}

    COPY --chown=1001:1001 . /app

    RUN pip install -r requirements.txt

    ENTRYPOINT ["/app/venv/bin/fastapi", "run", "main.py"]  # For production mode, use "app" instead of "run"


###  Example Kubernetes Deployment:


#### **Important** :
 
As described in the FastAPI official documentation https://fastapi.tiangolo.com/deployment/docker/#one-load-balancer-multiple-worker-containers, when deploying a component based on FastAPI, the --workers flag should be set to 1. Your FastAPI application will be associated with one PID, and Kubernetes will handle the rest using pod replicas. For other deployment scenarios (such as on bare metal), you can still use the --workers flag.

#### Deployment Example:

        apiVersion: apps/v1
        kind: Deployment
        metadata:
        name: api
        labels:
            app: api
        spec:
        selector:
            matchLabels:
            app: api
        replicas: 1
        template:
            metadata:
            labels:
                app: api
            spec:
            containers:
                - name: api
                image: <your final image>
                ports:
                - containerPort: 8080
                    name: http
                envFrom:
                - configMapRef:
                    name: api-config

#### ConfigMap Example

        apiVersion: v1
        kind: ConfigMap
        metadata:
        name: api-config
        labels:
            app: api
        data:
            PORT: "8080"