from flask import Flask, request, redirect, render_template_string
import requests

app = Flask(__name__)

HTML_PAGE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fly Proxy</title>
    <style>
        body { font-family: Arial; text-align: center; padding-top: 100px; background: #fafafa; }
        input[type=text] { width: 300px; padding: 10px; font-size: 16px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; background: #5a4afc; color: white; border: none; border-radius: 6px; }
        button:hover { background: #4838d1; }
    </style>
</head>
<body>
    <h2>🌐 Fly Proxy</h2>
    <form action="/go" method="get">
        <input type="text" name="url" placeholder="Enter URL (e.g. https://google.com)" required>
        <button type="submit">Go</button>
    </form>
</body>
</html>
"""

@app.route("/")
def home():
    return render_template_string(HTML_PAGE)

@app.route("/go")
def go():
    target_url = request.args.get("url")
    if not target_url.startswith("http"):
        target_url = "http://" + target_url
    return redirect(f"/proxy?url={target_url}")

@app.route("/proxy")
def proxy():
    url = request.args.get("url")
    try:
        response = requests.get(url, timeout=5)
        return response.text
    except Exception as e:
        return f"<h3>Error accessing {url}</h3><p>{e}</p>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
