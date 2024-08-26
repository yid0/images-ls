##
FROM alpine:3.20

ARG PYTHON_VERSION=3.12.3-r2
ARG WORKDIR_APP=app
ARG FASTAPI_VERSION=0.112.1

WORKDIR /${WORKDIR_APP}

RUN apk update && apk add --virtual --no-cache \
    python3=${PYTHON_VERSION} \
    python3-dev=${PYTHON_VERSION} && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    which python3 && python3 -V

RUN python -m venv ./venv && source ./venv/bin/activate && \
    pip install --upgrade pip && pip install "fastapi[standard]"==$FASTAPI_VERSION && \ 
    apk del --purge && rm -rf /var/cache/apk/*

## prod image
FROM alpine:3.20

ARG PYTHON_VERSION=3.12.3-r2
ARG WORKDIR_APP=app

WORKDIR /${WORKDIR_APP}

RUN apk update && apk add --no-cache \
    python3=${PYTHON_VERSION}

COPY --from=0 --chown=1001:1001 /${WORKDIR_APP} /${WORKDIR_APP}

RUN source /app/venv/bin/activate

SHELL ["/bin/sh", "-c"]