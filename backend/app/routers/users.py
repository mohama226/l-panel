from fastapi import APIRouter, Request, Cookie, HTTPException
from fastapi.responses import RedirectResponse

from app.core.template import render
from app.schemas.user import UserCreate
from app.services.ocserv_service import OcservService

router = APIRouter()

fake_db = []


@router.get("/users")
async def users_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:

        return RedirectResponse("/login")

    users = []

    for username in fake_db:

        users.append({

            "username": username,

            "status": "Active",

            "online": False,

            "traffic": "0 MB",

            "expire": "-",

            "group": "Default",

        })

    return render(

        request,

        "users/index.html",

        {

            "title": "Users",

            "users": users,

        },

    )


@router.post("/users")
def create_user(user: UserCreate):

    try:

        OcservService.add_user(
            user.username,
            user.password,
        )

        fake_db.append(user.username)

        return {

            "message": "User created",

            "user": user.username,

        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@router.delete("/users/{username}")
def delete_user(username: str):

    try:

        OcservService.delete_user(username)

        if username in fake_db:

            fake_db.remove(username)

        return {

            "message": "User deleted",

            "user": username,

        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@router.get("/api/users")
def list_users():

    users = []

    for username in fake_db:

        users.append({

            "username": username,

            "status": "Active",

            "online": False,

            "traffic": "0 MB",

            "expire": "-",

            "group": "Default",

        })

    return users
