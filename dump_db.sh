#!/bin/bash

DATABASE="postgres_db"
USERNAME="backend"
BACKUP_DIR="/backups"

docker exec -t backend_postgres pg_dumpall -c -U $USERNAME > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

mv dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql backups/

docker exec -i backend_postgres /bin/bash -c "PGPASSWORD=password psql --username backend postgres_db" < backups/dump_13-07-2023_21_59_28.sql