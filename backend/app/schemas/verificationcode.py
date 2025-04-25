from pydantic import BaseModel, Field
from typing import Optional


class VerificationCode(BaseModel):
    id: int = Field(..., ge=1, description="Идентификатор кода")
    value: int = Field(..., min_length=6, max_length=6, description="Код")
    expires: Optional[int] = Field(None, description="Время действия кода (формат UNIX timestamp)")


class Config:
    from_attributes = True
