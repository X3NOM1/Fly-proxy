# Lightweight Python base image (no Alpine pip issue)
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN pip install --no-cache-dir flask requests gunicorn

# Create simple proxy app
RUN echo 'from flask import Flask, request, Response\nimport requests\napp = Flask(__name__)\n@app.route("/", defaults={"path": ""})\n@app.route("/<path:path>")\ndef proxy(path):\n    url = request.args.get("url")\n    if not url: return "Please provide ?url=", 400\n    resp = requests.get(url)\n    return Response(resp.content, resp.status_code, resp.headers.items())\n\nif __name__ == "__main__":\n    app.run(host="0.0.0.0", port=8080)' > app.py

# Expose port for Fly.io
EXPOSE 8080

# Use gunicorn (production safe)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
