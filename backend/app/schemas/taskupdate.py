from pydantic import BaseModel, Field
from typing import Optional


class TaskUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=3, max_length=50)
    description: Optional[str] = None
    list_id: Optional[int] = Field(None, ge=1)
    priority: Optional[int] = Field(None, ge=1, le=5)
    finish_date: Optional[int] = None
    is_done: Optional[bool] = None
    time_reminder: Optional[int] = None
    scheduled_at: Optional[int] = None
