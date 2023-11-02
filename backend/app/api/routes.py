from app.api import bp 
from app.extensions import session
from flask import jsonify
from flask_jwt_extended import *

from app.models.Appello import Appello
from app.models.Iscrizione import Iscrizione

@bp.route('/appelli', methods=['POST'])
@jwt_required()
def get_appelli():
    current_user = get_jwt_identity()

    subquery = session.query(Iscrizione.idappello).filter(Iscrizione.email == current_user)
    query = session.query(Appello).filter(Appello.idappello.notin_(subquery)).all()

    result_list = [appello.__dict__ for appello in query]

    for appello_dict in result_list:
        appello_dict.pop('_sa_instance_state', None)

    return jsonify(result_list)
