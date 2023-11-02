from app.extensions import Base, metadata
from sqlalchemy import Table 

class Docente(Base):
    __table__ = Table('docenti', metadata)