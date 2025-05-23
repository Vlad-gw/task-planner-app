from typing import Dict, Any
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.utils import get_openapi
from fastapi.security import OAuth2PasswordBearer

from backend.app.auth import routers as auth_routers
from backend.app.routers import (
    users, tasks, tags,
    verification_codes
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/Auth/Login")

app = FastAPI(
    title="AI Personal Assistant API",
    description="API for personal assistant-planner",
    version="1.0.0",
    swagger_ui_init_oauth={
        "clientId": "your-client-id",
        "usePkceWithAuthorizationCodeGrant": True,
        "appName": "Task Planner App"
    }
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://0.0.0.0:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users.router, prefix="/Users", tags=["Users"])
app.include_router(tasks.router, prefix="/Tasks", tags=["Tasks"])
app.include_router(tags.router, prefix="/Tags", tags=["Tags"])
app.include_router(verification_codes.router, prefix="/Verification_codes", tags=["Verification_codes"])
app.include_router(auth_routers.router)


def custom_openapi() -> Dict[str, Any]:
    if app.openapi_schema:
        return app.openapi_schema


openapi_schema = get_openapi(
    title="AI Personal Assistant API",
    version="1.0.0",
    description="API for personal assistant-planner",
    routes=app.routes,
)
openapi_schema["components"]["securitySchemes"] = {
    "BearerAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT"
    }
}

for path in openapi_schema["paths"]:
    for method in openapi_schema["paths"][path]:
        openapi_schema["paths"][path][method]["security"] = [{"BearerAuth": []}]
app.openapi_schema = openapi_schema

app.openapi = custom_openapi

if __name__ == "__main__":
    import uvicorn

    uvicorn.run("backend.app.main:app", host="0.0.0.0", port=8080, reload=True)
