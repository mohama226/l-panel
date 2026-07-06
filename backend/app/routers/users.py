from fastapi import APIRouter, Request, Cookie, HTTPException, Depends
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from app.core.template import render
from app.db.database import SessionLocal
from app.schemas.user import UserCreate, UserPassword
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
    db: Session = Depends(get_db),
):

    if lak_admin is None:
        return RedirectResponse("/login")

    service = UserService(db)

    rows = service.list()

    users = []

    for u in rows:
        users.append(
            {
                "username": u.username,
                "status": "Active" if u.enabled else "Disabled",
                "online": False,
                "traffic": f"{u.traffic} MB",
                "expire": u.expire or "-",
                "group": u.group.name if u.group else "-",
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


@router.post("/users")
def create_user(
    user: UserCreate,
    db: Session = Depends(get_db),
):

    try:

        service = UserService(db)

        obj = service.create(
            username=user.username,
            password=user.password,
            expire=user.expire,
            traffic=user.traffic,
            group_id=user.group_id,
            server_id=user.server_id,
        )

        return {
            "message": "User created",
            "user": obj.username,
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@router.delete("/users/{username}")
def delete_user(
    username: str,
    db: Session = Depends(get_db),
):

    try:

        UserService(db).delete(username)

        return {
            "message": "User deleted",
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@router.patch("/users/{username}/enable")
def enable_user(
    username: str,
    db: Session = Depends(get_db),
):
    UserService(db).enable(username)
    return {"message": "enabled"}


@router.patch("/users/{username}/disable")
def disable_user(
    username: str,
    db: Session = Depends(get_db),
):
    UserService(db).disable(username)
    return {"message": "disabled"}


@router.patch("/users/{username}/password")
def change_password(
    username: str,
    body: UserPassword,
    db: Session = Depends(get_db),
):
    UserService(db).change_password(
        username,
        body.password,
    )
    return {"message": "password changed"}


@router.get("/api/users")
def api_users(
    db: Session = Depends(get_db),
):

    rows = UserService(db).list()

    return [
        {
            "username": u.username,
            "enabled": u.enabled,
            "traffic": u.traffic,
            "expire": u.expire,
            "group": u.group.name if u.group else None,
        }
        for u in rows
    ]
