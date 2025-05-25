from jose import jwt, JWTError
from datetime import datetime, timedelta, timezone
from fastapi import HTTPException, Depends, status
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordBearer

from backend.app.db.session import get_db
from backend.app.models.user import UserDB
import uuid

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/Auth/Login")

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


async def get_current_user(
        token: str = Depends(oauth2_scheme),
        db: Session = Depends(get_db)
) -> UserDB:
    try:
        user_data = decode_token(token)
        user = db.query(UserDB).filter(UserDB.id == user_data["id"]).first()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )

        return user

    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )
