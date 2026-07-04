from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.core.config import settings

BASE_DIR = Path(__file__).resolve().parent

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION
)

# Static Files
app.mount(
    "/static",
    StaticFiles(directory=str(BASE_DIR / "static")),
    name="static"
)

# Templates
templates = Jinja2Templates(
    directory=str(BASE_DIR / "templates")
)


@app.get("/")
async def home():
    return RedirectResponse("/login")


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "version": settings.APP_VERSION
    }
