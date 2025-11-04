# Use Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all files
COPY . .

# Expose port for Flask app
EXPOSE 8080

# Set environment variable
ENV PORT=8080
ENV PYTHONUNBUFFERED=1

# Run the Flask app
CMD ["python", "app.py"]
