INSERT INTO uniexams.studenti (nome, cognome, DataNascita, password, email, facolta, matricola)
VALUES
    ('Roberto', 'Neri', '1892-01-03', 'scrypt:32768:8:1$mKz7CYhVCz9OKp5d$c631e0252630a17bc3b7e0ee301bc2de8459ea0513e7fe61e52672553388acbb041c2c4ba7e16e5e619b0ecbb5180510f3cc12b069a2480d2e000db2dad8f462', '600653@unive.it', 'Informatica', '600653'), --password123
    ('Luca', 'Ottani', '1492-09-21', 'scrypt:32768:8:1$ZBFL6ALfOLYB7kk9$09afabd25e56ab0d163e0299d71a57dbff5f07c19db20990cfafff8cd6806ee97a43dec64fd24387c8054489bf2375636c4567022eb1a29693ef02901e9758af', '886512@unive.it', 'Scienze Ambientali', '886512'), --password456
    ('Francesca', 'Francescani', '1914-11-11', 'scrypt:32768:8:1$InF5HdDYQaMNoKo3$986c7795026afc9823acf9502a4f7436a9c973e1af81dc4ff81152c57d682cbcd098dfff518b8dc2f1f0c6c9fdb97762b3acaf0666ef1cd9a27a7cdcfb61a1a4', '787515@unive.it', 'Fisica', '787515'), --password789
    ('Giulio', 'Cesare', '1765-12-11', 'scrypt:32768:8:1$aQ2qEYyhSe3wyID6$d3b9aae1e34d33b13a6bfdc9e268398cbe391e0e826097bac7f379efd3134f6e2a335e82970b5f95db4c00621bf665ca6843022e2b20b5e9b5924e4235d49287', '347315@unive.it', 'Storia', '347315'); --//password987

INSERT INTO uniexams.Docenti(Nome, Cognome, DataNascita, Password, Email)
VALUES
    ('Lucio', 'Pozzobon', '1974-03-19', 'scrypt:32768:8:1$mKz7CYhVCz9OKp5d$c631e0252630a17bc3b7e0ee301bc2de8459ea0513e7fe61e52672553388acbb041c2c4ba7e16e5e619b0ecbb5180510f3cc12b069a2480d2e000db2dad8f462', 'luciopozzobon@unive.it'), --password123
    ('Maria', 'Bordin', '1987-05-20', 'scrypt:32768:8:1$ZBFL6ALfOLYB7kk9$09afabd25e56ab0d163e0299d71a57dbff5f07c19db20990cfafff8cd6806ee97a43dec64fd24387c8054489bf2375636c4567022eb1a29693ef02901e9758af', 'mariabordin@unive.it'), --password456
    ('Francesco', 'Quagliotto', '1990-01-03', 'scrypt:32768:8:1$InF5HdDYQaMNoKo3$986c7795026afc9823acf9502a4f7436a9c973e1af81dc4ff81152c57d682cbcd098dfff518b8dc2f1f0c6c9fdb97762b3acaf0666ef1cd9a27a7cdcfb61a1a4', 'francescoquagliotto@unive.it'), --password789
    ('Elena', 'Rossi', '1989-07-18', 'scrypt:32768:8:1$vAYCJBnoDNGEgNsj$a799c3af5a1127a47258ee6a9abeba0cf488e7bb99586304d8e89942dc325f1206b1a44d634793e668fb8259138b62ed3f13795a2f10808b0096a1fa7f48a8fc', 'elenarossi@unive.it'); --password321

INSERT INTO uniexams.esami(idEsame, nome, crediti, anno)
VALUES
    ('CT0006', 'Basi di Dati', 12, 3),
    ('CT0200', 'Analisi I', 6, 1),
    ('CT1002', 'Programmazione e Laboratorio', 12, 2);

INSERT INTO uniexams.realizza(email, idEsame)
VALUES 
    ('luciopozzobon@unive.it', 'CT0006'),
    ('mariabordin@unive.it', 'CT0006'),
    ('francescoquagliotto@unive.it', 'CT0200'),
    ('elenarossi@unive.it', 'CT1002');

INSERT INTO uniexams.Libretto (votoComplessivo, email, idEsame)
VALUES
    (30, '886512@unive.it', 'CT0006'),
    (23, '347315@unive.it', 'CT0200'),
    (19, '600653@unive.it', 'CT0200'),
    (25, '886512@unive.it', 'CT0200'),
    (20, '787515@unive.it', 'CT1002'),
    (22, '886512@unive.it', 'CT1002'),
    (29, '600653@unive.it', 'CT0006');

INSERT INTO uniexams.prove(idProva, tipologia, opzionale, dataScadenza, dipendeDa, idEsame, responsabile)
VALUES 
    ('CT0006-1', 'scritto', 'false', '2024-06-30', NULL, 'CT0006', 'luciopozzobon@unive.it'),
    ('CT0006-2', 'progetto', 'false', '2024-06-30', 'CT0006-1', 'CT0006', 'mariabordin@unive.it'),
    ('CT0200-1', 'scritto', 'false', '2024-06-30', NULL, 'CT0200', 'francescoquagliotto@unive.it'),
    ('CT1002-1', 'orale', 'false', '2024-06-30', NULL, 'CT1002', 'elenarossi@unive.it');

INSERT INTO uniexams.appelli(idProva, data)
VALUES 
    ('CT0006-1', '2023-01-3'),
    ('CT0006-2', '2023-01-6'),
    ('CT0200-1', '2023-01-10'),
    ('CT0200-1', '2023-01-15'),
    ('CT1002-1', '2023-01-30');


INSERT INTO uniexams.Iscrizioni(idAppello, email, voto, bonus, idoneita)
VALUES
	(6, '886512@unive.it', 17, 0, false),
	(7, '886512@unive.it', 30, 0, true),
	(8, '600653@unive.it', 18, 1, true),
	(9, '886512@unive.it', NULL, 0, true);