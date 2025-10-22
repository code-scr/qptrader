#!/bin/bash

echo "Initializing database and tables..."

mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" <<EOF
-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS $DB_NAME;

-- Switch to the database
USE $DB_NAME;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create trades table
CREATE TABLE IF NOT EXISTS trades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user VARCHAR(50) NOT NULL,
  Stock VARCHAR(50),
  quantity INT,
  AVG_price DECIMAL(10,2),
  type VARCHAR(10),
  AVG_cost DECIMAL(10,2),
  status VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

echo "Database '$DB_NAME' and tables initialized successfully!"
