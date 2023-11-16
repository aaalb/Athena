from app.extensions import Base, metadata
from sqlalchemy import Table 

class Studente(Base):
    __table__ = Table('studenti', metadata)
    

    
