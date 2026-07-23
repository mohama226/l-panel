from flask import Flask
from flask_cors import CORS

from config import *
from database import db

def create_app():

    app = Flask(__name__)

    app.config["SECRET_KEY"] = SECRET_KEY
    app.config["SQLALCHEMY_DATABASE_URI"] = SQLALCHEMY_DATABASE_URI
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    CORS(app)

    db.init_app(app)

    from app.routes import api

    app.register_blueprint(api,url_prefix="/api")

    with app.app_context():
        db.create_all()

    return app
