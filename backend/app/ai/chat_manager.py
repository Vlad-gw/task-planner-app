from datetime import datetime, timedelta
from typing import Optional

from sqlalchemy.orm import Session
from backend.app.crud.messages import create_message
from backend.app.crud.tasks import get_tasks_by_filter, create_task
from backend.app.db.session import get_db
from backend.app.models.task import TaskDB
from backend.app.models.tasklist import TaskListDB
from backend.app.schemas.message import MessageRequest, MessageResponse
import logging
from backend.app.schemas.task import TaskDetails
from backend.app.schemas.taskcreate import TaskCreate

logger = logging.getLogger(__name__)


class ChatManager:
    def __init__(self, ai_service):
        self.ai = ai_service
        logger.info("ChatManager initialized")

        self.handlers = {
            'priority_tasks': {
                'keywords': [
                    "самые важные",
                    "высокий приоритет",
                    "самый высокий приоритет",
                    "задача с высоким приоритетом",
                    "важнейшие задачи",
                    "самая важная задача",
                    "какая важная задача",
                    "что самое важное"
                ],
                'handler': self._handle_priority_tasks
            },
            'nearest_task': {
                'keywords': [
                    "ближайшая задача",
                    "следующая задача",
                    "что ближайшее",
                    "что следующее"
                ],
                'handler': self._handle_nearest_task
            },
            'task_by_name': {
                'keywords': [
                    "на какое время"
                    "на какое время у меня задача",
                    "назначено на",
                    "когда задача",
                    "информация о задаче"
                ],
                'handler': self._handle_task_by_name
            },
            'all_tasks': {
                'keywords': [
                    "какие у меня есть задачи",
                    "список моих задач",
                    "все задачи",
                    "список задач",
                    "мои задачи",
                    "покажи задачи"
                ],
                'handler': self._handle_all_tasks
            },
            'create_task': {
                'keywords': [
                    "создай задачу",
                    "добавь задачу",
                    "новая задача",
                    "запланируй"
                ],
                'handler': self._handle_create_task
            }
        }

    async def handle_message(self, user_id: int, first_name: str, request: MessageRequest) -> MessageResponse:
        db = next(get_db())
        try:
            logger.info(f"Processing message from user {user_id} ({first_name})")
            db = db if db else next(get_db())

            message_lower = request.message.lower()
            ai_response = "Не удалось обработать запрос. Пожалуйста, попробуйте еще раз."

            if any(x in message_lower for x in ["на какое время", "во сколько", "когда задача"]):
                task_name = self._extract_task_name(message_lower)
                if task_name:
                    tasks = self.ai._find_task_by_name(db, user_id, task_name)
                    if tasks:
                        if len(tasks) == 1:
                            task = tasks[0]
                            if task.scheduled_at:
                                time_str = datetime.fromtimestamp(task.scheduled_at).strftime("%d.%m.%Y в %H:%M")
                                ai_response = f"{first_name}, задача «{task.title}» назначена на {time_str}"
                            else:
                                ai_response = f"{first_name}, у задачи «{task.title}» не указано время"
                        else:
                            tasks_list = "\n".join(
                                f"- {t.title} (на {datetime.fromtimestamp(t.scheduled_at).strftime('%d.%m.%Y в %H:%M') if t.scheduled_at else 'без даты'})"
                                for t in tasks
                            )
                            ai_response = f"{first_name}, найдено несколько задач по запросу «{task_name}»:\n{tasks_list}"
                    else:
                        ai_response = f"{first_name}, задача не найдена"
                else:
                    ai_response = f"{first_name}, не понял, о какой задаче идет речь"

            elif any(x in message_lower for x in ["задачи с приоритетом", "приоритетом"]):
                priority = self._extract_priority(message_lower)
                if priority:
                    tasks = db.query(TaskDB).join(TaskListDB) \
                        .filter(TaskListDB.user_id == user_id) \
                        .filter(TaskDB.priority == priority) \
                        .order_by(TaskDB.scheduled_at.asc()) \
                        .all()

                    if tasks:
                        tasks_list = "\n".join(f"- {t.title}" for t in tasks)
                        ai_response = f"{first_name}, ваши задачи с приоритетом {priority}:\n{tasks_list}"
                    else:
                        ai_response = f"{first_name}, у вас нет задач с приоритетом {priority}"
                else:
                    ai_response = f"{first_name}, не понял, какой приоритет вас интересует"

            else:
                for handler_type, handler_data in self.handlers.items():
                    if any(keyword in message_lower for keyword in handler_data['keywords']):
                        ai_response = await handler_data['handler'](db, user_id, first_name, request.message)
                        break
                else:
                    ai_response = await self._handle_default(db, user_id, first_name, request.message)

            if not ai_response:
                ai_response = f"{first_name}, не удалось обработать ваш запрос. Пожалуйста, попробуйте сформулировать иначе."

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

    def _extract_task_name(self, message: str) -> Optional[str]:
        message_lower = message.lower()

        patterns = [
            ("на какое время у меня задача", 1),
            ("когда задача", 1),
            ("информация о задаче", 1),
            ("назначено на", 0),
            ("задача", 1),
            ("дело", 1),
            ("план", 1)
        ]

        for pattern, part in patterns:
            if pattern in message_lower:
                parts = message.split(pattern)
                if len(parts) > 1:
                    name = parts[part].strip()
                    name = name.rstrip('?').rstrip('.').rstrip(',').strip('"').strip("'")
                    if name:
                        return name

        words = message.split()
        if len(words) > 2:
            return ' '.join(words[-2:])

        return None

    def _extract_priority(self, message: str) -> Optional[int]:
        for i in range(1, 6):
            if f"приоритетом {i}" in message or f"приоритет {i}" in message:
                return i
        return None

    async def _handle_priority_tasks(self, db: Session, user_id: int, first_name: str, message: str) -> str:
        tasks = self.ai._get_priority_tasks(db, user_id)
        if not tasks:
            return f"{first_name}, у вас нет задач с высоким приоритетом."

        max_priority = tasks[0].priority
        if max_priority == 5:
            priority_desc = "высший приоритет (5)"
        else:
            priority_desc = f"приоритет {max_priority}"

        if len(tasks) == 1:
            task = tasks[0]
            time_str = datetime.fromtimestamp(task.scheduled_at).strftime(
                "%d.%m.%Y в %H:%M") if task.scheduled_at else "без указания даты"
            return f"{first_name}, ваша самая важная задача ({priority_desc}): «{task.title}» на {time_str}"
        else:
            tasks_list = "\n".join(f"- {t.title} (приоритет: {t.priority})" for t in tasks)
            return f"{first_name}, ваши самые важные задачи ({priority_desc}):\n{tasks_list}"

    async def _handle_nearest_task(self, db: Session, user_id: int, first_name: str, message: str) -> str:
        task = self.ai._get_nearest_task(db, user_id)
        if not task:
            return f"{first_name}, у вас нет предстоящих задач."

        time_str = datetime.fromtimestamp(task.scheduled_at).strftime("%d.%m.%Y в %H:%M")
        return f"{first_name}, ваша ближайшая задача: «{task.title}» на {time_str}, приоритет: {task.priority}"

    async def _handle_task_by_name(self, db: Session, user_id: int, first_name: str, message: str) -> str:
        task_name = self._extract_task_name(message)
        if not task_name:
            return f"{first_name}, не понял, о какой задаче идет речь"

        tasks = self.ai._find_task_by_name(db, user_id, task_name)
        if not tasks:
            return f"{first_name}, задача «{task_name}» не найдена."

        if len(tasks) == 1:
            task = tasks[0]
            time_str = datetime.fromtimestamp(task.scheduled_at).strftime(
                "%d.%m.%Y в %H:%M") if task.scheduled_at else "не указано"
            return f"{first_name}, задача «{task.title}» назначена на {time_str}, приоритет: {task.priority}"
        else:
            tasks_list = "\n".join(
                f"- {t.title} (на {datetime.fromtimestamp(t.scheduled_at).strftime('%d.%m.%Y в %H:%M') if t.scheduled_at else 'без даты'}, приоритет: {t.priority})"
                for t in tasks
            )
            return f"{first_name}, найдено несколько задач по запросу «{task_name}»:\n{tasks_list}"

    async def _handle_all_tasks(self, db: Session, user_id: int, first_name: str, message: str) -> str:
        tasks = self.ai._get_all_user_tasks(db, user_id)
        if not tasks:
            return f"{first_name}, у вас пока нет задач."

        tasks_list = "\n".join(f"- {t.title} (приоритет: {t.priority})" for t in tasks)
        return f"{first_name}, вот все ваши задачи:\n{tasks_list}"

    async def _handle_create_task(self, db: Session, user_id: int, first_name: str, message: str) -> str:
        task_details = self.ai.extract_task_details(message, first_name)
        if not task_details or not task_details.title:
            return self.ai.generate_response(message, first_name, "system_prompt")

        task_create = TaskCreate(
            title=task_details.title[:50],
            description=task_details.description,
            priority=task_details.priority or 3,
            creation_date=int(datetime.now().timestamp()),
            finish_date=task_details.scheduled_at,
            is_done=False,
            time_reminder=task_details.time_reminder,
            scheduled_at=task_details.scheduled_at
        )

        created_task = create_task(db, task_create, user_id)
        if not created_task:
            return f"{first_name}, не удалось создать задачу. Пожалуйста, попробуйте еще раз."

        response = f"{first_name}, задача «{created_task.title}»"
        if created_task.scheduled_at:
            task_time = datetime.fromtimestamp(created_task.scheduled_at)
            response += f" на {task_time.strftime('%d.%m.%Y в %H:%M')}"
        response += " успешно создана"
        return response

    async def _handle_default(self, db: Session, user_id: int, first_name: str, message: str) -> str:
        request_type = self.ai.determine_request_type(message)
        if request_type == "query":
            return self.ai.generate_task_query_response(db, user_id, first_name, message)
        else:
            return await self._handle_create_task(db, user_id, first_name, message)

    def _is_task_filter_request(self, message: str) -> bool:
        task_keywords = [
            "задачи", "покажи", "фильтр", "список",
            "мои задачи", "самая важная", "приоритет",
            "важные задачи", "какие задачи"
        ]
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
