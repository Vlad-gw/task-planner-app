from sqlalchemy import Integer, String, Text, Boolean, BigInteger, ForeignKey
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy.orm import Mapped, mapped_column, relationship
from backend.app.models.base import Base


class TaskDB(Base):
    __tablename__ = "tasks"
    __table_args__ = {"schema": "punctualis"}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, index=True, autoincrement=True)
    title: Mapped[str] = mapped_column(String(50))
    description: Mapped[str] = mapped_column(Text, nullable=True)
    priority: Mapped[int] = mapped_column(Integer)
    creation_date: Mapped[int] = mapped_column(BigInteger)
    finish_date: Mapped[int] = mapped_column(BigInteger, nullable=True)
    is_done: Mapped[bool] = mapped_column(Boolean, default=False)
    time_reminder: Mapped[int] = mapped_column(BigInteger, nullable=True)
    scheduled_at: Mapped[int] = mapped_column(BigInteger, nullable=True)
    task_lists = relationship("TaskListDB", back_populates="task", passive_deletes=True)
    tag_associations: Mapped[list["TaskTagDB"]] = relationship(
        "TaskTagDB",
        back_populates="task",
        cascade="all, delete-orphan"
    )

    tags = association_proxy("tag_associations", "tag")
