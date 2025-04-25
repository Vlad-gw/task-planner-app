from pydantic import BaseModel, Field, EmailStr
from typing import Optional


class UserCreate(BaseModel):
    first_name: str = Field(..., min_length=1, max_length=20)
    second_name: str = Field(..., min_length=1, max_length=50)
    email: EmailStr
    password: str = Field(..., min_length=6)
    role: str = "user"
    icon: Optional[int] = 1
    is_verified: bool = False

    class Config:
        from_attributes = True
