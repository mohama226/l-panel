from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.core.settings import APP_NAME, VERSION

from app.api.dashboard import router as dashboard_router

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

app.include_router(dashboard_router)


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
