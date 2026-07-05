from fastapi import APIRouter
from fastapi import Cookie
from fastapi import Depends
from fastapi import Form
from fastapi import Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.repositories.settings_repository import SettingsRepository
from app.services.settings_service import SettingsService

router = APIRouter(prefix="/settings", tags=["Settings"])

templates = Jinja2Templates(directory="app/templates")


@router.get("")
def settings_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
    db: Session = Depends(get_db),
):

    if lak_admin is None:
        return RedirectResponse("/login", status_code=302)

    repository = SettingsRepository(db)
    service = SettingsService(repository)

    return templates.TemplateResponse(
        "settings/index.html",
        {
            "request": request,
            "settings": service.get_all(),
        },
    )


@router.post("")
def save_settings(
    request: Request,
    calendar: str = Form(...),
    timezone: str = Form(...),
    time_format: str = Form(...),
    lak_admin: str | None = Cookie(default=None),
    db: Session = Depends(get_db),
):

    if lak_admin is None:
        return RedirectResponse("/login", status_code=302)

    repository = SettingsRepository(db)
    service = SettingsService(repository)

    service.save_localization(
        calendar,
        timezone,
        time_format,
    )

    return RedirectResponse(
        "/settings",
        status_code=303,
    )
