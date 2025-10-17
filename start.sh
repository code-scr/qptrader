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

echo "Database setup complete!"

# Create necessary tables automatically
mysql -uqptrader_user -pqptrader_password -h127.0.0.1 qptrader_db <<-EOSQL
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS trades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    stock_symbol VARCHAR(10),
    quantity INT,
    price DECIMAL(10,2),
    trade_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
EOSQL

echo "Tables setup complete!"

# Start Flask app
echo "Starting Flask app on port 8000..."
exec gunicorn app:app --bind 0.0.0.0:8000
