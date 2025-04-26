from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional

from backend.app.db.session import get_db
from backend.app.schemas.user import User
from backend.app.schemas.userupdate import UserUpdate
from backend.app.crud.users import get_user, update_user, delete_user, get_all_users

router = APIRouter()


@router.get("/Get_all_users", response_model=List[User], summary="Получить всех пользователей")
def read_users(
        db: Session = Depends(get_db),

        id: Optional[int] = None,
        first_name: Optional[str] = None,
        second_name: Optional[str] = None,
        email: Optional[str] = None,
        icon: Optional[int] = None,
):
    users = get_all_users(db, id=id, first_name=first_name, second_name=second_name, email=email, icon=icon)

    if not users:
        return []

    return users


@router.get("/Get_one_user", response_model=User)
def read_user(
        id: Optional[int] = None,
        first_name: Optional[str] = None,
        second_name: Optional[str] = None,
        email: Optional[str] = None,
        icon: Optional[int] = None,
        db: Session = Depends(get_db)
):
    user = get_user(db, id=id, first_name=first_name, second_name=second_name, email=email, icon=icon)

    if user is None:
        return {"message": "User not found"}

    return user


@router.put("/Update_user", response_model=User)
def update_user_view(id: int, user_data: UserUpdate, db: Session = Depends(get_db)):
    user = update_user(db, id, user_data)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@router.delete("/Delete_user")
def delete_user_by_id(id: int, db: Session = Depends(get_db)):
    deleted = delete_user(db, id)
    if deleted:
        return {"message": f"User with id={id} deleted"}
    return {"message": "User not found"}
