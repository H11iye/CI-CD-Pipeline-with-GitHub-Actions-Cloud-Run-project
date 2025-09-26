from fastapi import FastAPI
import os
import uvicorn 

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello from cloud run + GitHub Actions!"}


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)