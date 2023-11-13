from app.api import bp 
from app.extensions import session
from flask import jsonify
from flask_jwt_extended import *

from app.models.Appello import Appello
from app.models.Iscrizione import Iscrizione
from app.models.Libretto import Libretto
from app.models.Esame import Esame

@bp.route('/appelli', methods=['GET'])
@jwt_required()
def get_appelli():
    current_user = get_jwt_identity()

    subquery = session.query(Iscrizione.idappello).filter(Iscrizione.email == current_user)
    query = session.query(Appello).filter(Appello.idappello.notin_(subquery)).all()

    result_list = [record.__dict__ for record in query]

    for record_dict in result_list:
        record_dict.pop('_sa_instance_state', None)

    return jsonify(result_list)

@bp.route('/libretto', methods=['GET'])
@jwt_required()
def get_libretto():
    current_user = get_jwt_identity()

    query = session.query(Libretto.votocomplessivo, Esame.nome, Esame.crediti, Esame.anno) \
        .join(Esame) \
        .filter(Libretto.email == current_user) \
        .all()

    result = []
    for record in query:
        result.append({
            'nome' : record.nome, 
            'voto_complessivo' : record.votocomplessivo,
            'crediti' : record.crediti,
            'anno' : record.anno
        })

    return jsonify(result)