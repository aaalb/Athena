from app.api import bp 
from app.extensions import session 
from app.models.user import User
from app.models.appello import Appello
from flask import request, jsonify
from flask_jwt_extended import *

@bp.route('/getAppelli', methods=['GET'])
@jwt_required()
def getAppelli():
    current_user = get_jwt_identity()
    return jsonify({'hello_from':current_user}), 200


