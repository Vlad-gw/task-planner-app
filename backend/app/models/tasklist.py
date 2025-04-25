from sqlalchemy import BigInteger, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import Base


class TaskListDB(Base):
    __tablename__ = "task_lists"
    __table_args__ = {"schema": "punctualis"}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, index=True, autoincrement=True)
    task_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("tasks.id"))
    user_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("users.id"))
