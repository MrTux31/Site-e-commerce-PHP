Au moins 50 produits différents dont 8 produits composés. 



Au moins 25 couples de produits apparentés entre eux.


Au moins 50 clients différents, les clients seront tous situés en France et répartis sur plusieurs départements.




Au moins 10 catégories de produits, pour chacune au moins deux sous-catégories et pour une sous-catégorie, des catégories de niveau inférieur


Au moins 3 regroupements de produits (nouveautés, soldes, made in france, …)

Affectez les produits aux sous catégories et certains aux regroupements.


Au moins 100 commandes liées aux clients précédents, certains clients peuvent ne pas avoir de commande.

Au moins 20 avis de clients sur des produits (avec autant de réponses).


Pour chaque commande une moyenne d’environ 5 produits différents et pour certains une quantité supérieure à 1.


Il sera nécessaire pour les commandes de conserver les règlements.



Pour une dizaine de clients, conservez les références de carte bancaire






-- ============================================
-- SCRIPT DE PEUPLEMENT DES DONNÉES (INSERTION)
-- ============================================
-- Vider les tables pour repartir sur une base propre
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Composer;
TRUNCATE TABLE CompositionProduit;
TRUNCATE TABLE PhotoProduit;
TRUNCATE TABLE LigneCommande;
TRUNCATE TABLE DeclinaisonProduit;
TRUNCATE TABLE Produit;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. INSERTION DES PRODUITS ET DÉCLINAISONS
-- ============================================

-- 1. POTION DE MANA
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Potion de mana', 'Fiole contenant un liquide bleu lumineux permettant de restaurer la magie.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Potion de mana majeure', @id, 'Régénère une grande quantité de mana (100%)', 'Contenance: 200ml, Effet: Instantané, Poids: 0.3kg', 19.99, NULL, 250, 50, 'Commun', 'Falconia'),
('Potion de mana mineure', @id, 'Régénère une petite quantité de mana (20%)', 'Contenance: 50ml, Effet: Instantané, Poids: 0.1kg', 7.99, NULL, 700, 100, 'Commun', 'Falconia');

-- 2. POTION DE RÉSISTANCE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Potion de résistance', 'Potions alchimiques offrant une protection temporaire contre les éléments.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Potion de Résistance à la foudre', @id, 'Résistance aux attaques électriques', 'Durée: 3 min, Résistance: +40%, Saveur: Citronnée', 9.99, NULL, 108, 20, 'Peu commun', 'Tour de Babel'),
('Potion de Résistance à la glace', @id, 'Résistance au froid et au gel', 'Durée: 3 min, Résistance: +40%, Saveur: Mentholée', 9.99, NULL, 102, 20, 'Peu commun', 'Landes aux esprits'),
('Potion de Résistance au feu', @id, 'Résistance aux chaleurs intenses', 'Durée: 3 min, Résistance: +40%, Saveur: Pimentée', 9.99, NULL, 99, 20, 'Peu commun', 'Désert des Knaarens'),
('Potion de Résistance au poison', @id, 'Immunité temporaire aux toxines', 'Durée: 5 min, Antidote inclus, Saveur: Amère', 9.99, NULL, 102, 20, 'Peu commun', 'Tour de Babel');

-- 3. POTION DE SOIN
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Potion de soin', 'Le meilleur ami de l''aventurier, referme les plaies instantanément.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Potion de soin majeure', @id, 'Soigne les blessures graves', 'Récupération: 500 PV, Délai: 2s, Poids: 0.3kg', 19.99, NULL, 200, 50, 'Commun', 'Forêt obscure'),
('Potion de soin mineure', @id, 'Soigne les égratignures', 'Récupération: 100 PV, Délai: 2s, Poids: 0.1kg', 7.99, NULL, 600, 100, 'Commun', 'Forêt obscure');

-- 4. MANUEL D'INFORMATIONS
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Manuel d''informations', 'Livres et guides pour comprendre le monde qui vous entoure.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Guide de l''apprenti magicien', @id, 'Les bases théoriques de la magie', 'Pages: 120, Langue: Commun, Couverture: Cuir souple', 14.99, NULL, 55, 10, 'Commun', 'Désert des Knaarens'),
('Le Wiki des Monstres', @id, 'Encyclopédie illustrée de la faune hostile', 'Pages: 350, Illustrations: Couleur, Poids: 1.2kg', 8.99, NULL, 95, 15, 'Commun', 'Falconia');

-- 5. MANUEL DE RECETTES
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Manuel de recettes', 'Ouvrages dédiés à l''artisanat et la cuisine.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Les Recettes de Flagadus', @id, 'Plats délicieux par le chef Flagadus', 'Pages: 80, Recettes: 45, Type: Cuisine traditionnelle', 12.99, NULL, 35, 10, 'Commun', 'Landes aux esprits'),
('Manuel de fabrication de potion', @id, 'Alchimie pour les débutants', 'Pages: 200, Sécurité: Sort ignifuge, Type: Alchimie', 14.99, NULL, 60, 10, 'Commun', 'Tour de Babel');

-- 6. BAGUETTE MAGIQUE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Baguette magique', 'Catalyseur indispensable pour lancer des sorts avec précision.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Baguette à étincelles', @id, 'Baguette spécialisée Feu', 'Bois: Chêne calciné, Cœur: Plume de phénix, Longueur: 30cm', 37.99, NULL, 240, 30, 'Rare', 'Désert des Knaarens'),
('Baguette de glace', @id, 'Baguette spécialisée Glace', 'Bois: Pin givré, Cœur: Éclat de cristal, Longueur: 32cm', 37.99, NULL, 240, 30, 'Rare', 'Landes aux esprits'),
('Baguette tellurique', @id, 'Baguette spécialisée Terre', 'Bois: Racine millénaire, Cœur: Diamant brut, Longueur: 28cm', 37.99, NULL, 240, 30, 'Rare', 'Tour de Babel');

-- 7. BÂTON MAGIQUE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Bâton magique', 'Arme à deux mains pour sorciers puissants.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Bâton d''incantation novice', @id, 'Bâton simple pour débutant', 'Matériau: Bois simple, Poids: 2kg, Bonus Magie: +5', 74.99, NULL, 140, 20, 'Peu commun', 'Landes aux esprits'),
('Bâton du géomancien', @id, 'Bâton lourd incrusté de gemmes', 'Matériau: Pierre runique, Poids: 5kg, Bonus Magie: +25', 94.99, NULL, 90, 15, 'Epique', 'Tour de Babel');

-- 8. TALISMAN
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Talisman', 'Petit accessoire magique renforçant les capacités.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Talisman du petit magicien', @id, 'Idéal pour les premiers sorts', 'Matériau: Cuivre, Effet: +2 Intelligence, Poids: 50g', 19.99, NULL, 130, 20, 'Peu commun', 'Falconia');

-- 9. TOME DIVIN
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Tome divin', 'Recueils sacrés contenant des miracles anciens.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Tome divin de Lothric', @id, 'Miracles de chevaliers, édition rare', 'Reliure: Or sacré, Contenu: 5 Miracles, Poids: 3kg', 69.99, NULL, 35, 5, 'Legendaire', 'Landes aux esprits');

-- 10. TOME DE PYROMANCIE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Tome de pyromancie', 'Savoirs oubliés des maîtres du feu.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Tome de pyromancie de Carthus', @id, 'Pyromancie de combat agressive', 'Reliure: Peau de démon, Contenu: 4 Sorts, Résistance au feu: Oui', 49.99, NULL, 30, 5, 'Legendaire', 'Désert des Knaarens');

