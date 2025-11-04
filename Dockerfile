# Use official Alpine as base
FROM alpine:latest

# Install Python and pip
RUN apk add --no-cache python3 py3-pip

# Disable externally-managed environment restriction
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Upgrade pip and install dependencies safely
RUN pip install --upgrade pip && \
    pip install flask requests

# Set working directory
WORKDIR /app

# Copy all files to container
COPY . .

# (Optional) Create simple proxy app
RUN echo 'from flask import Flask, request, Response\nimport requests\napp = Flask(__name__)\n\n@app.route("/", defaults={"path": ""})\n@app.route("/<path:path>")\ndef proxy(path):\n    url = request.args.get("url")\n    if not url:\n        return "Usage: /?url=https://example.com", 400\n    try:\n        resp = requests.get(url, headers={k: v for (k, v) in request.headers if k.lower() != "host"})\n        return Response(resp.content, resp.status_code, resp.headers.items())\n    except Exception as e:\n        return f\"Error: {e}\", 500\n\nif __name__ == \"__main__\":\n    app.run(host=\"0.0.0.0\", port=8080)' > app.py

# Expose port
EXPOSE 8080

# Run app
CMD ["python3", "app.py"]
