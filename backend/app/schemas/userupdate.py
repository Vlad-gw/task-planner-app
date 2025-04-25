from pydantic import BaseModel, Field, EmailStr
from typing import Optional


class UserUpdate(BaseModel):
    first_name: str = Field(..., min_length=1, max_length=20, pattern=r"^[a-zA-Zа-яА-ЯёЁ-]+$",
                            description="Имя пользователя")
    second_name: str = Field(..., min_length=1, max_length=50, pattern=r"^[a-zA-Zа-яА-ЯёЁ-]+$",
                             description="Фамилия пользователя")
    email: EmailStr = Field(..., min_length=7, max_length=50, description="Email пользователя в корректном формате")
    password_hash: str = Field(..., min_length=6, max_length=30, description="Пароль пользователя")
    role: str = Field(default="user", min_length=1, max_length=5, description="Роль пользователя ( admin или user)")
    is_verified: bool = Field(False, description="Статус подтверждения")
    icon: Optional[int] = Field(default=1, description="Список иконок пользователя")
