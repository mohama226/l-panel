from fastapi import APIRouter, Request, Cookie, Form, HTTPException
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from app.core.template import render
from app.db.database import SessionLocal
from app.schemas.user import UserCreate
from app.services.user_service import UserService

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/users")
async def users_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:
        return RedirectResponse("/login")

    db: Session = SessionLocal()

    try:

        service = UserService(db)

        rows = service.list()

        users = []

        for row in rows:

            users.append(
                {
                    "username": row.username,
                    "status": "Active" if row.enabled else "Disabled",
                    "online": False,
                    "traffic": row.traffic,
                    "expire": row.expire or "-",
                    "group": row.group.name if row.group else "-",
                }
            )

        return render(
            request,
            "users/index.html",
            {
                "title": "Users",
                "users": users,
            },
        )

    finally:
        db.close()


@router.get("/users/new")
async def new_user_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:
        return RedirectResponse("/login")

    return render(
        request,
        "users/create.html",
        {
            "title": "Create User",
        },
    )


@router.post("/users/new")
async def create_user_form(
    username: str = Form(...),
    password: str = Form(...),
):

    db = SessionLocal()

    try:

        service = UserService(db)

        service.create(
            username=username,
            password=password,
        )

        return RedirectResponse(
            "/users",
            status_code=302,
        )

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )

    finally:

        db.close()


@router.post("/users")
async def create_user(user: UserCreate):

    db = SessionLocal()

    try:

        service = UserService(db)

        service.create(
            username=user.username,
            password=user.password,
            expire=user.expire,
            traffic=user.traffic,
            group_id=user.group_id,
            server_id=user.server_id,
        )

        return {
            "message": "User created",
        }

    finally:

        db.close()


@router.delete("/users/{username}")
async def delete_user(username: str):

    db = SessionLocal()

    try:

        service = UserService(db)

        service.delete(username)

        return {
            "message": "User deleted",
        }

    finally:

        db.close()


@router.patch("/users/{username}/enable")
async def enable_user(username: str):

    db = SessionLocal()

    try:

        UserService(db).enable(username)

        return {
            "message": "enabled",
        }

    finally:

        db.close()


@router.patch("/users/{username}/disable")
async def disable_user(username: str):

    db = SessionLocal()

    try:

        UserService(db).disable(username)

        return {
            "message": "disabled",
        }

    finally:

        db.close()


@router.get("/api/users")
async def api_users():

    db = SessionLocal()

    try:

        rows = UserService(db).list()

        return rows

    finally:

        db.close()
