#!/bin/bash
set -euo pipefail

echo "Initializing database and tables"

# Single connection for all SQL
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" <<SQL
-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

-- Only create users table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Only create trades table if it doesn't exist
CREATE TABLE IF NOT EXISTS trades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(50) NOT NULL,
    Stock VARCHAR(50),
    quantity INT,
    AVG_price DECIMAL(10,2),
    type VARCHAR(10),
    AVG_cost DECIMAL(10,2),
    status VARCHAR(20),
    created_at DATETIME
);


SQL

echo "Database '$DB_NAME' and tables initialized successfully in IST!"
