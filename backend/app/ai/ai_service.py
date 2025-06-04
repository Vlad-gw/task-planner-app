from datetime import datetime, timedelta
from typing import Optional
from langchain_together import Together
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from pathlib import Path
import os

from sqlalchemy import func

from backend.app.ai.chat_manager import logger
from backend.app.db.session import get_db
from backend.app.models.task import TaskDB
from backend.app.models.tasklist import TaskListDB
from backend.app.schemas.task import TaskFilter, TaskDetails


class AIService:
    def __init__(self,
                 model_name: str = "mistralai/Mixtral-8x7B-Instruct-v0.1",
                 together_api_key: str = "ce474e02c5423075638e98389897bb71436694ad921e34541eca88618b85f49b"):
        self.llm = Together(
            model=model_name,
            temperature=0.1,
            max_tokens=50,
            top_k=10,
            top_p=0.7,
            repetition_penalty=1.2,
            together_api_key=together_api_key
        )
        self.prompts = self._load_prompts()

    def _load_prompts(self):
        prompts = {}
        prompt_dir = os.path.join(os.path.dirname(__file__), "prompts")
        prompt_files = Path(prompt_dir).glob("*.txt")

        for file in prompt_files:
            with open(file, "r", encoding="utf-8") as f:
                prompts[file.stem] = f.read().strip()
        return prompts

    def extract_task_details(self, user_input: str, first_name: str) -> Optional[TaskDetails]:
        current_date = datetime.now().strftime("%d.%m.%Y")
        prompt = f"""
        Извлеки детали задачи. Формат ответа:
        Название: [название]
        Описание: [описание]
        Дата: [DD.MM.YYYY или "завтра"/"послезавтра"]
        Время: [HH:MM или "X утра"/"Y вечера"]
        Приоритет: [1-5]

        Пример для "выбросить мусор завтра в 8 утра":
        Название: выбросить мусор
        Описание: None
        Дата: завтра
        Время: 08:00
        Приоритет: None

        Текущая дата: {current_date}
        Сообщение: "{user_input}"
        """

        try:
            response = self.llm.invoke(prompt)
            logger.debug(f"LLM response: {response}")
            return self._parse_task_response(response)
        except Exception as e:
            logger.error(f"Error extracting task: {str(e)}")
            return None

    def _parse_task_response(self, response: str) -> Optional[TaskDetails]:
        try:
            details = {
                "title": "",
                "description": None,
                "priority": None,
                "scheduled_at": None,
                "time_reminder": None
            }

            for line in response.split('\n'):
                line = line.strip()
                if not line:
                    continue

                if line.startswith("Название:"):
                    details["title"] = line.split(":", 1)[1].strip()[:50]
                elif line.startswith("Описание:"):
                    desc = line.split(":", 1)[1].strip()
                    details["description"] = desc if desc.lower() != "none" else None
                elif line.startswith("Приоритет:"):
                    prio = line.split(":", 1)[1].strip()
                    if prio.isdigit() and 1 <= int(prio) <= 5:
                        details["priority"] = int(prio)

            date_str = time_str = None
            for line in response.split('\n'):
                line = line.strip()
                if line.startswith("Дата:"):
                    date_str = line.split(":", 1)[1].strip()
                elif line.startswith("Время:"):
                    time_str = line.split(":", 1)[1].strip()

            if time_str:
                if "утра" in time_str:
                    time_str = time_str.replace("утра", "").strip()
                    time_str = f"{int(time_str):02d}:00"
                elif "вечера" in time_str:
                    hours = int(time_str.replace("вечера", "").strip())
                    time_str = f"{hours + 12 if hours < 12 else hours}:00"

            if date_str or time_str:
                try:
                    if date_str in ["завтра", "послезавтра"]:
                        days = 1 if date_str == "завтра" else 2
                        date_obj = datetime.now() + timedelta(days=days)
                        date_str = date_obj.strftime("%d.%m.%Y")

                    datetime_str = f"{date_str or datetime.now().strftime('%d.%m.%Y')} {time_str or '00:00'}"
                    dt = datetime.strptime(datetime_str, "%d.%m.%Y %H:%M")
                    timestamp = int(dt.timestamp())
                    details["scheduled_at"] = timestamp
                    details["time_reminder"] = timestamp if time_str else None
                except Exception as e:
                    logger.error(f"Datetime parsing error: {str(e)}")

            if not details["title"]:
                return None

            return TaskDetails(**details)
        except Exception as e:
            logger.error(f"Error parsing response: {str(e)}")
            return None

    def parse_task_filter(self, message: str, user_id: int) -> TaskFilter:
        filter = TaskFilter(
            user_ids=[user_id],
            priority=None
        )

        if "приоритетом 1" in message.lower():
            filter.priority = 1
        elif "приоритетом 2" in message.lower():
            filter.priority = 2
        elif "приоритетом 3" in message.lower():
            filter.priority = 3
        elif "приоритетом 4" in message.lower():
            filter.priority = 4
        elif "приоритетом 5" in message.lower():
            filter.priority = 5
        elif "высокий приоритет" in message.lower():
            filter.priority = 4
        elif "низкий приоритет" in message.lower():
            filter.priority = 2

        return filter

    def generate_response(self, user_input: str, first_name: str, prompt_type: str = "system_prompt") -> str:
        current_date = datetime.now().strftime("%d.%m.%Y")
        prompt_template = self.prompts.get(prompt_type, "")

        if not prompt_template:
            logger.error(f"Prompt template '{prompt_type}' not found!")
            return f"{first_name}, произошла техническая ошибка. Пожалуйста, попробуйте позже."

        logger.info(f"Generating response for: {first_name}")
        logger.debug(f"Prompt template: {prompt_template[:200]}...")

        try:
            formatted_prompt = prompt_template.format(
                current_date=current_date,
                first_name=first_name
            )

            prompt = ChatPromptTemplate.from_messages([
                ("system", formatted_prompt),
                ("human", "{input}")
            ])

            chain = prompt | self.llm | StrOutputParser()

            logger.debug(f"Full prompt: {formatted_prompt[:300]}...")

            response = chain.invoke({"input": user_input})
            logger.info(f"Generated response: {response[:100]}...")

            if not response.startswith(f"{first_name},"):
                response = f"{first_name}, {response}"

            return response

        except Exception as e:
            logger.error(f"Error in generate_response: {str(e)}", exc_info=True)
            return f"{first_name}, произошла техническая ошибка. Пожалуйста, попробуйте позже."

    def determine_request_type(self, user_input: str) -> str:
        prompt = self.prompts.get("task_query_prompt", "")
        response = self.llm.invoke(prompt + "\nЗапрос: " + user_input)

        if "Тип: запрос" in response:
            return "query"
        return "create"

    def generate_task_query_response(self, db: get_db, user_id: int, first_name: str, query: str) -> str:
        query_lower = query.lower()

        priority_keywords = [
            "самые важные",
            "высокий приоритет",
            "самый высокий приоритет",
            "задача с высоким приоритетом",
            "важнейшие задачи",
            "самая важная задача",
            "какая важная задача",
            "что самое важное"
        ]

        if any(keyword in query_lower for keyword in priority_keywords):
            max_priority = db.query(func.max(TaskDB.priority)) \
                .join(TaskListDB) \
                .filter(TaskListDB.user_id == user_id) \
                .scalar()

            if not max_priority:
                return f"{first_name}, у вас пока нет задач."

            tasks = db.query(TaskDB) \
                .join(TaskListDB) \
                .filter(TaskListDB.user_id == user_id) \
                .filter(TaskDB.priority == max_priority) \
                .order_by(TaskDB.scheduled_at.asc()) \
                .all()

            if not tasks:
                return f"{first_name}, у вас нет задач с высоким приоритетом."

            if max_priority == 5:
                priority_desc = "высший приоритет (5)"
            else:
                priority_desc = f"максимальный приоритет ({max_priority})"

            if len(tasks) == 1:
                task = tasks[0]
                time_str = datetime.fromtimestamp(task.scheduled_at).strftime(
                    "%d.%m.%Y в %H:%M") if task.scheduled_at else "без указания даты"
                return (f"{first_name}, ваша самая важная задача ({priority_desc}): "
                        f"«{task.title}» на {time_str}")
            else:
                tasks_list = "\n".join(f"- {t.title}" for t in tasks)
                return f"{first_name}, ваши самые важные задачи ({priority_desc}):\n{tasks_list}"

    def _get_all_user_tasks(self, db: get_db, user_id: int) -> list:
        return db.query(TaskDB) \
            .join(TaskListDB) \
            .filter(TaskListDB.user_id == user_id) \
            .order_by(TaskDB.priority.desc(), TaskDB.scheduled_at.asc()) \
            .all()

    def _get_priority_tasks(self, db: get_db, user_id: int) -> list:
        priority_5_tasks = db.query(TaskDB) \
            .join(TaskListDB) \
            .filter(TaskListDB.user_id == user_id) \
            .filter(TaskDB.priority == 5) \
            .order_by(TaskDB.scheduled_at.asc()) \
            .all()

        if priority_5_tasks:
            return priority_5_tasks

        max_priority = db.query(func.max(TaskDB.priority)) \
            .join(TaskListDB) \
            .filter(TaskListDB.user_id == user_id) \
            .scalar()

        if not max_priority:
            return []

        return db.query(TaskDB) \
            .join(TaskListDB) \
            .filter(TaskListDB.user_id == user_id) \
            .filter(TaskDB.priority == max_priority) \
            .order_by(TaskDB.scheduled_at.asc()) \
            .all()

    def _get_nearest_task(self, db: get_db, user_id: int) -> Optional[TaskDB]:
        now = datetime.now().timestamp()
        return db.query(TaskDB) \
            .join(TaskListDB) \
            .filter(TaskListDB.user_id == user_id) \
            .filter(TaskDB.is_done == False) \
            .filter(TaskDB.scheduled_at >= now) \
            .order_by(TaskDB.scheduled_at.asc()) \
            .first()

    def _find_task_by_name(self, db: get_db, user_id: int, task_name: str) -> list[TaskDB]:
        if not task_name or len(task_name) < 2:
            return []

        words = task_name.split()
        queries = []

        for word in words:
            if len(word) >= 2:
                queries.append(TaskDB.title.ilike(f"%{word}%"))

        if not queries:
            return []

        return db.query(TaskDB) \
            .join(TaskListDB) \
            .filter(TaskListDB.user_id == user_id) \
            .filter(*queries) \
            .order_by(TaskDB.priority.desc(), TaskDB.scheduled_at.asc()) \
            .all()
