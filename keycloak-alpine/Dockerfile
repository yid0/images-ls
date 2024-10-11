ARG JAVA_VERSION=17
ARG ALPINE_VERSION=3.20
ARG WORKDIR_APP=opt
ARG KEYCLOAK_DIR=/${WORKDIR_APP}/keycloak
ARG KC_TRUSTSTORE_PASSWORD=password

FROM yidoughi/javapine:${JAVA_VERSION}-${ALPINE_VERSION} AS builder

ARG KEYCLOAK_VERSION=25.0.6

ARG KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz

ARG JARS_TO_DELETE=""

ARG WORKDIR_APP
ARG KEYCLOAK_DIR
ENV KEYCLOAK_DIR=${KEYCLOAK_DIR}

ENV KC_DB=${KC_DB:-postgres} 

ARG KC_FEATURES=persistent-user-sessions

# ENV KC_FEATURES=${KC_FEATURES}
# ARG KC_FEATURES_DISABLED=${KC_FEATURES_DISABLED:-account-api,account3}

ARG KC_DB_URL_HOST=postgres
ENV KC_DB_URL_HOST=${KC_DB_URL_HOST}
ARG KC_TRUSTSTORE_PASSWORD=password
ENV KC_TRUSTSTORE_PASSWORD=${KC_TRUSTSTORE_PASSWORD}

COPY clean.sh /tmp/clean.sh
COPY --chown=1001:1001 --chmod=0755 start.sh ${KEYCLOAK_DIR}/bin/start.sh
COPY --chown=1001:1001 realm.json ${KEYCLOAK_DIR}/data/import/realm.json

ENV KC_TRUSTSTORE_PATHS=${KEYCLOAK_DIR}/conf/truststores

RUN wget ${KEYCLOAK_DIST} -O /tmp/keycloak.tar.gz && \
    mkdir -p ${KEYCLOAK_DIR}/certs && mkdir -p /etc/ssl/certs/java/cacerts && \
    tar -xvzf /tmp/keycloak.tar.gz -C ${KEYCLOAK_DIR} --strip-components=1
 

RUN keytool -genkeypair -storepass ${KC_TRUSTSTORE_PASSWORD} -storetype PKCS12 -keyalg RSA -keysize 2048  -validity 365  -dname "CN=server" -alias  \
        server-cert -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore ${KEYCLOAK_DIR}/conf/server.keystore

RUN keytool -exportcert \
            -alias server-cert \
            -keystore ${KEYCLOAK_DIR}/conf/server.keystore \
            -storetype PKCS12 \
            -rfc \
            -file ${KEYCLOAK_DIR}/conf/truststores/server-truststore.pk12  \
            -storepass ${KC_TRUSTSTORE_PASSWORD}

RUN keytool -import -noprompt -storetype PKCS12 -alias public-cert -file ${KEYCLOAK_DIR}/conf/truststores/server-truststore.pk12 -keystore ${KEYCLOAK_DIR}/conf/server.keystore -storepass ${KC_TRUSTSTORE_PASSWORD} && \
    ln -sf ${KEYCLOAK_DIR}/conf/truststores/server-truststore.pk12 /etc/ssl/certs/java/cacerts/server-truststore.pk12

RUN ${KEYCLOAK_DIR}/bin/kc.sh build --db=${KC_DB} && \
    apk add --virtual --no-cache openssl bash unzip && \
    apk --no-cache del openssl curl wget git unzip --purge  && \  
    # mkdir -p ${KEYCLOAK_DIR}/themes/dev && unzip -q ${KEYCLOAK_DIR}/lib/lib/main/org.keycloak.keycloak-themes-${KEYCLOAK_VERSION}.jar -d ${KEYCLOAK_DIR}/themes/dev && \
    chmod +x /tmp/clean.sh && exec /tmp/clean.sh

## Production stage
FROM yidoughi/javapine-slim:${JAVA_VERSION}-${ALPINE_VERSION}

ARG WORKDIR_APP=opt
ENV WORKDIR_APP=${WORKDIR_APP}
ARG JAVA_VERSION=17

ARG KEYCLOAK_DIR
ENV KEYCLOAK_DIR=${KEYCLOAK_DIR}

ENV KEYCLOAK_ADMIN=${KEYCLOAK_ADMIN:-admin}
ENV KEYCLOAK_ADMIN_PASSWORD=${KEYCLOAK_ADMIN:-admin}

ENV KC_METRICS_ENABLED=${KC_METRICS_ENABLED:-true}

ENV KC_DIR=/opt/keycloak/export

ARG KC_HTTPS_PORT=8843
ENV KC_HTTPS_PORT=${KC_HTTPS_PORT}

ENV KC_HEALTH_ENABLED=${KC_HEALTH_ENABLED:-true}

ENV KC_DB_URL_DATABASE=${KC_DB_URL_DATABASE:-keycloak}
ENV KC_DB_USERNAME=${KC_DB_USERNAME:-postgres}
ENV KC_DB_PASSWORD=${KC_DB_PASSWORD:-P@ssword}

ENV KC_DB_URL_HOST=${KC_DB_URL_HOST:-postgrepine}
ENV KC_DB_URL_PORT=${KC_DB_URL_PORT:-5432}


ENV KC_PROXY_HEADERS=${KC_PROXY_HEADERS:-xforwarded}

ARG KC_TRUSTSTORE_PASSWORD=password
ENV KC_TRUSTSTORE_PASSWORD=${KC_TRUSTSTORE_PASSWORD}

ENV HOME=${KEYCLOAK_DIR}

ENV KC_REALM_NAME=${KC_REALM_NAME:-custom-realm}
ENV KC_TRUSTSTORE_PATHS=${KEYCLOAK_DIR}/conf/truststores

ENV PATH="$KEYCLOAK_DIR/bin:$PATH"


WORKDIR ${KEYCLOAK_DIR}

COPY --from=builder --chown=1001:1001 ${KEYCLOAK_DIR} ${KEYCLOAK_DIR}

RUN apk add --virtual --no-cache bash curl && rm -rf /var/cache/apk/* /tmp/* 

COPY --chown=1001:1001 --chmod=0755 start.sh ${KEYCLOAK_DIR}/bin/start.sh

EXPOSE ${KC_HTTPS_PORT}

USER 1001

CMD tail -f /dev/null

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 CMD curl -f https://localhost:$KC_HTTPS_PORT || exit 1
