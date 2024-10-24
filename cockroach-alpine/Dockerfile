ARG ALPINE_VERSION=3.20
ARG COCKROACHDB_VERSION=24.2.3
ARG COCKROACH_DIR=/usr/local/cockroachdb
ARG COCKROACH_LIB_DIR=/usr/local/lib/cockroach

FROM alpine:${ALPINE_VERSION} AS builder

ARG BUILD_ARCH=linux-amd64

ARG COCKROACHDB_VERSION

ARG COCKROACH_DIST=https://binaries.cockroachdb.com/cockroach-v${COCKROACHDB_VERSION}.${BUILD_ARCH}.tgz

ARG COCKROACH_DIR
ENV COCKROACH_DIR=${COCKROACH_DIR}

ARG COCKROACH_LIB_DIR

RUN mkdir -p ${COCKROACH_DIR} && mkdir -p ${COCKROACH_LIB_DIR} && \
    wget ${COCKROACH_DIST} -O /tmp/cockroachdb.tar.gz && tar -xzf /tmp/cockroachdb.tar.gz --strip-components=1 -C ${COCKROACH_DIR} && \ 
    ln -sf ${COCKROACH_DIR}/lib/libgeos_c.so ${COCKROACH_LIB_DIR}/libgeos_c.so && \
    ln -sf ${COCKROACH_DIR}/lib/libgeos.so ${COCKROACH_LIB_DIR}/libgeos.so && \
    rm -rf /var/cache/apk/* /tmp/* ${COCKROACH_DIR}/*.txt
    
FROM yidoughi/glibcpine:${ALPINE_VERSION}

ARG COCKROACH_DIR

ENV COCKROACH_DIR=${COCKROACH_DIR}

ARG COCKROACH_LIB_DIR
ENV COCKROACH_LIB_DIR=${COCKROACH_LIB_DIR}

ENV HOME=${COCKROACH_DIR}

ARG COCKROACH_PORT=26257
ENV COCKROACH_PORT=${COCKROACH_PORT}

ARG COCKROACH_HTTP_PORT=8099
ENV COCKROACH_HTTP_PORT=${COCKROACH_HTTP_PORT}

ENV COCKROACH_HTTP_HOST=dev
ENV COCKROACH_HOSTNAME=dev
ENV COCKROACH_ENV=dev

ENV PATH="$COCKROACH_DIR:/usr/glibc-compat:$PATH"

COPY --from=builder --chown=1001:1001 ${COCKROACH_DIR} ${COCKROACH_DIR}
COPY --chown=1001:1001 --chmod=755 start.sh /${COCKROACH_DIR}/start.sh

RUN adduser -D -h /var/lib/cockroach -u 1001 cockroach && \
    mkdir -p /var/lib/cockroach/certs && \
    chown -R 1001:1001 /var/lib/cockroach && \
    rm -rf /var/cache/apk/* /tmp/*

WORKDIR ${HOME}

EXPOSE ${PORT} ${HTTP_PORT}

USER 1001

CMD ["start.sh"]