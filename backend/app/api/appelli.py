from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *
from sqlalchemy import insert
from sqlalchemy.exc import SQLAlchemyError, DataError

from app.models.Appello import Appello
from app.models.Iscrizione import Iscrizione
from app.models.Esame import Esame
from app.models.Prova import Prova

@bp.route('/appelli', methods=['GET'])
@jwt_required()
def get_appelli():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        query = session.query(Appello.data, Prova.idprova, Prova.tipologia, Prova.opzionale, Prova.dipendeda, Esame.nome) \
            .select_from(Appello) \
            .join(Prova) \
            .join(Esame) \
            .all()

        result = []
        for record in query:
            result.append({
                'idprova' : record.idprova, 
                'nome' : record.nome,
                'tipologia' : record.tipologia,
                'data' : str(record.data),
                'opzionale' : record.opzionale,
                'dipendeda' : record.dipendeda
            })

        return jsonify(result), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception:
        return jsonify({"Error":"Internal Server Error"}), 500

@bp.route('/appelli/prenotazioni', methods=['GET'])
@jwt_required()
def get_appelli_prenotati():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        subquery = session.query(Iscrizione.idappello) \
            .filter(Iscrizione.voto == None) \
            .filter(Iscrizione.email == current_user['email'])
        
        query = session.query(Prova.idprova, Esame.nome, Appello.data, Prova.tipologia, Prova.responsabile, Prova.dipendeda) \
            .select_from(Appello) \
            .join(Prova) \
            .join(Esame) \
            .filter(Appello.idappello.in_(subquery)) \
            .all()

        result = []
        for record in query:
            result.append({
                'idprova' : record.idprova, 
                'nome' : record.nome,
                'tipologia' : record.tipologia,
                'data' : str(record.data),
                'responsabile' : record.responsabile,
                'dipendenza' : record.dipendeda
            })

        return jsonify(result), 200
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        return jsonify({"Error":"Internal Server Error"}), 500

@bp.route('/appelli/prenota', methods=['POST'])
@jwt_required()
def prenota_appello():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403

        id_prova = request.json['idprova']
        data = request.json['data']

        if not id_prova or not data:
            return jsonify({"Error":"Missing parameters!"}), 400
            
        appello = session.query(Appello) \
            .filter(Appello.idprova == id_prova) \
            .filter(Appello.data == data).first()
        
        if not appello:
            return jsonify({"Error": "Nessun Appello Trovato"}), 404

        query = insert(Iscrizione).values(
            idappello = appello.idappello,
            email = current_user['email']
        )

        session.execute(query)
        session.commit()

        return jsonify({"Status":"Success"}), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        return jsonify({"Error":"Internal Server Error"}), 500


@bp.route('/appelli/sprenota', methods=['DELETE'])
@jwt_required()
def sprenota_appello():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403

        id_prova = request.json['idprova']
        data = request.json['data']

        if not id_prova or not data:
            return jsonify({"Error":"Missing parameters!"}), 400

        appello = session.query(Appello.idappello) \
            .filter(Appello.idprova == id_prova) \
            .filter(Appello.data == data).first()
        
        if not appello:
            return jsonify({"Error": "Nessun Appello Trovato"}), 404

        session.query(Iscrizione) \
            .filter(Iscrizione.email == current_user['email']) \
            .filter(Iscrizione.idappello == appello.idappello) \
            .delete()
        
        session.commit()
        return jsonify({"Status":"Success"}), 200
    
    except DataError:
        session.rollback()
        return jsonify({"Error": "Invalid data format or type"}), 400  # 400 - Bad Request
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        return jsonify({"Error":"Internal Server Error"}), 500


@bp.route('/docente/appelli', methods=['GET'])
@jwt_required()
def get_appelli_docente():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        query = session.query(Appello.data, Prova.idprova, Prova.tipologia, Prova.opzionale, Prova.dipendeda, Esame.nome) \
            .select_from(Appello) \
            .join(Prova) \
            .join(Esame) \
            .filter(Prova.responsabile == current_user['email']) \
            .all()

        result = []
        for record in query:
            result.append({
                'idprova' : record.idprova, 
                'nome' : record.nome,
                'tipologia' : record.tipologia,
                'data' : str(record.data),
                'opzionale' : record.opzionale,
                'dipendeda' : record.dipendeda
            })

        return jsonify(result), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        return jsonify({"Error":"Internal Server Error"}), 500


@bp.route('/appelli/<idprova>/info', methods=['GET'])
@jwt_required()
def get_info_appello(idprova):
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        prova = session.query(Prova).filter(Prova.idprova == idprova).all()

        if not prova:
            return jsonify({"Error": "Nessuna Prova Trovata"}), 404

        result = []
        for record in prova:
            result.append({
                'idprova' : record.idprova, 
                'tipologia' : record.tipologia,
                'opzionale' : record.opzionale,
                'dipendeda' : record.dipendeda,
                'responsabile' : record.responsabile
            })

        return jsonify(result), 200
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        return jsonify({"Error":"Internal Server Error"}), 500