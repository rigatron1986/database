#!/bin/bash

# Set the timezone
export TZ=Asia/Kolkata

# Set PostgreSQL environment variables
export POSTGRES_USER=${POSTGRES_USER}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
export PGPASSWORD=${POSTGRES_PASSWORD}

# Set MySQL environment variables
export MYSQL_USER=${MYSQL_USER}
export MYSQL_PASSWORD=${MYSQL_PASSWORD}

# Get the IP address of the host system
SYSTEM_IP=$(getent hosts host.docker.internal | awk '{ print $1 }')

# Create backup directories if they do not exist
mkdir -p /backup/postgres
mkdir -p /backup/mariadb

# Ensure the script has execute permissions
chmod +x /cron/dump_db.sh

# Backup entire PostgreSQL database cluster
pg_dumpall -h ${SYSTEM_IP} -U ${POSTGRES_USER} > /backup/postgres/postgres_all_$(date +\%Y-\%m-\%d_\%Hh_\%Mm_\%Ss).sql
echo "$(date +\%Y-\%m-\%d_\%Hh_\%Mm_\%Ss) - PostgreSQL backup completed." >> /var/log/cron.log 2>&1

# Backup all MariaDB databases
mariadb-dump --all-databases -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} > /backup/mariadb/mariadb_all_$(date +\%Y-\%m-\%d_\%Hh_\%Mm_\%Ss).sql
echo "$(date +\%Y-\%m-\%d_\%Hh_\%Mm_\%Ss) - MariaDB backup completed." >> /var/log/cron.log 2>&1