from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.schemas.task import Task
from app.crud.tasks import create_task, get_tasks, update_task, delete_task, get_all_tasks
from app.db.session import get_db
from app.schemas.taskupdate import TaskUpdate

router = APIRouter()


@router.get("/Get_all_tasks", response_model=List[Task])
def read_all_tasks(db: Session = Depends(get_db)):
    return get_all_tasks(db)


@router.get("/Get_one_task", response_model=List[Task])
def read_task(id: int = Query(..., description="ID task, required field"),
              user_id: Optional[int] = Query(None, description="ID user, optional field"),
              db: Session = Depends(get_db)):
    return get_tasks(db, id=id, user_id=user_id)


@router.post("/Create_task", response_model=Task)
def create(task: Task, db: Session = Depends(get_db)):
    return create_task(db, task)


@router.put("/Update_task", response_model=Task)
def update(id: int, task_data: TaskUpdate, db: Session = Depends(get_db)):
    return update_task(db, id, task_data)


@router.delete("/Delete_task")
def delete(id: int, db: Session = Depends(get_db)):
    deleted = delete_task(db, id)
    if deleted:
        return {"message": f"Task with id={id} deleted"}
    return {"message": "Task not found"}
