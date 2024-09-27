
ARG ALPINE_VERSION=3.20
ARG WORKDIR_APP=app
ARG NODE_ENV=production

FROM alpine:${ALPINE_VERSION}

ARG WORKDIR_APP
ARG NODE_ENV
ARG NODE_ENV=${NODE_ENV}

ENV NODE_ENV=${NODE_ENV}
ENV WORKDIR_APP=${WORKDIR_APP}
ENV HOME=/${WORKDIR_APP}

WORKDIR /${WORKDIR_APP}

RUN apk update --no-cache && apk add --no-cache nodejs npm  && \
    node -v && which node && npm -v && which npm && \
    rm -rf /usr/share/man /tmp/* /var/tmp/* /var/cache/apk/* rm -rf

FROM alpine:${ALPINE_VERSION}

ARG WORKDIR_APP
ARG NODE_ENV

ENV NODE_ENV=${NODE_ENV}
ENV WORKDIR_APP=${WORKDIR_APP}
ENV HOME=/${WORKDIR_APP}

WORKDIR /${WORKDIR_APP}

COPY --from=0 /usr/bin /usr/bin
COPY --from=0 /usr/lib /usr/lib
COPY --from=0 /usr/local /usr/local

CMD ["sh", "-c", "node -v && tail -f /dev/null"]