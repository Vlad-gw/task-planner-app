from sqlalchemy.orm import Session
from backend.app.models.user import UserDB
from backend.app.schemas.userupdate import UserUpdate


def get_all_users(db: Session,
                  id: int = None,
                  first_name: str = None,
                  second_name: str = None,
                  email: str = None,
                  icon: int = None):
    query = db.query(UserDB)

    if id is not None:
        query = query.filter(UserDB.id == id)
    if first_name is not None:
        query = query.filter(UserDB.first_name == first_name)
    if second_name is not None:
        query = query.filter(UserDB.second_name == second_name)
    if email is not None:
        query = query.filter(UserDB.email == email)
    if icon is not None:
        query = query.filter(UserDB.icon == icon)

    return query.all()


def get_user(db: Session, id: int = None, first_name: str = None, second_name: str = None,
             email: str = None, icon: int = None):
    query = db.query(UserDB)
    if id:
        query = query.filter(UserDB.id == id)
    if first_name:
        query = query.filter(UserDB.first_name == first_name)
    if second_name:
        query = query.filter(UserDB.second_name == second_name)
    if email:
        query = query.filter(UserDB.email == email)
    if icon:
        query = query.filter(UserDB.icon == icon)

    return query.first()


def update_user(db: Session, id: int, user_data: UserUpdate):
    db_user = db.query(UserDB).filter(UserDB.id == id).first()
    if db_user:
        user_dict = user_data.model_dump(exclude_unset=True)
        for key, value in user_dict.items():
            setattr(db_user, key, value)
        db.commit()
        db.refresh(db_user)
        return db_user
    return None


def delete_user(db: Session, id: int):
    db_user = db.query(UserDB).filter(UserDB.id == id).first()
    if db_user:
        db.delete(db_user)
        db.commit()
    return db_user
