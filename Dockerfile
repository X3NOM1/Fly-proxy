# Simple Fly.io Proxy Server
FROM alpine:latest

# Install Python and pip
RUN apk add --no-cache python3 py3-pip

# Create working directory
WORKDIR /app

# Set up a virtual environment to avoid PEP 668 issue
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Flask and Requests in the virtual environment
RUN pip install flask requests

# Copy the app source
COPY . .

# Create a simple proxy script
RUN echo 'from flask import Flask, request, Response\nimport requests\n\napp = Flask(__name__)\n\n@app.route("/", defaults={"path": ""})\n@app.route("/<path:path>")\ndef proxy(path):\n    url = request.args.get("url")\n    if not url:\n        return "Usage: /?url=https://example.com", 400\n    try:\n        resp = requests.get(url, headers={k: v for (k, v) in request.headers if k.lower() != "host"})\n        return Response(resp.content, resp.status_code, resp.headers.items())\n    except Exception as e:\n        return f"Error: {e}", 500\n\nif __name__ == "__main__":\n    app.run(host="0.0.0.0", port=8080)' > app.py

# Expose Flask port
EXPOSE 8080

# Run the app
CMD ["python3", "app.py"]
