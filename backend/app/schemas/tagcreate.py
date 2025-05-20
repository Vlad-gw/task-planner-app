from pydantic import BaseModel, Field
from typing import Annotated

HexColor = Annotated[str, Field(min_length=6, max_length=6, pattern=r'^[0-9A-Fa-f]{6}$')]


class TagCreate(BaseModel):
    tag_name: str = Field(..., min_length=1, max_length=50)
    color: HexColor
