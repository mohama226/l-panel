from backend.extensions import db
from datetime import datetime


class User(db.Model):

    __tablename__ = "users"

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    username = db.Column(
        db.String(64),
        unique=True,
        nullable=False
    )

    password = db.Column(
        db.String(255),
        nullable=False
    )

    expire_date = db.Column(
        db.DateTime,
        nullable=True
    )

    traffic_limit = db.Column(
        db.BigInteger,
        default=0,
        nullable=False
    )

    used_traffic = db.Column(
        db.BigInteger,
        default=0,
        nullable=False
    )

    status = db.Column(
        db.String(20),
        default="active",
        nullable=False
    )

    server_id = db.Column(
        db.Integer,
        db.ForeignKey("servers.id"),
        nullable=True
    )

    created_at = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )
