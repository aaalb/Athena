from app.extensions import Base, metadata
from sqlalchemy import Table

class Appello(Base):
    __table__ = Table('exam', metadata)

    def __repr__(self):
        return f"name={self.idexam}, ExpirationDate={self.studentbadgenumber}"