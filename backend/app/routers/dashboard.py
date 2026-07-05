from fastapi import APIRouter, Cookie, Request
from fastapi.responses import RedirectResponse

from app.core.template import render

router = APIRouter()


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

    # فعلاً آمار ثابت است، بعداً از دیتابیس خوانده می‌شود
    return render(
        request,
        "dashboard.html",
        {
            "admin_id": lak_admin,
            "users": 0,
            "admins": 1,
            "groups": 0,
            "servers": 0,
            "online": 0,
            "traffic": "0 GB",
            "backups": 0,
            "logs": 0,
        },
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

    return render(
        request,
        "dashboard_content.html",
        {
            "admin_id": lak_admin,
            "users": 0,
            "admins": 1,
            "groups": 0,
            "servers": 0,
            "online": 0,
            "traffic": "0 GB",
            "backups": 0,
            "logs": 0,
        },
    )
