from app.extensions import Base, metadata
from sqlalchemy import Table 

class Esame(Base):
    __table__ = Table('esami', metadata)

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}