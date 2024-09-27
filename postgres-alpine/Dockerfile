ARG ALPINE_VERSION=3.20
ARG POSTGRES_DIR=/usr/local/postgres
ARG POSTGRES_VERSION=16.0

FROM alpine:${ALPINE_VERSION} AS builder

ARG POSTGRES_VERSION
ARG POSTGRES_DIST=https://ftp.postgresql.org/pub/source/v${POSTGRES_VERSION}/postgresql-${POSTGRES_VERSION}.tar.gz

ARG POSTGRES_DIR
ENV POSTGRES_DIR=${POSTGRES_DIR}

RUN mkdir -p ${POSTGRES_DIR} && apk add --no-cache linux-headers build-base curl openssl-dev libedit-dev perl bison zlib-dev icu-dev icu-libs

WORKDIR ${POSTGRES_DIR}

# COPY postgres*.tar.gz /tmp/postgresql.tar.gz

RUN wget ${POSTGRES_DIST} -O /tmp/postgresql.tar.gz  && tar -xzf /tmp/postgresql.tar.gz -C ${POSTGRES_DIR} --strip-components=1 && ls -la . && \
    ./configure --prefix=${POSTGRES_DIR} && make && make install && \
    rm -rf /var/cache/apk/* /tmp/* ${POSTGRES_DIR}/doc

FROM alpine:${ALPINE_VERSION}

ARG POSTGRES_DIR
ENV POSTGRES_DIR=${POSTGRES_DIR}
ENV HOME=${POSTGRES_DIR}
ENV PORT=5432

ENV PATH="$POSTGRES_DIR/bin:$PATH" \
    PGDATA="/var/lib/postgresql/data" \
    PGLOG="/var/lib/postgresql/logs"

ENV APP_DB=db
ENV APP_USER=app_user
ENV APP_PASSWORD=user
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-P@ssword}

WORKDIR ${HOME}

COPY --chown=1001:1001 start.sh  ./bin/start.sh

RUN apk add --no-cache libedit openssl icu-libs && adduser -D -h /var/lib/postgresql -u 1001 postgres && \
    mkdir -p /var/lib/postgresql/data /var/lib/postgresql/logs && \
    chown -R 1001:1001 /var/lib/postgresql && \
    chmod +x ./bin/start.sh && \
    rm -rf /var/cache/apk/* /tmp/*

COPY --from=builder --chown=1001:1001 ${POSTGRES_DIR} ${POSTGRES_DIR}

EXPOSE ${PORT}

USER 1001

RUN initdb -D ${PGDATA}

CMD [ "sh", "-c", "tail -f /dev/null" ]