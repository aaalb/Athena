from app.api import bp 
from app.extensions import session
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from sqlalchemy import insert
from sqlalchemy.exc import SQLAlchemyError, DataError
from datetime import datetime, timedelta

from app.models.Appello import Appello
from app.models.Iscrizione import Iscrizione
from app.models.Esame import Esame
from app.models.Prova import Prova
from app.models.Libretto import Libretto

@bp.route('/appelli', methods=['GET'])
@jwt_required()
def get_appelli():
    """
        Ritorna la lista degli appelli disponibili

        @return: lista json
    """
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        # seleziono tutti gli appelli disponibili a cui l'utente non si è prenotato
        prenotazioni = session.query(Iscrizione.idappello) \
            .filter(Iscrizione.voto == None) \
            .filter(Iscrizione.email == current_user['email'])

        data_attuale = datetime.now()
        # Calcolo la data attuale a cui vengono sommati 2 mesi
        data_due_mesi_dopo = data_attuale + timedelta(days=2*30)

        #seleziono tutti gli appelli entro la data calcolata
        query = session.query(Appello.data, Prova.idprova, Prova.tipologia, Prova.opzionale, Prova.dipendeda, Esame.nome, Esame.idesame) \
            .select_from(Appello) \
            .join(Prova) \
            .join(Esame) \
            .filter(Appello.idappello.not_in(prenotazioni)) \
            .filter(Appello.data <= data_due_mesi_dopo) \
            .all()

        # selezioni tutti gli idesame nel libretto dell'utente
        libretto = session.query(Libretto.idesame).all()
        libretto_ids = [item.idesame for item in libretto]
        result = []
        for record in query:
            # se l'idesame è gia nel libretto, non deve aggiungere l'appello tra quelli disponibili
            if(record.idesame not in libretto_ids):
                result.append({
                    'idprova' : record.idprova, 
                    'nome' : record.nome,
                    'tipologia' : record.tipologia,
                    'data' : str(record.data),
                    'opzionale' : record.opzionale,
                    'dipendeda' : record.dipendeda
                })
        return jsonify(result), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error":"Internal Server Error"}), 500

@bp.route('/appelli/prenotazioni', methods=['GET'])
@jwt_required()
def get_appelli_prenotati():
    """
        Ritorna la lista delle prenotazioni agli esami dell'utente

        @return: lista json
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente che accede alla risorsa non ha il ruolo di studente, gli viene negata la richiesta
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        # seleziono tutte le prenotazioni e i relativi dati delle prove a cui l'utente è prenotato
        subquery = session.query(Iscrizione.idappello) \
            .filter(Iscrizione.voto == None) \
            .filter(Iscrizione.email == current_user['email'])
        
        query = session.query(Prova.idprova, Esame.nome, Appello.data, Prova.tipologia, Prova.responsabile, Prova.dipendeda) \
            .select_from(Appello) \
            .join(Prova) \
            .join(Esame) \
            .filter(Appello.idappello.in_(subquery)) \
            .all()

        result = []
        for record in query:
            result.append({
                'idprova' : record.idprova, 
                'nome' : record.nome,
                'tipologia' : record.tipologia,
                'data' : str(record.data),
                'responsabile' : record.responsabile,
                'dipendenza' : record.dipendeda
            })

        return jsonify(result), 200
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)

        return jsonify({"Error":"Internal Server Error"}), 500

@bp.route('/appelli/prenota', methods=['POST'])
@jwt_required()
def prenota_appello():
    """
        Permette di prenotarsi ad un appello

        :param idprova: String - id della prova
        :param data:String - data della prova
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente che accede alla risorsa non ha il ruolo di studente, gli viene negata la richiesta
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403

        id_prova = request.json['idprova']
        data = request.json['data']

        if not id_prova or not data:
            return jsonify({"Error":"Missing parameters!"}), 400

        #seleziono le informazioni dell'appello a cui l'utente vuole prenotarsi
        appello = session.query(Appello) \
            .filter(Appello.idprova == id_prova) \
            .filter(Appello.data == data).first()
        
        if not appello:
            return jsonify({"Error": "Nessun Appello Trovato"}), 404

        #inserisco nella tabella "iscrizioni" una nuova prenotazione
        query = insert(Iscrizione).values(
            idappello = appello.idappello,
            email = current_user['email']
        )

        session.execute(query)
        session.commit()

        return jsonify({"Status":"Success"}), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error":"Internal Server Error"}), 500


@bp.route('/appelli/sprenota', methods=['DELETE'])
@jwt_required()
def sprenota_appello():
    """
        Permette di sprenotarsi da un appello

        :param idprova: String - id della prova
        :param data: String - data dell'appello
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente che accede alla risorsa non ha il ruolo di studente, gli viene negata la richiesta
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403

        id_prova = request.json['idprova']
        data = request.json['data']

        if not id_prova or not data:
            return jsonify({"Error":"Missing parameters!"}), 400

        # seleziono le informazioni dell'appello a cui l'utente vuole prenotarsi
        appello = session.query(Appello.idappello) \
            .filter(Appello.idprova == id_prova) \
            .filter(Appello.data == data).first()
        
        if not appello:
            return jsonify({"Error": "Nessun Appello Trovato"}), 404

       # rimuovo dalla tabella "iscrizioni" la prenotazione 
        session.query(Iscrizione) \
            .filter(Iscrizione.email == current_user['email']) \
            .filter(Iscrizione.idappello == appello.idappello) \
            .delete()
        
        session.commit()
        return jsonify({"Status":"Success"}), 200
    
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


@bp.route('/docente/appelli', methods=['GET'])
@jwt_required()
def get_appelli_docente():
    """
        Ritorna la lista degli appelli degli esami di cui è responsabile il docente

        :return lista json
    """
    try:
        current_user = get_jwt_identity()

        #se l'utente ha il ruolo di studente, gli viene negato l'accesso 
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        data_attuale = datetime.now()
        # Calcolo la data attuale a cui vengono sommati 2 mesi
        data_due_mesi_dopo = data_attuale + timedelta(days=2*30)

        # seleziono tutti gli appelli entro la data calcolata
        query = session.query(Appello.data, Prova.idprova, Prova.tipologia, Prova.opzionale, Prova.dipendeda, Esame.nome) \
            .select_from(Appello) \
            .join(Prova) \
            .join(Esame) \
            .filter(Prova.responsabile == current_user['email']) \
            .filter(Appello.data <= data_due_mesi_dopo) \
            .all()

        result = []
        for record in query:
            result.append({
                'idprova' : record.idprova, 
                'nome' : record.nome,
                'tipologia' : record.tipologia,
                'data' : str(record.data),
                'opzionale' : record.opzionale,
                'dipendeda' : record.dipendeda
            })

        return jsonify(result), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)

        return jsonify({"Error":"Internal Server Error"}), 500


@bp.route('/appelli/<idprova>/info', methods=['GET'])
@jwt_required()
def get_info_appello(idprova):
    """
        Ritorna le informazioni riguardanti la prova

        :param idprova: String - id della prova
    """
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        prova = session.query(Prova).filter(Prova.idprova == idprova).all()

        if not prova:
            return jsonify({"Error": "Nessuna Prova Trovata"}), 404

        result = []
        for record in prova:
            result.append({
                'idprova' : record.idprova, 
                'tipologia' : record.tipologia,
                'opzionale' : record.opzionale,
                'dipendeda' : record.dipendeda,
                'responsabile' : record.responsabile
            })

        return jsonify(result), 200
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)

        return jsonify({"Error":"Internal Server Error"}), 500