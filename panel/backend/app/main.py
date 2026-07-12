from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.routers import auth
from app.routers import dashboard
from app.routers import users
from app.routers import settings


app = FastAPI(
    title="LAK Panel"
)


app.mount(
    "/static",
    StaticFiles(directory="app/static"),
    name="static"
)


app.include_router(auth.router)
app.include_router(dashboard.router)
app.include_router(users.router)
app.include_router(settings.router)


@app.get("/")
def home():

    return {
        "status":"ok",
        "panel":"LAK"
    }
