ARG ALPINE_VERSION=3.20
ARG JAVA_VERSION=17
ARG WORKDIR_APP=app

FROM alpine:${ALPINE_VERSION}

ARG JAVA_VERSION

ENV JAVA_VERSION=${JAVA_VERSION}
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk

RUN apk update --no-cache && apk add --virtual --no-cache curl openjdk${JAVA_VERSION} && \
    apk del --purge && rm -rf /var/cache/apk/* && rm -rf /usr/share/man /tmp/* ${JAVA_HOME}/demo ${JAVA_HOME}/man

FROM alpine:${ALPINE_VERSION}

ARG WORKDIR_APP
ARG JAVA_VERSION

ENV WORKDIR_APP=${WORKDIR_APP}
ENV HOME=/${WORKDIR_APP}

WORKDIR ${HOME}

ENV JAVA_VERSION=${JAVA_VERSION}
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk

COPY --from=0 /usr/bin /usr/bin
COPY --from=0 /usr/lib/jvm /usr/lib/jvm
    
CMD ["sh", "-c", "java --version && tail -f /dev/null"]