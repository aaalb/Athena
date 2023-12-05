from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *
from sqlalchemy import insert

from app.models.Libretto import Libretto
from app.models.Esame import Esame

@bp.route('/libretto', methods=['GET'])
@jwt_required()
def get_libretto():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
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

        return jsonify(result), 200
    except:
        return jsonify({"Error":"Internal Server Error"}), 500

    
