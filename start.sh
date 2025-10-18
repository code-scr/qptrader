#!/bin/bash
set -e

# Wait until RDS MySQL responds
until mysql -h "$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" &> /dev/null; do
    sleep 3
done

# Create tables if not exist
mysql -h "$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" <<-EOSQL
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS trades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user VARCHAR(50),
  Stock VARCHAR(50),
  quantity INT,
  AVG_price FLOAT,
  type VARCHAR(50),
  AVG_cost FLOAT,
  status VARCHAR(50)
);
EOSQL

# Start Flask app with Gunicorn
exec gunicorn app:app --bind 0.0.0.0:8000
