from sqlalchemy import BigInteger, ForeignKey, PrimaryKeyConstraint
from sqlalchemy.orm import Mapped, mapped_column
from backend.app.models.base import Base


class TaskListDB(Base):
    __tablename__ = "task_lists"
    __table_args__ = (
        PrimaryKeyConstraint("task_id", "user_id"),
        {"schema": "punctualis"},
    )

    task_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("punctualis.tasks.id"))
    user_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("punctualis.users.id"))
