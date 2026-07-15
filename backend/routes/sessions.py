from flask import Blueprint, render_template
from backend.models.session import Session


sessions_bp = Blueprint(
    "sessions",
    __name__,
    url_prefix="/sessions"
)



@sessions_bp.route("/")
def index():

    sessions = Session.query.order_by(
        Session.login_time.desc()
    ).all()


    return render_template(
        "sessions/list.html",
        sessions=sessions
    )
