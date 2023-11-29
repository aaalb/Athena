from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *
from sqlalchemy import insert

from app.models.Appello import Appello
from app.models.Iscrizione import Iscrizione
from app.models.Esame import Esame
from app.models.Prova import Prova

@bp.route('/appelli/', methods=['GET'])
@jwt_required()
def get_appelli():
    current_user = get_jwt_identity()

    subquery = session.query(Iscrizione.idappello).filter(Iscrizione.email == current_user['email'])
    
    query = session.query(Appello) \
        .filter(Appello.idappello.notin_(subquery)) \
        .all()

    result_list = [record.__dict__ for record in query]

    for record_dict in result_list:
        record_dict.pop('_sa_instance_state', None)

    return jsonify(result_list)


@bp.route('/appelli/prenotazioni', methods=['GET'])
@jwt_required()
def get_appelli_prenotati():
    try:
        current_user = get_jwt_identity()

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

        return jsonify(result)
    except:
        return "Error", 500

@bp.route('/appelli/prenota', methods=['POST'])
@jwt_required()
def prenota_appello():
    try:
        current_user = get_jwt_identity()
        id_prova = request.json['idprova']
        data = request.json['data']

        if not id_prova or not data:
            return jsonify({"Status": 401, "Reason":"Missing parameters!"})

        appello = session.query(Appello) \
            .filter(Appello.idprova == id_prova) \
            .filter(Appello.data == data).first()

        query = insert(Iscrizione).values(
            idappello = appello.idappello,
            email = current_user['email']
        )

        session.execute(query)
        session.commit()

        return "Done", 200
    except:
        return "Error", 500


@bp.route('/appelli/sprenota', methods=['POST'])
@jwt_required()
def sprenota_appello():
    try:
        current_user = get_jwt_identity()
        id_prova = request.form.get('idprova')
        data = request.form.get('data')

        if not id_prova or not data:
            return jsonify({"Status": 401, "Reason":"Missing parameters!"})

        query = session.query(Appello.idappello) \
            .filter(Appello.idprova == id_prova) \
            .filter(Appello.data == data).all()
        
        id_appello = query[0][0]
        
        query = session.query(Iscrizione) \
            .filter(Iscrizione.email == current_user['email']) \
            .filter(Iscrizione.idappello == id_appello) \
            .delete()
        
        return "Done", 200
    except:
        return "Error", 500



