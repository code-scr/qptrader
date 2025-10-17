#!/bin/bash

# Start MySQL in background
mysqld_safe &

# Wait for MySQL to start
sleep 5

# Create database and user if not exists
mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS qptrader_db;
CREATE USER IF NOT EXISTS 'qptrader_user'@'localhost' IDENTIFIED BY 'qptrader_password';
GRANT ALL PRIVILEGES ON qptrader_db.* TO 'qptrader_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Start Flask app
gunicorn app:app --bind 0.0.0.0:8000
