# Use Python 3.9 slim image
FROM python:3.9-slim

# Install system dependencies for MySQL connector
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Expose the port
EXPOSE 8000

# Start the Flask app with gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
