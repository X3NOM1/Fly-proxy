# Simple Fly.io Proxy Server
FROM alpine:latest

# Install Python and required tools
RUN apk add --no-cache python3 py3-pip

# Create working directory
WORKDIR /app

# Copy all files
COPY . .

# Create a virtual environment for Python
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install required Python packages inside the venv
RUN pip install --no-cache-dir flask requests

# Create proxy app
RUN echo 'from flask import Flask, request, Response\nimport requests\napp = Flask(__name__)\n@app.route("/", defaults={"path": ""})\n@app.route("/<path:path>")\ndef proxy(path):\n    url = request.args.get("url")\n    if not url: return "Please provide ?url=", 400\n    resp = requests.get(url)\n    return Response(resp.content, resp.status_code, resp.headers.items())\n\nif __name__ == "__main__":\n    app.run(host="0.0.0.0", port=8080)' > app.py

# Expose port for Fly.io
EXPOSE 8080

# Run the Flask app
CMD ["python3", "app.py"]
