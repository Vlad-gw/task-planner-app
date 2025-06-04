from fastapi import APIRouter, Depends, HTTPException
from backend.app.ai.ai_service import AIService
from backend.app.ai.chat_manager import ChatManager
from backend.app.auth.oauth2 import get_current_user
from backend.app.db.session import get_db
from backend.app.models.user import UserDB
from backend.app.schemas.message import MessageRequest, MessageResponse
from backend.app.ai.chat_manager import logger

router = APIRouter(prefix="/Chat", tags=["Chat"])
ai_service = AIService()
chat_manager = ChatManager(ai_service)


@router.post("/", response_model=MessageResponse)
async def chat_endpoint(
        request: MessageRequest,
        current_user: UserDB = Depends(get_current_user)
):
    db = None
    try:
        db = next(get_db())
        return await chat_manager.handle_message(
            user_id=current_user.id,
            first_name=current_user.first_name,
            request=request
        )
    except Exception as e:
        logger.error(f"Endpoint error: {str(e)}", exc_info=True)
        if db:
            db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if db:
            db.close()