-- 11. PARCHEMIN DE SORCELLERIE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Parchemin de sorcellerie', 'Sorts à usage unique ou à apprendre pour les érudits.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Parchemin cristallin', @id, 'Magie de cristal pure', 'Usage: Unique, Élément: Magie pure, Niveau requis: 20', 24.99, NULL, 60, 10, 'Rare', 'Landes aux esprits');

-- 12. FLÈCHES MAGIQUES
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Flèches magiques', 'Munitions enchantées pour archers.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Flèche magique (Unité)', @id, 'Flèche imprégnée de magie', 'Pointe: Acier enchanté, Dégâts magiques: 15, Portée: +10%', 1.99, NULL, 1000, 100, 'Peu commun', 'Falconia');

-- 13. SORTS UTILITAIRES
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Parchemin utilitaire', 'Sorts pratiques pour l''exploration.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Projection de lumière', @id, 'Crée une orbe lumineuse', 'Durée: 10 min, Rayon: 15m, Couleur: Blanche', 19.99, NULL, 50, 10, 'Peu commun', 'Landes aux esprits');

-- 14. SORTS DE GLACE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Parchemin de glace', 'Sorts offensifs basés sur le froid.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Gel instantané', @id, 'Congèle la cible sur place', 'Dégâts: 40 Froid, Effet: Ralentissement 50%, Portée: 10m', 34.99, NULL, 50, 10, 'Rare', 'Landes aux esprits');

-- 15. SORTS DE FEU
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Parchemin de feu', 'Sorts destructeurs basés sur la pyromancie.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Boule de feu', @id, 'Le classique : lance une boule de feu', 'Dégâts: 50 Feu, Zone: 2m, Incantation: 1.5s', 19.99, NULL, 100, 20, 'Peu commun', 'Désert des Knaarens'),
('Chaos bouillonnant', @id, 'Magie du chaos instable', 'Dégâts: 120 Feu/Ténèbres, Zone: 4m, Risque: Explosion différée', 99.99, NULL, 5, 2, 'Legendaire', 'Désert des Knaarens');

-- 16. SORTS DE TERRE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Parchemin de terre', 'Géomancie et manipulation du sol.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Graviers', @id, 'Projette des rochers sur l''ennemi', 'Dégâts: 30 Physique, Coups: 3 projectiles, Stabilité: -10', 19.99, NULL, 100, 20, 'Peu commun', 'Tour de Babel');

-- 17. MIRACLE DE SOIN
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Miracle de soin', 'Incantations sacrées de restauration.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Guérir', @id, 'Soin de base des clercs', 'Restauration: 300 PV, Coût Mana: 40, Incantation: 2s', 14.99, NULL, 300, 50, 'Peu commun', 'Forêt obscure'),
('Lumière apaisante du soleil', @id, 'Soin de zone puissant', 'Restauration: 800 PV (Groupe), Rayon: 20m, Incantation: 4s', 54.49, NULL, 100, 20, 'Epique', 'Désert des Knaarens');

-- 18. MIRACLE OFFENSIF
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Miracle offensif', 'La colère des dieux sous forme d''attaques.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Lance de foudre', @id, 'Javelot d''électricité pure', 'Dégâts: 80 Foudre, Portée: 25m, Bonus: Dégâts x2 si cible dans l''eau', 32.49, NULL, 150, 25, 'Epique', 'Landes aux esprits');

-- 19. ENCHANTEMENT D'ARME
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Enchantement d''arme', 'Améliore temporairement votre équipement.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Arme bénie', @id, 'Ajoute des dégâts sacrés', 'Durée: 60s, Effet: +30 Dégâts Sacrés + Regen PV lente', 19.99, NULL, 250, 40, 'Rare', 'Forêt obscure');

-- 20. BUFF MAGIQUE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Buff magique', 'Amélioration des statistiques personnelles.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Serment sacré', @id, 'Augmente l''attaque et la défense du groupe', 'Durée: 90s, Attaque: +10%, Défense: +10%, Cible: Alliés proches', 34.99, NULL, 180, 30, 'Rare', 'Forêt obscure');

-- 21. DAGUE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Dague', 'Lame courte, rapide et facile à dissimuler.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Dague de voleur', @id, 'Parfaite pour les attaques sournoises', 'Dégâts: 15, Critique: 130%, Poids: 0.5kg, Vitesse: Très rapide', 15.99, NULL, 80, 15, 'Commun', 'Falconia');

-- 22. ÉPÉE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Épée', 'L''arme la plus polyvalente.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Épée courte', @id, 'Légère et maniable', 'Dégâts: 25, Poids: 2kg, Matériau: Acier, Type: Tranchant', 20.49, NULL, 70, 15, 'Commun', 'Falconia'),
('Épée à deux mains', @id, 'Lourde, nécessite de la force', 'Dégâts: 60, Poids: 8kg, Matériau: Acier lourd, Type: Tranchant', 34.99, NULL, 30, 10, 'Commun', 'Falconia');

-- 23. HACHE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Hache', 'Arme brutale pour fendre les armures.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Hache de guerre', @id, 'Simple mais efficace', 'Dégâts: 35, Poids: 4kg, Bonus: Perce-armure faible', 12.99, NULL, 60, 15, 'Commun', 'Falconia');

-- 24. MARTEAU
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Marteau', 'Arme contondante.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Marteau de guerre', @id, 'Écrase les ennemis avec facilité', 'Dégâts: 40 Contondant, Poids: 6kg, Bonus: Brise garde', 34.99, NULL, 35, 10, 'Commun', 'Falconia');

-- 25. ARME D'HAST
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Arme d''hast', 'Arme à longue portée.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Lance', @id, 'Bonne allonge, parfaite en formation', 'Dégâts: 30 Estoc, Portée: Longue, Poids: 4kg', 17.49, NULL, 40, 10, 'Commun', 'Falconia');

-- 26. ARME DE TRAIT
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Arme de trait', 'Pour atteindre les cibles éloignées.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Arc long', @id, 'Nécessite de la dextérité', 'Dégâts: 35, Portée: 50m, Cadence: Moyenne, Poids: 1.5kg', 19.99, NULL, 60, 15, 'Commun', 'Falconia');

-- 27. ARME LÉGENDAIRE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Arme Légendaire', 'Relique unique d''une puissance incommensurable.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Dragon Slayer', @id, 'L''épée noire capable de tuer des apôtres', 'Dégâts: 250, Poids: 180kg, Matériau: Fer noir, Malédiction: Attire les esprits', 499.99, NULL, 1, 0, 'Legendaire', 'Falconia');

-- 28. CHAUSSURES MAGIQUES
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Chaussures magiques', 'Bottes enchantées pour le déplacement.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Bottes légèrement enchantées', @id, 'Confortables et imperméables', 'Défense: 5, Poids: 1kg, Enchantement: Marche silencieuse', 42.49, NULL, 20, 5, 'Peu commun', 'Falconia');

-- 29. SORT EN BOUTEILLE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Sort en bouteille', 'Magie condensée à lancer comme une grenade.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Sort de cristal en bouteille', @id, 'Explose en éclats de cristal', 'Dégâts: 60 Zone, Type: Jetable, Rayon: 3m', 25.00, NULL, 200, 50, 'Peu commun', 'Landes aux esprits');

-- 30. VÊTEMENTS DE MAGE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Vêtements de mage', 'Tenues tissées de mana.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Robe de sorcier pédestre', @id, 'Pour les mages voyageurs', 'Défense Physique: 10, Défense Magique: 30, Poids: 2kg', 134.00, NULL, 75, 10, 'Rare', 'Falconia');

