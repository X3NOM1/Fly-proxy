# Use lightweight Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements if exists
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the application code
COPY . .

# Expose the port that Fly.io expects
EXPOSE 8080

# Set environment variables for Flask
ENV PORT=8080
ENV PYTHONUNBUFFERED=1

# Run the app
CMD ["python", "app.py"]
