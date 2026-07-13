from database import db
from datetime import datetime


class Admin(db.Model):

    id=db.Column(
        db.Integer,
        primary_key=True
    )

    username=db.Column(
        db.String(100),
        unique=True
    )

    password=db.Column(
        db.String(200)
    )

    created=db.Column(
        db.DateTime,
        default=datetime.utcnow
    )
