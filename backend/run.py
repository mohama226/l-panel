import uvicorn

from app.db.database import Base
from app.db.database import engine

# Import models
import app.models.admin
import app.models.server

Base.metadata.create_all(bind=engine)

if __name__ == "__main__":
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=False
    )
