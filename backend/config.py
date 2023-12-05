import os 
import datetime
from dotenv import load_dotenv
import ssl

basedir = os.path.abspath(os.path.dirname(__file__))

load_dotenv()

class Config:  
    SQLACHEMY_DATABASE_URI = os.environ.get('DB_URI')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY')
    JWT_ACCESS_TOKEN_EXPIRES = datetime.timedelta(days=30)