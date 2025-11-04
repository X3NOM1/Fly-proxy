# Use official Alpine image
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache python3 py3-pip

# Set working directory
WORKDIR /app

# Create a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip and install Flask + Requests inside venv
RUN /opt/venv/bin/pip install --upgrade pip && /opt/venv/bin/pip install flask requests

# Copy all files
COPY . .

# Simple Python proxy app
RUN echo 'from flask import Flask, request, Response\nimport requests\napp = Flask(__name__)\n\n@app.route("/", defaults={"path": ""})\n@app.route("/<path:path>")\ndef proxy(path):\n    url = request.args.get("url")\n    if not url:\n        return "Usage: /?url=https://example.com", 400\n    try:\n        resp = requests.get(url, headers={k: v for (k, v) in request.headers if k.lower() != "host"})\n        return Response(resp.content, resp.status_code, resp.headers.items())\n    except Exception as e:\n        return f\"Error: {e}\", 500\n\nif __name__ == \"__main__\":\n    app.run(host=\"0.0.0.0\", port=8080)' > app.py

# Expose the port for Fly.io
EXPOSE 8080

# Command to run app using venv python
CMD ["/opt/venv/bin/python", "app.py"]
