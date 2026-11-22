"""FastAPI Main Application Entrypoint.

Initializes database, CORS, route handlers, and startup lifecycle hooks.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import os
import sys
from pathlib import Path

# Ensure backend root is on sys.path for direct uvicorn invocations
backend_dir = str(Path(__file__).resolve().parent.parent)
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from .config import BASE_DIR
from .db.database import init_db
from .data.catalog import populate_catalog_db
from .api.routes import router


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Run database migration and initialize official metadata on startup."""
    init_db()
    populate_catalog_db()
    yield


app = FastAPI(
    title="AI/ML Heavy Rainfall Early Warning & Inundation System",
    description="Research prototype integrating Satellite, Radar, Observational, and NWP data.",
    version="1.0.0",
    lifespan=lifespan
)

# Enable CORS for local React/Vite development and cloud deployment
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "*"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount API routes
app.include_router(router)

@app.get("/")
def root():
    return {
        "message": "RainShield Heavy Rainfall & Inundation Prediction Engine is running.",
        "documentation": "/docs",
        "service": "RainShield API",
        "health": "/api/health"
    }

@app.get("/health")
def root_health():
    return {"status": "healthy", "service": "RainShield API"}

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    host = os.environ.get("HOST", "127.0.0.1")
    uvicorn.run("app.main:app", host=host, port=port, reload=True)
