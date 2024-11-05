ARG ALPINE_VERSION=3.20
ARG POSTGRES_DIR=/usr/local/postgres
ARG POSTGRES_VERSION=16.0

## builder image
FROM alpine:${ALPINE_VERSION} AS builder

ARG POSTGRES_VERSION
ARG POSTGRES_DIST=https://ftp.postgresql.org/pub/source/v${POSTGRES_VERSION}/postgresql-${POSTGRES_VERSION}.tar.gz

ARG POSTGRES_DIR
ENV POSTGRES_DIR=${POSTGRES_DIR}

RUN mkdir -p ${POSTGRES_DIR} && \ 
    apk update --no-cache && apk add --no-cache linux-headers \
    build-base \
    curl \
    openssl-dev \
    libressl \ 
    libedit-dev \ 
    perl \ 
    bison zlib-dev \ 
    icu-libs \
    icu-dev 

WORKDIR ${POSTGRES_DIR}

RUN wget ${POSTGRES_DIST} -O /tmp/postgresql.tar.gz  && tar -xzf /tmp/postgresql.tar.gz -C ${POSTGRES_DIR} --strip-components=1 && \
    ./configure --prefix=${POSTGRES_DIR} --with-openssl && make && make install && \
    rm -rf /var/cache/apk/* /tmp/* ${POSTGRES_DIR}/doc && \
    rm -rf config.log config.status Makefile GNUmakefile* INSTALL contrib src include README COPYRIGHT HISTORY

## prod image
FROM alpine:${ALPINE_VERSION}

ARG POSTGRES_DIR
ENV POSTGRES_DIR=${POSTGRES_DIR}
ENV HOME=/var/lib/postgresql

ENV PATH="$POSTGRES_DIR/bin:$PATH" \
    PGDATA="/var/lib/postgresql/data" \
    PGLOG="/var/lib/postgresql/logs" \ 
    PGCERTS="/var/lib/postgresql/certs" \
    POSTGRES_PORT="5432" \
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-P@ssword} \
    POSTGRES_ENV="dev"

WORKDIR ${HOME}

RUN apk update --no-cache && apk add --no-cache libedit ca-certificates openssl libressl libressl-dev musl-utils musl-locales icu-libs && \
    update-ca-certificates && adduser -D -h /var/lib/postgresql -u 1001 postgres && \
    mkdir -p ${PGDATA} ${PGLOG} ${PGCERTS} && \
    chown -R 1001:1001 /var/lib/postgresql && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    rm -rf /var/cache/apk/* /tmp/*

COPY --from=builder --chown=1001:1001 ${POSTGRES_DIR} ${POSTGRES_DIR}
COPY --chown=1001:1001 --chmod=755 start.sh  ${POSTGRES_DIR}/bin/start.sh
COPY --chown=1001:1001 --chmod=755 ssl.sh  ${POSTGRES_DIR}/bin/ssl.sh
    
EXPOSE ${PORT}

USER 1001

CMD ["tail",  "-f" , "/dev/null"]