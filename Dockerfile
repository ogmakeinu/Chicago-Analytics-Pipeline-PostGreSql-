FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your code
COPY scripts/ ./scripts/

# Default command (can be overridden in docker-compose)
CMD ["python", "scripts/ingest_chicago.py"]