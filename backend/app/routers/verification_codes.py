from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from backend.app.schemas.verificationcode import VerificationCode
from backend.app.crud.verification_codes import create_verification_code, get_verification_codes, \
    delete_verification_code
from backend.app.db.session import get_db

router = APIRouter()


@router.get("/Get_one_verification_code", response_model=List[VerificationCode])
def get_verification_code_view(id: Optional[int] = None, expires: Optional[int] = None, db: Session = Depends(get_db)):
    return get_verification_codes(db, id, expires)


@router.post("/Create_verification_code", response_model=VerificationCode)
def create_verification_code_view(db: Session = Depends(get_db)):
    return create_verification_code(db)


@router.delete("/Delete_verification_code", summary="Delete verification code")
def delete_verification_code_view(id: int, db: Session = Depends(get_db)):
    deleted = delete_verification_code(db, id)
    if deleted:
        return {"message": f"Verification code with id={id} deleted"}
    return {"message": "Verification cod not found"}
