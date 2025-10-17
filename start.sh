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

# Create database and user if not exists
echo "Setting up database and user..."
mysql -uroot <<-EOSQL
CREATE DATABASE IF NOT EXISTS qptrader_db;
CREATE USER IF NOT EXISTS 'qptrader_user'@'localhost' IDENTIFIED BY 'qptrader_password';
GRANT ALL PRIVILEGES ON qptrader_db.* TO 'qptrader_user'@'localhost';
FLUSH PRIVILEGES;
EOSQL

echo "Database and user setup complete!"

# Start Flask app using Gunicorn
echo "Starting Flask app..."
exec gunicorn app:app --bind 0.0.0.0:8000
