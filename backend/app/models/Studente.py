from app.extensions import Base, metadata
from sqlalchemy import Table 

class Studente(Base):
    __table__ = Table('studenti', metadata)

    def __repr__(self):
        return f"email={self.email}"