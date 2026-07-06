from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


# ---------------------------------
# Create User
# ---------------------------------

class UserCreate(BaseModel):

    username: str = Field(
        min_length=3,
        max_length=100,
    )

    password: str = Field(
        min_length=4,
    )

    expire: Optional[datetime] = None

    traffic: int = 0

    group_id: Optional[int] = None

    server_id: Optional[int] = None


# ---------------------------------
# Change Password
# ---------------------------------

class UserPassword(BaseModel):

    password: str = Field(
        min_length=4,
        max_length=255,
    )


# ---------------------------------
# Extend Account
# ---------------------------------

class UserExpire(BaseModel):

    expire: datetime


# ---------------------------------
# Traffic
# ---------------------------------

class UserTraffic(BaseModel):

    traffic: int = Field(
        ge=0,
    )


# ---------------------------------
# Edit User
# ---------------------------------

class UserEdit(BaseModel):

    expire: Optional[datetime] = None

    traffic: Optional[int] = None

    enabled: Optional[bool] = None

    suspended: Optional[bool] = None

    blocked: Optional[bool] = None

    group_id: Optional[int] = None

    server_id: Optional[int] = None


# ---------------------------------
# Output
# ---------------------------------

class UserOut(BaseModel):

    id: int

    username: str

    enabled: bool

    suspended: bool

    blocked: bool

    traffic: int

    expire: Optional[datetime]

    group_id: Optional[int]

    server_id: Optional[int]

    class Config:
        from_attributes = True
