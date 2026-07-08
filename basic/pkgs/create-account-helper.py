#!/usr/bin/env python3
"""EXPERIMENTAL / UNVERIFIED.

Minimal localhost-only HTTP service that lets the create-account greeter
theme (script.js) create real Unix accounts via useradd/chpasswd, since the
greeter's own JS bridge runs unprivileged and has no concept of account
creation.

Security note: this listens on 127.0.0.1 for as long as the service runs
(see basic/user-create-helper.nix for how it's scoped to display-manager's
lifetime), which is not the same as "only while the greeter is shown before
anyone logs in" -- lightdm keeps running while other sessions are active
too. Any local process can reach this endpoint while it's up. Treat that as
an accepted trust boundary (equivalent to physical/local access), not as
something this script tries to fully close.
"""

import json
import pwd
import re
import subprocess
from http.server import BaseHTTPRequestHandler, HTTPServer

HOST = "127.0.0.1"
PORT = 7891

USERNAME_RE = re.compile(r"^[a-z_][a-z0-9_-]{0,31}$")


def user_exists(username: str) -> bool:
    try:
        pwd.getpwnam(username)
        return True
    except KeyError:
        return False


def create_user(username: str, password: str) -> None:
    subprocess.run(
        [
            "useradd",
            "--create-home",
            "--shell", "/run/current-system/sw/bin/bash",
            "--groups", "networkmanager,audio,video,input",
            username,
        ],
        check=True,
    )
    subprocess.run(
        ["chpasswd"],
        input=f"{username}:{password}\n",
        text=True,
        check=True,
    )


class Handler(BaseHTTPRequestHandler):
    def _json(self, status, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        if self.path != "/create-user":
            self._json(404, {"ok": False, "error": "not found"})
            return

        length = int(self.headers.get("Content-Length", 0))
        try:
            data = json.loads(self.rfile.read(length) or b"{}")
            username = str(data.get("username", ""))
            password = str(data.get("password", ""))
        except (json.JSONDecodeError, ValueError):
            self._json(400, {"ok": False, "error": "invalid request"})
            return

        if not USERNAME_RE.match(username):
            self._json(400, {"ok": False, "error": "invalid username"})
            return
        if len(password) < 8:
            self._json(400, {"ok": False, "error": "password too short"})
            return
        if user_exists(username):
            self._json(409, {"ok": False, "error": "user already exists"})
            return

        try:
            create_user(username, password)
        except subprocess.CalledProcessError:
            self._json(500, {"ok": False, "error": "account creation failed"})
            return

        self._json(200, {"ok": True})

    def log_message(self, format, *args):
        pass


if __name__ == "__main__":
    HTTPServer((HOST, PORT), Handler).serve_forever()
