from sqlalchemy.orm import Session

from app.db.models import VPNUser
from app.repositories.user_repository import UserRepository
from app.services.ocserv_service import OcservService


class UserService:

    def __init__(self, db: Session):
        self.db = db
        self.repo = UserRepository(db)

    def list(self):
        return self.repo.get_all()

    def get(self, username: str):
        return self.repo.get(username)

    def create(
        self,
        username: str,
        password: str,
        expire=None,
        traffic=0,
        group_id=None,
        server_id=None,
    ):

        if self.repo.get(username):
            raise Exception("Username already exists.")

        # ایجاد در OCServ
        OcservService.add_user(
            username=username,
            password=password,
        )

        user = VPNUser(
            username=username,
            password="",
            expire=expire,
            traffic=traffic,
            enabled=True,
            group_id=group_id,
            server_id=server_id,
        )

        return self.repo.create(user)

    def delete(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found.")

        try:
            OcservService.delete_user(username)
        except Exception:
            pass

        self.repo.delete(user)

    def enable(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found.")

        user.enabled = True

        return self.repo.update(user)

    def disable(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found.")

        user.enabled = False

        return self.repo.update(user)

    def change_password(
        self,
        username: str,
        password: str,
    ):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found.")

        OcservService.change_password(
            username=username,
            password=password,
        )

        return user

    def count(self):

        return self.repo.count()
