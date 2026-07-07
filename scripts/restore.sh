#!/bin/bash

FILE=$1

if [ -z "$FILE" ]; then
    echo "Usage: ./restore.sh backup_file.sql"
    exit 1
fi

docker exec -i hotel-mysql \
mysql -uroot -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} \
< "$FILE"

echo "Database restored successfully."
