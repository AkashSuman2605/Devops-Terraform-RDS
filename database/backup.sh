#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p backups

docker exec mysql-db \
mysqldump -uroot -proot123 hoteldb \
> backups/backup_$TIMESTAMP.sql

echo "Backup created successfully."
