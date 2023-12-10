from app.api import bp 
from app.extensions import session
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from sqlalchemy import insert, update
from sqlalchemy.exc import IntegrityError, DataError, SQLAlchemyError
from datetime import datetime
import sys
from app.utils import genera_date_appello
from app.models.Esame import Esame
from app.models.Prova import Prova
from app.models.Realizza import Realizza
from app.models.Appello import Appello
from app.models.Studente import Studente
from app.models.Iscrizione import Iscrizione
from app.models.Libretto import Libretto

@bp.route('/esami/crea', methods=['POST'])
@jwt_required()
def crea_esame():
    """
        Inserisce un nuovo esame nel database

        :param idesame
        :param nome
        :param crediti
        :param anno
        :param prove: lista json contenente le varie prove di cui si compone l'esame.
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente ha il ruolo di studente, gli viene negato l'accesso
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403

        idesame = request.json["idesame"]
        nome = request.json["nome"]
        crediti = request.json["crediti"]
        anno = request.json["anno"]
        prove = request.json["prove"]

        if not idesame or not nome or not crediti or not anno or not prove:
            return jsonify({"Error":"Missing parameters"}), 400

        query = insert(Esame).values(
            idesame = idesame,
            nome = nome,
            crediti = crediti,
            anno = anno
        )

        session.execute(query)

        collaboratori = [current_user['email']]

        for index, prova in enumerate(prove, start=1):
            #per ogni prova, calcolo l'id della prova
            idprova = f"{idesame}-{index}",
            responsabile = prova.get("responsabile") if prova.get("responsabile") != "" else current_user['email']

            query = insert(Prova).values(
                idprova = idprova,
                tipologia = prova.get("tipologia"),
                opzionale = prova.get("opzionale"),
                datascadenza = prova.get("datascadenza"),
                #se non è esplicitata una dipendenza, viene settata su NULL
                dipendeda = prova.get("dipendeda") if prova.get("dipendeda") != "" else None,
                idesame = idesame,
                #se non è esplicitato un responsabile, viene settata sull'utente corrente
                responsabile = responsabile,
            )
            session.execute(query)
            
            if responsabile not in collaboratori:
                collaboratori.append(responsabile)

            #genero casualmente le date dell'appello
            date_appelli = genera_date_appello()

            for data in date_appelli:
                query = insert(Appello).values(
                    idprova = idprova,
                    data = data
                )
                session.execute(query)

        for collaboratore in collaboratori:
            query = insert(Realizza).values(
                email = collaboratore,
                idesame = idesame
            )

            session.execute(query)

        session.commit()
        return jsonify({"Status": "Success"}),200

    except IntegrityError:
        session.rollback()
        return jsonify({"Error": "Exam already exists in the transcript"}), 409  # 409 - Conflict
    except DataError:
        session.rollback()
        return jsonify({"Error": "Invalid data format or type"}), 400  # 400 - Bad Request
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        return jsonify({"Status": "Internal Server Error"}), 500
    

@bp.route('/esami/elimina', methods=['DELETE'])
@jwt_required()
def elimina_esame():
    """
        Elimina il determinato esame dal database

        :param idesame
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente ha il ruolo di studente, gli viene negato l'accesso
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403

        idesame = request.json["idesame"]

        if not idesame:
            return jsonify({"Error":"Missing parameters!"}), 400

        # se il docente non è colui che ha realizzato l'esame, gli viene negato l'accesso
        creatore = session.query(Realizza).filter(Realizza.idesame == idesame).first()
        if(creatore.email != current_user['email']):
            return jsonify({"Error":"Not Allowed"}), 403

        session.query(Esame).filter(Esame.idesame == idesame).delete()

        session.commit()
        return jsonify({"Status": "Success"}),200
    
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        return jsonify({"Status": "Internal Server Error"}), 500
    

