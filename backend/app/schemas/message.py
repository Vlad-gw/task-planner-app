from pydantic import BaseModel, Field


class MessageRequest(BaseModel):
    message: str = Field(..., min_length=1)


class MessageResponse(BaseModel):
    id: int
    message: str
    user_id: int
    sent_at: int

    class Config:
        from_attributes = True
