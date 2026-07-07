#!/bin/bash

echo "Starting MySQL restore..."

docker exec -i hotel-mysql \
mysql -uadmin -pPassword@123 hoteldb < hoteldb_backup.sql

echo "Database restored successfully."
