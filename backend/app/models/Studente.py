from app.extensions import Base, metadata
from sqlalchemy import Table 

class Studente(Base):
    __table__ = Table('studenti', metadata)

    def getNome(self):
        return f"{self.nome}"
    
    def getCognome(self):
        return f"{self.cognome}"
    
    def getDataNascita(self):
        return f"{self.datanascita}"
    
    def getEmail(self):
        return f"{self.email}"
    

    
