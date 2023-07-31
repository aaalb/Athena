from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy import create_engine, MetaData, Table

engine = create_engine('postgresql://backend:password@backend_postgres:5432/postgres_db')

metadata = MetaData(schema='uniexams')
metadata.reflect(bind=engine)
Session = sessionmaker(engine)
Base = declarative_base()