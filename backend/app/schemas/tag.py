from pydantic import BaseModel, Field
from typing import Annotated
import re

HexColor = Annotated[str, Field(min_length=6, max_length=6, pattern=r'^[0-9A-Fa-f]{6}$')]


class Tag(BaseModel):
    id: int = Field(..., ge=0, description="Идентификатор тега")
    tag_name: str = Field(..., min_length=1, max_length=50, description="Название тега (1-50 символов)")
    color: HexColor


class Config:
    from_attributes = True
