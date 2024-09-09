from fastapi import FastAPI

app = FastAPI()

@app.get("/status")
def status():
    return "200 OK"