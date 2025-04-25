from pydantic import BaseModel, Field


class Message(BaseModel):
    id: int = Field(..., ge=1, description="Идентификатор сообщения")
    message: str = Field(..., min_length=1, description="Текст сообщения")
    user_id: int = Field(..., ge=1, description="Идентификатор пользователя")


class Config:
    from_attributes = True
