import json
import subprocess
from typing import Dict, List


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
    def user_exists(cls, username: str):

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

            if isinstance(data, dict):

                if "users" in data:
                    return data["users"]

                if "Users" in data:
                    return data["Users"]

                return [data]

            return []

        except Exception:
            return []

    # =====================================================
    # Single User
    # =====================================================

    @classmethod
    def user_info(cls, username: str) -> Dict:

        result = subprocess.run(
            [
                "occtl",
                "--json",
                "show",
                "user",
                username,
            ],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            return {}

        try:

            data = json.loads(result.stdout)

            if isinstance(data, list):
                return data[0] if data else {}

            if isinstance(data, dict):
                return data

            return {}

        except Exception:
            return {}

    # =====================================================
    # Active Sessions
    # =====================================================

    @classmethod
    def sessions(cls, username: str) -> List[Dict]:

        users = cls.online_users()

        sessions = []

        for user in users:

            name = (
                user.get("Username")
                or user.get("username")
                or user.get("User")
                or user.get("user")
                or user.get("Name")
                or user.get("name")
            )

            if name == username:
                sessions.append(user)

        return sessions

    # =====================================================
    # Disconnect
    # =====================================================

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
            raise Exception(
                result.stderr.strip() or "Failed to disconnect user"
            )

        return True

    # =====================================================
    # Traffic / Live Statistics
    # =====================================================

    @classmethod
    def traffic(cls, username: str) -> Dict:

        return cls.user_info(username)

    # =====================================================
    # Generic Command
    # =====================================================

    @classmethod
    def run(cls, *args):

        result = subprocess.run(
            list(args),
            capture_output=True,
            text=True,
        )

        return {
            "returncode": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
        }
