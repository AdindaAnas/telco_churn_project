from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

load_dotenv()

def get_engine():
    return create_engine(
        f"postgresql://{os.getenv('DB_USER')}:"
        f"{os.getenv('DB_PASSWORD')}@"
        f"{os.getenv('DB_HOST')}:"
        f"{os.getenv('DB_PORT')}/"
        f"{os.getenv('DB_NAME')}"
    )
