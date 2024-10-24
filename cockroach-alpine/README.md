#   Cockrochpine - CockroachDB with Alpine Linux


This repository contains a Dockerfile to build a **CockroachDB** Docker image based on **Alpine Linux**. At the moment, this image is primarily intended for **development** and **testing** environments and is **not recommended for production**.


### Quickstart
    
You can start a **CockroachDB** instance with cockroachpine image available on docker hub.

        
        docker run --name cockroachpine -d -p 26257:26257 -p 8099:8099 yidoughi/cockroachpine:latest
**Or**

        docker run --name cockroachpine -d --network host yidoughi/cockroachpine:latest

The **CockroachDB UI** will be visible at : http://localhost:8099/#/overview

## Build Variables

The Dockerfile is designed to be flexible and configurable. You can adjust the following variables during the build process:

| Variable             | Default Value         | Description                                                                 |
|----------------------|-----------------------|-----------------------------------------------------------------------------|
| `ALPINE_VERSION`      | 3.20                  | Alpine version used in both build and runtime stages                        |
| `COCKROACHDB_VERSION` | 24.2.3                | CockroachDB version to be installed                                         |
| `BUILD_ARCH`          | linux-amd64           | Target architecture (e.g., `linux-arm64` for ARM, `linux-amd64` for x86_64) |
| `COCKROACH_DIR`       | /usr/local/cockroachdb | Directory where CockroachDB will be installed                               |
| `COCKROACH_LIB_DIR`   | /usr/local/lib/cockroach | Directory for CockroachDB libraries                                      |
| `COCKROACH_PORT`      | 26257                 | Default port for CockroachDB                                                |
| `COCKROACH_HTTP_PORT` | 8099                  | Default HTTP port for CockroachDB's web interface                           |
| `COCKROACH_HTTP_HOST` | localhost             | HTTP host setting                                                           |
| `COCKROACH_HOSTNAME`  | localhost             | Hostname for the CockroachDB instance                                       |
| `COCKROACH_ENV`       | dev                   | Environment (e.g., `dev`, `prod`, etc.)                                     |
| `COCKROACH_NODES`     | N/A                   | Used in production to specify the nodes to join in the cluster              |

## How to Build your own Image

You can build the Docker image for two different architectures by specifying the `BUILD_ARCH` variable during the build process.

### Build for `linux-amd64` (Default)

export username=devel  ## 
```bash
docker build --build-arg BUILD_ARCH=linux-amd64 -t cockroachdb:${COCKROACHDB_VERSION}-alpine${ALPINE_VERSION} .
docker tag ${username}/cockroachdb:${COCKROACHDB_VERSION}-alpine${ALPINE_VERSION} ${username}/cockroachdb:latest
```

### Build for `linux-arm64`

```bash
docker build --build-arg BUILD_ARCH=linux-arm64 -t cockroachdb-${COCKROACHDB_VERSION}:${ALPINE_VERSION} .
docker tag cockroachdb-${COCKROACHDB_VERSION}:${ALPINE_VERSION} cockroachdb:latest
```

By default, the image will use the `linux-amd64` architecture if no `BUILD_ARCH` argument is provided.

## Running the Container

Once the image is built, you can run the container using the following command:

```bash
docker run -d --name cockroachdb-dev -p 26257:26257 -p 8099:8099 cockroachdb-alpine:amd64
```

This will expose the default CockroachDB port (`26257`) and the HTTP port (`8099`) on your local machine. You can adjust these ports as needed by passing the `-p` flag with different values.

## Starting the CockroachDB Server

A `start.sh` script is included to start the CockroachDB server. It handles both **development** and **production** environments.

### Development Mode

In development mode, the server runs in **single-node mode** with the `--insecure` flag for simplicity.

```bash
#!/bin/sh
set -e

START="start-single-node --insecure"
JOIN_CLUSTER=

cockroach $START --http-addr="$COCKROACH_HOST":"$COCKROACH_HTTP_PORT" --listen-addr="$COCKROACH_HOST":"$COCKROACH_PORT" $JOIN_CLUSTER
```

### Production Mode (TODO)

In production mode, the script will start CockroachDB and attempt to join a cluster using the nodes specified in the `COCKROACH_NODES` variable. It also sets up secure communication with the `--certs-dir` option.

```bash
#!/bin/sh
set -e

START="start"
JOIN_CLUSTER=--join="$COCKROACH_NODES"
CERTS_DIR=--certs-dir=/var/lib/cockroachdb/certs

cockroach $START --http-addr="$COCKROACH_HOST":"$COCKROACH_HTTP_PORT" --listen-addr="$COCKROACH_HOST":"$COCKROACH_PORT" $JOIN_CLUSTER $CERTS_DIR
```

To run in **production mode**, ensure that the environment variable `COCKROACH_ENV` is set to `production`:

```bash
docker run -d --name cockroachdb-prod -p 26257:26257 -p 8099:8099 -e COCKROACH_ENV=production -e COCKROACH_NODES=<node-list> cockroachdb-alpine:amd64
```

## Important Notes

- This image is **not recommended for production use**. It is tailored for development and testing environments.
- In a production setup, additional steps such as setting up secure configurations, certificates, and proper resource management are required, which are **not included** in this Dockerfile.
- For production environments, ensure that you provide valid certificates and node information for the CockroachDB cluster.
