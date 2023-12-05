from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *
from sqlalchemy import insert

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
        
        subquery = session.query(Iscrizione.idappello).filter(Iscrizione.email == current_user['email'])
        
        query = session.query(Appello.data, Prova.idprova, Prova.tipologia, Prova.opzionale, Prova.dipendeda, Esame.nome) \
            .select_from(Appello) \
            .join(Prova) \
            .join(Esame) \
            .filter(Appello.idappello.notin_(subquery)) \
            .all()

        result = []
        for record in query:
            result.append({
                'idprova' : record.idprova, 
                'nome' : record.nome,
                'tipologia' : record.tipologia,
                'data' : record.data,
                'opzionale' : record.opzionale,
                'dipendeda' : record.dipendeda
            })

        return jsonify(result), 200
    except:
        jsonify({"Error":"Internal Server Error"}), 500


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
        
        query = session.query(Prova.idprova, Esame.nome, Appello.data, Prova.tipologia) \
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
                'data' : record.data,
            })

        return jsonify(result), 200
    except:
        jsonify({"Error":"Internal Server Error"}), 500

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
            return jsonify({"Status": 401, "Reason":"Missing parameters!"})

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
    except:
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
            return jsonify({"Status": 401, "Reason":"Missing parameters!"})

        appello = session.query(Appello.idappello) \
            .filter(Appello.idprova == id_prova) \
            .filter(Appello.data == data).first()
        
        query = session.query(Iscrizione) \
            .filter(Iscrizione.email == current_user['email']) \
            .filter(Iscrizione.idappello == appello.idappello) \
            .delete()
        
        session.commit()
        jsonify({"Status":"Success"}), 200
    except:
        session.rollback()
        jsonify({"Error":"Internal Server Error"}), 500


@bp.route('/appelli/storico', methods=['GET'])
@jwt_required()
def storico_appelli():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403

        query = session.query(Iscrizione.voto, Prova.idprova, Esame.nome, Prova.tipologia, Appello.data) \
            .select_from(Iscrizione) \
            .join(Appello) \
            .join(Prova) \
            .join(Esame) \
            .filter(Iscrizione.email == current_user['email']) \
            .filter(Iscrizione.voto != None)
        
        result = []
        for record in query:
            result.append({
                'idprova' : record.idprova, 
                'nome' : record.nome,
                'tipologia' : record.tipologia,
                'data' : record.data,
                'voto' : record.voto
            })

        return jsonify(result), 200
    except:
        jsonify({"Error":"Internal Server Error"}), 500


@bp.route('/appelli/info', methods=['GET'])
@jwt_required()
def get_info_appello():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403

        id_prova = request.json['idprova']

        if not id_prova:
            return jsonify({"Status": 401, "Reason":"Missing parameters!"})
        
        query = session.query(Prova).filter(Prova.idprova == id_prova).all()

        result = []
        for record in query:
            result.append({
                'idprova' : record.idprova, 
                'tipologia' : record.tipologia,
                'opzionale' : record.opzionale,
                'dipendeda' : record.dipendeda,
                'responsabile' : record.responsabile
            })

        return jsonify(result), 200
    except:
        return jsonify({"Error":"Internal Server Error"}), 500