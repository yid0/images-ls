#!/bin/sh

set -e 

# Fonction pour initialiser la base de données PostgreSQL
initialize_db() {
  if [ -z "$(ls -A $PGDATA)" ]; then
    echo "Initializing new database..."
    initdb -D $PGDATA
  else
    echo "Database already exists, skipping initdb..."
  fi
  pg_ctl -D "$PGDATA" -o "-c listen_addresses='*'" -w start
}

# Fonction pour créer ou mettre à jour un utilisateur PostgreSQL
create_or_update_user() {
  local user=$1
  local password=$2
  psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
      DO
      \$\$
      BEGIN
          IF NOT EXISTS (
              SELECT FROM pg_catalog.pg_roles WHERE rolname = '${user}'
          ) THEN
              CREATE USER ${user} WITH PASSWORD '${password}';
          ELSE
              ALTER USER ${user} WITH PASSWORD '${password}';
          END IF;
      END
      \$\$;
EOSQL
}

# Fonction pour créer une base de données si elle n'existe pas
create_database_if_not_exists() {
  local db=$1
  local user=$2
  DB_EXISTS=$(psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${db}'")
  if [ -z "$DB_EXISTS" ]; then
    echo "Creating database ${db}..."
    psql -v ON_ERROR_STOP=1 --username "postgres" --command "CREATE DATABASE ${db} OWNER ${user};"
  else
    echo "Database ${db} already exists, skipping creation..."
  fi
}

# Fonction pour configurer les privilèges sur la base de données
grant_privileges() {
  local db=$1
  local user=$2
  psql --username "postgres" --command "GRANT ALL PRIVILEGES ON DATABASE ${db} TO ${user}; \
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ${user};"
}

# Fonction pour configurer PostgreSQL pour écouter sur toutes les interfaces
configure_postgresql() {
  sed -i "s/^#*listen_addresses\s*=\s*'.*'/listen_addresses = '0.0.0.0'/" /var/lib/postgresql/data/postgresql.conf
  echo "host    all             all             0.0.0.0/0          md5" >> /var/lib/postgresql/data/pg_hba.conf
}

# Initialisation de PostgreSQL
initialize_db

# Configuration du superutilisateur 'postgres'
psql -v ON_ERROR_STOP=1 --username "postgres" --command "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"

# Exemple de configuration pour plusieurs applications
# Pour chaque application, on peut appeler les fonctions avec des paramètres spécifiques
for app in "APP1" "APP2"; do
  APP_USER_VAR=$app"_USER"
  APP_PASSWORD_VAR=$app"_PASSWORD"
  APP_DB_VAR=$app"_DB"


  # Extraction des variables spécifiques à chaque application
  APP_USER=${!APP_USER_VAR}
  APP_PASSWORD=${!APP_PASSWORD_VAR}
  APP_DB=${!APP_DB_VAR}

  # Création/mise à jour de l'utilisateur et de la base de données
  create_or_update_user $APP_USER $APP_PASSWORD
  create_database_if_not_exists $APP_DB $APP_USER
  grant_privileges $APP_DB $APP_USER
done

# Configuration des fichiers PostgreSQL
configure_postgresql

# Redémarrage du serveur PostgreSQL
pg_ctl -D "$PGDATA" -m fast stop && exec pg_ctl -D $PGDATA start -l $PGLOG/app.log -o "-c config_file=$PGDATA/postgresql.conf"