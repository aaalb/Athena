from flask import Flask
from config import Config
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from flask_wtf import CSRFProtect 

from app.extensions import token_blacklist

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    from app.api import bp as api_bp
    app.register_blueprint(api_bp, url_prefix='/api')

    from app.auth import bp as auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')

    jwt = JWTManager(app)
    
    @jwt.token_in_blocklist_loader
    def check_if_token_is_revoked(jwt_header, jwt_payload: dict):
        jti = jwt_payload["jti"]
        return jti in token_blacklist
    
    #csrf = CSRFProtect(app) 
    CORS(app)
    return app