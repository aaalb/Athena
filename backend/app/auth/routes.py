from app.auth import bp 
from app.extensions import session 
from app.models.Studente import Studente
from app.models.Docente import Docente
from app.extensions import token_blacklist
from sqlalchemy.exc import SQLAlchemyError, DataError

from flask_jwt_extended import *
from flask import request, jsonify
from werkzeug.security import check_password_hash

@bp.route('/login', methods=['POST'])
def login():
    try:
        email = request.json["email"]
        password = request.json["password"]

        if not email or not password:
            return jsonify({"Error":"Missing Parameters"}), 400

        # Controlla se è uno studente
        studente = session.query(Studente).filter_by(email=email).first()
        if studente:
            if check_password_hash(studente.password, password):
                # Usa l'email come subject (stringa) e aggiungi il ruolo come claim aggiuntivo
                access_token = create_access_token(
                    identity=email,
                    additional_claims={"role": "Studente"}
                )
                return jsonify(access_token=access_token), 200
        
        # Controlla se è un docente
        docente = session.query(Docente).filter_by(email=email).first()
        if docente:
            if check_password_hash(docente.password, password):
                access_token = create_access_token(
                    identity=email,
                    additional_claims={"role": "Docente"}
                )
                return jsonify(access_token=access_token), 200
        
        return jsonify({"Error":"Wrong Credentials"}), 403
    
    except DataError:
        session.rollback()
        return jsonify({"Error": "Invalid data format or type"}), 400  
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        return jsonify({"Error":"Internal Server Error"}), 500    

@bp.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    try:
        # Estrae l'identificatore univoco del token JWT corrente (JWT ID - jti) dall'oggetto JWT.
        jti = get_jwt()['jti']

        # Aggiungi l'identificatore univoco del token JWT (jti) alla lista delle token blacklist.
        token_blacklist.append(jti)

        return jsonify({"Status":"Done"}), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        return jsonify({"Error":"Internal Server Error"}), 500