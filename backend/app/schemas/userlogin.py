from pydantic import BaseModel, Field, EmailStr


class UserLogin(BaseModel):
    email: EmailStr = Field(..., min_length=7, max_length=50)
    password: str = Field(..., min_length=6, max_length=30)
