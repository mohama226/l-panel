from flask import Blueprint, jsonify, request

from backend.services.user_service import UserService
from backend.services.ocserv_service import OcservService

users_api = Blueprint(
    "users_api",
    __name__,
    url_prefix="/api/users"
)


@users_api.get("")
def list_users():

    users = UserService.get_all()

    return jsonify([
        {
            "id": u.id,
            "username": u.username,
            "expire_date": str(u.expire_date),
            "traffic_limit": u.traffic_limit,
            "used_traffic": u.used_traffic,
            "status": u.status,
            "server_id": u.server_id
        }
        for u in users
    ])


@users_api.post("")
def create_user():

    data = request.get_json()

    user = UserService.create(data)

    OcservService.add_user(
        user.username,
        data["password"]
    )

    return jsonify({
        "success": True,
        "id": user.id
    })
