FROM python:3.9

# Install dependencies
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application code
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy start script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose port for Flask
EXPOSE 8000

# Health check (checks Flask app)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8000/ || exit 1

# Start Flask app
CMD ["/app/start.sh"]
