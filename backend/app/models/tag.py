from sqlalchemy import String, BigInteger
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy.orm import Mapped, mapped_column, relationship
from backend.app.models.base import Base


class TagDB(Base):
    __tablename__ = "tags"
    __table_args__ = {"schema": "punctualis"}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, index=True, autoincrement=True)
    tag_name: Mapped[str] = mapped_column(String(50))
    color: Mapped[str] = mapped_column(String(6))
    task_tags = relationship("TaskTagDB", back_populates="tag", cascade="all, delete-orphan")
    tasks = association_proxy("task_tags", "task")
    tag_tasks: Mapped[list["TaskTagDB"]] = relationship("TaskTagDB", back_populates="tag", cascade="all, delete-orphan")
