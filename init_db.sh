#!/bin/bash
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "DROP DATABASE IF EXISTS $DB_NAME;"
echo "Database '$DB_NAME' deleted successfully!"
