from app.auth import bp 
from app.extensions import session 
from app.models.user import User
from flask_jwt_extended import *
from flask import request, jsonify
from werkzeug.security import check_password_hash

@bp.route('/login', methods=['GET'])
def login():
    #Sanificare input, possibile SQLI
    badgenumber = request.args.get('badgenumber')
    plain_password = request.args.get('password')

    if not badgenumber or not plain_password:
        return jsonify({"Status": 401, "Reason":"Missing parameters!"})

    user = session.query(User).filter_by(badgenumber=badgenumber).first()

    if user:
        if check_password_hash(user.password, plain_password):
            ret = {'access_token': create_access_token(identity=badgenumber)}
            return jsonify(ret), 200
        else:
            return jsonify({"Status": 401, "Reason":"Wrong credentials"})
    else:
        return jsonify({"Status": 401, "Reason":"Wrong credentials"})
    

@bp.route('/logout', methods=['GET'])
def logout():
    return jsonify({"Status": 200, "Info": "Logout Successfull"})