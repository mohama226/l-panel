from fastapi import APIRouter, Cookie, Request
from fastapi.responses import RedirectResponse, JSONResponse

from app.core.template import render
from app.core.settings import get_dashboard_settings

router = APIRouter()


def get_dashboard_stats():
    """
    فعلاً آمار ثابت است.
    بعداً از دیتابیس و سرویس‌ها خوانده می‌شود.
    """

    return {
        "users": 0,
        "admins": 1,
        "groups": 0,
        "servers": 0,
        "online": 0,
        "traffic": "0 GB",
        "backups": 0,
        "logs": 0,
    }


@router.get("/dashboard")
async def dashboard(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:
        return RedirectResponse(
            "/login",
            status_code=302,
        )

    settings = get_dashboard_settings()

    data = get_dashboard_stats()

    data.update({
        "admin_id": lak_admin,
        "dashboard_settings": settings,
    })

    return render(
        request,
        "dashboard.html",
        data,
    )


@router.get("/dashboard/content")
async def dashboard_content(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:
        return RedirectResponse(
            "/login",
            status_code=302,
        )

    data = get_dashboard_stats()

    data.update({
        "admin_id": lak_admin,
    })

    return render(
        request,
        "dashboard_content.html",
        data,
    )


@router.get("/dashboard/api")
async def dashboard_api(
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:

        return JSONResponse(
            {
                "error": "Unauthorized"
            },
            status_code=401,
        )

    return JSONResponse(
        get_dashboard_stats()
    )
