# ========== 1️⃣ Base Image ==========
# Use lightweight Python base image for small deploy size
FROM python:3.10-slim

# ========== 2️⃣ Working Directory ==========
WORKDIR /usr/src/app

# ========== 3️⃣ Copy Files ==========
# Copy everything from your project folder into container
COPY . .

# ========== 4️⃣ Install Dependencies ==========
# Install Flask, Requests, and Gunicorn for production server
RUN pip install --no-cache-dir flask requests gunicorn

# ========== 5️⃣ Expose Port ==========
# Fly.io uses port 8080 by default
EXPOSE 8080

# ========== 6️⃣ Run App in Production ==========
# Run with Gunicorn (faster, multi-worker Flask server)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
