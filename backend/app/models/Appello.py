from app.extensions import Base, metadata
from sqlalchemy import Table 

class Appello(Base):
    __table__ = Table('appelli', metadata)

    def __repr__(self):
        return f"idAppello={self.idappello}"
    