from app.auth import bp 
from app.extensions import session 
from app.models.Studente import Studente
from app.models.Docente import Docente

from flask_jwt_extended import *
from flask import request, jsonify
from werkzeug.security import check_password_hash

@bp.route('/login', methods=['POST'])
def login():
    #TODO: Insert tole in jwt token
    email = request.json["email"]
    password = request.json["password"]

    if not email or not password:
        return jsonify({"Status": 401, "Reason":"Missing parameters!"})

    studente = session.query(Studente).filter_by(email=email).first()
    if studente:
        if check_password_hash(studente.password, password):
            identity = {'email': email, 'role': 'Studente'}
            ret = {
                'role': 'studente',
                'access_token': create_access_token(identity=identity)
                }
            return jsonify(ret), 200
    
    docente = session.query(Docente).filter_by(email=email).first()
    if docente:
        if check_password_hash(docente.password, password):
            ret = {
                'role':'docente',
                'access_token': create_access_token(identity=email)
                }
            return jsonify(ret), 200
    
    return jsonify({"Status": 401, "Reason":"Wrong credentials"})
    
    

@bp.route('/logout', methods=['GET'])
def logout():
    return jsonify({"Status": 200, "Info": "Logout Successfull"})