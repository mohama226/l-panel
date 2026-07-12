import os


class Settings:

    APP_PORT = int(os.getenv("APP_PORT", 2096))

    DB_NAME = os.getenv("DB_NAME")
    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")

    DATABASE_URL = (
        f"postgresql://"
        f"{DB_USER}:"
        f"{DB_PASSWORD}@localhost/"
        f"{DB_NAME}"
    )


settings = Settings()
