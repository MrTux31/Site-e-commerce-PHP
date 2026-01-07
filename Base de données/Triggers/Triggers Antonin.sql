-- update les lignes avant la mise en place du trigger 

UPDATE DeclinaisonProduit DP
SET qteStock = qteStock - (
    SELECT COALESCE(SUM(LC.quantite), 0)
    FROM LigneCommande LC
    WHERE LC.idDeclinaison = DP.idDeclinaison
);

DELIMITER $$

DROP TRIGGER IF EXISTS t_ai_stock_reservation $$

CREATE TRIGGER t_ai_stock_reservation
AFTER INSERT ON LigneCommande
FOR EACH ROW
BEGIN

    DECLARE qteStockProduit INT;
    SELECT qteStock INTO qteStockProduit FROM DeclinaisonProduit D WHERE
    D.idDeclinaison = NEW.idDeclinaison;

    -- On regarde si c'est possible de prélever la quantité demandée
    IF (qteStockProduit - NEW.quantite) < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = CONCAT(
                'Impossible de retirer la quantité ',
                NEW.quantite,
                ' du produit ',
                NEW.idDeclinaison
            );
    END IF;
    -- Si il y a une quantité en stock correcte, on retire du stock
    UPDATE DeclinaisonProduit
    SET qteStock = qteStock - NEW.quantite
    WHERE idDeclinaison = NEW.idDeclinaison;
END $$

DELIMITER ;

DELIMITER $$

DROP TRIGGER IF EXISTS t_au_stock_annulation $$

CREATE TRIGGER t_au_stock_annulation
AFTER UPDATE ON Commande
FOR EACH ROW
BEGIN
    -- On vérifie si la commande vient d'être passée à 'annulee'
    IF NEW.statutCommande = 'annulee' AND OLD.statutCommande != 'annulee' THEN
        UPDATE DeclinaisonProduit DP
        INNER JOIN LigneCommande LC ON DP.idDeclinaison = LC.idDeclinaison
        SET DP.qteStock = DP.qteStock + LC.quantite
        WHERE LC.idCommande = NEW.idCommande;
        
    END IF;
END $$

DELIMITER ;


-- ==========================================================
-- 1. RÉCUPÉRATION DE TON COMPTE EXISTANT
-- ==========================================================

-- On cherche ton ID via ton email (plus sûr que de mettre 52 en dur)
SELECT idClient INTO @idClient 
FROM Client 
WHERE email = 'ledonneantoni@gmail.com' 
LIMIT 1;

-- ==========================================================
-- 2. CRÉATION D'UN PRODUIT DE TEST (Stock 100)
-- ==========================================================

INSERT INTO Produit (libelle, description, moyenneAvis) 
VALUES ('Produit Test SQL', 'Juste pour vérifier les triggers', 0);
SET @idProduit = LAST_INSERT_ID();

INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, prix, qteStock, seuilQte, qualite, provenance) 
VALUES ('Test Stock', @idProduit, 'N/A', 10.00, 100, 0, 'Commun', 'France');
SET @idDeclinaison = LAST_INSERT_ID();

-- VÉRIF 1 : Stock doit être à 100
SELECT '1. STOCK INITIAL' as Etape, qteStock FROM DeclinaisonProduit WHERE idDeclinaison = @idDeclinaison;


-- ==========================================================
-- 3. TEST COMMANDE (DÉCLENCHE LE TRIGGER INSERT)
-- ==========================================================

-- Création de la commande sur ton compte (@idClient)
INSERT INTO Commande (idClient, numTransaction, dateCommande, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (@idClient, 'TRANS_TEST_ANTONIN', NOW(), 'payee', '21 Rue du Docteur Hervé', 'CB', 50.00);
SET @idCommande = LAST_INSERT_ID();

-- Achat de 5 unités
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) 
VALUES (@idCommande, @idDeclinaison, 5, 50.00);

-- VÉRIF 2 : Stock doit être à 95 (100 - 5)
SELECT '2. APRES COMMANDE' as Etape, qteStock FROM DeclinaisonProduit WHERE idDeclinaison = @idDeclinaison;


-- ==========================================================
-- 4. TEST ANNULATION (DÉCLENCHE LE TRIGGER UPDATE)
-- ==========================================================

-- Annulation de la commande
UPDATE Commande 
SET statutCommande = 'annulee' 
WHERE idCommande = @idCommande;

-- VÉRIF 3 : Stock doit être revenu à 100 (95 + 5)
SELECT '3. APRES ANNULATION' as Etape, qteStock FROM DeclinaisonProduit WHERE idDeclinaison = @idDeclinaison;
