from sqlalchemy.orm import Session
from backend.app.models.message import MessageDB
import logging

logger = logging.getLogger(__name__)


def create_message(db: Session, message: str, user_id: int, sent_at: int) -> MessageDB:
    try:
        logger.info(f"Creating message for user {user_id}")
        db_message = MessageDB(
            message=message,
            user_id=user_id,
            sent_at=sent_at
        )
        db.add(db_message)
        db.flush()
        logger.info(f"Message created with ID {db_message.id}")
        return db_message
    except Exception as e:
        logger.error(f"Error creating message: {str(e)}", exc_info=True)
        raise


def get_messages(db: Session, id: int = None, user_id: int = None):
    query = db.query(MessageDB)
    if id:
        query = query.filter(MessageDB.id == id)
    if user_id:
        query = query.filter(MessageDB.user_id == user_id)
    return query.all()
