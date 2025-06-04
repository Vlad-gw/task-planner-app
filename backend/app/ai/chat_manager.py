from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from backend.app.crud.messages import create_message
from backend.app.crud.tasks import get_tasks_by_filter, create_task
from backend.app.db.session import get_db
from backend.app.schemas.message import MessageRequest, MessageResponse
import logging

from backend.app.schemas.task import TaskDetails
from backend.app.schemas.taskcreate import TaskCreate

logger = logging.getLogger(__name__)


class ChatManager:
    def __init__(self, ai_service):
        self.ai = ai_service
        logger.info("ChatManager initialized")

    async def handle_message(self, user_id: int, first_name: str, request: MessageRequest) -> MessageResponse:
        db = next(get_db())
        try:
            logger.info(f"Processing message from user {user_id} ({first_name})")
            db = db if db else next(get_db())

            if self._is_task_filter_request(request.message):
                ai_response = await self._handle_task_filter_request(db, user_id, first_name, request.message)
            else:
                request_type = self.ai.determine_request_type(request.message)

                if request_type == "query":
                    ai_response = self.ai.generate_task_query_response(db, user_id, first_name, request.message)
                else:

                    ai_response = await self._handle_regular_message(db, user_id, first_name, request.message)

            current_time = int(datetime.now().timestamp())

            user_message = create_message(
                db=db,
                message=request.message,
                user_id=user_id,
                sent_at=current_time
            )
            logger.info(f"User message saved with ID {user_message.id}")

            ai_message = create_message(
                db=db,
                message=ai_response,
                user_id=0,
                sent_at=int(datetime.now().timestamp())
            )
            logger.info(f"AI response saved with ID {ai_message.id}")

            db.commit()
            logger.info("Transaction committed")

            return MessageResponse(
                id=user_message.id,
                message=ai_response,
                user_id=user_id,
                sent_at=user_message.sent_at
            )

        except Exception as e:
            logger.error(f"Error: {str(e)}", exc_info=True)
            if db:
                db.rollback()
                logger.error("Transaction rolled back")
            raise
        finally:
            if db:
                db.close()
                logger.info("Database session closed")

    def _is_task_filter_request(self, message: str) -> bool:
        task_keywords = ["задачи", "покажи", "фильтр", "список", "мои задачи"]
        return any(keyword in message.lower() for keyword in task_keywords)

    async def _handle_task_filter_request(self, db: Session, user_id: int, first_name: str, message: str) -> str:

        try:
            db = db if db else next(get_db())
            filter = self.ai.parse_task_filter(message, user_id)
            tasks = get_tasks_by_filter(db, filter)

            if not tasks:
                return f"{first_name}, по вашему запросу задач не найдено"

            user_tasks = [task for task in tasks if any(
                task_list.user_id == user_id for task_list in task.task_lists
            )]

            if not user_tasks:
                return f"{first_name}, у вас нет задач с указанными параметрами"

            tasks_list = "\n".join(
                f"- {task.title} (приоритет: {task.priority})"
                for task in user_tasks
                if task.title
            )
            return f"{first_name}, вот ваши задачи:\n{tasks_list}"

        except Exception as e:
            logger.error(f"Error in task filter: {str(e)}", exc_info=True)
            return f"{first_name}, произошла ошибка при поиске задач. Пожалуйста, попробуйте позже."

    async def _handle_regular_message(self, db: Session, user_id: int, first_name: str, message: str) -> str:
        db_session = None
        try:
            task_details = self.ai.extract_task_details(message, first_name)

            if task_details and task_details.title:
                logger.info(f"Creating task from message: {message}")

                db_session = next(get_db()) if db is None else db

                task_create = self._prepare_task_create(task_details, user_id)
                logger.debug(f"TaskCreate object: {task_create}")

                created_task = create_task(db_session, task_create, user_id)

                if not created_task:
                    logger.error("Task creation returned None")
                    raise ValueError("Task creation failed")

                response = f"{first_name}, задача «{created_task.title}»"
                if created_task.scheduled_at:
                    task_time = datetime.fromtimestamp(created_task.scheduled_at)
                    response += f" на {task_time.strftime('%d.%m.%Y в %H:%M')}"
                response += " успешно создана"

                return response

            return self.ai.generate_response(message, first_name, "system_prompt")

        except Exception as e:
            logger.error(f"Error handling message: {str(e)}", exc_info=True)
            if db_session:
                db_session.rollback()
            return f"{first_name}, не удалось создать задачу. Пожалуйста, попробуйте еще раз."
        finally:
            if db is None and db_session:
                db_session.close()

    def _prepare_task_create(self, task_details: TaskDetails, user_id: int) -> TaskCreate:
        try:
            logger.debug(f"Preparing task from: {task_details}")

            return TaskCreate(
                title=task_details.title[:50],
                description=task_details.description,
                priority=task_details.priority or 3,
                creation_date=int(datetime.now().timestamp()),
                finish_date=task_details.scheduled_at,
                is_done=False,
                time_reminder=task_details.time_reminder,
                scheduled_at=task_details.scheduled_at
            )
        except Exception as e:
            logger.error(f"Error preparing task: {str(e)}")
            raise

    def _parse_relative_date(self, date_str: str, time_str: str = None) -> int:
        now = datetime.now()
        time_str = time_str or '00:00'

        date_str = date_str.lower().strip()

        if date_str == 'сегодня':
            delta = 0
        elif date_str == 'завтра':
            delta = 1
        elif date_str == 'послезавтра':
            delta = 2
        elif date_str.startswith('через'):
            try:
                delta = int(date_str.split()[1])
            except (IndexError, ValueError):
                delta = 1
        else:
            delta = 1

        target_date = now + timedelta(days=delta)

        try:
            hours, minutes = map(int, time_str.split(':'))
            target_date = target_date.replace(hour=hours, minute=minutes, second=0)
        except:
            target_date = target_date.replace(hour=0, minute=0, second=0)

        return int(target_date.timestamp())
