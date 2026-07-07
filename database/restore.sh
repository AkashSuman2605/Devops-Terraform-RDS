#!/bin/bash

FILE=$1

if [ -z "$FILE" ]; then
    echo "Usage: ./restore.sh backup_file.sql"
    exit 1
fi

docker exec -i mysql-db \
mysql -uroot -proot123 hoteldb \
< "$FILE"

echo "Database restored successfully."
