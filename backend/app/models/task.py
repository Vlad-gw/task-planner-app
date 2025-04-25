from sqlalchemy import Integer, String, Text, Boolean, BigInteger, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import Base


class TaskDB(Base):
    __tablename__ = "tasks"
    __table_args__ = {"schema": "punctualis"}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, index=True, autoincrement=True)
    title: Mapped[str] = mapped_column(String(50))
    description: Mapped[str] = mapped_column(Text, nullable=True)
    list_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("task_lists.id"))
    priority: Mapped[int] = mapped_column(Integer)
    creation_date: Mapped[int] = mapped_column(BigInteger)
    finish_date: Mapped[int] = mapped_column(BigInteger, nullable=True)
    is_done: Mapped[bool] = mapped_column(Boolean, default=False)
    time_reminder: Mapped[int] = mapped_column(BigInteger, nullable=True)
    scheduled_at: Mapped[int] = mapped_column(BigInteger, nullable=True)
