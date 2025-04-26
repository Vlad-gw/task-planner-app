from fastapi import Depends, HTTPException
from backend.app.auth.oauth2 import get_current_user
from backend.app.models.user import UserDB


def require_role(role: str):
    def role_checker(current_user: UserDB = Depends(get_current_user)):
        if current_user.role != role:
            raise HTTPException(
                status_code=403,
                detail=f"Доступ запрещён: требуется роль '{role}'"
            )
        return current_user

    return role_checker
