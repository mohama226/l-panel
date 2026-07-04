from fastapi import FastAPI

app = FastAPI(
    title="LAK Panel",
    version="0.0.1"
)


@app.get("/")
async def home():
    return {
        "project": "LAK Panel",
        "version": "0.0.1",
        "status": "running"
    }


@app.get("/health")
async def health():
    return {
        "status": "ok"
    }
