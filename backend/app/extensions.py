from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy import create_engine, MetaData

import os

engine = create_engine(os.environ.get('DB_URI'))

metadata = MetaData(schema='uniexams')
metadata.reflect(bind=engine)
Session = sessionmaker(engine)
Base = declarative_base()
session = Session()

token_blacklist = []