-- 31. BOUCLIER
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Bouclier', 'Protection essentielle pour parer les coups.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Bouclier en bois', @id, 'Léger et maniable', 'Stabilité: 40, Absorption Physique: 80%, Poids: 3kg', 15.00, NULL, 50, 10, 'Commun', 'Falconia'),
('Écu du dragon', @id, 'Résiste au feu', 'Stabilité: 65, Résistance Feu: 85%, Poids: 5kg', 120.00, NULL, 5, 2, 'Epique', 'Désert des Knaarens'),
('Grand Pavois', @id, 'Protection lourde et intégrale', 'Stabilité: 80, Absorption Physique: 100%, Poids: 12kg', 60.00, NULL, 15, 5, 'Rare', 'Tour de Babel');

-- 32. ANNEAU MAGIQUE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Anneau magique', 'Bijou enchanté conférant divers bonus.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Anneau de vie', @id, 'Augmente légèrement la vitalité', 'Bonus PV: +10%, Poids: 0.1kg, Matériau: Or', 250.00, NULL, 10, 2, 'Rare', 'Falconia'),
('Anneau de pierre', @id, 'Augmente l''équilibre', 'Bonus Stabilité: +15, Poids: 0.5kg, Matériau: Granit', 200.00, NULL, 12, 2, 'Rare', 'Tour de Babel');

-- 33. CASQUE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Casque', 'Protection pour la tête.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Heaume de chevalier', @id, 'Casque en acier standard', 'Défense: 15, Poids: 4kg, Visibilité: Moyenne', 45.00, NULL, 30, 5, 'Commun', 'Falconia'),
('Capuche de voleur', @id, 'Légère et discrète', 'Défense: 5, Poids: 1kg, Bonus: Discrétion', 25.00, NULL, 40, 5, 'Commun', 'Forêt obscure');

-- 34. PLASTRON
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Armure de torse', 'La pièce principale de toute armure.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Plastron en acier', @id, 'Protection solide contre les lames', 'Défense: 45, Poids: 15kg, Mobilité: Réduite', 150.00, NULL, 20, 5, 'Commun', 'Falconia'),
('Gilet de cuir clouté', @id, 'Bon compromis mobilité/défense', 'Défense: 25, Poids: 6kg, Mobilité: Bonne', 80.00, NULL, 35, 8, 'Commun', 'Forêt obscure');

-- 35. GANTELETS
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Gantelets', 'Protection pour les mains et avant-bras.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Gantelets de fer', @id, 'Pour frapper aussi dur que l''on encaisse', 'Défense: 10, Poids: 3kg, Dégâts à mains nues: +5', 35.00, NULL, 25, 5, 'Commun', 'Falconia');

-- 36. JAMBIÈRES
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Jambières', 'Protection pour les jambes.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Grèves de soldat', @id, 'Standard pour l''armée', 'Défense: 12, Poids: 5kg, Matériau: Fer', 40.00, NULL, 30, 5, 'Commun', 'Falconia');

-- 37. AMULETTE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Amulette', 'Pendentif aux propriétés mystiques.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Amulette solaire', @id, 'Brille faiblement dans le noir', 'Effet: Illumination 2m, Poids: 0.1kg', 180.00, NULL, 8, 2, 'Rare', 'Désert des Knaarens');

-- 38. ARME DE JET
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Arme de jet', 'Projectiles consommables.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Couteau de lancer (x10)', @id, 'Lot de couteaux équilibrés', 'Dégâts: 10/u, Portée: 15m, Quantité: 10', 15.00, NULL, 100, 20, 'Commun', 'Falconia'),
('Kunaï (x10)', @id, 'Arme de jet orientale', 'Dégâts: 8/u, Portée: 20m, Quantité: 10, Vitesse: Rapide', 18.00, NULL, 80, 20, 'Commun', 'Forêt obscure');

-- 39. BOMBE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Bombe artisanale', 'Explosifs dangereux à manipuler avec précaution.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Bombe incendiaire noire', @id, 'Explosion de feu intense', 'Dégâts: 150 Feu, Zone: 4m, Délai: 2s', 12.00, NULL, 200, 30, 'Peu commun', 'Falconia'),
('Bombe de foudre', @id, 'Libère une décharge électrique', 'Dégâts: 120 Foudre, Zone: 3m, Effet: Paralysie', 15.00, NULL, 150, 30, 'Rare', 'Tour de Babel');

-- 40. TORCHE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Source de lumière', 'Indispensable dans les donjons sombres.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Torche inépuisable', @id, 'Brule éternellement sans se consumer', 'Durée: Infinie, Luminosité: Forte, Poids: 1kg', 85.00, NULL, 20, 5, 'Rare', 'Tour de Babel'),
('Torche simple', @id, 'Brule pendant 1 heure', 'Durée: 1h, Luminosité: Moyenne, Poids: 0.5kg', 2.00, NULL, 500, 50, 'Commun', 'Falconia');

-- 41. OUTILS DE VOLEUR
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Outils de voleur', 'Matériel pour ouvrir les portes verrouillées.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Crochets de serrure', @id, 'Fragiles mais efficaces', 'Usage: Déverrouillage, Durabilité: 10 utilisations', 10.00, NULL, 100, 20, 'Commun', 'Falconia');

-- 42. LONGUE-VUE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Longue-vue', 'Pour observer l''ennemi de loin.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Longue-vue en laiton', @id, 'Grossissement x10', 'Zoom: x10, Matériau: Laiton/Verre, Poids: 0.8kg', 45.00, NULL, 30, 5, 'Peu commun', 'Falconia');

-- 43. CONSOMMABLE (NOURRITURE)
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Nourriture', 'Provisions pour ne pas mourir de faim.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Pain elfique', @id, 'Une bouchée rassasie un homme', 'Valeur nutritionnelle: Haute, Conservation: 1 an, Poids: 0.1kg', 30.00, NULL, 50, 10, 'Rare', 'Forêt obscure'),
('Ration de voyage', @id, 'Viande séchée et pain dur', 'Valeur nutritionnelle: Moyenne, Conservation: 3 mois', 5.00, NULL, 200, 50, 'Commun', 'Falconia');

-- 44. MINERAI
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Matériaux d''artisanat', 'Ressources brutes pour la forge.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Éclat de Titanite', @id, 'Renforce les armes', 'Usage: Forge +3, Rareté: Élevée', 80.00, NULL, 40, 10, 'Rare', 'Tour de Babel'),
('Acier trempé', @id, 'Métal de qualité supérieure', 'Usage: Forge de base, Poids: 1kg/lingot', 20.00, NULL, 100, 20, 'Commun', 'Falconia');

-- 45. GEMMES
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Gemmes précieuses', 'Pierres pouvant être serties ou vendues.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Rubis sanglant', @id, 'Augmente les dégâts de feu', 'Infusion: Feu +10%, Pureté: Parfaite, Poids: 0.05kg', 300.00, NULL, 5, 1, 'Epique', 'Désert des Knaarens');

-- 46. HERBES
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Herbes médicinales', 'Plantes aux vertus curatives.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Fleur verte', @id, 'Accélère la récupération d''endurance', 'Effet: Regen Endurance +20%, Durée: 60s, Goût: Herbeux', 8.00, NULL, 150, 20, 'Commun', 'Forêt obscure'),
('Mousse violette', @id, 'Soigne le poison', 'Effet: Cure Poison, Réduit jauge toxique, Goût: Infecte', 12.00, NULL, 100, 20, 'Peu commun', 'Forêt obscure');

