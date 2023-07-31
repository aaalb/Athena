import os 

basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    SQLACHEMY_DATABASE_URI = 'postgresql://backend:password@backend_postgres:5432/postgres_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False