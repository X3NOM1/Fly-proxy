from flask import Flask, request, Response
import requests

app = Flask(__name__)

@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def proxy(path):
    url = request.args.get("url")
    if not url:
        return "Please provide ?url=", 400
    resp = requests.get(url)
    excluded_headers = ["content-encoding", "content-length", "transfer-encoding", "connection"]
    headers = [(name, value) for (name, value) in resp.raw.headers.items() if name.lower() not in excluded_headers]
    response = Response(resp.content, resp.status_code, headers)
    return response

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
