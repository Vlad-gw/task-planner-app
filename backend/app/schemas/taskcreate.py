from typing import Optional
from pydantic import BaseModel, Field


class TaskCreate(BaseModel):
    title: str = Field(..., min_length=3, max_length=50)
    description: Optional[str] = None
    priority: int = Field(..., ge=1, le=5)
    creation_date: int
    finish_date: Optional[int] = None
    is_done: bool = False
    time_reminder: Optional[int] = None
    scheduled_at: Optional[int] = None