@bp.route('/esami', methods=['GET'])
@jwt_required()
def visualizza_esame():
    """
        Ritorna la lista degli esami creati dal docente con annesse le prove.
    """
    try:
        current_user = get_jwt_identity()

        # se l'utente ha il ruolo di studente, gli viene negato l'accesso
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        subquery = session.query(Realizza.idesame).filter(Realizza.email == current_user['email'])
        esami = session.query(Esame).filter(Esame.idesame.in_(subquery))

        if not esami:
                return jsonify({"Error": "Nessun Esame Trovato"}), 404

        result = []
        for esame in esami:
            prove = session.query(Prova).filter(Prova.idesame == esame.idesame)

            lista_prove = []
            for prova in prove:
                lista_prove.append({
                    "idprova" : prova.idprova,
                    "tipologia" : prova.tipologia,
                    "opzionale" : prova.opzionale,
                    "datascadenza" : str(prova.datascadenza),
                    "dipendeda" : prova.dipendeda 
                })

            result.append({
                "idesame" : esame.idesame,
                "nome" : esame.nome,
                "crediti" : esame.crediti,
                "anno" : esame.anno,
                "prove" : lista_prove
            })

        return jsonify(result), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        return jsonify({"Error":"Internal Server Error"}), 500


@bp.route('/esami/<idesame>/candidati', methods=['GET'])
@jwt_required()
def get_candidati(idesame):
    """
        Ritorna la lista degli studenti che possono avere l'esame registrato, quindi
        hanno superato tutte le varie prove.
    """
    try:
        current_user = get_jwt_identity()
        
         # se l'utente ha il ruolo di studente, gli viene negato l'accesso
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        # se il docente non è colui che ha realizzato l'esame, gli viene negato l'accesso
        creatore = session.query(Realizza).filter(Realizza.idesame == idesame).first()
        if(creatore.email != current_user['email']):
            return jsonify({"Error":"Not Allowed"}), 403

        studenti = session.query(Studente).all()
        if not studenti:
            return jsonify({"Error": "Nessuno Studente Trovato"}), 404
        
        prove = session.query(Prova.idprova, Prova.datascadenza).filter(Prova.idesame == idesame).all()
        if not prove:
            return jsonify({"Error": "Nessuna Prova Trovata"}), 404
        
        candidati = []
        for studente in studenti:
            flag = True
            tmp = {'email': studente.email, 'prove': []}
            for prova in prove:
                #se l'esame è già stato inserito nel libretto, allora non viene aggiunto alla lista
                presente = session.query(Libretto) \
                    .filter(Libretto.idesame == idesame) \
                    .filter(Libretto.email == studente.email) \
                    .first()
                if (presente):
                    flag = False
                    exit
                else:
                    data_attuale = datetime.now()

                    #converto la data di scadenza in datetime
                    data_scadenza_datetime = datetime.strptime(str(prova.datascadenza), '%Y-%m-%d')

                    # se la data attuale è superiore a quella di scadenza, invalida la prova
                    if(data_attuale > data_scadenza_datetime):
                        query = update(Iscrizione) \
                            .join(Appello) \
                            .filter(Iscrizione.email == studente.email) \
                            .filter(Appello.idprova == prova.idprova) \
                            .values(
                                idoneita = False 
                            )
                        session.execute(query)
                        session.commit()

                    query = session.query(Iscrizione.voto, Iscrizione.bonus) \
                        .join(Appello) \
                        .filter(Iscrizione.email == studente.email) \
                        .filter(Iscrizione.idoneita == True) \
                        .filter(Appello.idprova == prova.idprova).first()
                    
                    if query:
                        tmp['prove'].append({
                            'idprova':prova.idprova,
                            'voto': query.voto,
                            'bonus':query.bonus
                        })

                    else:
                        flag = False
            
            if flag: 
                candidati.append(tmp)
        
        return jsonify(candidati), 200
    
    except SQLAlchemyError as e:
        session.rollback()
        current_app.logger.error("Database Error: %s", e)

        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        print(e, file=sys.stderr)
        current_app.logger.error("Internal Server Error: %s", e)

        return jsonify({"Status": "Internal Server Error"}), 500
        