from sqlalchemy import Boolean
from sqlalchemy import Column
from sqlalchemy import DateTime
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy.orm import relationship

from app.db.database import Base

from datetime import datetime


class VPNServer(Base):
    __tablename__ = "vpn_servers"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True)
    host = Column(String)
    port = Column(Integer, default=443)
    enabled = Column(Boolean, default=True)

    users = relationship("VPNUser", back_populates="server")


class UserGroup(Base):
    __tablename__ = "user_groups"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True)
    description = Column(String, default="")

    users = relationship("VPNUser", back_populates="group")


class VPNUser(Base):
    __tablename__ = "vpn_users"

    id = Column(Integer, primary_key=True, index=True)

    username = Column(String, unique=True, index=True)

    password = Column(String)

    email = Column(String, default="")

    mobile = Column(String, default="")

    fullname = Column(String, default="")

    enabled = Column(Boolean, default=True)

    suspended = Column(Boolean, default=False)

    blocked = Column(Boolean, default=False)

    created_at = Column(DateTime, default=datetime.utcnow)

    expire_at = Column(DateTime, nullable=True)

    last_login = Column(DateTime, nullable=True)

    last_ip = Column(String, nullable=True)

    server_id = Column(
        Integer,
        ForeignKey("vpn_servers.id"),
        nullable=True,
    )

    group_id = Column(
        Integer,
        ForeignKey("user_groups.id"),
        nullable=True,
    )

    server = relationship(
        "VPNServer",
        back_populates="users",
    )

    group = relationship(
        "UserGroup",
        back_populates="users",
    )

    logs = relationship(
        "UserLog",
        back_populates="user",
        cascade="all, delete-orphan",
    )


class UserLog(Base):
    __tablename__ = "user_logs"

    id = Column(Integer, primary_key=True, index=True)

    username = Column(
        String,
        ForeignKey("vpn_users.username"),
    )

    event = Column(String)

    ip = Column(String)

    details = Column(String, default="")

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
    )

    user = relationship(
        "VPNUser",
        back_populates="logs",
    )
