from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(directory="templates")

router = APIRouter()

@router.get("/users")
async def users_list(request: Request):
    # فعلاً دیتای تستی؛ بعداً به ocserv و PostgreSQL وصل می‌کنیم
    users = [
        {"username": "test1", "status": "active"},
        {"username": "test2", "status": "disabled"},
    ]
    return templates.TemplateResponse(
        "users.html",
        {"request": request, "users": users, "title": "لیست یوزرها"}
    )
