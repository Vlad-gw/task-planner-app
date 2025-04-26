from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from backend.app.schemas.tag import Tag
from backend.app.crud.tags import create_tag, get_tags, update_tag, delete_tag, get_all_tags
from backend.app.db.session import get_db
from backend.app.schemas.tagupdate import TagUpdate

router = APIRouter()


@router.get("/Get_all_tags", response_model=List[Tag])
def read_all_tags(db: Session = Depends(get_db)):
    return get_all_tags(db)


@router.get("/Get_one_tag", response_model=List[Tag])
def read_tag(id: int = Query(..., description="ID тега, required field"),
             db: Session = Depends(get_db)):
    return get_tags(db, id=id)


@router.post("/Create_tag", response_model=Tag)
def create(tag: Tag, db: Session = Depends(get_db)):
    return create_tag(db, tag)


@router.put("/Update_tag", response_model=Tag)
def update(id: int, tag_data: TagUpdate, db: Session = Depends(get_db)):
    return update_tag(db, id, tag_data)


@router.delete("/Delete_tag")
def delete(id: int, db: Session = Depends(get_db)):
    deleted = delete_tag(db, id)
    if deleted:
        return {"message": f"Tag with id={id} deleted"}
    return {"message": "Tag not found"}
