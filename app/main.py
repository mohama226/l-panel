from fastapi import FastAPI
from app.routers import users, admin, ocserv
from app.database import init_db

app = FastAPI(title="l-panel")

@app.on_event("startup")
def startup():
    init_db()

app.include_router(users.router, prefix="/users", tags=["Users"])
app.include_router(admin.router, prefix="/admin", tags=["Admin"])
app.include_router(ocserv.router, prefix="/ocserv", tags=["Ocserv"])
