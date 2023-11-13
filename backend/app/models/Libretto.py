from app.extensions import Base, metadata
from sqlalchemy import Table 

class Libretto(Base):
    __table__ = Table('libretto', metadata)

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}