from flask import Flask, request , json, jsonify
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy import create_engine, MetaData, Table

app = Flask(__name__)

engine = create_engine('postgresql://backend:password@backend_postgres:5432/postgres_db')

Base = declarative_base()

metadata = MetaData(schema='uniexams')
metadata.reflect(bind=engine)

class User(Base):
    __table__ = Table('users', metadata)
    
    def __repr__(self):
        return f"badgenumber={self.badgenumber}, name={self.name}, surname={self.surname}"


Session = sessionmaker(engine)
session = Session()

@app.route('/api/login', methods=['GET'])
def login():
    #badgeNumber = request.form.get('badgeNumber')
    #password = request.form.get('password')
    #remember = True if request.form.get('remember') else False
    
    result = {}

    res = str(session.query(User).filter(User.badgenumber == 'B12345').first())

    return res


if __name__ == '__main__':
   app.run()
