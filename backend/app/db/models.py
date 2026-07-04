from datetime import datetime

from sqlalchemy import (
    Boolean,
    Column,
    DateTime,
    ForeignKey,
    Integer,
    String,
)

from sqlalchemy.orm import relationship

from app.db.database import Base


class Role(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True, index=True)

    name = Column(String(100), unique=True)

    description = Column(String(255))


class Admin(Base):
    __tablename__ = "admins"

    id = Column(Integer, primary_key=True, index=True)

    username = Column(String(100), unique=True, nullable=False)

    password = Column(String(255), nullable=False)

    fullname = Column(String(255))

    active = Column(Boolean, default=True)

    role_id = Column(Integer, ForeignKey("roles.id"))

    created_at = Column(DateTime, default=datetime.utcnow)

    role = relationship("Role")


class Server(Base):
    __tablename__ = "servers"

    id = Column(Integer, primary_key=True)

    name = Column(String(100))

    host = Column(String(255))

    port = Column(Integer, default=22)

    username = Column(String(100))

    password = Column(String(255))

    token = Column(String(255))

    active = Column(Boolean, default=True)


class Group(Base):
    __tablename__ = "groups"

    id = Column(Integer, primary_key=True)

    name = Column(String(100), unique=True)

    description = Column(String(255))


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)

    username = Column(String(100), unique=True)

    password = Column(String(255))

    expire = Column(DateTime)

    traffic = Column(Integer, default=0)

    active = Column(Boolean, default=True)

    group_id = Column(Integer, ForeignKey("groups.id"))

    server_id = Column(Integer, ForeignKey("servers.id"))

    group = relationship("Group")

    server = relationship("Server")
