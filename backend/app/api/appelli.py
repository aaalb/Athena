from app.api import bp 
from app.extensions import session
from flask import jsonify
from flask_jwt_extended import *

from app.models.Appello import Appello
from app.models.Iscrizione import Iscrizione
from app.models.Esame import Esame
from app.models.Prova import Prova

@bp.route('/appelli', methods=['GET'])
@jwt_required()
def get_appelli():
    current_user = get_jwt_identity()

    subquery = session.query(Iscrizione.idappello).filter(Iscrizione.email == current_user)
    
    query = session.query(Appello) \
        .filter(Appello.idappello.notin_(subquery)) \
        .all()

    result_list = [record.__dict__ for record in query]

    for record_dict in result_list:
        record_dict.pop('_sa_instance_state', None)

    return jsonify(result_list)


@bp.route('/appelli/prenotati', methods=['GET'])
@jwt_required()
def get_appelli_prenotati():
    current_user = get_jwt_identity()

    subquery = session.query(Iscrizione.idappello) \
        .filter(Iscrizione.voto == None) \
        .filter(Iscrizione.email == current_user)
    
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