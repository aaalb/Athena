from app.extensions import Base, metadata
from sqlalchemy import Table 

class Docente(Base):
    __table__ = Table('docenti', metadata)

    def getNome(self):
        return f"{self.nome}"
    
    def getCognome(self):
        return f"{self.cognome}"
    
    def getDataNascita(self):
        return f"{self.datanascita}"
    
    def getMatricola(self):
        return f"{self.matricola}"
    
    def getEmail(self):
        return f"{self.email}"