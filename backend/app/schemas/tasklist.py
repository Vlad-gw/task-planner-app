from pydantic import BaseModel, Field


class TaskList(BaseModel):
    task_id: int = Field(..., ge=1, description="Идентификатор задачи")
    user_id: int = Field(..., ge=1, description="Идентификатор пользователя")

    class Config:
        from_attributes = True
