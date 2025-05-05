from sqlalchemy.orm import Session

from backend.app.models.task import TaskDB
from backend.app.models.tag import TagDB
from backend.app.models.tasklist import TaskListDB
from backend.app.models.tasktag import TaskTagDB
from backend.app.models.user import UserDB
from backend.app.schemas.taskcreate import TaskCreate
from backend.app.schemas.taskupdate import TaskUpdate


def add_tag_to_task(db: Session, task_id: int, tag_id: int):
    task = db.query(TaskDB).filter(TaskDB.id == task_id).first()
    tag = db.query(TagDB).filter(TagDB.id == tag_id).first()
    if not task or not tag:
        raise ValueError("Task or Tag not found")

    existing = db.query(TaskTagDB).filter_by(task_id=task_id, tag_id=tag_id).first()
    if existing:
        return task

    task_tag = TaskTagDB(task_id=task_id, tag_id=tag_id)
    db.add(task_tag)
    db.commit()
    db.refresh(task)
    return task


def create_task(db: Session, task: TaskCreate, user_id: int):
    user = db.query(UserDB).filter(UserDB.id == user_id).first()
    if not user:
        raise ValueError(f"User with id {user_id} not found")

    db_task = TaskDB(**task.model_dump())
    db.add(db_task)
    db.commit()

    db_link = TaskListDB(task_id=db_task.id, user_id=user_id)
    db.add(db_link)
    db.commit()

    db.refresh(db_task)
    return db_task


def get_all_tasks(db: Session):
    try:
        return db.query(TaskDB).all()
    except Exception as e:
        print(f"Error retrieving tasks: {e}")
        return []


def get_tasks(db: Session, **filters):
    query = db.query(TaskDB)
    for attr, value in filters.items():
        if value is not None:
            if hasattr(TaskDB, attr):
                query = query.filter(getattr(TaskDB, attr) == value)
            else:
                print(f"Warning: Attribute '{attr}' not found in TaskDB model.")
    try:
        return query.all()
    except Exception as e:
        print(f"Error retrieving tasks with filters {filters}: {e}")
        return []


def update_task(db: Session, id: int, task_data: TaskUpdate):
    db_task = db.query(TaskDB).filter(TaskDB.id == id).first()
    if db_task:
        task_dict = task_data.model_dump(exclude_unset=True)
        for key, value in task_dict.items():
            setattr(db_task, key, value)
        db.commit()
        db.refresh(db_task)
        return db_task
    return None


def delete_task(db: Session, task_id: int):
    db.query(TaskListDB).filter(TaskListDB.task_id == task_id).delete()

    task = db.query(TaskDB).filter(TaskDB.id == task_id).first()
    if not task:
        return None
    db.delete(task)
    db.commit()
    return task
