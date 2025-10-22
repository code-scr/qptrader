#!/bin/bash
set -euo pipefail

# Create database
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

# Create users table
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);"

# Create trades table
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "
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
);"

# Drop trigger
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "DROP TRIGGER IF EXISTS trades_before_insert;"

# Create trigger (single-line, avoids BEGIN...END)
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "
CREATE TRIGGER trades_before_insert
BEFORE INSERT ON trades
FOR EACH ROW
SET NEW.created_at = CONVERT_TZ(NOW(), '+00:00', '+05:30');"
