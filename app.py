from flask import Flask, request , json, jsonify
from sqlalchemy import *

app = Flask(__name__)

engine = create_engine('postgresql://backend:password@backend_postgres:5432/postgres_db', echo = True)
metadata = MetaData(schema='uniexams')

users = Table('users', metadata, autoload_with=engine)

@app.route('/login', methods=['GET'])
def login():
    #badgeNumber = request.form.get('badgeNumber')
    #password = request.form.get('password')
    #remember = True if request.form.get('remember') else False

    #if response:
    #    return jsonify(["Authenticated"])
    #return jsonify(["Wrong Credentials"])
    
    result = {}

    query = select(users)
    with engine.connect() as conn:
        for row in conn.execute(query):
            result[row.name] = row.surname
    
    return result
    

if __name__ == '__main__':
   app.run()
