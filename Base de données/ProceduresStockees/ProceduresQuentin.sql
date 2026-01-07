DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCategEnfants`(IN `idParent` INT)
BEGIN
    WITH RECURSIVE sousCategories AS (
        SELECT idCategorie, libelle, idCategorieParent
        FROM categorie
        WHERE idCategorie = idParent

        UNION ALL

        SELECT c.idCategorie, c.libelle, c.idCategorieParent
        FROM categorie c, sousCategories sc
        WHERE c.idCategorieParent = sc.idCategorie 
    )
    
    -- récup uniquement les sous categ ayant des produits dedans
    SELECT DISTINCT sousCategories.* FROM sousCategories , appartenir WHERE sousCategories.idCategorieParent IS NOT NULL
    AND sousCategories.idCategorie = appartenir.idCategorie;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getProduitsByCategorie`(IN `idCat` INT)
BEGIN
    WITH RECURSIVE SousCategories AS (
        SELECT idCategorie
        FROM categorie
        WHERE idCategorie = idCat

        UNION ALL

        SELECT c.idCategorie
        FROM categorie c, SousCategories sc WHERE c.idCategorieParent = sc.idCategorie
    )

    SELECT DISTINCT d.*
    FROM produit p, declinaisonproduit d, appartenir a WHERE d.idProduit = p.idProduit
    AND a.idProduit = p.idProduit
    AND a.idCategorie IN (SELECT idCategorie FROM SousCategories);
END$$
DELIMITER ;


SELECT De test : --Ramène toutes les catégories ayan au moins un produit dedans

SELECT DISTINCT C.* FROM Categorie C, Appartenir A WHERE A.idCategorie = C.idCategorie AND C.idCategorieParent IS NOT NULL;




DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDeclinaisonsApparente`(IN `idDeclinaison` INT)
BEGIN
    DECLARE vIDProduit INT;

    -- On récupère l'id du produit de la déclinaison
    SELECT idProduit 
    INTO vIDProduit 
    FROM DeclinaisonProduit D
    WHERE D.idDeclinaison = idDeclinaison;

    -- On récupère les déclinaisons des produits apparentés
    SELECT * 
    FROM DeclinaisonProduit D
    WHERE D.idProduit IN (
        SELECT 
            CASE -- Si l'id du produit 1 est le meme que vIDProduit, alors on select l'id du produit 2 (le vrai produit apparenté) 
                WHEN A.idProduit1 = vIDProduit THEN A.idProduit2
                ELSE A.idProduit1 -- Sinon on sélectionne l'id du produit 1 car c'est le produit 2 qui a le meme id que celui de vIDProduit
            END
        FROM Apparenter A
        WHERE A.idProduit1 = vIDProduit
           OR A.idProduit2 = vIDProduit
    );

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPhotosProduit`(IN `idDeclinaison` INT)
BEGIN
    DECLARE nbPhotos INT; 

    -- Compter le nombre de photos pour cette déclinaison
    SELECT COUNT(*) INTO nbPhotos
    FROM PhotoProduit P
    WHERE idDeclinaison = P.idDeclinaison;

    -- Si aucune photo trouvée, lever une exception
    IF nbPhotos = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Aucune photo trouvée pour cette déclinaison';
    END IF;

    -- Retourner les photos
    SELECT url 
    FROM PhotoProduit P
    WHERE idDeclinaison = P.idDeclinaison
    ORDER BY idPhoto ASC;
END$$
DELIMITER ;
