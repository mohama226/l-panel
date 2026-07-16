from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import OcservUser
from app.schemas import UserCreate, UserOut
from app.ocserv_manager import add_user, delete_user

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=UserOut)
def create_user(data: UserCreate, db: Session = Depends(get_db)):
    add_user(data.username, data.password)
    user = OcservUser(username=data.username, password=data.password)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

@router.delete("/{username}")
def remove_user(username: str, db: Session = Depends(get_db)):
    delete_user(username)
    db.query(OcservUser).filter(OcservUser.username == username).delete()
    db.commit()
    return {"status": "deleted"}
