from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.core.config import settings
from app.db.database import Base, engine

from app.routers.auth import router as auth_router
from app.routers.dashboard import router as dashboard_router


# ساخت جداول دیتابیس
Base.metadata.create_all(bind=engine)

BASE_DIR = Path(__file__).resolve().parent

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION
)

# فایل‌های استاتیک
app.mount(
    "/static",
    StaticFiles(directory=str(BASE_DIR / "static")),
    name="static"
)

# قالب‌ها
templates = Jinja2Templates(
    directory=str(BASE_DIR / "templates")
)

# ثبت Router ها
app.include_router(auth_router)
app.include_router(dashboard_router)


@app.get("/")
async def home():
    return RedirectResponse("/login")


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "version": settings.APP_VERSION
    }
