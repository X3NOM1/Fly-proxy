# Use lightweight Python base image
FROM python:3.11-slim

# Install dependencies
RUN pip install flask requests gunicorn

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Expose Fly.io port
EXPOSE 8080

# Run Flask app with gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
