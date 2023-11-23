from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *

from app.models.Libretto import Libretto
from app.models.Esame import Esame

import sys

@bp.route('/libretto', methods=['GET'])
@jwt_required()
def get_libretto():
    try:
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

        return jsonify(result), 200
    except:
        return "Error", 500


@bp.route('/libretto/inserisci', methods=['POST'])
@jwt_required()
def inserisci_in_libretto():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Studente':
            return 'Not Allowed', 403

        idesame = request.json["idesame"]
        nome = request.json["nome"]
        crediti = request.json["crediti"]
        anno = request.json["anno"]
        prove = request.json["prove"]

        for prova in prove:
            print(prova, file=sys.stderr)

        return jsonify()
        
    except:
        return "Error", 500