#!/usr/bin/env python3
"""Runs as the whole 'account-setup' session for the addaccount user.

Walks through creating a real account via zenity dialogs, then exits --
which ends the session and returns to the LightDM greeter.
"""

import json
import re
import socket
import subprocess

SOCKET_PATH = "/run/account-setup-helper.sock"
USERNAME_RE = re.compile(r"^[a-z_][a-z0-9_-]{0,31}$")


def zenity(*args):
    return subprocess.run(["zenity", *args], capture_output=True, text=True)


def ask_username():
    r = zenity("--entry", "--title=Create your account", "--text=Choose a username:")
    return r.stdout.strip() if r.returncode == 0 else None


def ask_password():
    r = zenity(
        "--forms",
        "--title=Create your account",
        "--text=Choose a password:",
        "--add-password=Password",
        "--add-password=Confirm password",
    )
    if r.returncode != 0:
        return None
    parts = r.stdout.rstrip("\n").split("|")
    if len(parts) != 2:
        return None
    return parts[0], parts[1]


def create_account(username, password):
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.connect(SOCKET_PATH)
        s.sendall(json.dumps({"username": username, "password": password}).encode() + b"\n")
        data = b""
        while True:
            chunk = s.recv(4096)
            if not chunk:
                break
            data += chunk
    return json.loads(data.decode())


def main():
    while True:
        username = ask_username()
        if not username:
            return
        if not USERNAME_RE.match(username):
            zenity("--error", "--text=Usernames must be lowercase, and start with a letter or underscore.")
            continue

        creds = ask_password()
        if not creds:
            return
        password, confirm = creds
        if len(password) < 8:
            zenity("--error", "--text=Password must be at least 8 characters.")
            continue
        if password != confirm:
            zenity("--error", "--text=Passwords did not match.")
            continue

        try:
            result = create_account(username, password)
        except OSError:
            zenity("--error", "--text=Could not reach the account-setup helper service.")
            return

        if result.get("ok"):
            zenity(
                "--info",
                "--text=Account '%s' created. You'll be signed out now -- log in as %s with your new password."
                % (username, username),
            )
            return
        else:
            zenity("--error", "--text=Could not create account: %s" % result.get("error", "unknown error"))
            continue


if __name__ == "__main__":
    main()
