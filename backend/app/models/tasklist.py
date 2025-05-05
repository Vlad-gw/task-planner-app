from sqlalchemy import BigInteger, ForeignKey, PrimaryKeyConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship
from backend.app.models.base import Base


class TaskListDB(Base):
    __tablename__ = "task_lists"
    __table_args__ = (
        PrimaryKeyConstraint("task_id", "user_id"),
        {"schema": "punctualis"},
    )

    task_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("punctualis.tasks.id", ondelete="CASCADE"))
    user_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("punctualis.users.id"))
    task = relationship("TaskDB", back_populates="task_lists")
