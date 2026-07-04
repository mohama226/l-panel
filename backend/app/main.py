from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.core.settings import APP_NAME, VERSION
from app.services.system_service import (
    get_cpu_usage,
    get_ram_usage,
    get_disk_usage,
    get_uptime,
    get_ocserv_status,
)

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
            "title": APP_NAME,
            "cpu": get_cpu_usage(),
            "ram": get_ram_usage(),
            "disk": get_disk_usage(),
            "uptime": get_uptime(),
            "ocserv": get_ocserv_status(),
        }
    )


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "version": VERSION,
        "cpu": get_cpu_usage(),
        "ram": get_ram_usage(),
        "disk": get_disk_usage(),
        "uptime": get_uptime(),
        "ocserv": get_ocserv_status(),
    }
