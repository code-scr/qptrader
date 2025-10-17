#!/bin/bash
set -e

echo "Initializing MySQL..."

# Initialize database if first run
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First time setup: initializing MySQL database..."
    mysqld --initialize-insecure --user=mysql
fi

# Start MySQL in the background
echo "Starting MySQL..."
mysqld_safe --skip-networking=0 &

# Wait until MySQL is ready
echo "Waiting for MySQL to be ready..."
until mysqladmin ping --silent; do
    sleep 2
done

echo "MySQL is ready!"

# Optional: create default user/db if needed
# mysql -uroot -e "CREATE DATABASE IF NOT EXISTS mydb;"
# mysql -uroot -e "CREATE USER IF NOT EXISTS 'appuser'@'localhost' IDENTIFIED BY 'password';"
# mysql -uroot -e "GRANT ALL PRIVILEGES ON mydb.* TO 'appuser'@'localhost'; FLUSH PRIVILEGES;"

# Start Flask app using Gunicorn
echo "Starting Flask app..."
exec gunicorn app:app --bind 0.0.0.0:8000
