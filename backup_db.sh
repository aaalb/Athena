#!/bin/bash

# Assicurati che le variabili d'ambiente siano impostate correttamente
if [[ -z "$DB_USERNAME" || -z "$DB_PASSWORD" ]]; then
  echo "Errore: Le variabili d'ambiente DB_USERNAME e/o DB_PASSWORD non sono impostate."
  exit 1
fi

DB_NAME="postgres_db"
BACKUP_DIR="backups"
DATE=$(date +"%Y_%m_%d")
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.tar"

# Esegui il backup del database PostgreSQL utilizzando le variabili d'ambiente
docker exec -t backend_postgres pg_dump -U $DB_USERNAME -F t $DB_NAME -C > $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Backup del database $DB_NAME completato con successo. Il file si trova in: $BACKUP_FILE"
else
  echo "Si è verificato un errore durante il backup del database $DB_NAME."
fi