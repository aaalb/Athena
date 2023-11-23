#!/bin/bash

# Assicurati che le variabili d'ambiente siano impostate correttamente
if [[ -z "$DB_USERNAME" || -z "$DB_PASSWORD" ]]; then
  echo "Errore: Le variabili d'ambiente DB_USERNAME e/o DB_PASSWORD non sono impostate."
  exit 1
fi

DB_NAME="postgres_db"

docker cp backups/$1 backend_postgres:/tmp
# Esegui il backup del database PostgreSQL utilizzando le variabili d'ambiente
docker exec -t backend_postgres pg_restore -c -U backend -d postgres_db -v tmp/$1

if [ $? -eq 0 ]; then
  echo "Restore del database $DB_NAME completato con successo."
else
  echo "Si è verificato un errore durante il restore del database $DB_NAME."
fi