from backend.extensions import db
from datetime import datetime



class Session(db.Model):

    __tablename__ = "sessions"


    id = db.Column(
        db.Integer,
        primary_key=True
    )


    user_id = db.Column(
        db.Integer,
        db.ForeignKey("users.id"),
        nullable=False
    )


    device_id = db.Column(
        db.String(128)
    )


    ip_address = db.Column(
        db.String(64)
    )


    login_time = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )


    logout_time = db.Column(
        db.DateTime,
        nullable=True
    )


    active = db.Column(
        db.Boolean,
        default=True
    )


    user = db.relationship(
        "User",
        backref="sessions"
    )
