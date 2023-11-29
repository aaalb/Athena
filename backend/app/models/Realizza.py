from app.extensions import Base, metadata
from sqlalchemy import Table 

class Realizza(Base):
    __table__ = Table('realizza', metadata)

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}