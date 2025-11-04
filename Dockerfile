# Simple Fly.io Proxy Server
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache python3 py3-pip

# Fix PEP 668 restriction and install Flask + Requests
RUN pip install --break-system-packages flask requests

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Create a basic Flask proxy app
RUN echo 'from flask import Flask, request, Response\nimport requests\n\napp = Flask(__name__)\n\n@app.route("/", defaults={"path": ""})\n@app.route("/<path:path>")\ndef proxy(path):\n    url = request.args.get("url")\n    if not url:\n        return "Usage: /?url=https://example.com", 400\n    try:\n        resp = requests.get(url, headers={key: value for (key, value) in request.headers if key != "Host"})\n        return Response(resp.content, resp.status_code, resp.headers.items())\n    except Exception as e:\n        return f"Error: {str(e)}", 500\n\nif __name__ == "__main__":\n    app.run(host="0.0.0.0", port=8080)' > app.py

# Expose the port for Fly.io
EXPOSE 8080

# Start the proxy server
CMD ["python3", "app.py"]
