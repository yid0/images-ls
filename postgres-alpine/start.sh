#!/bin/sh

set -e 


if [ -z "$(ls -A $PGDATA)" ]; then
  echo "Initializing new database..."
  initdb -D $PGDATA
  echo "Creates certs and configure SSL ..."
  ssl.sh
else
  echo "Database already exists, skipping initdb..."
fi

if [ "$POSTGRES_ENV" = "dev" ]; then

  sed -i "s/^#*listen_addresses\s*=\s*'.*'/listen_addresses = '0.0.0.0'/" $PGDATA/postgresql.conf && \
  echo "host    all             all             0.0.0.0/0          md5" >> $PGDATA/pg_hba.conf

fi;

sed -i "s|^#logging_collector = off|logging_collector = on|" $PGDATA/postgresql.conf
sed -i "s|^#log_directory =.*|log_directory = '/var/lib/postgresql/logs'|" $PGDATA/postgresql.conf
sed -i "s|^#log_filename =.*|log_filename = 'app.log'|" $PGDATA/postgresql.conf
sed -i "s|^#log_min_duration_statement =.*|log_min_duration_statement = 1000 |" $PGDATA/postgresql.conf

pg_ctl -D "$PGDATA" -o "-c listen_addresses='*'" -w start
psql -v ON_ERROR_STOP=1 --username "postgres" --command "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"

echo "**************** Restart postgressql ************** "

echo "Stoping postgressql ... "
pg_ctl reload
pg_ctl -D "$PGDATA" -m fast stop

echo "Starting postgressql ... "
exec pg_ctl -D $PGDATA start -l $PGLOG/app.log -o "-c config_file=$PGDATA/postgresql.conf"