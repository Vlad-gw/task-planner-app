from pydantic import BaseModel, Field


class TaskTag(BaseModel):
    task_id: int = Field(..., ge=0, description="Идентификатор задачи")
    tag_id: int = Field(..., ge=0, description="Идентификатор тега")


class Config:
    from_attributes = True
