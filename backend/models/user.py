from backend.extensions import db
from datetime import datetime

class User(db.Model):
    __tablename__ = "users"

    # شناسه کاربر
    id = db.Column(
        db.Integer,
        primary_key=True
    )

    # نام کاربری
    username = db.Column(
        db.String(64),
        unique=True,
        nullable=False
    )

    # رمز عبور هش‌شده
    password = db.Column(
        db.String(255),
        nullable=False
    )

    # تاریخ انقضا
    expire_date = db.Column(
        db.DateTime,
        nullable=True
    )

    # سقف ترافیک مجاز (به MB یا GB — بسته به سیستم شما)
    traffic_limit = db.Column(
        db.BigInteger,
        default=0
    )

    # میزان ترافیک مصرف‌شده
    used_traffic = db.Column(
        db.BigInteger,
        default=0
    )

    # وضعیت کاربر
    status = db.Column(
        db.String(20),
        default="active"
    )

    # سروری که کاربر روی آن قرار دارد
    server_id = db.Column(
        db.Integer,
        db.ForeignKey("servers.id"),
        nullable=True
    )

    # تاریخ ایجاد حساب
    created_at = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )

    # ارتباط با مدل Server (اختیاری ولی توصیه‌شده)
    server = db.relationship(
        "Server",
        backref="users",
        lazy=True
    )
