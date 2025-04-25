from pydantic import BaseModel, Field


class TaskTag(BaseModel):
    task_id: int = Field(..., ge=1, description="Идентификатор задачи")
    tag_id: int = Field(..., ge=1, description="Идентификатор тега")


class Config:
    from_attributes = True
