#!/bin/bash
set -e

echo "Starting MySQL..."

# Initialize database if first run
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MySQL database..."
    mysqld --initialize-insecure --user=mysql
fi

# Start MySQL in background
mysqld_safe &

# Wait for MySQL to be ready
echo "Waiting for MySQL to start..."
until mysqladmin ping --silent; do
    sleep 2
done

echo "MySQL is ready!"

# Create database and user if not exists
mysql -uroot <<-EOSQL
CREATE DATABASE IF NOT EXISTS qptrader_db;
CREATE USER IF NOT EXISTS 'qptrader_user'@'localhost' IDENTIFIED BY 'qptrader_password';
GRANT ALL PRIVILEGES ON qptrader_db.* TO 'qptrader_user'@'localhost';
FLUSH PRIVILEGES;
EOSQL

# Create tables if not exist
mysql -uqptrader_user -pqptrader_password qptrader_db <<-EOSQL
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS trades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(100),
    Stock VARCHAR(100),
    quantity INT,
    AVG_price FLOAT,
    type VARCHAR(20),
    AVG_cost FLOAT,
    status VARCHAR(50)
);
EOSQL

echo "Database setup complete!"

# Start Flask app
echo "Starting Flask app on port 8000..."
exec gunicorn app:app --bind 0.0.0.0:8000
