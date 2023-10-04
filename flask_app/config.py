import os 
import datetime

basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    SQLACHEMY_DATABASE_URI = 'postgresql://backend:password@backend_postgres:5432/postgres_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = "diocane" #os.urandom(16)
    JWT_ACCESS_TOKEN_EXPIRES = datetime.timedelta(days=30)