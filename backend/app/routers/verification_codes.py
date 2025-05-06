from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from backend.app.schemas.verificationcode import VerificationCode
from backend.app.schemas.verification import VerificationResponse, VerificationRequest
from backend.app.crud.verification_codes import create_verification_code, get_verification_codes, \
    delete_verification_code
from backend.app.db.session import get_db
from backend.app.models.user import UserDB
from backend.app.models.verificationcode import VerificationCodeDB
from backend.app.auth.oauth2 import get_current_user
from backend.app.crud.verification_codes import create_and_send_verification_code

router = APIRouter()


@router.get("/Get_one_verification_code", response_model=List[VerificationCode])
def get_verification_code(id: Optional[int] = None, expires: Optional[int] = None, db: Session = Depends(get_db)):
    return get_verification_codes(db, id, expires)


@router.post("/Create_verification_code", response_model=VerificationCode)
def create_verification_code(db: Session = Depends(get_db)):
    return create_verification_code(db)


@router.delete("/Delete_verification_code", summary="Delete verification code")
def delete_verification_code(id: int, db: Session = Depends(get_db)):
    deleted = delete_verification_code(db, id)
    if deleted:
        return {"message": f"Verification code with id={id} deleted"}
    return {"message": "Verification cod not found"}


@router.post("/Create_and_send_verification_code", response_model=VerificationCode)
def create_and_send_verification_code_for_users(
        db: Session = Depends(get_db),
        current_user: UserDB = Depends(get_current_user)
):
    try:
        code = create_and_send_verification_code(
            db=db,
            first_name=current_user.first_name,
            second_name=current_user.second_name,
            email=current_user.email
        )
        return VerificationCode.model_validate(code, from_attributes=True)
    except Exception as e:
        raise HTTPException(status_code=500, detail="Ошибка при создании или отправке кода")


@router.post("/Verify_code", response_model=VerificationResponse)
def verify_code(data: VerificationRequest, db: Session = Depends(get_db),
                current_user: UserDB = Depends(get_current_user)):
    code_entry = db.query(VerificationCodeDB).filter(VerificationCodeDB.value == data.code).first()

    if not code_entry:
        return VerificationResponse(success=False, detail="Неверный код")

    user = db.query(UserDB).filter(UserDB.email == current_user.email).first()
    if not user:
        return VerificationResponse(success=False, detail="Пользователь не найден")

    user.is_verified = True
    db.delete(code_entry)
    db.commit()

    return VerificationResponse(success=True, detail="Код подтверждён")
