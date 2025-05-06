CREATE SCHEMA IF NOT EXISTS uniexams;

CREATE TABLE IF NOT EXISTS uniexams.Studenti (
    Nome VARCHAR(64) NOT NULL,
    Cognome VARCHAR(64) NOT NULL,
    DataNascita DATE NOT NULL,
    Email VARCHAR(64) PRIMARY KEY,
    Password VARCHAR(256) NOT NULL,
    Facolta VARCHAR(64),
    Matricola VARCHAR(6) CHECK(LENGTH(Matricola) = 6)
);

CREATE TABLE IF NOT EXISTS  uniexams.Docenti(
    Nome VARCHAR(64) NOT NULL,
    Cognome VARCHAR(64) NOT NULL,
    DataNascita DATE NOT NULL,
    Password VARCHAR(256) NOT NULL,
    Email VARCHAR(64) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS uniexams.Esami (
    idEsame VARCHAR(8) PRIMARY KEY,
    nome VARCHAR(40),
    crediti INTEGER,
    anno INTEGER CHECK (anno >= 0 AND anno <= 5)
);

CREATE TABLE IF NOT EXISTS uniexams.Prove(
    idProva VARCHAR(10) PRIMARY KEY,
    tipologia VARCHAR(10),
    opzionale BOOLEAN,
    dataScadenza DATE CHECK(dataScadenza > CURRENT_DATE),
    dipendeDa VARCHAR(10),
    FOREIGN KEY (dipendeDa) REFERENCES uniexams.Prove (idProva) ON DELETE CASCADE,
    idEsame VARCHAR(8),
    FOREIGN KEY (idEsame) REFERENCES uniexams.Esami (idEsame) ON DELETE CASCADE,
    responsabile VARCHAR(64),
    FOREIGN KEY (responsabile) REFERENCES uniexams.Docenti (email)
);

CREATE TABLE IF NOT EXISTS uniexams.Appelli(
    idAppello SERIAL PRIMARY KEY,
    idProva VARCHAR(10),
    data DATE,

    FOREIGN KEY(idProva) REFERENCES uniexams.Prove(idProva) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS uniexams.Iscrizioni(
	idIscrizione SERIAL PRIMARY KEY,
    idAppello INTEGER,
    email VARCHAR(64),
    voto INTEGER CHECK (voto >= 0 AND voto <= 31),
    bonus INTEGER CHECK (bonus > 0),
    idoneita BOOLEAN,

    FOREIGN KEY(idAppello) REFERENCES uniexams.Appelli(idAppello) ON DELETE CASCADE,
    FOREIGN KEY(email) REFERENCES uniexams.Studenti(email)
);

CREATE TABLE IF NOT EXISTS uniexams.realizza(
    email VARCHAR(64),
    idEsame VARCHAR(8),

    PRIMARY KEY(email, idEsame),
    FOREIGN KEY(email) REFERENCES uniexams.Docenti(email),
    FOREIGN KEY(idEsame) REFERENCES uniexams.Esami(idEsame) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS uniexams.Libretto (
    votoComplessivo INTEGER CHECK (votoComplessivo >= 0 AND votoComplessivo <= 31),
    email VARCHAR(64),
    idEsame VARCHAR(8),
    PRIMARY KEY(email, idEsame),
    FOREIGN KEY (email) REFERENCES uniexams.Studenti (email),
    FOREIGN KEY (idEsame) REFERENCES uniexams.Esami (idEsame) ON DELETE CASCADE
);
