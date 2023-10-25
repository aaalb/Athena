from app.extensions import Base, metadata
from sqlalchemy import Table

class Student(Base):
    __table__ = Table('student', metadata)

    def __repr__(self):
        return f""