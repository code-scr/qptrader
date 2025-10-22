#!/bin/bash
set -e

echo "Initializing database and tables..."

mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" <<EOF || { echo "❌ Database initialization failed!"; exit 1; }

CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS trades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user VARCHAR(50) NOT NULL,
  Stock VARCHAR(50),
  quantity INT,
  AVG_price DECIMAL(10,2),
  type VARCHAR(10),
  AVG_cost DECIMAL(10,2),
  status VARCHAR(20),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trades_before_insert;

CREATE TRIGGER trades_before_insert
BEFORE INSERT ON trades
FOR EACH ROW
BEGIN
    SET NEW.created_at = CONVERT_TZ(NOW(), '+00:00', '+05:30');
END;

EOF

mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "SHOW TABLES;"

echo "✅ Database '$DB_NAME' and tables initialized successfully!"
