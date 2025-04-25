from sqlalchemy.orm import Session
from app.models.message import MessageDB
from app.schemas.message import Message


def create_message(db: Session, message: Message):
    db_message = MessageDB(**message.model_dump())
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    return db_message


def get_messages(db: Session, id: int = None, user_id: int = None):
    query = db.query(MessageDB)
    if id:
        query = query.filter(MessageDB.id == id)
    if user_id:
        query = query.filter(MessageDB.user_id == user_id)
    return query.all()
