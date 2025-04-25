from sqlalchemy import Text, BigInteger, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import Base


class MessageDB(Base):
    __tablename__ = "messages"
    __table_args__ = {"schema": "punctualis"}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, index=True, autoincrement=True)
    message: Mapped[str] = mapped_column(Text)
    user_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("users.id"))
