from pydantic import BaseModel


class VerificationRequest(BaseModel):
    code: str


class VerificationResponse(BaseModel):
    success: bool
    detail: str
