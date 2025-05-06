from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.app.db.session import get_db
from backend.app.models.user import UserDB
from backend.app.schemas.usercreate import UserCreate
from backend.app.auth.oauth2 import create_access_token
from backend.app.auth.oauth2 import get_current_user
from backend.app.schemas.userlogin import UserLogin

router = APIRouter(prefix="/Auth", tags=["Auth"])


@router.get("/Who_I_am")
def get_profile(current_user: UserDB = Depends(get_current_user)):
    return {
        "id": current_user.id,
        "first_name": current_user.first_name,
        "second_name": current_user.second_name,
        "email": current_user.email,
        "role": current_user.role
    }


@router.post("/Login")
def login(user_data: UserLogin, db: Session = Depends(get_db)):
    user = db.query(UserDB).filter(UserDB.email == user_data.email).first()
    if not user or user.password_hash != user_data.password:
        raise HTTPException(status_code=401, detail="Неверный email или пароль")

    access_token = create_access_token(
        user_id=user.id,
        first_name=user.first_name,
        second_name=user.second_name,
        email=user.email,
        role=user.role
    )
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/Registration")
def register_user(user_data: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(UserDB).filter(UserDB.email == user_data.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Пользователь с таким email уже существует")

    new_user = UserDB(
        first_name=user_data.first_name,
        second_name=user_data.second_name,
        email=user_data.email,
        password_hash=user_data.password,
        role=user_data.role or "user",
        icon=user_data.icon or 1,
        is_verified=user_data.is_verified if user_data.is_verified is not None else False
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    access_token = create_access_token(
        user_id=new_user.id,
        first_name=new_user.first_name,
        second_name=new_user.second_name,
        email=new_user.email,
        role=new_user.role
    )
    return {"access_token": access_token}
