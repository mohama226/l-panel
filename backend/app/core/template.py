from fastapi import Request
from fastapi.templating import Jinja2Templates
from datetime import datetime
from zoneinfo import ZoneInfo

from app.db.database import SessionLocal
from app.db.models import Setting

import subprocess

templates = Jinja2Templates(directory="app/templates")


def get_setting(key: str, default: str):

    db = SessionLocal()

    try:

        item = (
            db.query(Setting)
            .filter(Setting.key == key)
            .first()
        )

        if item:
            return item.value

        return default

    finally:

        db.close()


def get_ocserv_status():

    try:

        result = subprocess.run(
            ["systemctl", "is-active", "ocserv"],
            capture_output=True,
            text=True,
            timeout=2,
        )

        return result.stdout.strip()

    except Exception:

        return "unknown"


def render(
    request: Request,
    template: str,
    context: dict | None = None,
):

    if context is None:
        context = {}

    timezone = get_setting(
        "timezone",
        "Asia/Tehran",
    )

    try:

        now = datetime.now(
            ZoneInfo(timezone)
        )

    except Exception:

        now = datetime.now()

    base = {

        "request": request,

        "server_time": now,

        "panel_name": "LAK PANEL",

        "panel_version": "1.0.0",

        "ocserv_status": get_ocserv_status(),

    }

    base.update(context)

    return templates.TemplateResponse(
        template,
        base,
    )
