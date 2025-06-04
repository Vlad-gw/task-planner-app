from pydantic import BaseModel, Field
from typing import Optional, List


class Task(BaseModel):
    id: int = Field(..., ge=1, description="Уникальный идентификатор задачи")
    title: str = Field(..., min_length=3, max_length=50, description="Название задачи (от 3 до 50 символов)")
    description: Optional[str] = Field(None, description="Описание задачи (необязательно)")
    priority: int = Field(..., ge=1, le=5, description="Приоритет задачи от 1 (низкий) до 5 (высокий)")
    creation_date: int = Field(..., description="Дата создания задачи (формат UNIX timestamp)")
    finish_date: Optional[int] = Field(None, description="Дата завершения задачи")
    is_done: bool = Field(False, description="Статус выполнения задачи")
    time_reminder: Optional[int] = Field(None, description="Время напоминания (формат UNIX timestamp)")
    scheduled_at: Optional[int] = Field(None, description="Запланированное время выполнения (формат UNIX timestamp)")


class TaskFilter(BaseModel):
    user_ids: List[int]
    task_ids: Optional[List[int]] = None
    priority: Optional[int] = None
    is_done: Optional[bool] = None
    min_creation_date: Optional[int] = None
    max_creation_date: Optional[int] = None


class TaskDetails(BaseModel):
    title: str = Field(..., min_length=1, max_length=50)
    description: Optional[str] = Field(None)
    priority: Optional[int] = Field(None, ge=1, le=5)
    scheduled_at: Optional[int] = Field(None, description="UNIX timestamp")
    finish_date: Optional[int] = Field(None, description="UNIX timestamp")
    time_reminder: Optional[int] = Field(None, description="UNIX timestamp")


class Config:
    from_attributes = True
