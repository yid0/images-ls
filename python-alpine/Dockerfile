ARG ALPINE_VERSION=3.20
ARG WORKDIR_APP=app
ARG VIRTUAL_ENV=/${WORKDIR_APP}/venv

FROM alpine:${ALPINE_VERSION}

ARG WORKDIR_APP
ARG VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /${WORKDIR_APP}

RUN apk update --no-cache && apk add --no-cache python3 && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    python -m venv ${VIRTUAL_ENV} && \
    source ${VIRTUAL_ENV}/bin/activate && \
    which python && pip install --upgrade pip && \
    find ${VIRTUAL_ENV} -type d -name "tests" -exec rm -rf {} + && \
    find ${VIRTUAL_ENV} -type d -name "test" -exec rm -rf {} + && \
    find ${VIRTUAL_ENV} -type d -name "__pycache__" -exec rm -rf {} + && \
    rm -rf ${VIRTUAL_ENV}/lib/python*/site-packages/*-info &&\    
    rm -rf /**/.cache/pip && rm -rf /var/cache/apk/*


FROM alpine:${ALPINE_VERSION}

ARG WORKDIR_APP
ARG VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /${WORKDIR_APP}

COPY --from=0 /usr/bin /usr/bin
COPY --from=0 /usr/lib /usr/lib
COPY --from=0 --chown=1001:1001 ${VIRTUAL_ENV} ${VIRTUAL_ENV}

CMD ["tail",  "-f" , "/dev/null"]