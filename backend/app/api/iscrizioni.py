from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *
from sqlalchemy import update

from app.models.Iscrizione import Iscrizione
from app.models.Studente import Studente
from app.models.Appello import Appello
import sys
@bp.route('/iscrizioni/<idprova>/<data>/')
@jwt_required()
def get_iscritti(idprova=None, data=None):
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Studente':
            return 'Not Allowed', 403
        
        appello = session.query(Appello) \
            .filter(Appello.idprova == idprova) \
            .filter(Appello.data == data) \
            .first() 

        subquery = session.query(Iscrizione.email) \
            .filter(Iscrizione.idappello == appello.idappello)

        query = session.query(Studente.nome, Studente.cognome, Studente.email, Studente.matricola) \
            .filter(Studente.email.in_(subquery)) \
            .all()

        result = []
        for record in query:
            result.append({
                'nome' : record.nome, 
                'cognome' : record.cognome,
                'email' : record.email,
                'matricola' : record.matricola
            })
        if not result:
            return 'Invalid data', 404

        return jsonify(result)
    except:
        return jsonify({"error": "Something went wrong"})
    

@bp.route('/iscrizioni/<idprova>/<data>/voto')
@jwt_required()
def inserisci_voto(idprova, data):
    #TODO: controllo se prova già stata eseguita in passato
    current_user = get_jwt_identity()
    if current_user['role'] == 'Studente':
        return 'Not Allowed', 403
    
    stud_email = request.json['stud_email']
    voto = None
    bonus = None
    idoneita = None

    if "voto" in request.json:
        voto = request.json['voto']
    elif "bonus" in request.json:
        bonus = request.json['bonus']
    elif "idoneita" in request.json:
        idoneita = request.json['idoneita']

    appello = session.query(Appello) \
            .filter(Appello.idprova == idprova) \
            .filter(Appello.data == data) \
            .first() 

    query = update(Iscrizione) \
        .filter(Iscrizione.idappello == appello.idappello) \
        .filter(Iscrizione.email == stud_email) \
        .values(
            voto = voto,
            bonus = bonus,
            idoneita = idoneita
        )
    print(f'voto:{voto}, bonus:{bonus}, email:{stud_email}, appello: {appello.idappello}', file=sys.stderr)
    print(query, file=sys.stderr)
    session.execute(query)
    session.commit()
    
    return jsonify({"Status":"Success"})









