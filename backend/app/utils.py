import random
from datetime import datetime, timedelta

def genera_date_appello():
    """
        Genera e ritorna 4 date casuali per l'appello.
    """
    date_appello = []
    mesi_validi = [1, 5, 6, 9]  # Mesi validi: gennaio (1), maggio (5), giugno (6), settembre (9)

    for mese in mesi_validi:
        #calcolo il numero di giorni nel determinato mese
        giorni_nel_mese = 29

        #seleziono un giorno casuale del mese
        giorno_casuale = random.randint(1, giorni_nel_mese) 

        #creo la data a partire dalle informazioni generate
        #TODO: calcolare anche l'anno
        data_casuale = datetime(2024, mese, giorno_casuale)
        date_appello.append(data_casuale)

    return date_appello
