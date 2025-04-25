from sqlalchemy import String, BigInteger
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import Base


class TagDB(Base):
    __tablename__ = "tags"
    __table_args__ = {"schema": "punctualis"}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, index=True, autoincrement=True)
    tag_name: Mapped[str] = mapped_column(String(50))
    color: Mapped[str] = mapped_column(String(6))
