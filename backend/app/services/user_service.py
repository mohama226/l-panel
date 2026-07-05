from datetime import datetime, timedelta

from app.db.models import VPNUser
from app.repositories.user_repository import UserRepository


class UserService:

    def __init__(self, repo: UserRepository):
        self.repo = repo

    def list(self):
        return self.repo.all()

    def create(
        self,
        username,
        password,
        days,
        server_id=None,
        group_id=None,
    ):

        expire = datetime.utcnow() + timedelta(days=days)

        user = VPNUser(
            username=username,
            password=password,
            expire=expire,
            enabled=True,
            server_id=server_id,
            group_id=group_id,
        )

        return self.repo.create(user)
