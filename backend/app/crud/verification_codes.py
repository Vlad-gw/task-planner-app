from sqlalchemy.orm import Session
from backend.app.models.verificationcode import VerificationCodeDB
from backend.app.schemas.verificationcode import VerificationCode


def create_verification_code(db: Session, code: VerificationCode):
    db_code = VerificationCodeDB(**code.model_dump())
    db.add(db_code)
    db.commit()
    db.refresh(db_code)
    return db_code


def get_verification_codes(db: Session, id: int = None, expires: int = None):
    query = db.query(VerificationCodeDB)
    if id:
        query = query.filter(VerificationCodeDB.id == id)
    if expires:
        query = query.filter(VerificationCodeDB.expires == expires)
    return query.all()


def delete_verification_code(db: Session, id: int):
    db_code = db.query(VerificationCodeDB).filter(VerificationCodeDB.id == id).first()
    if db_code:
        db.delete(db_code)
        db.commit()
    return db_code
