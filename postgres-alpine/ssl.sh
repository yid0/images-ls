#!/bin/sh

set -e

if [ ! -f "$PGDATA/server.crt" ] || [ ! -f "$PGDATA/server.key" ]; then
    echo "Generating SSL certificates..."
    openssl req -new -x509 -days 365 -nodes -text -out $PGDATA/server.crt -keyout $PGDATA/server.key -subj "/CN=localhost"
    chmod 600 $PGDATA/server.key
    chown 1001:1001 $PGDATA/server.crt $PGDATA/server.key
fi

sed -i "s/^#ssl =.*/ssl = 'on'/" $PGDATA/postgresql.conf && \
sed -i "s|^#ssl_cert_file =.*|ssl_cert_file = '$PGDATA/server.crt'|" $PGDATA/postgresql.conf && \
sed -i "s|^#ssl_key_file =.*|ssl_key_file = '$PGDATA/server.key'|" $PGDATA/postgresql.conf
