from app.extensions import Base, metadata
from sqlalchemy import Table 

class Prova(Base):
    __table__ = Table('prove', metadata)