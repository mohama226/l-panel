from flask import Flask

from backend.config import Config
from backend.extensions import db


def create_app():
    app = Flask(__name__)

    # Config
    app.config.from_object(Config)

    # Database
    db.init_app(app)

    # Import models
    from backend.models.user import User
    from backend.models.server import Server
    from backend.models.session import Session

    # Create tables + update users table
    with app.app_context():

        db.create_all()

        from backend.database.update_users import update_users_table
        update_users_table()

    # ==========================
    # Register Blueprints
    # ==========================

    from backend.routes.dashboard import dashboard_bp
    from backend.routes.auth import auth_bp
    from backend.routes.users import users_bp
    from backend.routes.servers import servers_bp
    from backend.routes.sessions import sessions_bp

    app.register_blueprint(dashboard_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(users_bp)
    app.register_blueprint(servers_bp)
    app.register_blueprint(sessions_bp)

    return app
