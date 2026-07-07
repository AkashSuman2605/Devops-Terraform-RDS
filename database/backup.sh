#!/bin/bash

echo "Starting MySQL backup..."

docker exec hotel-mysql \
mysqldump -uadmin -pPassword@123 hoteldb > hoteldb_backup.sql

echo "Backup completed successfully."
