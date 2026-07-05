from fastapi import APIRouter, Cookie, Depends, Form, Request
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from app.core.template import render
from app.db.database import get_db
from app.repositories.settings_repository import SettingsRepository
from app.services.settings_service import SettingsService

router = APIRouter(prefix="/settings", tags=["Settings"])


@router.get("")
def settings_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
    db: Session = Depends(get_db),
):

    if lak_admin is None:
        return RedirectResponse("/login", status_code=302)

    service = SettingsService(
        SettingsRepository(db)
    )

    return render(
        request,
        "settings/index.html",
        {
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

    service = SettingsService(
        SettingsRepository(db)
    )

    service.save_localization(
        calendar,
        timezone,
        time_format,
    )

    return RedirectResponse(
        "/settings",
        status_code=303,
    )
