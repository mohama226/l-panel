from pydantic import BaseModel



class LoginSchema(BaseModel):

    username:str

    password:str



class AdminCreate(BaseModel):

    username:str

    password:str
