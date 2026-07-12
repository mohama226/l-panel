from sqlalchemy import Column, Integer, String

from ..database import Base


class Admin(Base):

    __tablename__ = "admins"


    id = Column(
        Integer,
        primary_key=True
    )


    username = Column(
        String(100),
        unique=True,
        index=True
    )


    password_hash = Column(
        String(255)
    )


    role = Column(
        String(50),
        default="superadmin"
    )
