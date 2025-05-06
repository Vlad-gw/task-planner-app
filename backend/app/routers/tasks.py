from typing import List, Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from backend.app.crud.tasks import create_task, get_tasks, update_task, delete_task, get_all_tasks, add_tag_to_task
from backend.app.db.session import get_db
from backend.app.schemas.task import Task
from backend.app.schemas.taskcreate import TaskCreate
from backend.app.schemas.taskupdate import TaskUpdate
from backend.app.auth.oauth2 import get_current_user
from backend.app.models.user import UserDB

router = APIRouter()


@router.post("/Add_tag_to_task")
def add_tag(task_id: int, tag_id: int, db: Session = Depends(get_db)):
    task = add_tag_to_task(db, task_id, tag_id)
    return {"message": "Tag added to task", "task_id": task.id}


@router.get("/Get_all_tasks", response_model=List[Task])
def read_all_tasks(db: Session = Depends(get_db)):
    return get_all_tasks(db)


@router.get("/Get_one_task", response_model=List[Task])
def read_task(id: int = Query(..., description="ID task, required field"),
              user_id: Optional[int] = Query(None, description="ID user, optional field"),
              db: Session = Depends(get_db)):
    return get_tasks(db, id=id, user_id=user_id)


@router.post("/Create_task", response_model=Task)
def create_task_endpoint(
        task: TaskCreate,
        db: Session = Depends(get_db),
        current_user: UserDB = Depends(get_current_user)):
    return create_task(db, task, user_id=current_user.id)


@router.put("/Update_task", response_model=Task)
def update(id: int, task_data: TaskUpdate, db: Session = Depends(get_db)):
    return update_task(db, id, task_data)


@router.delete("/Delete_task")
def delete(id: int, db: Session = Depends(get_db)):
    deleted = delete_task(db, id)
    if deleted:
        return {"message": f"Task with id={id} deleted"}
    return {"message": "Task not found"}
