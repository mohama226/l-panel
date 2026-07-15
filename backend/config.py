import os


class Config:

    SECRET_KEY = "lpanel-secret-key"

    DB_USER = "lpanel_user"
    DB_PASSWORD = "lpanel_pass"
    DB_HOST = "localhost"
    DB_NAME = "lpanel"


    SQLALCHEMY_DATABASE_URI = (
        f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
    )


    SQLALCHEMY_TRACK_MODIFICATIONS = False


    SQLALCHEMY_ENGINE_OPTIONS = {
        "pool_pre_ping": True,
        "pool_recycle": 300,
        "pool_size": 10,
        "max_overflow": 20
    }
