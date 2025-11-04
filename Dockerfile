# ✅ Use Python base image instead of Node
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements file if exists
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt || true

# Copy the rest of the app
COPY . .

# Expose the app port
EXPOSE 8080

# Environment variables
ENV PORT=8080
ENV PYTHONUNBUFFERED=1

# Start the Flask app
CMD ["python", "app.py"]
