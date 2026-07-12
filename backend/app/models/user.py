from sqlalchemy import Column, Integer, String, Boolean

from ..database import Base


class User(Base):

    __tablename__ = "users"


    id = Column(
        Integer,
        primary_key=True
    )


    username = Column(
        String(100),
        unique=True
    )


    password = Column(
        String(255)
    )


    expire_date = Column(
        String(50)
    )


    enabled = Column(
        Boolean,
        default=True
    )
