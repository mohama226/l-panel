from datetime import datetime, timedelta

from app.db.models import VPNUser
from app.repositories.user_repository import UserRepository


class UserService:

    def __init__(self, repository: UserRepository):
        self.repository = repository

    def get_users(self):
        return self.repository.get_all()

    def get_user(self, username: str):
        return self.repository.get(username)

    def create_user(
        self,
        username: str,
        password: str,
        days: int,
        server_id: int | None = None,
        group_id: int | None = None,
    ):

        user = VPNUser(
            username=username,
            password=password,
            expire=datetime.utcnow() + timedelta(days=days),
            enabled=True,
            server_id=server_id,
            group_id=group_id,
        )

        return self.repository.create(user)

    def delete_user(self, user: VPNUser):
        return self.repository.delete(user)
