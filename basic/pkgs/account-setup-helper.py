#!/usr/bin/env python3
"""Root-privileged backend for the addaccount setup wizard.

Listens on a Unix socket restricted (via filesystem permissions) to the
account-setup group, and independently verifies over SO_PEERCRED that the
connecting process really is the addaccount user before doing anything --
two layers, not just the socket permission bit.
"""

import grp
import json
import os
import pwd
import re
import socket
import struct
import subprocess

SOCKET_PATH = "/run/account-setup-helper.sock"
SOCKET_GROUP = "account-setup"
ALLOWED_USERNAME = "addaccount"
USERNAME_RE = re.compile(r"^[a-z_][a-z0-9_-]{0,31}$")


def peer_uid(conn):
    creds = conn.getsockopt(socket.SOL_SOCKET, socket.SO_PEERCRED, struct.calcsize("3i"))
    _pid, uid, _gid = struct.unpack("3i", creds)
    return uid


def user_exists(username):
    try:
        pwd.getpwnam(username)
        return True
    except KeyError:
        return False


def create_user(username, password):
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
    subprocess.run(["chpasswd"], input=f"{username}:{password}\n", text=True, check=True)


def reply(conn, payload):
    conn.sendall(json.dumps(payload).encode("utf-8"))


def handle(conn):
    try:
        try:
            requester_uid = peer_uid(conn)
            requester = pwd.getpwuid(requester_uid).pw_name
        except (OSError, KeyError):
            requester = None

        if requester != ALLOWED_USERNAME:
            reply(conn, {"ok": False, "error": "not authorized"})
            return

        data = b""
        while not data.endswith(b"\n"):
            chunk = conn.recv(4096)
            if not chunk:
                break
            data += chunk

        try:
            req = json.loads(data.decode("utf-8"))
        except (json.JSONDecodeError, ValueError):
            reply(conn, {"ok": False, "error": "invalid request"})
            return

        username = str(req.get("username", ""))
        password = str(req.get("password", ""))

        if not USERNAME_RE.match(username) or username == ALLOWED_USERNAME:
            reply(conn, {"ok": False, "error": "invalid username"})
            return
        if len(password) < 8:
            reply(conn, {"ok": False, "error": "password too short"})
            return
        if user_exists(username):
            reply(conn, {"ok": False, "error": "user already exists"})
            return

        try:
            create_user(username, password)
        except subprocess.CalledProcessError:
            reply(conn, {"ok": False, "error": "account creation failed"})
            return

        reply(conn, {"ok": True})
    finally:
        conn.close()


def main():
    if os.path.exists(SOCKET_PATH):
        os.remove(SOCKET_PATH)

    srv = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    srv.bind(SOCKET_PATH)

    gid = grp.getgrnam(SOCKET_GROUP).gr_gid
    os.chown(SOCKET_PATH, 0, gid)
    os.chmod(SOCKET_PATH, 0o660)

    srv.listen(5)
    while True:
        conn, _ = srv.accept()
        handle(conn)


if __name__ == "__main__":
    main()
