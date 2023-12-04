CREATE OR REPLACE FUNCTION check_idoneita() RETURNS TRIGGER AS $$
DECLARE
    prova_attuale VARCHAR(10);
BEGIN
    SELECT idProva INTO prova_attuale
    FROM uniexams.Appelli
    WHERE idAppello = NEW.idAppello;

    UPDATE uniexams.Iscrizioni i
    SET idoneita = false
    WHERE idappello IN (
        SELECT idappello
        FROM uniexams.Appelli
        WHERE idprova = prova_attuale
    )
    AND email = NEW.email AND i.idIscrizione <> NEW.idIscrizione;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_idoneita_trigger
AFTER UPDATE ON uniexams.Iscrizioni
FOR EACH ROW
WHEN (pg_trigger_depth() = 0)
EXECUTE FUNCTION check_idoneita();
