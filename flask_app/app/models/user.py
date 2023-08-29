from app.extensions import Base, metadata
from sqlalchemy import Table

class User(Base):
    __table__ = Table('users', metadata)

    def __repr__(self):
        return f"badgenumber={self.badgenumber}, name={self.name}, surname={self.surname}, password={self.password}"