# --- Base image ---
FROM python:3.11-slim

# --- Set working directory ---
WORKDIR /app

# --- Prevent Python from writing .pyc files & buffering output ---
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# --- Install system dependencies (optional but helpful) ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# --- Install Python dependencies ---
RUN pip install --no-cache-dir flask requests gunicorn

# --- Copy app code into container ---
COPY app.py .

# --- Expose port 8080 (for Fly.io) ---
EXPOSE 8080

# --- Run the Flask app via Gunicorn (production server) ---
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
