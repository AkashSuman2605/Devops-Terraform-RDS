#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p backups

docker exec hotel-mysql \
mysqldump -uroot -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} \
> backups/backup_$TIMESTAMP.sql

echo "Backup created successfully."
