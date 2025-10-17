#!/bin/bash

# Start MySQL
echo "Starting MySQL..."
service mysql start

# Wait for MySQL to be ready
echo "Waiting for MySQL..."
while ! mysqladmin ping --silent; do
    sleep 2
done

echo "MySQL is up!"

# Start Flask
echo "Starting Flask app..."
gunicorn app:app --bind 0.0.0.0:8000
