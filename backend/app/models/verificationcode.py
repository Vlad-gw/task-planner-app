from sqlalchemy import BigInteger, Integer
from sqlalchemy.orm import Mapped, mapped_column
from backend.app.models.base import Base


class VerificationCodeDB(Base):
    __tablename__ = "verification_codes"
    __table_args__ = {"schema": "punctualis"}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, index=True, autoincrement=True)
    value: Mapped[int] = mapped_column(Integer)
    expires: Mapped[int] = mapped_column(BigInteger, nullable=True)
