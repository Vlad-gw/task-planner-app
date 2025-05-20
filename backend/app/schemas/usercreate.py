from pydantic import BaseModel, Field, EmailStr
from typing import Optional


class UserCreate(BaseModel):
    first_name: str = Field(..., min_length=1, max_length=20, pattern=r"^[a-zA-Zа-яА-ЯёЁ-]+$",
                            description="Имя пользователя")
    second_name: str = Field(..., min_length=1, max_length=50, pattern=r"^[a-zA-Zа-яА-ЯёЁ-]+$",
                             description="Фамилия пользователя")
    email: EmailStr
    password: str = Field(..., min_length=6)
    role: str = "user"
    is_verified: bool = False
    icon: Optional[int] = 1

    class Config:
        from_attributes = True
