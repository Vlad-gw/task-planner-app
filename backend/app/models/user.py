from sqlalchemy import Boolean, BigInteger, Integer, VARCHAR
from sqlalchemy.orm import mapped_column, Mapped
from app.models.base import Base


class UserDB(Base):
    __tablename__ = "users"
    __table_args__ = {"schema": "punctualis"}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, index=True, autoincrement=True)
    first_name: Mapped[str] = mapped_column(VARCHAR(20))
    second_name: Mapped[str] = mapped_column(VARCHAR(50))
    email: Mapped[str] = mapped_column(VARCHAR(50), nullable=False, unique=True)
    password_hash: Mapped[str] = mapped_column(VARCHAR(265), nullable=False)
    role: Mapped[str] = mapped_column(VARCHAR(5), nullable=False, default="user")
    is_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    icon: Mapped[int] = mapped_column(Integer, nullable=True)
