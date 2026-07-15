from flask import Blueprint

sessions_api = Blueprint(
    "sessions_api",
    __name__,
    url_prefix="/api/sessions"
)
