from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String

from .database import Base


class Server(Base):

    __tablename__ = "servers"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    name = Column(
        String,
        nullable=False
    )

    host = Column(
        String,
        nullable=False
    )

    ssh_port = Column(
        Integer,
        default=22
    )

    ssh_user = Column(
        String,
        nullable=False
    )

    auth_type = Column(
        String,
        default="password"
    )

    ssh_password = Column(
        String
    )

    ssh_private_key = Column(
        String
    )

    vpn_type = Column(
        String,
        default="ocserv"
    )

    status = Column(
        String,
        default="offline"
    )
