from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base

# Параметры подключения к вашей БД
DATABASE_URL = 'postgresql://postgres:password@localhost:5432/postgres'

engine = create_engine(DATABASE_URL)
Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()


