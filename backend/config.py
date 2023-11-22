import os 
import datetime
import configparser

basedir = os.path.abspath(os.path.dirname(__file__))

config = configparser.ConfigParser()
config.read('app.ini')

class Config:  
    SQLACHEMY_DATABASE_URI = 'postgresql://backend:password@backend_postgres:5432/postgres_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = 'prova'
    JWT_ACCESS_TOKEN_EXPIRES = datetime.timedelta(days=30)