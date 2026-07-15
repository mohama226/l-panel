from backend.extensions import db


class Admin(db.Model):

    __tablename__ = "admins"

    id = db.Column(db.Integer, primary_key=True)

    username = db.Column(db.String(64), unique=True)

    password = db.Column(db.String(255))

    is_super = db.Column(db.Boolean, default=False)

    created_at = db.Column(db.DateTime)
