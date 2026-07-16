from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os

DB_URL = os.getenv("DB_URL", "postgresql://lpanel:1234@localhost:5432/lpanel")

engine = create_engine(DB_URL)
SessionLocal = sessionmaker(bind=engine, autoflush=False)
Base = declarative_base()

def init_db():
    Base.metadata.create_all(bind=engine)
