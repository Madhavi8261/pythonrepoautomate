from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib.parse

# Dummy user database
USERS = {
    "admin": "1234",
    "user": "password"
}

class SimpleLoginServer(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            with open("login.html", "rb") as f:
                self.wfile.write(f.read())
        elif self.path.startswith("/dashboard"):
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(b"<h1>Welcome to Dashboard </h1>")
            self.wfile.write(b"<p><a href='/'>Logout</a></p>")
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"404 Not Found")

    def do_POST(self):
        if self.path == "/login":
            content_length = int(self.headers["Content-Length"])
            body = self.rfile.read(content_length).decode("utf-8")
            data = urllib.parse.parse_qs(body)

            username = data.get("username", [""])[0]
            password = data.get("password", [""])[0]

            if username in USERS and USERS[username] == password:
                self.send_response(302)
                self.send_header("Location", "/dashboard")
                self.end_headers()
            else:
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(b"<h2>Invalid username or password!</h2>")
                self.wfile.write(b"<a href='/'>Go back</a>")

# Run server
if __name__ == "__main__":
    server = HTTPServer(("localhost", 8000), SimpleLoginServer)
    print("Server running at http://localhost:8000")
    server.serve_forever()
