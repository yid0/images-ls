ARG ALPINE_VERSION=3.20
ARG GLIBC_VERSION=2.34-r0

FROM alpine:${ALPINE_VERSION}

ARG GLIBC_VERSION
ARG GLIBC_DIST=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget ${GLIBC_DIST} && cp /etc/nsswitch.conf /etc/nsswitch.conf.backup && \
    apk update --no-cache && apk add --no-cache --force-overwrite glibc-${GLIBC_VERSION}.apk && \
    apk add --force-overwrite alpine-baselayout-data && rm -rf /var/cache/apk/* /lib/apk/db/* /tmp/*

CMD ["tail", "-f" , "/dev/null"]  