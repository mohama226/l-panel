import os
import shutil
import subprocess

from app.core.config import settings


class OcservService:

    @staticmethod
    def binary():
        return shutil.which("ocpasswd") or "/usr/bin/ocpasswd"

    @staticmethod
    def ensure():

        binary = OcservService.binary()

        if not os.path.exists(binary):
            raise RuntimeError(
                "ocpasswd not found. Install ocserv first."
            )

        users_file = settings.OC_SERV_USERS_FILE

        directory = os.path.dirname(users_file)

        os.makedirs(directory, exist_ok=True)

        if not os.path.exists(users_file):
            open(users_file, "a").close()

    @staticmethod
    def add_user(username: str, password: str):

        OcservService.ensure()

        subprocess.run(
            [
                OcservService.binary(),
                "-c",
                settings.OC_SERV_USERS_FILE,
                username,
            ],
            input=f"{password}\n{password}\n",
            text=True,
            check=True,
        )

    @staticmethod
    def delete_user(username: str):

        OcservService.ensure()

        subprocess.run(
            [
                OcservService.binary(),
                "-c",
                settings.OC_SERV_USERS_FILE,
                "-d",
                username,
            ],
            check=True,
        )

    @staticmethod
    def change_password(username: str, password: str):

        OcservService.ensure()

        subprocess.run(
            [
                OcservService.binary(),
                "-c",
                settings.OC_SERV_USERS_FILE,
                username,
            ],
            input=f"{password}\n{password}\n",
            text=True,
            check=True,
        )
