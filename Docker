# Simple Fly.io Proxy Server
FROM alpine:latest
RUN apk add --no-cache python3 py3-pip
RUN pip install flask requests

WORKDIR /app
COPY . .

# Basic proxy script
RUN echo 'from flask import Flask, request, Response\nimport requests\napp = Flask(__name__)\n@app.route("/", defaults={"path": ""})\n@app.route("/<path:path>")\ndef proxy(path):\n    url = request.args.get("url")\n    if not url: return "Please provide ?url=", 400\n    resp = requests.get(url)\n    return Response(resp.content, resp.status_code, resp.headers.items())\n\nif __name__ == "__main__":\n    app.run(host="0.0.0.0", port=8080)' > app.py

CMD ["python3", "app.py"]
