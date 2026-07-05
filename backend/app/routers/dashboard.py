from fastapi import APIRouter
from fastapi import Cookie
from fastapi import Request
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

    return render(
        request,
        "dashboard.html",
        {
            "admin_id": lak_admin,
        },
    )
