from fastapi import APIRouter,HTTPException


from .database import SessionLocal

from .models import Admin

from .schemas import LoginSchema

from .security import verify_password,create_token



router = APIRouter()



@router.post("/login")
def login(
    data:LoginSchema
):

    db=SessionLocal()


    admin=db.query(Admin).filter(
        Admin.username==data.username
    ).first()


    db.close()


    if not admin:

        raise HTTPException(
            401,
            "Invalid login"
        )



    if not verify_password(
        data.password,
        admin.password
    ):

        raise HTTPException(
            401,
            "Invalid login"
        )



    token=create_token(
        {
            "username":admin.username,
            "role":admin.role
        }
    )


    return {

        "access_token":token,

        "type":"bearer"

    }
