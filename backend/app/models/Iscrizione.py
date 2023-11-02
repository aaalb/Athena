from app.extensions import Base, metadata
from sqlalchemy import Table 

class Iscrizione(Base):
    __table__ = Table('iscrizioni', metadata)