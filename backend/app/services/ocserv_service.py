import json
import subprocess


class OcservService:

    PASSWD_FILE = "/etc/ocserv/ocpasswd"

    @classmethod
    def add_user(cls, username: str, password: str):

        cmd = [
            "ocpasswd",
            "-c",
            cls.PASSWD_FILE,
            username,
        ]

        p = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

        p.communicate(password + "\n" + password + "\n")

        if p.returncode != 0:
            raise Exception("Failed to create ocserv user")

    @classmethod
    def delete_user(cls, username: str):

        result = subprocess.run(
            [
                "ocpasswd",
                "-c",
                cls.PASSWD_FILE,
                "-d",
                username,
            ],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            raise Exception(result.stderr.strip())

    @classmethod
    def change_password(cls, username: str, password: str):

        cmd = [
            "ocpasswd",
            "-c",
            cls.PASSWD_FILE,
            username,
        ]

        p = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

        p.communicate(password + "\n" + password + "\n")

        if p.returncode != 0:
            raise Exception("Failed to change password")

    @classmethod
    def disconnect_user(cls, username: str):

        result = subprocess.run(
            [
                "occtl",
                "disconnect",
                "user",
                username,
            ],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            raise Exception(result.stderr.strip())

    @classmethod
    def online_users(cls):

        result = subprocess.run(
            [
                "occtl",
                "--json",
                "show",
                "users",
            ],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            return []

        try:
            return json.loads(result.stdout)
        except Exception:
            return []

    @classmethod
    def user_sessions(cls, username):

        users = cls.online_users()

        sessions = []

        for u in users:

            if u.get("Username") == username:
                sessions.append(u)

        return sessions

    @classmethod
    def disconnect_id(cls, session_id):

        result = subprocess.run(
            [
                "occtl",
                "disconnect",
                "id",
                str(session_id),
            ],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            raise Exception(result.stderr.strip())

    @classmethod
    def user_exists(cls):

        try:

            with open(cls.PASSWD_FILE) as f:

                for line in f:
                    if line.startswith(username + ":"):
                        return True

        except Exception:
            return False

        return False

    @classmethod
    def status(cls):

        result = subprocess.run(
            [
                "systemctl",
                "is-active",
                "ocserv",
            ],
            capture_output=True,
            text=True,
        )

        return result.stdout.strip() == "active"

    @classmethod
    def restart(cls):

        subprocess.run(
            [
                "systemctl",
                "restart",
                "ocserv",
            ]
        )
