from fastapi import APIRouter

from sqlalchemy.orm import Session

from .database import SessionLocal

from .models import Admin



router = APIRouter(
    prefix="/admin"
)



@router.get("/")
def admin_home():

    return {
        "panel": "admin",
        "status": "ok"
    }



@router.get("/list")
def admins():

    db = SessionLocal()

    data = db.query(Admin).all()

    db.close()


    return data
