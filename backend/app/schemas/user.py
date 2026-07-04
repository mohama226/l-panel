from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class UserCreate(BaseModel):
    username: str
    password: str
    expires_at: Optional[datetime] = None


class UserOut(BaseModel):
    id: int
    username: str
    expires_at: Optional[datetime]

    class Config:
        from_attributes = True
