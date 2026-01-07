DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `isProduitAvisPossible`(`idClient` INT, `idDeclinaison` INT) RETURNS tinyint(1)
BEGIN 

DECLARE vNbAchete INT;
DECLARE vCountClient INT;
DECLARE vNbAvis INT;

-- On vérifie que le client existe
SELECT COUNT(*) INTO vCountClient FROM Client C WHERE C.idClient = idClient;
IF vCountClient = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Aucun client trouvé pour cet ID !';
    END IF;

-- On compte combien de fois il à été acheté
SELECT COUNT(*) INTO vNbAchete FROM Commande C, LigneCommande L
WHERE C.idClient = idClient AND L.idCommande = C.idCommande AND L.idDeclinaison = idDeclinaison;

-- On compte le nombre de fois que le client a déposé un avis sur ce produit
SELECT COUNT(*) INTO vNbAvis FROM Avis A WHERE A.idClient = idClient AND A.idDeclinaisonProduit = idDeclinaison;

-- Si le produit n'est pas acheté / un avis est déja déposé on return FALSE
IF vNbAchete = 0 OR vNbAvis != 0 THEN	
	RETURN FALSE;
ELSE -- Sinon True, il a le droit de déposer un avis
	RETURN TRUE;
END IF;

END$$
DELIMITER ;
