DELIMITER $$

CREATE PROCEDURE getTopProduitsAccueil()
BEGIN
    DECLARE nbValides INT DEFAULT 0;

    -- On compte les produits qui ont une moyenne non NULL
    SELECT COUNT(*)
    INTO nbValides
    FROM DeclinaisonProduit
    WHERE moyenneAvis IS NOT NULL;

    -- Si aucun produit n'a de moyenne → on lève une erreur
    IF nbValides = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Aucun produit avec une moyenne valide';
    END IF;

    -- Sinon on renvoie les 4 produits les plus populaires
    SELECT 
        p.idProduit,
        p.libelle AS nomProduit,
        d.idDeclinaison,
        d.prix,
        d.prixSolde,
        d.qualite,
        d.libelleDeclinaison,
        d.descDeclinaison
    FROM Produit p
    JOIN DeclinaisonProduit d ON p.idProduit = d.idProduit
    WHERE d.moyenneAvis IS NOT NULL
    ORDER BY d.moyenneAvis DESC
    LIMIT 4;


END$$

DELIMITER ;
