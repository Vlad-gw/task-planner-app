from datetime import datetime, timezone, timedelta
import random
from sqlalchemy.orm import Session
from backend.app.models.verificationcode import VerificationCodeDB
from backend.app.email_service.mail import send_letter


def generate_verification_code() -> str:
    return ''.join([str(random.randint(0, 9)) for _ in range(6)])


def generate_expiration_time():
    dt_utc_aware = datetime.now(timezone.utc)
    expiration_dt = dt_utc_aware + timedelta(minutes=10)
    unix_timestamp = int(expiration_dt.timestamp())
    return unix_timestamp


def create_verification_code(db: Session) -> VerificationCodeDB:
    value = generate_verification_code()
    expires = generate_expiration_time()

    db_code = VerificationCodeDB(value=value, expires=expires)
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


def create_and_send_verification_code(db: Session, first_name: str, second_name: str, email: str):
    code_obj = create_verification_code(db)
    send_letter(first_name, second_name, email, code_obj.value)
    return code_obj
