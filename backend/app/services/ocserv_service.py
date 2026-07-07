import json
import subprocess
from typing import List, Dict


class OcservService:

    PASSWD_FILE = "/etc/ocserv/ocpasswd"

    # =====================================================
    # Users
    # =====================================================

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
            raise Exception("Failed to create user")

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
    def change_password(
        cls,
        username,
        password,
    ):

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

        p.communicate(
            password + "\n" + password + "\n"
        )

        if p.returncode != 0:
            raise Exception("Failed to change password")

    @classmethod
    def user_exists(cls, username):

        try:

            with open(cls.PASSWD_FILE) as f:

                for line in f:

                    if line.startswith(username + ":"):
                        return True

        except Exception:
            return False

        return False

    # =====================================================
    # Server
    # =====================================================

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

    @classmethod
    def reload(cls):

        subprocess.run(
            [
                "occtl",
                "reload",
            ]
        )

    # =====================================================
    # Online Users
    # =====================================================

    @classmethod
    def online_users(cls) -> List[Dict]:

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

            data = json.loads(result.stdout)

            if isinstance(data, list):
                return data

            return []

        except Exception:

            return []
