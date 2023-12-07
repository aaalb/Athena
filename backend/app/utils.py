import random
from datetime import datetime, timedelta

def genera_date_appello(num_date):
    date_appello = []
    mesi_validi = [1, 5, 6, 9]  # Mesi validi: gennaio (1), maggio (5), giugno (6), settembre (9)

    for _ in range(num_date):
        mese_casuale = random.choice(mesi_validi) 
        giorni_nel_mese = (datetime(2024, mese_casuale % 12 + 1, 1) - timedelta(days=1)).day
        giorno_casuale = random.randint(1, giorni_nel_mese) 

        data_casuale = datetime(2024, mese_casuale, giorno_casuale)
        date_appello.append(data_casuale)

    return date_appello