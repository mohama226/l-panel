from fastapi import APIRouter, HTTPException
from app.schemas.user import UserCreate
from app.services.ocserv_service import OcservService

router = APIRouter()

fake_db = []

@router.post("/")
def create_user(user: UserCreate):
    try:
        OcservService.add_user(user.username, user.password)
        fake_db.append(user.username)
        return {"message": "User created", "user": user.username}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/{username}")
def delete_user(username: str):
    try:
        OcservService.delete_user(username)
        return {"message": "User deleted", "user": username}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/")
def list_users():
    return {"users": fake_db}
