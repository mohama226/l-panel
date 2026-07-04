from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.core.settings import APP_NAME, VERSION

BASE_DIR = Path(__file__).resolve().parent

app = FastAPI(
    title=APP_NAME,
    version=VERSION
)

app.mount(
    "/static",
    StaticFiles(directory=str(BASE_DIR / "static")),
    name="static"
)

templates = Jinja2Templates(
    directory=str(BASE_DIR / "templates")
)


@app.get("/", response_class=HTMLResponse)
async def dashboard(request: Request):
    return templates.TemplateResponse(
        "dashboard.html",
        {
            "request": request,
            "title": APP_NAME
        }
    )


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "version": VERSION
    }
