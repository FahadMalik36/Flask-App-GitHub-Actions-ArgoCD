# Stage 1: Build environment
FROM python:3.14.0a3-alpine3.21 as builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache build-base linux-headers

# Create and activate virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime environment
FROM python:3.14.0a3-alpine3.21

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Set environment variables
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Copy application code
COPY . .

# Application port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]