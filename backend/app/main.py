from fastapi import FastAPI

app = FastAPI(
    title="L-Panel",
    version="1.0.0"
)


@app.get("/")
async def home():

    return {
        "project": "L-Panel",
        "status": "running",
        "version": "1.0.0"
    }
