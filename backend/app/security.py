from passlib.context import CryptContext


from jose import jwt


SECRET_KEY = "CHANGE_THIS_SECRET"

ALGORITHM = "HS256"



pwd_context = CryptContext(
    schemes=["argon2"],
    deprecated="auto"
)



def hash_password(password):

    return pwd_context.hash(password)



def verify_password(
    plain,
    hashed
):

    return pwd_context.verify(
        plain,
        hashed
    )



def create_token(data):

    return jwt.encode(
        data,
        SECRET_KEY,
        algorithm=ALGORITHM
    )
