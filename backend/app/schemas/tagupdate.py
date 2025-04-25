from pydantic import BaseModel, Field
from typing import Optional


class TagUpdate(BaseModel):
    tag_name: Optional[str] = Field(None, min_length=1, max_length=50)
    color: Optional[str] = Field(None, min_length=6, max_length=6)
