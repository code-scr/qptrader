# Base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .



# Expose port
EXPOSE 8000

# Run Flask app via Gunicorn directly
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000", "--workers", "1"]
