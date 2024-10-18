ARG ALPINE_VERSION=3.20
ARG GLIBC_VERSION=2.35-r1

FROM alpine:${ALPINE_VERSION}

ARG GLIBC_VERSION
ARG GLIBC_DIST=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}

ENV PATH="/usr/glibc-compat/bin:$PATH"

RUN apk update --no-cache && apk --no-cache add --virtual .build-deps && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget ${GLIBC_DIST}/glibc-${GLIBC_VERSION}.apk && \
    wget ${GLIBC_DIST}/glibc-bin-${GLIBC_VERSION}.apk && \
    wget ${GLIBC_DIST}/glibc-i18n-${GLIBC_VERSION}.apk && \
    apk --no-cache add --force-overwrite glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk && \
    localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    cp /etc/nsswitch.conf /etc/nsswitch.conf.backup && \
    apk add --force-overwrite alpine-baselayout-data && \
    apk del .build-deps --purge && rm -rf /var/cache/apk/* /tmp/* /glibc*.apk /etc/apk/keys/sgerrand.rsa.pub

RUN ldd --version

CMD ["tail", "-f" , "/dev/null"]