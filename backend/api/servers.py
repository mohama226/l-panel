from flask import Blueprint

servers_api = Blueprint(
    "servers_api",
    __name__,
    url_prefix="/api/servers"
)
