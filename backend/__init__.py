from flask import Flask
from backend.extensions import db
from backend.config import Config


def create_app():
    app = Flask(__name__)

    # بارگذاری تنظیمات
    app.config.from_object(Config)

    # اتصال دیتابیس
    db.init_app(app)

    # Import مدل‌ها
    from backend.models import (
        User,
        Server,
        Session
    )

    # ایجاد جداول دیتابیس
    with app.app_context():
        db.create_all()

    # ======================== Routes ========================

    @app.route("/")
    def index():
        return """
        <html>
        <head>
            <title>L-Panel</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    text-align: center;
                    padding: 50px;
                    background-color: #f4f4f4;
                }
                h1 {
                    color: #2c3e50;
                }
                p {
                    color: #27ae60;
                    font-size: 1.2em;
                }
            </style>
        </head>
        <body>
            <h1>L-Panel</h1>
            <p>✅ Panel is running successfully</p>
        </body>
        </html>
        """

    # TODO: بقیه روت‌ها را اینجا اضافه کنید

    return app
