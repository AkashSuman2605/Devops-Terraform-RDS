#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p backups

docker exec hotel-mysql \
mysqldump -uroot -proot123 hoteldb \
> backups/backup_$TIMESTAMP.sql

echo "Backup created successfully."
