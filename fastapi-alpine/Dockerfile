ARG ALPINE_VERSION=3.20
ARG WORKDIR_APP=app
ARG VIRTUAL_ENV=/${WORKDIR_APP}/venv

FROM yidoughi/pythopine:${ALPINE_VERSION}

ARG FASTAPI_VERSION=0.112.1

ARG WORKDIR_APP
ARG VIRTUAL_ENV

ENV WORKDIR_APP=${WORKDIR_APP}
ENV VIRTUAL_ENV=${VIRTUAL_ENV}
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /${WORKDIR_APP}

COPY status.py ./status.py

RUN apk update --no-cache && \
    pip install "fastapi[standard]"==$FASTAPI_VERSION && \ 
    find ${VIRTUAL_ENV} -type d -name "tests" -exec rm -rf {} + && \
    find ${VIRTUAL_ENV} -type d -name "test" -exec rm -rf {} + && \
    find ${VIRTUAL_ENV} -type d -name "__pycache__" -exec rm -rf {} + && \
    rm -rf ${VIRTUAL_ENV}/lib/python*/site-packages/*-info && \
    rm -rf /**/.cache/pip && rm -rf /var/cache/apk/*

FROM alpine:${ALPINE_VERSION}
 
ARG WORKDIR_APP
ARG VIRTUAL_ENV

ENV WORKDIR_APP=${WORKDIR_APP}
ENV VIRTUAL_ENV=${VIRTUAL_ENV}
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV HOME=/${WORKDIR_APP}

WORKDIR /${WORKDIR_APP}

COPY --from=0 /usr/lib /usr/lib
COPY --from=0 /usr/bin /usr/bin
COPY --from=0 --chown=1001:1001 /${WORKDIR_APP}/status.py ./status.py
COPY --from=0 --chown=1001:1001 ${VIRTUAL_ENV} ${VIRTUAL_ENV}

CMD ["tail", "-f" , "/dev/null"]