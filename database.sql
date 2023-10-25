CREATE SCHEMA uniexams;

CREATE TABLE uniexams.Studenti (
    Nome VARCHAR(64) NOT NULL,
    Cognome VARCHAR(64) NOT NULL,
    DataNascita DATE NOT NULL,
    Email VARCHAR(64) PRIMARY KEY,
    Password VARCHAR(256) NOT NULL,
    Facolta VARCHAR(64),
    Matricola VARCHAR(6) CHECK(LENGTH(Matricola) = 6)
);

CREATE TABLE uniexams.Docenti(
    Nome VARCHAR(64) NOT NULL,
    Cognome VARCHAR(64) NOT NULL,
    DataNascita DATE NOT NULL,
    Password VARCHAR(256) NOT NULL,
    Email VARCHAR(64) PRIMARY KEY
);

CREATE TABLE UniExams.Esami (
    idEsame VARCHAR(8) PRIMARY KEY,
    nome VARCHAR(40),
    crediti INTEGER,
    anno INTEGER
);

CREATE TABLE UniExams.Prove(
    idProva VARCHAR(10) PRIMARY KEY,
    tipologia VARCHAR(10),
    opzionale BOOLEAN,
    dataScadenza DATE,
    dipendeDa VARCHAR(10),
    FOREIGN KEY (dipendeDa) REFERENCES UniExams.Prove (idProva),
    idEsame VARCHAR(8),
    FOREIGN KEY (idEsame) REFERENCES UniExams.Esami (idEsame),
    responsabile VARCHAR(64),
    FOREIGN KEY (responsabile) REFERENCES UniExams.Docenti (email)
);

CREATE TABLE uniexams.Appelli(
    idAppello SERIAL PRIMARY KEY,
    idProva VARCHAR(10),
    data DATE,

    FOREIGN KEY(idProva) REFERENCES uniexams.Prove(idProva)
);

CREATE TABLE uniexams.Iscrizioni(
	idIscrizione SERIAL PRIMARY KEY,
    idAppello INTEGER,
    email VARCHAR(64),
    voto INTEGER,
    bonus INTEGER,
    idoneita BOOLEAN,

    FOREIGN KEY(idAppello) REFERENCES uniexams.Appelli(idAppello),
    FOREIGN KEY(email) REFERENCES uniexams.Studenti(email)
);

CREATE TABLE uniexams.realizza(
    email VARCHAR(64),
    idEsame VARCHAR(8),

    PRIMARY KEY(email, idEsame),
    FOREIGN KEY(email) REFERENCES uniexams.Docenti(email),
    FOREIGN KEY(idEsame) REFERENCES uniexams.Esami(idEsame)
);

CREATE TABLE UniExams.Libretto (
    votoComplessivo INTEGER,
    email VARCHAR(64),
    idEsame VARCHAR(8),
    PRIMARY KEY(email, idEsame),
    FOREIGN KEY (email) REFERENCES UniExams.Studenti (email),
    FOREIGN KEY (idEsame) REFERENCES UniExams.Esami (idEsame)
);
