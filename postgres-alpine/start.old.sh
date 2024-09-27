#!/bin/sh

set -e 

if [ -z "$(ls -A $PGDATA)" ]; then
  echo "Initializing new database..."
  initdb -D $PGDATA 
else
  echo "Database already exists, skipping initdb..."
fi

# pg_ctl -D "$PGDATA" -o "-c listen_addresses='*'" -w start
pg_ctl -D "$PGDATA" -o "-c listen_addresses='*'" -w start

psql -v ON_ERROR_STOP=1 --username "postgres" --command "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"
psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
    DO
    \$\$
    BEGIN
        IF NOT EXISTS (
            SELECT FROM pg_catalog.pg_roles WHERE rolname = '${APP_USER}'
        ) THEN
            CREATE USER ${APP_USER} WITH PASSWORD '${APP_PASSWORD}';
        ELSE
            ALTER USER ${APP_USER} WITH PASSWORD '${APP_PASSWORD}';
        END IF;
    END
    \$\$;
EOSQL
DB_EXISTS=$(psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${APP_DB}'")
echo "DB $DB_EXISTS"
if [ -z "$DB_EXISTS" ]; then
  echo "Creating database ${APP_DB}..."
  psql -v ON_ERROR_STOP=1 --username "postgres" --command "CREATE DATABASE ${APP_DB} OWNER ${APP_USER};"
else
  echo "Database ${APP_DB} already exists, skipping creation..."
fi

psql --username "postgres" --command "GRANT ALL PRIVILEGES ON DATABASE ${APP_DB} TO ${APP_USER}; \
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ${APP_USER};"


sed -i "s/^#*listen_addresses\s*=\s*'.*'/listen_addresses = '0.0.0.0'/" /var/lib/postgresql/data/postgresql.conf && \
echo "host    all             all             0.0.0.0/0          md5" >> /var/lib/postgresql/data/pg_hba.conf

pg_ctl -D "$PGDATA" -m fast stop && exec pg_ctl -D $PGDATA start -l $PGLOG/app.log -o "-c config_file=$PGDATA/postgresql.conf"