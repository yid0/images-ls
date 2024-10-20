ARG ALPINE_VERSION=3.20
ARG GLIBC_VERSION=2.35-r1

FROM alpine:${ALPINE_VERSION} AS builder

ARG GLIBC_VERSION
ENV GLIBC_VERSION=${GLIBC_VERSION}
ARG GLIBC_DIST=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}

ENV PATH="/usr/glibc-compat:$PATH"

RUN apk update --no-cache && apk --no-cache add --virtual .build-deps gcompat binutils libstdc++ libgcc tzdata && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget ${GLIBC_DIST}/glibc-${GLIBC_VERSION}.apk && \
    wget ${GLIBC_DIST}/glibc-bin-${GLIBC_VERSION}.apk && \
    wget ${GLIBC_DIST}/glibc-i18n-${GLIBC_VERSION}.apk && \
    cp /etc/nsswitch.conf /etc/nsswitch.conf.backup && \
    apk add --force-overwrite glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    apk del .build-deps --purge && rm -rf /var/cache/apk/* /tmp/* /glibc* 

RUN /usr/glibc-compat/bin/ldd /lib/ld-linux-x86-64.so.2

CMD ["tail", "-f" , "/dev/null"]
