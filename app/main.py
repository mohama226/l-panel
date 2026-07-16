from fastapi import FastAPI
from app.routers import users_router, admin_router, ocserv_router, dashboard_router

app = FastAPI()

app.include_router(users_router)
app.include_router(admin_router)
app.include_router(ocserv_router)
app.include_router(dashboard_router)
