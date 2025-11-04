# ✅ Fixed Dockerfile for Fly.io Proxy Server
FROM alpine:latest

# Install Python3 and pip
RUN apk add --no-cache python3 py3-pip

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Install Flask and Requests safely
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"
RUN pip install --no-cache-dir flask requests

# Create simple proxy app
RUN echo 'from flask import Flask, request, Response\nimport requests\napp = Flask(__name__)\n@app.route("/", defaults={"path": ""})\n@app.route("/<path:path>")\ndef proxy(path):\n    url = request.args.get("url")\n    if not url: return "Please provide ?url=", 400\n    resp = requests.get(url)\n    return Response(resp.content, resp.status_code, resp.headers.items())\n\nif __name__ == "__main__":\n    app.run(host="0.0.0.0", port=8080)' > app.py

# Run the app
CMD ["python3", "app.py"]
