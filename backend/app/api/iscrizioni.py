from app.api import bp 
from app.extensions import session
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from sqlalchemy import update
from sqlalchemy.exc import SQLAlchemyError, DataError
from datetime import datetime

from app.models.Iscrizione import Iscrizione
from app.models.Studente import Studente
from app.models.Appello import Appello
from app.models.Prova import Prova

@bp.route('/iscrizioni/<idprova>/<data>')
@jwt_required()
def get_iscritti(idprova=None, data=None):
    """
        Ritorna le informazioni per ciascun utente iscritto ad un appello

        :param idprova
        :param data: data dell'appello
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente ha il ruolo di studente, gli viene negato l'accesso
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        # seleziono le informazioni dell'appello ricercato
        appello = session.query(Appello) \
            .filter(Appello.idprova == idprova) \
            .filter(Appello.data == data) \
            .first() 

        # selezioni le informazioni riguardante l'utente dove il voto risulta essere NULL
        subquery = session.query(Iscrizione.email) \
            .filter(Iscrizione.idappello == appello.idappello) \
            .filter(Iscrizione.voto == None)

        query = session.query(Studente.nome, Studente.cognome, Studente.email) \
            .filter(Studente.email.in_(subquery)) \
            .all()

        result = []
        for record in query:
            result.append({
                'nome' : record.nome, 
                'cognome' : record.cognome,
                'email' : record.email,
            })

        return jsonify(result), 200
    
    except DataError:
        session.rollback()
        current_app.logger.error("DataError: %s", e)

        return jsonify({"Error": "Invalid data format or type"}), 400  # 400 - Bad Request
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        
        return jsonify({"error": "Internal Server Error"}), 500
    

@bp.route('/iscrizioni/<idprova>/<data>/voto', methods=['POST'])
@jwt_required()
def inserisci_voto(idprova, data):
    """
        Permette di registrare un voto per uno studente ad un determinato appello

        :param stud_email: email dello studente
        :param idprova
        :param data: data dell'appello
        :param voto | bonus | idoneita
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente ha il ruolo di studente, gli viene negato l'accesso
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        # se il docente non è colui che ha crato l'esame, gli viene negato l'accesso
        responsabile = session.query(Prova).filter(Prova.idprova == idprova).first()

        if responsabile.responsabile != current_user['email']:
            return jsonify({"Error":f"Not Allowed to modify grades for {idprova}"}), 403

        stud_email = request.json['stud_email']
        voto = None
        bonus = None
        idoneita = True

        # controllo per capire se viene inserito un voto, punti bonus oppure solo l'idoneità
        if "voto" in request.json:
            voto = request.json['voto']
            if int(voto) >= 18:
                idoneita = True
            else:
                idoneita = False
        elif "bonus" in request.json:
            bonus = request.json['bonus']
        elif "idoneita" in request.json:
            idoneita = request.json['idoneita']

        appello = session.query(Appello) \
                .filter(Appello.idprova == idprova) \
                .filter(Appello.data == data) \
                .first() 

        #viene effettuato l'aggiornamento della tabella iscrizione con le informazioni inserite dall'utente
        query = update(Iscrizione) \
            .filter(Iscrizione.idappello == appello.idappello) \
            .filter(Iscrizione.email == stud_email) \
            .values(
                voto = voto,
                bonus = bonus,
                idoneita = idoneita 
            )

        session.execute(query)
        session.commit()
        
        return jsonify({"Status":"Success"})
    
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
