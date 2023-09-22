from app.extensions import Base, metadata
from sqlalchemy import Table

class Test(Base):
    __table__ = Table('test', metadata)

    def __repr__(self):
        return f""