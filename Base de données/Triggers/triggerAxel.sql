-- Update Synchro

UPDATE DeclinaisonProduit dp
SET dp.moyenneAvis = (
    SELECT AVG(a.note)
    FROM Avis a
    WHERE a.idDeclinaisonProduit = dp.idDeclinaison
);

-- Trigger

DELIMITER //

CREATE TRIGGER t_ai_MoyenneAvis
AFTER INSERT ON Avis
FOR EACH ROW
BEGIN
    UPDATE DeclinaisonProduit dp
    SET dp.moyenneAvis = (
        SELECT AVG(a.note)
        FROM Avis a
        WHERE a.idDeclinaisonProduit = dp.idDeclinaison
    )
    WHERE dp.idDeclinaison = NEW.idDeclinaisonProduit;
END;
//

DELIMITER ;