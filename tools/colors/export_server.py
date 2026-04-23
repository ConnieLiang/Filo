#!/usr/bin/env python3

import json
import subprocess
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path


ROOT = Path(__file__).resolve().parent
EXPORT_DIR = ROOT / "exports"
HOST = "127.0.0.1"
PORT = 4174


class Handler(BaseHTTPRequestHandler):
    def _send(self, status, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self):
        self._send(200, {"ok": True})

    def do_POST(self):
        if self.path == "/save-json":
            try:
                length = int(self.headers.get("Content-Length", "0"))
                raw = self.rfile.read(length)
                data = json.loads(raw.decode("utf-8"))
                filename = Path(data["filename"]).name
                payload = data["payload"]

                EXPORT_DIR.mkdir(parents=True, exist_ok=True)
                target = EXPORT_DIR / filename
                target.write_text(json.dumps(payload, indent=2), encoding="utf-8")

                size = target.stat().st_size
                self._send(
                    200,
                    {
                        "ok": True,
                        "path": str(target),
                        "size": size,
                    },
                )
            except Exception as error:
                self._send(500, {"ok": False, "error": str(error)})
            return

        if self.path == "/open-exports":
            try:
                EXPORT_DIR.mkdir(parents=True, exist_ok=True)
                subprocess.run(["open", str(EXPORT_DIR)], check=True)
                self._send(200, {"ok": True, "path": str(EXPORT_DIR)})
            except Exception as error:
                self._send(500, {"ok": False, "error": str(error)})
            return

        self._send(404, {"ok": False, "error": "Not found"})


if __name__ == "__main__":
    server = HTTPServer((HOST, PORT), Handler)
    print(f"Filo Colors export server listening on http://{HOST}:{PORT}")
    server.serve_forever()
