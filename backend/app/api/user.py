from app.api import bp 
from app.extensions import session
from flask import jsonify, current_app
from flask_jwt_extended import *
from sqlalchemy.exc import SQLAlchemyError

from app.models.Studente import Studente
from app.models.Docente import Docente

@bp.route('/utente/data', methods=['GET'])
@jwt_required()
def get_user_data():
    """
        Ritorna tutti i dati di un determinato utente

        :return lista json contenente i dati dell'utente.
    """
    try:
        current_user = get_jwt_identity()
        tipo = get_jwt().get('role')
        
        result = []

        #in base al ruolo dell'utente vengono effettuate due query diverse
        if tipo == 'Studente':
            query = session.query(Studente.nome, Studente.cognome, Studente.email, Studente.datanascita, Studente.matricola, Studente.facolta) \
                .filter(Studente.email == current_user) \
                .all()
        else:
            query = session.query(Docente.nome, Docente.cognome, Docente.email, Docente.datanascita) \
                .filter(Docente.email == current_user) \
                .all()
            
        result = []
        for record in query:
            result.append({
                'nome' : record.nome, 
                'cognome' : record.cognome,
                'email' : record.email,
                'datanascita' : str(record.datanascita),
                'facolta': record.facolta if tipo == 'Studente' else None, 
                'matricola': record.matricola if tipo == 'Studente' else None, 
                'role' : tipo
            })

        return jsonify(result), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        current_app.logger.error("Internal Server Error: %s", e)

        return jsonify({"Error":"Internal Server Error"}), 500