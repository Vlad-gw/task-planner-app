from sqlalchemy.orm import Session
from backend.app.models.tag import TagDB
from backend.app.schemas.tag import Tag
from backend.app.schemas.tagupdate import TagUpdate


def create_tag(db: Session, tag: Tag):
    db_tag = TagDB(**tag.model_dump())
    db.add(db_tag)
    db.commit()
    db.refresh(db_tag)
    return db_tag


def get_all_tags(db: Session):
    return db.query(TagDB).all()


def get_tags(db: Session, id: int = None):
    query = db.query(TagDB)
    if id:
        query = query.filter(TagDB.id == id)
    return query.all()


def update_tag(db: Session, id: int, tag_data: TagUpdate):
    db_tag = db.query(TagDB).filter(TagDB.id == id).first()
    if db_tag:
        tag_dict = tag_data.model_dump(exclude_unset=True)
        for key, value in tag_dict.items():
            setattr(db_tag, key, value)
        db.commit()
        db.refresh(db_tag)
        return db_tag
    return None


def delete_tag(db: Session, id: int):
    db_tag = db.query(TagDB).filter(TagDB.id == id).first()
    if db_tag:
        db.delete(db_tag)
        db.commit()
    return db_tag
