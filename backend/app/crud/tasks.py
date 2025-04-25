from sqlalchemy.orm import Session
from app.models.task import TaskDB
from app.schemas.task import Task
from app.schemas.taskupdate import TaskUpdate


def create_task(db: Session, task: Task):
    db_task = TaskDB(**task.model_dump())
    db.add(db_task)
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


def delete_task(db: Session, id: int):
    db_task = db.query(TaskDB).filter(TaskDB.id == id).first()
    if db_task:
        db.delete(db_task)
        db.commit()
    return db_task
