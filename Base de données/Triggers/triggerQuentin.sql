



--UPDATE Synchro 1

UPDATE LigneCommande L SET prixTotal = ( SELECT prix * quantite FROM DeclinaisonProduit D WHERE D.idDeclinaison = L.idDeclinaison );

-- Trigger qui update le prix total d'une ligne commande
DELIMITER $$
CREATE Trigger t_bi_ligneCommande_prixTotalLigne
    BEFORE INSERT ON LigneCommande
    FOR EACH ROW
    
    BEGIN
        DECLARE prixProduit DECIMAL(10,2);

        -- On récupère le prix de la déclinaison
        SELECT prix INTO prixProduit 
        FROM DeclinaisonProduit D WHERE D.idDeclinaison = NEW.idDeclinaison;

        -- On met à jour le prix total de la ligne
        SET NEW.prixTotal = NEW.quantite * prixProduit;
    
    END$$

DELIMITER ;

-- Udpate Synchro 2

UPDATE Commande C
SET prixTotal = IFNULL(
    (SELECT SUM(prixTotal) FROM LigneCommande L WHERE C.idCommande = L.idCommande),
    0
);

DELIMITER $$
-- Trigger qui update le prix total d'une commande (dans la table Commande)
CREATE Trigger t_ai_ligneCommande_prixTotalCommande
    AFTER INSERT ON LigneCommande
    FOR EACH ROW
BEGIN
    DECLARE prixTotCommande DECIMAL(10,2);
    -- Calcul du prix total de la commande
    SELECT SUM(prixTotal) INTO prixTotCommande FROM LigneCommande L
    WHERE NEW.idCommande = L.idCommande;

    -- Mise à jour du prix total de la commande
    UPDATE Commande SET prixTotal = prixTotCommande WHERE idCommande = NEW.idCommande;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_insert_DeclinaisonProduit
BEFORE INSERT ON DeclinaisonProduit
FOR EACH ROW
BEGIN
    IF NOT (NEW.moyenneAvis IS NULL OR (NEW.moyenneAvis >= 0 AND NEW.moyenneAvis <= 5)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'moyenneAvis doit être entre 0 et 5 ou NULL';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_update_DeclinaisonProduit
BEFORE UPDATE ON DeclinaisonProduit
FOR EACH ROW
BEGIN
    IF NOT (NEW.moyenneAvis IS NULL OR (NEW.moyenneAvis >= 0 AND NEW.moyenneAvis <= 5)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'moyenneAvis doit être entre 0 et 5 ou NULL';
    END IF;
END $$

DELIMITER ;


--- MAJ : Gestion des commandes sur la partie de nino, besoin de modifiers quelques trucs
--------------------------------------------------------------------------------

CREATE TRIGGER `t_a_u_PtsFidelite` AFTER UPDATE ON `commande`
 FOR EACH ROW BEGIN
  IF NEW.statutCommande IN ('payee', 'expediee', 'livree') THEN
    UPDATE Client -- On ajoute la différence entre le nouveau prix commande et l'ancien pour avoir la bonne valeur des points a créditer (sinon bug de duplication)
    SET ptsFidelite = ptsFidelite + FLOOR(GREATEST(IFNULL(NEW.prixTotal,0) - IFNULL(OLD.prixTotal,0),0) * 0.10)
    WHERE idClient = NEW.idClient;
  END IF;
END

CREATE TRIGGER `t_ai_ligneCommande_prixTotalCommande` AFTER INSERT ON `lignecommande`
 FOR EACH ROW BEGIN
    DECLARE prixTotCommande DECIMAL(10,2);
    DECLARE ptsFideliteUsed INT;
    DECLARE reduction DECIMAL(10,2);
    
     SELECT C.ptsFideliteUsed INTO ptsFideliteUsed FROM    	 Commande C WHERE idCommande = NEW.idCommande;
    
    -- Sécurtité
    IF ptsFideliteUsed < 0 THEN 
    	SET ptsFideliteUsed = 0;
    END IF;
    -- 0.5 euros de réduc par pts de fidelite
    SET reduction = ptsFideliteUsed *0.5; 
    
    
    
    -- Calcul du prix total de la commande
    SELECT SUM(prixTotal) INTO prixTotCommande FROM LigneCommande L
    WHERE NEW.idCommande = L.idCommande;

    -- Mise à jour du prix total de la commande
    UPDATE Commande SET prixTotal = prixTotCommande - reduction WHERE idCommande = NEW.idCommande;

END

--- Trigger qui check qu'il reste assez de points de fidélité avant de les utiliser dans une commande

CREATE TRIGGER `t_ai_commande_ptsFidelite` AFTER INSERT ON `commande`
 FOR EACH ROW BEGIN
    
    -- Débit uniquement si nécessaire
    IF NEW.ptsFideliteUsed > 0 THEN
        UPDATE Client
        SET ptsFidelite = ptsFidelite - NEW.ptsFideliteUsed
        WHERE idClient = NEW.idClient;
    END IF;
END

--- Trigger qui débite les points de fidélité après qu'une commande utilisant des points soit passée
CREATE TRIGGER `t_ai_commande_ptsFidelite` AFTER INSERT ON `commande`
 FOR EACH ROW BEGIN
    
    -- Débit uniquement si nécessaire
    IF NEW.ptsFideliteUsed > 0 THEN
        UPDATE Client
        SET ptsFidelite = ptsFidelite - NEW.ptsFideliteUsed
        WHERE idClient = NEW.idClient;
    END IF;
END