-- 47. CAPE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Cape', 'Vêtement couvrant le dos.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Cape de voyage', @id, 'Protège de la pluie', 'Matériau: Laine huilée, Résistance froid: +5, Poids: 1.5kg', 20.00, NULL, 60, 10, 'Commun', 'Falconia');

-- 48. INSTRUMENT DE MUSIQUE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Instrument', 'Pour les bardes et les fêtes.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Luth', @id, 'Instrument à cordes classique', 'Cordes: 6, Bois: Érable, Sonorité: Claire, Poids: 2kg', 65.00, NULL, 15, 2, 'Peu commun', 'Falconia');

-- 49. NÉCROMANCIE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Objets occultes', 'Accessoires liés à la magie de la mort.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Crâne maudit', @id, 'Attire les esprits', 'Effet: Leurre spectral, Durée: 15s, Poids: 0.5kg', 40.00, NULL, 20, 5, 'Rare', 'Landes aux esprits');

-- 50. CARTE
INSERT INTO Produit (libelle, description, moyenneAvis) VALUES ('Carte géographique', 'Pour ne jamais se perdre.', NULL);
SET @id = LAST_INSERT_ID();
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES
('Carte du royaume', @id, 'Carte détaillée de Falconia et alentours', 'Format: A2, Papier: Parchemin, Détail: Élevé', 10.00, NULL, 100, 10, 'Commun', 'Falconia');



-- =======================================================
-- 2. INSERTION DES KITS (DÉCLINAISONS DE "KITS THÉMATIQUES")
-- =======================================================

-- Création du produit générique pour tous les kits (le Parent)
INSERT INTO Produit (libelle, description, moyenneAvis)
VALUES ('Kits Thématiques', 'Lots de produits regroupés à un prix avantageux.', NULL)
ON DUPLICATE KEY UPDATE libelle = libelle;
SET @idKitProduit = LAST_INSERT_ID();
-- Définition des valeurs fixes pour tous les kits
SET @qualiteFixe = 'Mixte';
SET @provenanceFixe = 'Multiples';

-- -------------------------
-- Kit 1 : Pyromancien
-- -------------------------
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
VALUES
('Kit du Pyromancien', @idKitProduit, 'Équipement essentiel pour maîtriser la pyromancie.', 'Contient : 1x Sort de Boule de feu, 1x Sort de Chaos Bouillonnant, 1x Torche Inépuisable, 3x Pain Elfique. Avantage : Spécialisé en dégâts de zone et lumière illimitée.', 129.95, NULL, 50, 10, @qualiteFixe, @provenanceFixe);
SET @idKitPyromancien = LAST_INSERT_ID();

INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES
(@idKitPyromancien, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Boule de feu' LIMIT 1), 1),
(@idKitPyromancien, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Chaos bouillonnant' LIMIT 1), 1),
(@idKitPyromancien, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Torche inépuisable' LIMIT 1), 1),
(@idKitPyromancien, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Pain elfique' LIMIT 1), 3);

-- -------------------------
-- Kit 2 : Cryomage
-- -------------------------
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
VALUES
('Kit du Cryomage', @idKitProduit, 'Maîtrisez le froid et la glace.', 'Contient : 1x Sort de Gel Instantané, 5x Fleurs Vertes, 1x Robe de Sorcier Pédestre, 1x Longue-vue. Avantage : Contrôle des foules et endurance accrue pour l\'exploration.', 149.90, NULL, 40, 8, @qualiteFixe, @provenanceFixe);
SET @idKitCryomage = LAST_INSERT_ID();

INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES
(@idKitCryomage, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Gel instantané' LIMIT 1), 1),
(@idKitCryomage, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Fleur verte' LIMIT 1), 5),
(@idKitCryomage, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Robe de sorcier pédestre' LIMIT 1), 1),
(@idKitCryomage, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Longue-vue en laiton' LIMIT 1), 1);

-- -------------------------
-- Kit 3 : Mage Tellurique
-- -------------------------
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
VALUES
('Kit du Mage Tellurique', @idKitProduit, 'Force brute et protection terrestre.', 'Contient : 2x Sort de Graviers, 1x Éclat de Titanite, 1x Grand Pavois. Avantage : Défense physique très élevée et capacité d\'amélioration d\'arme.', 118.50, NULL, 30, 5, @qualiteFixe, @provenanceFixe);
SET @idKitTellurique = LAST_INSERT_ID();

INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES
(@idKitTellurique, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Graviers' LIMIT 1), 2),
(@idKitTellurique, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Éclat de Titanite' LIMIT 1), 1),
(@idKitTellurique, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Grand Pavois' LIMIT 1), 1);

-- -------------------------
-- Kit 4 : Mage Vagabond
-- -------------------------
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
VALUES
('Kit du Mage Vagabond', @idKitProduit, 'L\'équipement parfait pour les voyages prolongés.', 'Contient : 1x Robe de Sorcier Pédestre, 1x Bottes Légèrement Enchantées, 5x Torches Simples, 1x Carte du Royaume. Avantage : Optimisé pour le long voyage et l\'orientation.', 199.99, 179.99, 60, 10, @qualiteFixe, @provenanceFixe);
SET @idKitVagabond = LAST_INSERT_ID();

INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES
(@idKitVagabond, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Robe de sorcier pédestre' LIMIT 1), 1),
(@idKitVagabond, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Bottes légèrement enchantées' LIMIT 1), 1),
(@idKitVagabond, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Torche simple' LIMIT 1), 5),
(@idKitVagabond, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Carte du royaume' LIMIT 1), 1);

-- -------------------------
-- Kit 5 : Mage de Guerre
-- -------------------------
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
VALUES
('Kit du Mage de Guerre', @idKitProduit, 'Quand la magie et la force se rencontrent.', 'Contient : 1x Serment Sacré, 1x Épée à Deux Mains, 1x Grèves de Soldat, 1x Bouclier en Bois. Avantage : Équilibre entre magie de soutien et combat au corps-à-corps lourd.', 179.90, NULL, 25, 5, @qualiteFixe, @provenanceFixe);
SET @idKitGuerre = LAST_INSERT_ID();

INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES
(@idKitGuerre, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Serment sacré' LIMIT 1), 1),
(@idKitGuerre, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Épée à deux mains' LIMIT 1), 1),
(@idKitGuerre, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Grèves de soldat' LIMIT 1), 1),
(@idKitGuerre, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Bouclier en bois' LIMIT 1), 1);

-- -------------------------
-- Kit 6 : Mage aux Petits Soins
-- -------------------------
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
VALUES
('Kit du Mage aux Petits Soins', @idKitProduit, 'L\'essentiel pour un soigneur divin.', 'Contient : 2x Miracle Guérir, 1x Miracle Lumière Apaisante du Soleil, 3x Mousse Violette. Avantage : Maximise la capacité de soin en zone et la gestion du poison.', 149.00, NULL, 70, 15, @qualiteFixe, @provenanceFixe);
SET @idKitSoins = LAST_INSERT_ID();

INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES
(@idKitSoins, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Guérir' LIMIT 1), 2),
(@idKitSoins, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Lumière apaisante du soleil' LIMIT 1), 1),
(@idKitSoins, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Mousse violette' LIMIT 1), 3);

-- -------------------------
-- Kit 7 : Kit du Gardien
-- -------------------------
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
VALUES
('Kit du Gardien', @idKitProduit, 'Armure lourde complète pour tanker.', 'Contient : 1x Plastron en Acier, 1x Grand Pavois, 1x Heaume de Chevalier, 1x Gantelets de Fer. Avantage : Armure complète pour une absorption maximale des dégâts.', 239.99, 219.99, 15, 3, @qualiteFixe, @provenanceFixe);
SET @idKitGardien = LAST_INSERT_ID();

INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES
(@idKitGardien, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Plastron en acier' LIMIT 1), 1),
(@idKitGardien, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Grand Pavois' LIMIT 1), 1),
(@idKitGardien, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Heaume de chevalier' LIMIT 1), 1),
(@idKitGardien, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Gantelets de fer' LIMIT 1), 1);

-- -------------------------
-- Kit 8 : Kit de l'Ombre
-- -------------------------
INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
VALUES
('Kit de l''Ombre', @idKitProduit, 'L\'équipement discret pour le voleur professionnel.', 'Contient : 2x Dagues de Voleur, 1x Capuche de Voleur, 3x Crochets de Serrure, 1x Cape de Voyage. Avantage : Ensemble parfait pour la discrétion, l\'ouverture de serrures et le combat rapide.', 89.90, NULL, 80, 20, @qualiteFixe, @provenanceFixe);
SET @idKitOmbre = LAST_INSERT_ID();

INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES
(@idKitOmbre, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Dague de voleur' LIMIT 1), 2),
(@idKitOmbre, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Capuche de voleur' LIMIT 1), 1),
(@idKitOmbre, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Crochets de serrure' LIMIT 1), 3),
(@idKitOmbre, (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison='Cape de voyage' LIMIT 1), 1);


-- ============================================
-- INSERTION DES CLIENTS (50 clients)
-- ============================================
INSERT INTO Client (nom, prenom, email, motDePasse, adresse, codePostal, ville, telephone, ptsFidelite) VALUES
-- Paris et Île-de-France (75, 77, 78, 91, 92, 93, 94, 95)
('Dubois', 'Marie', 'marie.dubois@email.fr', '$2y$10$abcdefghijklmnopqrstuv', '12 rue de Rivoli', '75001', 'Paris', '0145678901', 150),
('Martin', 'Jean', 'jean.martin@email.fr', '$2y$10$bcdefghijklmnopqrstuvw', '45 avenue des Champs-Élysées', '75008', 'Paris', '0156789012', 320),
('Bernard', 'Sophie', 'sophie.bernard@email.fr', '$2y$10$cdefghijklmnopqrstuvwx', '23 rue du Faubourg Saint-Antoine', '75011', 'Paris', '0167890123', 75),
('Petit', 'Lucas', 'lucas.petit@email.fr', '$2y$10$defghijklmnopqrstuvwxy', '78 boulevard Voltaire', '75011', 'Paris', '0178901234', 0),
('Durand', 'Emma', 'emma.durand@email.fr', '$2y$10$efghijklmnopqrstuvwxyz', '15 rue de la Paix', '75002', 'Paris', '0189012345', 450),
('Leroy', 'Thomas', 'thomas.leroy@email.fr', '$2y$10$fghijklmnopqrstuvwxyza', '89 avenue de Versailles', '92130', 'Issy-les-Moulineaux', '0190123456', 210),
('Moreau', 'Léa', 'lea.moreau@email.fr', '$2y$10$ghijklmnopqrstuvwxyzab', '34 rue du Commerce', '92100', 'Boulogne-Billancourt', '0101234567', 80),
('Simon', 'Hugo', 'hugo.simon@email.fr', '$2y$10$hijklmnopqrstuvwxyzabc', '56 avenue Paul Doumer', '94160', 'Saint-Mandé', '0112345678', 0),
('Laurent', 'Chloé', 'chloe.laurent@email.fr', '$2y$10$ijklmnopqrstuvwxyzabcd', '12 boulevard de Strasbourg', '77000', 'Melun', '0123456789', 190),
('Lefebvre', 'Nathan', 'nathan.lefebvre@email.fr', '$2y$10$jklmnopqrstuvwxyzabcde', '67 rue de la République', '78000', 'Versailles', '0134567890', 340),

-- Nord et Hauts-de-France (59, 62, 80, 02, 60)
('Roux', 'Camille', 'camille.roux@email.fr', '$2y$10$klmnopqrstuvwxyzabcdef', '89 rue Nationale', '59000', 'Lille', '0320123456', 125),
('Fournier', 'Louis', 'louis.fournier@email.fr', '$2y$10$lmnopqrstuvwxyzabcdefg', '23 place du Général de Gaulle', '59800', 'Lille', '0320234567', 0),
('Girard', 'Manon', 'manon.girard@email.fr', '$2y$10$mnopqrstuvwxyzabcdefgh', '45 rue Gambetta', '62000', 'Arras', '0321345678', 95),
('Bonnet', 'Gabriel', 'gabriel.bonnet@email.fr', '$2y$10$nopqrstuvwxyzabcdefghi', '78 boulevard Carnot', '80000', 'Amiens', '0322456789', 260),
('Dupont', 'Inès', 'ines.dupont@email.fr', '$2y$10$opqrstuvwxyzabcdefghij', '12 rue de la Gare', '60000', 'Beauvais', '0344567890', 0),

-- Grand Est (67, 68, 54, 57, 51, 10, 88)
('Lambert', 'Arthur', 'arthur.lambert@email.fr', '$2y$10$pqrstuvwxyzabcdefghijk', '34 rue du Vieux-Marché-aux-Vins', '67000', 'Strasbourg', '0388678901', 410),
('Fontaine', 'Jade', 'jade.fontaine@email.fr', '$2y$10$qrstuvwxyzabcdefghijkl', '56 avenue de Colmar', '68100', 'Mulhouse', '0389789012', 170),
('Rousseau', 'Jules', 'jules.rousseau@email.fr', '$2y$10$rstuvwxyzabcdefghijklm', '89 rue Saint-Dizier', '54000', 'Nancy', '0383890123', 0),
('Vincent', 'Alice', 'alice.vincent@email.fr', '$2y$10$stuvwxyzabcdefghijklmn', '23 rue Serpenoise', '57000', 'Metz', '0387901234', 285),
('Muller', 'Adam', 'adam.muller@email.fr', '$2y$10$tuvwxyzabcdefghijklmno', '45 boulevard Victor Hugo', '51100', 'Reims', '0326012345', 130),

-- Auvergne-Rhône-Alpes (69, 38, 74, 73, 42, 63)
('Leclerc', 'Zoé', 'zoe.leclerc@email.fr', '$2y$10$uvwxyzabcdefghijklmnop', '67 rue de la République', '69002', 'Lyon', '0478123456', 380),
('Gauthier', 'Raphaël', 'raphael.gauthier@email.fr', '$2y$10$vwxyzabcdefghijklmnopq', '12 cours Berriat', '38000', 'Grenoble', '0476234567', 0),
('Morel', 'Lola', 'lola.morel@email.fr', '$2y$10$wxyzabcdefghijklmnopqr', '34 rue Vaugelas', '74000', 'Annecy', '0450345678', 220),
('Garnier', 'Paul', 'paul.garnier@email.fr', '$2y$10$xyzabcdefghijklmnopqrs', '56 avenue du Général de Gaulle', '73000', 'Chambéry', '0479456567', 0),
('Faure', 'Lina', 'lina.faure@email.fr', '$2y$10$yzabcdefghijklmnopqrst', '89 rue de la République', '42000', 'Saint-Étienne', '0477567890', 160),
('André', 'Tom', 'tom.andre@email.fr', '$2y$10$zabcdefghijklmnopqrstu', '23 boulevard Berthelot', '63000', 'Clermont-Ferrand', '0473678901', 90),

-- Provence-Alpes-Côte d'Azur (13, 83, 06, 84)
('Mercier', 'Mia', 'mia.mercier@email.fr', '$2y$10$abcdefghijklmnopqrstuv1', '45 La Canebière', '13001', 'Marseille', '0491789012', 500),
('Blanc', 'Noah', 'noah.blanc@email.fr', '$2y$10$bcdefghijklmnopqrstuv1w', '67 avenue Jean Médecin', '06000', 'Nice', '0493890123', 275),
('Guerin', 'Lou', 'lou.guerin@email.fr', '$2y$10$cdefghijklmnopqrstuv1wx', '12 boulevard de Strasbourg', '83000', 'Toulon', '0494901234', 0),
('Boyer', 'Ethan', 'ethan.boyer@email.fr', '$2y$10$defghijklmnopqrstuv1wxy', '34 rue de la République', '84000', 'Avignon', '0490012345', 140),

-- Occitanie (31, 34, 66, 11, 81, 82)
('Garnier', 'Nina', 'nina.garnier@email.fr', '$2y$10$efghijklmnopqrstuv1wxyz', '56 rue Alsace-Lorraine', '31000', 'Toulouse', '0561123456', 310),
('Chevalier', 'Théo', 'theo.chevalier@email.fr', '$2y$10$fghijklmnopqrstuv1wxyza', '89 rue de la Loge', '34000', 'Montpellier', '0467234567', 0),
('François', 'Sarah', 'sarah.francois@email.fr', '$2y$10$ghijklmnopqrstuv1wxyzab', '23 avenue de la Gare', '66000', 'Perpignan', '0468345678', 185),
('Fernandez', 'Maxime', 'maxime.fernandez@email.fr', '$2y$10$hijklmnopqrstuv1wxyzabc', '45 rue de Verdun', '11000', 'Carcassonne', '0468456789', 70),
('Lemoine', 'Léna', 'lena.lemoine@email.fr', '$2y$10$ijklmnopqrstuv1wxyzabcd', '67 rue Gambetta', '81000', 'Albi', '0563567890', 0),

-- Nouvelle-Aquitaine (33, 64, 40, 87, 86, 24)
('Martinez', 'Alexandre', 'alexandre.martinez@email.fr', '$2y$10$jklmnopqrstuv1wxyzabcde', '12 cours de l\'Intendance', '33000', 'Bordeaux', '0556678901', 425),
('Lopez', 'Juliette', 'juliette.lopez@email.fr', '$2y$10$klmnopqrstuv1wxyzabcdef', '34 avenue du Maréchal Foch', '64000', 'Pau', '0559789012', 0),
('Sanchez', 'Baptiste', 'baptiste.sanchez@email.fr', '$2y$10$lmnopqrstuv1wxyzabcdefg', '56 avenue Georges Clemenceau', '40000', 'Mont-de-Marsan', '0558890123', 200),
('Rolland', 'Clara', 'clara.rolland@email.fr', '$2y$10$mnopqrstuv1wxyzabcdefgh', '89 boulevard Carnot', '87000', 'Limoges', '0555901234', 110),

-- Bretagne (35, 29, 56, 22)
('Giraud', 'Antoine', 'antoine.giraud@email.fr', '$2y$10$nopqrstuv1wxyzabcdefghi', '23 rue d\'Antrain', '35000', 'Rennes', '0299012345', 240),
('Caron', 'Rose', 'rose.caron@email.fr', '$2y$10$opqrstuv1wxyzabcdefghij', '45 rue de Siam', '29200', 'Brest', '0298123456', 0),
('Renard', 'Matteo', 'matteo.renard@email.fr', '$2y$10$pqrstuv1wxyzabcdefghijk', '67 rue du Port', '56100', 'Lorient', '0297234567', 175),
('Colin', 'Anna', 'anna.colin@email.fr', '$2y$10$qrstuv1wxyzabcdefghijkl', '12 place du Général de Gaulle', '22000', 'Saint-Brieuc', '0296345678', 85),

-- Pays de la Loire (44, 49, 85, 72, 53)
('Pierre', 'Mathis', 'mathis.pierre@email.fr', '$2y$10$rstuv1wxyzabcdefghijklm', '34 rue Crébillon', '44000', 'Nantes', '0240456789', 365),
('Masson', 'Victoria', 'victoria.masson@email.fr', '$2y$10$stuv1wxyzabcdefghijklmn', '56 boulevard du Roi René', '49100', 'Angers', '0241567890', 0),
('Leroux', 'Mathéo', 'matheo.leroux@email.fr', '$2y$10$tuv1wxyzabcdefghijklmno', '89 rue Georges Clemenceau', '85000', 'La Roche-sur-Yon', '0251678901', 155),

-- Centre-Val de Loire (45, 37, 41, 18, 28)
('Perrin', 'Léonie', 'leonie.perrin@email.fr', '$2y$10$uv1wxyzabcdefghijklmnop', '23 rue de la République', '45000', 'Orléans', '0238789012', 195),
('Clement', 'Sacha', 'sacha.clement@email.fr', '$2y$10$v1wxyzabcdefghijklmnopq', '45 rue Nationale', '37000', 'Tours', '0247890123', 0),
('Joly', 'Lily', 'lily.joly@email.fr', '$2y$10$w1xyzabcdefghijklmnopqr', '67 rue du Commerce', '41000', 'Blois', '0254901234', 120),
('Marchand', 'Élise', 'elise.marchand@email.fr', '$2y$10$x1yzabcdefghijklmnopqrs', 
 '12 rue des Lilas', '72000', 'Le Mans', '0244789012', 145);





-- ============================================
-- INSERTION DES PRODUITS APPARENTÉS (25 Couples)
-- ============================================

-- 1. Potion de Soin & Potion de Mana (Les indispensables)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Potion de soin' AND p2.libelle = 'Potion de mana';

-- 2. Épée & Bouclier (Le set du guerrier)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Épée' AND p2.libelle = 'Bouclier';

-- 3. Baguette magique & Vêtements de mage (Le set du sorcier)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Baguette magique' AND p2.libelle = 'Vêtements de mage';

-- 4. Arme de trait (Arc) & Flèches magiques (Munitions)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Arme de trait' AND p2.libelle = 'Flèches magiques';

-- 5. Dague & Outils de voleur (Le set du roublard)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Dague' AND p2.libelle = 'Outils de voleur';

-- 6. Plastron & Jambières (Armure complète partie 1)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Armure de torse' AND p2.libelle = 'Jambières';

-- 7. Plastron & Casque (Armure complète partie 2)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Armure de torse' AND p2.libelle = 'Casque';

-- 8. Manuel de recettes & Herbes médicinales (Crafting)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Manuel de recettes' AND p2.libelle = 'Herbes médicinales';

-- 9. Matériaux d'artisanat & Gemmes précieuses (Forge)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Matériaux d''artisanat' AND p2.libelle = 'Gemmes précieuses';

-- 10. Tome de pyromancie & Parchemin de feu (Magie du feu)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Tome de pyromancie' AND p2.libelle = 'Parchemin de feu';

-- 11. Tome divin & Miracle de soin (Magie sacrée)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Tome divin' AND p2.libelle = 'Miracle de soin';

-- 12. Carte géographique & Longue-vue (Exploration)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Carte géographique' AND p2.libelle = 'Longue-vue';

-- 13. Source de lumière & Nourriture (Survie de base)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Source de lumière' AND p2.libelle = 'Nourriture';

-- 14. Anneau magique & Amulette (Bijoux)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Anneau magique' AND p2.libelle = 'Amulette';

-- 15. Dague & Cape (Discrétion)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Dague' AND p2.libelle = 'Cape';

-- 16. Bombe artisanale & Arme de jet (Projectiles)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Bombe artisanale' AND p2.libelle = 'Arme de jet';

-- 17. Épée & Enchantement d'arme (Buff d'attaque)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Épée' AND p2.libelle = 'Enchantement d''arme';

-- 18. Hache & Bouclier (Variante Guerrier)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Hache' AND p2.libelle = 'Bouclier';

-- 19. Bâton magique & Vêtements de mage (Variante Mage)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Bâton magique' AND p2.libelle = 'Vêtements de mage';

-- 20. Parchemin de glace & Baguette magique (Synergie Glace)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Parchemin de glace' AND p2.libelle = 'Baguette magique';

-- 21. Chaussures magiques & Cape (Voyage rapide)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Chaussures magiques' AND p2.libelle = 'Cape';

-- 22. Arme Légendaire & Anneau magique (Équipement haut niveau)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Arme Légendaire' AND p2.libelle = 'Anneau magique';

-- 23. Manuel d'informations & Carte géographique (Savoir)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Manuel d''informations' AND p2.libelle = 'Carte géographique';

-- 24. Marteau & Gantelets (Force brute)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Marteau' AND p2.libelle = 'Gantelets';

-- 25. Parchemin de terre & Bâton magique (Synergie Terre)
INSERT INTO Apparenter (idProduit1, idProduit2)
SELECT LEAST(p1.idProduit, p2.idProduit), GREATEST(p1.idProduit, p2.idProduit)
FROM Produit p1 JOIN Produit p2 ON p1.libelle = 'Parchemin de terre' AND p2.libelle = 'Bâton magique';

-- Potions et consommables
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (1, 2);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (2, 3);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (1, 8);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (2, 20);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (29, 1);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (29, 2);

-- Manuels et apprentissage
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (4, 5);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (4, 11);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (4, 13);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (5, 44);

-- Équipement magique
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (6, 8);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (6, 20);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (6, 11);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (7, 8);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (7, 11);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (7, 20);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (8, 32);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (8, 37);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (28, 32);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (30, 32);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (30, 37);

-- Tomes et parchemins
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (9, 18);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (9, 37);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (10, 14);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (11, 13);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (11, 20);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (13, 40);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (14, 15);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (15, 16);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (17, 18);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (17, 9);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (17, 3);

-- Armes de mêlée
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (21, 22);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (22, 23);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (23, 24);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (23, 19);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (24, 19);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (25, 19);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (25, 31);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (21, 31);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (24, 31);

-- Armes à distance
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (26, 38);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (26, 39);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (12, 38);

-- Armures complètes
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (33, 35);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (33, 36);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (35, 36);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (31, 33);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (31, 35);

-- Équipement d'exploration
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (40, 50);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (40, 41);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (41, 21);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (50, 13);

-- Artisanat et ressources
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (44, 19);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (45, 32);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (45, 37);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (46, 3);

-- Équipement de voleur/rôdeur
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (28, 21);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (28, 41);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (30, 28);

-- Vêtements et accessoires
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (47, 30);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (47, 32);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (47, 37);

-- Armes légendaires
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (27, 19);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (27, 20);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (27, 37);

-- Objets spéciaux
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (29, 20);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (29, 39);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (49, 11);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (49, 37);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (49, 8);

-- Kits et combinaisons
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (51, 1);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (51, 3);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (51, 40);
INSERT INTO Apparenter (idProduit1, idProduit2) VALUES (51, 50);


-- ============================================
-- PEUPLEMENT DES CATÉGORIES ET LIAISON PRODUITS
-- ============================================



-- --------------------------------------------------------
-- 1. RAYON : ARMES (Guerrier / Voleur)
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Armes', NULL);
SET @idArmes = LAST_INSERT_ID();

    -- Niveau 2 : Corps à corps
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Armes de Mêlée', @idArmes);
    SET @idMelee = LAST_INSERT_ID();
    
        -- Niveau 3 : Types spécifiques
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Dagues & Couteaux', @idMelee);
        SET @idDagues = LAST_INSERT_ID();
        -- Liaison Produits
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, @idDagues FROM Produit WHERE libelle IN ('Dague', 'Dague de voleur', 'Kit de l''Ombre');

        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Épées', @idMelee);
        SET @idEpees = LAST_INSERT_ID();
        -- Liaison Produits
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, @idEpees FROM Produit WHERE libelle IN ('Épée', 'Épée courte', 'Épée à deux mains', 'Dragon Slayer');
        INSERT INTO Appartenir (idProduit, idCategorie)
        SELECT idProduit, @idEpees
        FROM Produit
        WHERE libelle = 'Arme Légendaire';
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Haches', @idMelee);
        SET @idHaches = LAST_INSERT_ID();
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, @idHaches FROM Produit WHERE libelle IN ('Hache', 'Hache de guerre');

        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Marteaux', @idMelee);
        SET @idMarteaux = LAST_INSERT_ID();
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, @idMarteaux FROM Produit WHERE libelle IN ('Marteau', 'Marteau de guerre');

        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Armes d''Hast', @idMelee);
        SET @idHast = LAST_INSERT_ID();
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, @idHast FROM Produit WHERE libelle IN ('Arme d''hast', 'Lance');

    -- Niveau 2 : Distance
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Armes à Distance', @idArmes);
    SET @idDist = LAST_INSERT_ID();
    
        -- Niveau 3
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Arcs', @idDist);
        SET @idArcs = LAST_INSERT_ID();
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, @idArcs FROM Produit WHERE libelle IN ('Arme de trait', 'Arc long');

-- --------------------------------------------------------
-- 2. RAYON : ARMURES & PROTECTIONS
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Protections', NULL);
SET @idProtect = LAST_INSERT_ID();

    -- Niveau 2
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Armures Métalliques', @idProtect);
    SET @idMetal = LAST_INSERT_ID();
        -- Niveau 3
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Casques & Heaumes', @idMetal);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Casque';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Plastrons', @idMetal);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Armure de torse';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Gantelets & Jambières', @idMetal);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle IN ('Gantelets', 'Jambières');

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Boucliers', @idProtect);
    SET @idBouclier = LAST_INSERT_ID();
    INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, @idBouclier FROM Produit WHERE libelle = 'Bouclier';

-- --------------------------------------------------------
-- 3. RAYON : MAGIE (Catalyseurs)
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Catalyseurs Magiques', NULL);
SET @idMagicItems = LAST_INSERT_ID();

    -- Niveau 2
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Pour Sorciers', @idMagicItems);
    SET @idSorcier = LAST_INSERT_ID();
        -- Niveau 3
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Baguettes Magiques', @idSorcier);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Baguette magique';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Bâtons de Mage', @idSorcier);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Bâton magique';

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Pour Clercs', @idMagicItems);
    SET @idClerc = LAST_INSERT_ID();
        -- Niveau 3
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Talismans Sacrés', @idClerc);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Talisman';

-- --------------------------------------------------------
-- 4. RAYON : POTIONS (Alchimie)
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Alchimie & Potions', NULL);
SET @idAlchi = LAST_INSERT_ID();

    -- Niveau 2
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Potions de Restauration', @idAlchi);
    SET @idRestau = LAST_INSERT_ID();
        -- Niveau 3
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Soins', @idRestau);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Potion de soin';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Mana', @idRestau);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Potion de mana';

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Potions de Buff', @idAlchi);
    SET @idBuffs = LAST_INSERT_ID();
        -- Niveau 3
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Résistances Élémentaires', @idBuffs);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Potion de résistance';

-- --------------------------------------------------------
-- 5. RAYON : BIBLIOTHÈQUE (Savoir)
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Bibliothèque', NULL);
SET @idBiblio = LAST_INSERT_ID();

    -- Niveau 2
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Grimoires de Sorts', @idBiblio);
    SET @idGrim = LAST_INSERT_ID();
        -- Niveau 3
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Tomes Divins', @idGrim);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Tome divin';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Pyromancie', @idGrim);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Tome de pyromancie';

        SET @idGrim = (SELECT idCategorie FROM Categorie WHERE libelle = 'Grimoires de Sorts' LIMIT 1);
        INSERT INTO Appartenir (idProduit, idCategorie)
        SELECT idProduit, @idGrim FROM Produit WHERE libelle = 'Objets occultes';


    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Parchemins Unitaires', @idBiblio);
    SET @idParch = LAST_INSERT_ID();
     INSERT INTO Appartenir (idProduit, idCategorie)
         SELECT idProduit, @idParch
         FROM Produit
         WHERE libelle = 'Parchemin utilitaire';
  
        -- Niveau 3
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Sorts Offensifs', @idParch);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle IN ('Parchemin de feu', 'Parchemin de glace', 'Parchemin de terre', 'Parchemin de sorcellerie');

        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Miracles', @idParch);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle IN ('Miracle de soin', 'Miracle offensif', 'Buff magique', 'Enchantement d''arme');

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Guides Pratiques', @idBiblio);
    INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle IN ('Manuel d''informations', 'Manuel de recettes', 'Carte géographique');

-- --------------------------------------------------------
-- 6. RAYON : MUNITIONS & EXPLOSIFS
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Munitions & Explosifs', NULL);
SET @idAmmo = LAST_INSERT_ID();

    -- Niveau 2
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Projectiles', @idAmmo);
    SET @idProj = LAST_INSERT_ID();
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Flèches', @idProj);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Flèches magiques';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Armes de Jet', @idProj);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Arme de jet';

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Explosifs', @idAmmo);
    SET @idBomb = LAST_INSERT_ID();
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Bombes', @idBomb);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Bombe artisanale';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Sorts en Bouteille', @idBomb);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Sort en bouteille';

-- --------------------------------------------------------
-- 7. RAYON : VÊTEMENTS & APPARAT
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Vêtements & Apparat', NULL);
SET @idVet = LAST_INSERT_ID();

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Tenues de Voyage', @idVet);
    SET @idVoyage = LAST_INSERT_ID();
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Capes', @idVoyage);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Cape';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Chaussures', @idVoyage);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Chaussures magiques';

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Tenues de Mage', @idVet);
    INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Vêtements de mage';

-- --------------------------------------------------------
-- 8. RAYON : BIJOUTERIE
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Bijouterie Magique', NULL);
SET @idBijoux = LAST_INSERT_ID();

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Anneaux', @idBijoux);
    INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Anneau magique';

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Amulettes', @idBijoux);
    INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Amulette';

-- --------------------------------------------------------
-- 9. RAYON : OUTILS D'AVENTURIER
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Outils d''Aventurier', NULL);
SET @idOutils = LAST_INSERT_ID();

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Exploration', @idOutils);
    SET @idExplo = LAST_INSERT_ID();
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Éclairage', @idExplo);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Source de lumière'; -- Torches
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Observation', @idExplo);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Longue-vue';

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Effraction', @idOutils);
    INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Outils de voleur';

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Survie', @idOutils);
    INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Nourriture';

-- --------------------------------------------------------
-- 10. RAYON : ARTISANAT (Crafting)
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Artisanat & Ressources', NULL);
SET @idCraft = LAST_INSERT_ID();

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Composants de Forge', @idCraft);
    SET @idForge = LAST_INSERT_ID();
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Minerais', @idForge);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Matériaux d''artisanat';
        
        INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Gemmes', @idForge);
        INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Gemmes précieuses';

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Botanique', @idCraft);
    INSERT INTO Appartenir (idProduit, idCategorie) SELECT idProduit, LAST_INSERT_ID() FROM Produit WHERE libelle = 'Herbes médicinales';

-- --------------------------------------------------------
-- 11. RAYON : KITS THÉMATIQUES
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Kits & Coffrets', NULL);
SET @idKits = LAST_INSERT_ID();

    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Kits Thématiques', @idKits);
    SET @idKitsThematiques = LAST_INSERT_ID();

    -- Liaison des 8 kits au produit 'Kits Thématiques' et à cette sous-catégorie
    INSERT INTO Appartenir (idProduit, idCategorie)
    SELECT idProduit, @idKitsThematiques
    FROM Produit
    WHERE libelle = 'Kits Thématiques'
    ON DUPLICATE KEY UPDATE idCategorie = idCategorie;

-- --------------------------------------------------------
-- 12. RAYON : CULTURE & DIVERTISSEMENT
-- --------------------------------------------------------
INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Culture & Divertissement', NULL);
SET @idCulture = LAST_INSERT_ID();

    -- Niveau 2
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Instruments de Musique', @idCulture);
    SET @idInstruments = LAST_INSERT_ID();
    
    -- Niveau 3
    INSERT INTO Categorie (libelle, idCategorieParent) VALUES ('Cordes', @idInstruments);
    SET @idCordes = LAST_INSERT_ID();

    -- Liaison du Produit 'Instrument' à la sous-catégorie 'Cordes'
    INSERT INTO Appartenir (idProduit, idCategorie) 
    SELECT idProduit, @idCordes FROM Produit WHERE libelle = 'Instrument';

-- ============================
-- INSERTION DES REGROUPEMENTS
-- ============================
INSERT INTO Regroupement (libelle) VALUES
('Nouveautés'),
('Soldes'),
('Made in Falconia'),
('Best Sellers'),
('Éditions limitées'),
('Recommandés');

-- ============================
-- ASSOCIATION PRODUITS / REGROUPEMENTS
-- ============================
-- Regroupement : Nouveautés (id 1)
INSERT INTO Regrouper VALUES
(1, 1), (1, 2), (1, 3), (1, 7), (1, 8);

-- Regroupement : Soldes (id 2)
INSERT INTO Regrouper VALUES
(2, 2), (2, 4), (2, 5), (2, 9), (2, 10);

-- Regroupement : Made in Falconia (id 3)
INSERT INTO Regrouper VALUES
(3, 1), (3, 3), (3, 6), (3, 8), (3, 11), (3, 12);

-- Regroupement : Best Sellers (id 4)
INSERT INTO Regrouper VALUES
(4, 1), (4, 4), (4, 5), (4, 6), (4, 9), (4, 12);

-- Regroupement : Éditions limitées (id 5)
INSERT INTO Regrouper VALUES
(5, 7), (5, 8), (5, 10), (5, 11);

-- Regroupement : Recommandés (id 6)
INSERT INTO Regrouper VALUES
(6, 2), (6, 3), (6, 5), (6, 7), (6, 8), (6, 9);



