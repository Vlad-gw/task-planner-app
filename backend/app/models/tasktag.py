from sqlalchemy import BigInteger, ForeignKey, PrimaryKeyConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship
from backend.app.models.base import Base


class TaskTagDB(Base):
    __tablename__ = "task_tags"
    __table_args__ = (
        PrimaryKeyConstraint("task_id", "tag_id", name="pk_task_tag"),
        {"schema": "punctualis"},
    )

    task_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey("punctualis.tasks.id", ondelete="CASCADE"),
        nullable=False
    )
    tag_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey("punctualis.tags.id", ondelete="CASCADE"),
        nullable=False
    )

    task: Mapped["TaskDB"] = relationship(
        "TaskDB",
        back_populates="task_tags"
    )
    tag: Mapped["TagDB"] = relationship(
        "TagDB",
        back_populates="tag_tasks"
    )
