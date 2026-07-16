from .users import router as users_router
from .dashboard import router as dashboard_router
from .admin import router as admin_router
from .ocserv import router as ocserv_router

__all__ = [
    "users_router",
    "dashboard_router",
    "admin_router",
    "ocserv_router",
]
