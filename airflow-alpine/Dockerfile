
FROM yidoughi/pythopine:latest

ARG AIRFLOW_VERSION=2.10.1
ENV AIRFLOW_HOME=/usr/local/airflow

ARG WORKDIR=app
ARG VIRTUAL_ENV=/${WORKDIR}/venv
ENV VIRTUAL_ENV=${VIRTUAL_ENV}


RUN mkdir -p $AIRFLOW_HOME/dags $AIRFLOW_HOME/logs $AIRFLOW_HOME/plugins && \
    apk update --no-cache && apk add --no-cache bash python3-dev \
    linux-headers \
    libffi-dev \
    openssl-dev \
    postgresql-dev \
    gcc \
    g++ \
    abseil-cpp-dev \
    cmake \
    make \
    re2-dev \
    musl-dev && \
    pip install --upgrade pip setuptools wheel pybind11 && \
    pip install "apache-airflow==${AIRFLOW_VERSION}" && pip install pendulum && \
    which airflow && \
    apk del libffi-dev \
    openssl-dev \
    postgresql-dev \
    gcc \
    g++ \
    abseil-cpp-dev \
    cmake \
    make \
    python3-dev \
    bash \
    musl-dev --purge && \
    find ${VIRTUAL_ENV} -type d -name "tests" -exec rm -rf {} + && \
    find ${VIRTUAL_ENV} -type d -name "test" -exec rm -rf {} + && \
    find ${VIRTUAL_ENV} -type d -name "__pycache__" -exec rm -rf {} + && \
    rm -rf /**/.cache/pip && \
    rm -rf /var/cache/apk/* && rm -rf /tmp/** 


FROM yidoughi/pythopine:latest

ARG WORKDIR=app

ARG VIRTUAL_ENV=/${WORKDIR}/venv
ENV VIRTUAL_ENV=${VIRTUAL_ENV}

ENV PATH="$VIRTUAL_ENV/bin/airflow:$PATH"

ENV AIRFLOW_HOME=/usr/local/airflow

ENV PASSWORD=admin
ENV PORT=8080

ARG USERNAME=admin
ENV USERNAME=${USERNAME}

ARG EMAIL=admin@admin.com
ENV EMAIL=${EMAIL}

COPY --from=0 /usr/bin /usr/bin
COPY --from=0 /usr/lib /usr/lib
COPY --from=0 --chown=1001:1001 ${VIRTUAL_ENV} ${VIRTUAL_ENV}

RUN airflow --help && airflow db init && airflow users create \
    --username ${USERNAME} \
    --password ${PASSWORD} \
    --firstname admin \
    --lastname admin \
    --role Admin \
    --email ${EMAIL}

EXPOSE ${PORT}

CMD [ "sh", "-c", "tail -f /dev/null" ]
