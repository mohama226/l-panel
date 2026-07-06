from sqlalchemy import or_
from sqlalchemy.orm import Session, joinedload

from app.db.models import VPNUser


class UserRepository:

    def __init__(self, db: Session):
        self.db = db

    def get_all(self):
        return (
            self.db.query(VPNUser)
            .options(
                joinedload(VPNUser.group),
                joinedload(VPNUser.server),
            )
            .order_by(VPNUser.id.desc())
            .all()
        )

    def get_paginated(
        self,
        page: int = 1,
        per_page: int = 20,
        search: str | None = None,
    ):

        query = (
            self.db.query(VPNUser)
            .options(
                joinedload(VPNUser.group),
                joinedload(VPNUser.server),
            )
        )

        if search:

            query = query.filter(

                or_(

                    VPNUser.username.ilike(f"%{search}%"),

                )

            )

        total = query.count()

        rows = (

            query

            .order_by(VPNUser.id.desc())

            .offset((page - 1) * per_page)

            .limit(per_page)

            .all()

        )

        return rows, total

    def get(self, username: str):

        return (

            self.db.query(VPNUser)

            .options(

                joinedload(VPNUser.group),

                joinedload(VPNUser.server),

            )

            .filter(VPNUser.username == username)

            .first()

        )

    def get_by_id(self, user_id: int):

        return (

            self.db.query(VPNUser)

            .options(

                joinedload(VPNUser.group),

                joinedload(VPNUser.server),

            )

            .filter(VPNUser.id == user_id)

            .first()

        )

    def exists(self, username: str):

        return (

            self.db.query(VPNUser.id)

            .filter(VPNUser.username == username)

            .first()

            is not None

        )

    def create(self, user: VPNUser):

        self.db.add(user)

        self.db.commit()

        self.db.refresh(user)

        return user

    def update(self, user: VPNUser):

        self.db.commit()

        self.db.refresh(user)

        return user

    def delete(self, user: VPNUser):

        self.db.delete(user)

        self.db.commit()

    def count(self):

        return self.db.query(VPNUser).count()

    def enable(self, username: str):

        user = self.get(username)

        if not user:
            return None

        user.enabled = True

        self.db.commit()

        self.db.refresh(user)

        return user

    def disable(self, username: str):

        user = self.get(username)

        if not user:
            return None

        user.enabled = False

        self.db.commit()

        self.db.refresh(user)

        return user
