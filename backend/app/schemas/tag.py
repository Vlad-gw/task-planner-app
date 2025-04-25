from pydantic import BaseModel, Field


class Tag(BaseModel):
    id: int = Field(..., ge=1, description="Идентификатор тега")
    tag_name: str = Field(..., min_length=1, max_length=50, description="Название тега (1-50 символов)")
    color: str = Field(..., min_length=6, max_length=6, description="Цвет тега в HEX формате (например, #FF5733)")


class Config:
    from_attributes = True
