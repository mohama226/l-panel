from flask import Blueprint

servers_bp = Blueprint(
    "servers",
    __name__,
    url_prefix="/servers"
)

@servers_bp.route("/")
def servers():

    return "Servers"
