from fastapi import FastAPI

app = FastAPI(
    title="LAK Panel",
    version="0.1.0"
)


@app.get("/")
def home():
    return {
        "status": "running",
        "panel": "LAK Panel"
    }
