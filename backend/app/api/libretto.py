from app.api import bp 
from app.extensions import session
from flask import jsonify
from flask_jwt_extended import *

from app.models.Libretto import Libretto
from app.models.Esame import Esame

@bp.route('/libretto', methods=['GET'])
@jwt_required()
def get_libretto():
    current_user = get_jwt_identity()

    query = session.query(Libretto.votocomplessivo, Esame.nome, Esame.crediti, Esame.anno) \
        .join(Esame) \
        .filter(Libretto.email == current_user['email']) \
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