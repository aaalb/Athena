from app.api import bp 
from app.extensions import session
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from sqlalchemy import insert 
from app.models.Libretto import Libretto
from app.models.Esame import Esame
from app.models.Appello import Appello
from app.models.Iscrizione import Iscrizione
from app.models.Prova import Prova
from sqlalchemy.exc import SQLAlchemyError, DataError, IntegrityError

def _storico_appelli(email, idesame):
    """
        Ritorna tutte le prove eseguite di un determinato esame
    """
    query = session.query(Iscrizione.voto, Prova.idprova, Iscrizione.idoneita, Prova.tipologia, Appello.data) \
        .select_from(Iscrizione) \
        .join(Appello) \
        .join(Prova) \
        .join(Esame) \
        .filter(Iscrizione.email == email) \
        .filter(Esame.idesame == idesame) \
        .filter(Iscrizione.voto != None)
    
    result = []
    for record in query:
        result.append({
            'idprova' : record.idprova, 
            'tipologia' : record.tipologia,
            'data' : str(record.data),
            'voto' : record.voto,
            'idoneita' : record.idoneita,
        })
    
    return result

    
@bp.route('/libretto', methods=['GET'])
@jwt_required()
def get_libretto():
    """
        Inserisce tutti gli esami completati e il relativo storico
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente ha il ruolo di docente, gli viene negato l'accesso
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        # seleziono le informazioni riguardanti il libretto e lo storico delle prove 
        query = session.query(Libretto.votocomplessivo, Esame.nome, Esame.crediti, Esame.anno, Esame.idesame) \
            .join(Esame) \
            .filter(Libretto.email == current_user['email']) \
            .all()
        
        result = []
        for record in query:
            result.append({
                'nome' : record.nome, 
                'voto_complessivo' : record.votocomplessivo,
                'crediti' : record.crediti,
                'anno' : record.anno,
                'idesame' : record.idesame,
                'prove' : _storico_appelli(current_user['email'], record.idesame)  
            })

        return jsonify(result), 200
    
    except SQLAlchemyError as e:
            session.rollback()
            current_app.logger.error("Database Error: %s", e)

            return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        current_app.logger.error("Internal Server Error: %s", e)

        return jsonify({"Error": "Internal Server Error"}), 500

@bp.route('/libretto/inserisci', methods=['POST'])
@jwt_required()
def inserisci_in_libretto():
    """
        Inserisce un nuovo esame completato nel libretto

        :param idesame
        :param stud_email: email dello studente
        :param voto
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente ha il ruolo di docente, gli viene negato l'accesso
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        idesame = request.json["idesame"]
        stud_email = request.json["stud_email"]
        voto = request.json["voto"]

        if not idesame or not stud_email or not voto:
            return jsonify({"Error":"Missing parameters"}), 400

        query = insert(Libretto).values(
            idesame = idesame,
            email = stud_email,
            votocomplessivo = voto
        )
        session.execute(query)
        session.commit()
        
        return jsonify({"Status": "Success"}),200

    except IntegrityError:
        session.rollback()
        current_app.logger.error("IntegrityError: %s", e)

        return jsonify({"Error": "Exam already exists"}), 409  # 409 - Conflict
    except DataError:
        session.rollback()
        current_app.logger.error("DataError: %s", e)

        return jsonify({"Error": "Invalid data format or type"}), 400  # 400 - Bad Request
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        current_app.logger.error("Internal Server Error: %s", e)

        return jsonify({"Error":"Internal Server Error"}), 500
