from fastapi import APIRouter, Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

router = APIRouter()

templates = Jinja2Templates(
    directory="app/templates"
)


@router.get("/dashboard")
async def dashboard(request: Request):

    admin = request.cookies.get("lak_admin")

    if not admin:

        return RedirectResponse("/login")

    return templates.TemplateResponse(
        "dashboard.html",
        {
            "request": request
        }
    )
