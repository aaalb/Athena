from app.extensions import Base, metadata
from sqlalchemy import Table

class Exam(Base):
    __table__ = Table('exam', metadata)

    def __repr__(self):
        return f""