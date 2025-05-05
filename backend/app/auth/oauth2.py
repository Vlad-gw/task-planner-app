from jose import jwt, JWTError
from datetime import datetime, timedelta, timezone
from fastapi import HTTPException, Depends, Request
from sqlalchemy.orm import Session

from backend.app.db.session import get_db
from backend.app.models.user import UserDB
import uuid

SECRET_KEY = "super-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


def create_access_token(user_id: int, first_name: str, second_name: str, email: str, role: str = "user"):
    to_encode = {
        "user_id": user_id,
        "first_name": first_name,
        "second_name": second_name,
        "email": email,
        "role": role,
        "jti": str(uuid.uuid4()),
        "exp": datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    }
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("user_id")
        first_name = payload.get("first_name")
        second_name = payload.get("second_name")
        email = payload.get("email")
        role = payload.get("role")

        if user_id is None:
            raise HTTPException(status_code=401, detail="Токен не содержит user_id")

        return {
            "id": user_id,
            "first_name": first_name,
            "second_name": second_name,
            "email": email,
            "role": role,
        }
    except JWTError:
        raise HTTPException(status_code=401, detail="Недействительный токен")


def get_current_user(request: Request, db: Session = Depends(get_db)) -> UserDB:
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Отсутствует токен авторизации")

    token = auth_header.split(" ")[1]
    user_data = decode_token(token)

    user = db.query(UserDB).filter(UserDB.id == user_data["id"]).first()
    if user is None:
        raise HTTPException(status_code=404, detail="Пользователь не найден")

    user.first_name = user_data["first_name"]
    user.second_name = user_data["second_name"]
    user.email = user_data["email"]
    user.role = user_data["role"]

    return user
