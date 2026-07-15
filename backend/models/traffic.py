from backend.extensions import db


class Traffic(db.Model):

    __tablename__="traffic"

    id=db.Column(db.Integer,primary_key=True)

    user_id=db.Column(db.Integer,
        db.ForeignKey("users.id"))

    upload=db.Column(db.BigInteger,default=0)

    download=db.Column(db.BigInteger,default=0)

    total=db.Column(db.BigInteger,default=0)

    updated_at=db.Column(db.DateTime)
