TRUNCATE TABLE LigneCommande;
TRUNCATE TABLE Commande;
-- ============================================
-- INSERTION DE 100 COMMANDES RÉALISTES
-- ============================================
-- Période : Novembre 2024 à Août 2025
-- Moyenne : 5 produits par commande
-- Statuts variés : payee, expediee, livree, annulee

-- ============================================
-- COMMANDES DE NOVEMBRE 2024
-- ============================================

-- Commande 1 : Marie Dubois (idClient=1) - Mage débutante
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (1, UUID_SHORT(), '2024-11-02 14:23:15', '2024-11-03 09:15:00', '2024-11-05 16:30:00', 'livree', '12 rue de Rivoli, 75001 Paris', 'CB', 162.44);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 2, 39.98),
(LAST_INSERT_ID(), 8, 3, 35.97),
(LAST_INSERT_ID(), 31, 1, 14.99),
(LAST_INSERT_ID(), 13, 1, 37.99),
(LAST_INSERT_ID(), 10, 1, 14.99),
(LAST_INSERT_ID(), 79, 3, 6.00);

-- Commande 2 : Jean Martin (idClient=2) - Guerrier complet
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (2, UUID_SHORT(), '2024-11-05 10:45:30', '2024-11-06 08:00:00', '2024-11-08 14:20:00', 'livree', '45 avenue des Champs-Élysées, 75008 Paris', 'Paypal', 409.97);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 52, 1, 219.99),
(LAST_INSERT_ID(), 55, 1, 34.99),
(LAST_INSERT_ID(), 7, 4, 79.96),
(LAST_INSERT_ID(), 62, 1, 120.00),
(LAST_INSERT_ID(), 82, 3, 60.00);

-- Commande 3 : Sophie Bernard (idClient=3) - Alchimiste
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (3, UUID_SHORT(), '2024-11-08 16:12:45', '2024-11-09 10:30:00', '2024-11-11 11:15:00', 'livree', '23 rue du Faubourg Saint-Antoine, 75011 Paris', 'CB', 128.90);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 3, 59.97),
(LAST_INSERT_ID(), 7, 2, 39.98),
(LAST_INSERT_ID(), 3, 2, 19.98),
(LAST_INSERT_ID(), 12, 1, 14.99),
(LAST_INSERT_ID(), 82, 5, 40.00);

-- Commande 4 : Lucas Petit (idClient=4) - Première commande modeste
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (4, UUID_SHORT(), '2024-11-10 09:15:22', '2024-11-11 08:45:00', '2024-11-13 14:00:00', 'livree', '45 rue Oberkampf, 75011 Paris', 'CB', 81.44);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 2, 4, 31.96),
(LAST_INSERT_ID(), 8, 2, 23.98),
(LAST_INSERT_ID(), 51, 1, 15.99),
(LAST_INSERT_ID(), 79, 5, 10.00),
(LAST_INSERT_ID(), 81, 4, 9.96);

-- Commande 5 : Emma Durand (idClient=5) - VIP Premium
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (5, UUID_SHORT(), '2024-11-12 09:30:22', '2024-11-13 08:45:00', '2024-11-15 15:00:00', 'livree', '15 rue de la Paix, 75002 Paris', 'CB', 1299.97);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 59, 1, 499.99),
(LAST_INSERT_ID(), 82, 1, 300.00),
(LAST_INSERT_ID(), 66, 1, 250.00),
(LAST_INSERT_ID(), 71, 1, 180.00),
(LAST_INSERT_ID(), 62, 1, 120.00),
(LAST_INSERT_ID(), 20, 1, 69.99);

-- Commande 6 : Thomas Leroy (idClient=6) - Explorateur
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (6, UUID_SHORT(), '2024-11-15 11:20:10', '2024-11-16 09:00:00', '2024-11-18 10:30:00', 'livree', '89 avenue de Versailles, 92130 Issy-les-Moulineaux', 'Virement', 247.43);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 77, 1, 99.99),
(LAST_INSERT_ID(), 64, 1, 49.99),
(LAST_INSERT_ID(), 76, 1, 45.00),
(LAST_INSERT_ID(), 75, 1, 10.00),
(LAST_INSERT_ID(), 41, 3, 29.97),
(LAST_INSERT_ID(), 79, 6, 12.00);

-- Commande 7 : Léa Moreau (idClient=7) - Pyromancienne
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (7, UUID_SHORT(), '2024-11-18 14:55:33', '2024-11-19 08:30:00', '2024-11-21 16:45:00', 'livree', '34 rue du Commerce, 92100 Boulogne-Billancourt', 'CB', 243.91);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 129.95),
(LAST_INSERT_ID(), 33, 2, 39.98),
(LAST_INSERT_ID(), 5, 3, 29.97),
(LAST_INSERT_ID(), 21, 1, 49.99),
(LAST_INSERT_ID(), 78, 1, 85.00);

-- Commande 8 : Hugo Simon (idClient=8) - Débutant épéiste
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (8, UUID_SHORT(), '2024-11-20 11:20:50', '2024-11-21 08:00:00', '2024-11-23 15:30:00', 'livree', '12 rue Pasteur, 94160 Saint-Mandé', 'CB', 155.42);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 52, 2, 37.50),
(LAST_INSERT_ID(), 54, 1, 53.96),
(LAST_INSERT_ID(), 61, 1, 15.00),
(LAST_INSERT_ID(), 7, 2, 39.98),
(LAST_INSERT_ID(), 11, 1, 8.99);

-- Commande 9 : Chloé Laurent (idClient=9) - Commande annulée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (9, UUID_SHORT(), '2024-11-22 10:12:00', NULL, NULL, 'annulee', '12 boulevard de Strasbourg, 77000 Melun', 'CB', 204.89);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 149.90),
(LAST_INSERT_ID(), 32, 1, 34.99),
(LAST_INSERT_ID(), 82, 2, 24.00),
(LAST_INSERT_ID(), 76, 1, 45.00);

-- Commande 10 : Nathan Lefebvre (idClient=10) - Mage offensif
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (10, UUID_SHORT(), '2024-11-25 15:40:25', '2024-11-26 09:00:00', '2024-11-28 14:00:00', 'livree', '67 rue de la République, 78000 Versailles', 'Paypal', 294.45);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 34, 1, 99.99),
(LAST_INSERT_ID(), 32, 2, 69.98),
(LAST_INSERT_ID(), 38, 2, 64.98),
(LAST_INSERT_ID(), 1, 2, 39.98),
(LAST_INSERT_ID(), 17, 1, 14.99),
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDES DE DÉCEMBRE 2024
-- ============================================

-- Commande 11 : Camille Roux (idClient=11) - Mage complet
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (11, UUID_SHORT(), '2024-12-01 09:25:18', '2024-12-02 08:15:00', '2024-12-04 11:30:00', 'livree', '89 rue Nationale, 59000 Lille', 'CB', 427.33);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 149.90),
(LAST_INSERT_ID(), 20, 1, 69.99),
(LAST_INSERT_ID(), 60, 1, 42.49),
(LAST_INSERT_ID(), 61, 1, 134.00),
(LAST_INSERT_ID(), 19, 1, 19.99),
(LAST_INSERT_ID(), 1, 5, 99.95);

-- Commande 12 : Louis Fournier (idClient=12) - Première commande
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (12, UUID_SHORT(), '2024-12-03 15:45:18', '2024-12-04 08:00:00', '2024-12-06 14:00:00', 'livree', '12 rue du Maréchal Foch, 69006 Lyon', 'CB', 137.43);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 54, 1, 53.96),
(LAST_INSERT_ID(), 51, 2, 31.98),
(LAST_INSERT_ID(), 68, 1, 25.00),
(LAST_INSERT_ID(), 80, 3, 30.00),
(LAST_INSERT_ID(), 8, 2, 23.98);

-- Commande 13 : Manon Girard (idClient=13) - Rôdeuse
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (13, UUID_SHORT(), '2024-12-05 13:50:42', '2024-12-06 09:30:00', '2024-12-08 15:20:00', 'livree', '45 rue Gambetta, 62000 Arras', 'CB', 197.82);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 52, 1, 89.90),
(LAST_INSERT_ID(), 72, 2, 30.00),
(LAST_INSERT_ID(), 73, 2, 36.00),
(LAST_INSERT_ID(), 82, 3, 24.00),
(LAST_INSERT_ID(), 54, 2, 24.00);

-- Commande 14 : Gabriel Bonnet (idClient=14) - Arsenal lourd
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (14, UUID_SHORT(), '2024-12-08 10:15:30', '2024-12-09 08:00:00', '2024-12-11 14:30:00', 'livree', '78 boulevard Carnot, 80000 Amiens', 'Virement', 272.46);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 55, 1, 34.99),
(LAST_INSERT_ID(), 56, 1, 49.99),
(LAST_INSERT_ID(), 57, 1, 34.99),
(LAST_INSERT_ID(), 82, 2, 160.00),
(LAST_INSERT_ID(), 69, 1, 150.00),
(LAST_INSERT_ID(), 7, 3, 59.97);

-- Commande 15 : Inès Dupont (idClient=15) - Mage feu
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (15, UUID_SHORT(), '2024-12-10 11:55:22', '2024-12-11 08:45:00', '2024-12-13 14:00:00', 'livree', '23 rue de la Verrerie, 75004 Paris', 'CB', 184.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 33, 3, 59.97),
(LAST_INSERT_ID(), 13, 1, 37.99),
(LAST_INSERT_ID(), 5, 2, 19.98),
(LAST_INSERT_ID(), 74, 3, 36.00),
(LAST_INSERT_ID(), 1, 3, 59.97);

-- Commande 16 : Arthur Lambert (idClient=16) - Collectionneur premium
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (16, UUID_SHORT(), '2024-12-12 14:22:15', '2024-12-13 09:15:00', '2024-12-15 16:00:00', 'livree', '34 rue du Vieux-Marché-aux-Vins, 67000 Strasbourg', 'CB', 954.96);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 20, 1, 69.99),
(LAST_INSERT_ID(), 21, 1, 49.99),
(LAST_INSERT_ID(), 66, 1, 250.00),
(LAST_INSERT_ID(), 71, 1, 180.00),
(LAST_INSERT_ID(), 62, 1, 120.00),
(LAST_INSERT_ID(), 78, 1, 85.00),
(LAST_INSERT_ID(), 40, 2, 69.98),
(LAST_INSERT_ID(), 82, 1, 300.00);

-- Commande 17 : Jade Fontaine (idClient=17) - Alchimiste confirmée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (17, UUID_SHORT(), '2024-12-15 09:40:50', '2024-12-16 08:30:00', '2024-12-18 11:15:00', 'livree', '56 avenue de Colmar, 68100 Mulhouse', 'Paypal', 197.82);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95),
(LAST_INSERT_ID(), 7, 3, 59.97),
(LAST_INSERT_ID(), 3, 2, 19.98),
(LAST_INSERT_ID(), 82, 5, 40.00),
(LAST_INSERT_ID(), 70, 3, 36.00);

-- Commande 18 : Jules Rousseau (idClient=18) - Tank débutant
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (18, UUID_SHORT(), '2024-12-18 10:20:50', '2024-12-19 09:15:00', '2024-12-21 16:20:00', 'livree', '12 rue des Rosiers, 75004 Paris', 'CB', 335.00);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 69, 1, 150.00),
(LAST_INSERT_ID(), 67, 1, 45.00),
(LAST_INSERT_ID(), 70, 1, 35.00),
(LAST_INSERT_ID(), 65, 1, 50.00),
(LAST_INSERT_ID(), 63, 1, 60.00),
(LAST_INSERT_ID(), 7, 2, 39.98);

-- Commande 19 : Alice Vincent (idClient=19) - Vagabonde
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (19, UUID_SHORT(), '2024-12-20 11:30:20', '2024-12-21 09:00:00', '2024-12-23 15:45:00', 'livree', '23 rue Serpenoise, 57000 Metz', 'CB', 304.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 48, 1, 179.99),
(LAST_INSERT_ID(), 77, 1, 99.99),
(LAST_INSERT_ID(), 79, 10, 20.00),
(LAST_INSERT_ID(), 81, 5, 12.49),
(LAST_INSERT_ID(), 75, 1, 10.00);

-- Commande 20 : Adam Muller (idClient=20) - Archer
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (20, UUID_SHORT(), '2024-12-22 15:20:35', '2024-12-23 08:45:00', '2024-12-26 14:00:00', 'livree', '45 boulevard Victor Hugo, 51100 Reims', 'CB', 227.44);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 58, 1, 19.99),
(LAST_INSERT_ID(), 23, 50, 99.50),
(LAST_INSERT_ID(), 72, 3, 45.00),
(LAST_INSERT_ID(), 73, 2, 36.00),
(LAST_INSERT_ID(), 68, 1, 25.00),
(LAST_INSERT_ID(), 82, 3, 24.00);

-- ============================================
-- COMMANDES DE JANVIER 2025
-- ============================================

-- Commande 21 : Zoé Leclerc (idClient=21) - Grande commande variée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (21, UUID_SHORT(), '2025-01-03 10:05:45', '2025-01-04 09:30:00', '2025-01-06 16:20:00', 'livree', '67 rue de la République, 69002 Lyon', 'Paypal', 508.79);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 48, 1, 179.90),
(LAST_INSERT_ID(), 61, 1, 134.00),
(LAST_INSERT_ID(), 17, 1, 14.99),
(LAST_INSERT_ID(), 28, 5, 74.95),
(LAST_INSERT_ID(), 40, 1, 34.99),
(LAST_INSERT_ID(), 1, 4, 79.96);

-- Commande 22 : Raphaël Gauthier (idClient=22) - Première commande équilibrée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (22, UUID_SHORT(), '2025-01-05 10:15:30', '2025-01-06 08:00:00', '2025-01-08 16:30:00', 'livree', '12 rue du Rempart, 31000 Toulouse', 'CB', 154.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 3, 59.97),
(LAST_INSERT_ID(), 7, 2, 39.98),
(LAST_INSERT_ID(), 52, 1, 20.49),
(LAST_INSERT_ID(), 61, 1, 15.00),
(LAST_INSERT_ID(), 79, 4, 8.00),
(LAST_INSERT_ID(), 81, 3, 7.49);

-- Commande 23 : Lola Morel (idClient=23) - Commande expédiée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (23, UUID_SHORT(), '2025-01-08 14:30:12', '2025-01-09 08:00:00', NULL, 'expediee', '34 rue Vaugelas, 74000 Annecy', 'CB', 257.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 48, 1, 149.00),
(LAST_INSERT_ID(), 28, 3, 44.97),
(LAST_INSERT_ID(), 37, 1, 54.49),
(LAST_INSERT_ID(), 82, 2, 24.00),
(LAST_INSERT_ID(), 7, 2, 39.98);

-- Commande 24 : Paul Garnier (idClient=24) - Première commande annulée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (24, UUID_SHORT(), '2025-01-10 09:55:18', NULL, NULL, 'annulee', '56 rue du Temple, 75003 Paris', 'Virement', 223.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 149.90),
(LAST_INSERT_ID(), 32, 1, 34.99),
(LAST_INSERT_ID(), 1, 2, 39.98),
(LAST_INSERT_ID(), 82, 3, 24.00);

-- Commande 25 : Lina Faure (idClient=25) - Explosifs
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (25, UUID_SHORT(), '2025-01-12 09:15:40', '2025-01-13 08:30:00', '2025-01-15 11:00:00', 'livree', '89 rue de la République, 42000 Saint-Étienne', 'CB', 164.97);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 74, 4, 48.00),
(LAST_INSERT_ID(), 75, 3, 45.00),
(LAST_INSERT_ID(), 72, 2, 30.00),
(LAST_INSERT_ID(), 8, 3, 35.97),
(LAST_INSERT_ID(), 79, 3, 6.00);

-- Commande 26 : Tom André (idClient=26) - Forgeron
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (26, UUID_SHORT(), '2025-01-15 16:45:22', '2025-01-16 09:00:00', '2025-01-18 15:30:00', 'livree', '23 boulevard Berthelot, 63000 Clermont-Ferrand', 'Virement', 424.99);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 82, 5, 200.00),
(LAST_INSERT_ID(), 80, 2, 160.00),
(LAST_INSERT_ID(), 52, 1, 20.00),
(LAST_INSERT_ID(), 54, 1, 53.96),
(LAST_INSERT_ID(), 79, 4, 8.00);

-- Commande 27 : Mia Dubois (idClient=27) - Commande express
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (27, UUID_SHORT(), '2025-01-18 10:20:15', '2025-01-19 08:15:00', '2025-01-20 12:30:00', 'livree', '12 rue du Maréchal Joffre, 35000 Rennes', 'CB', 149.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 3, 59.97),
(LAST_INSERT_ID(), 7, 2, 39.98),
(LAST_INSERT_ID(), 52, 1, 18.75),
(LAST_INSERT_ID(), 61, 1, 15.00),
(LAST_INSERT_ID(), 81, 4, 16.28);

-- Commande 28 : Alex Fournier (idClient=28) - Mage foudre
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (28, UUID_SHORT(), '2025-01-20 15:30:40', '2025-01-21 09:00:00', '2025-01-23 16:15:00', 'livree', '67 avenue Jean Médecin, 06000 Nice', 'Paypal', 292.42);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 38, 3, 97.47),
(LAST_INSERT_ID(), 75, 3, 45.00),
(LAST_INSERT_ID(), 3, 3, 29.97),
(LAST_INSERT_ID(), 1, 4, 79.96),
(LAST_INSERT_ID(), 17, 1, 14.99),
(LAST_INSERT_ID(), 22, 1, 22.49);

-- Commande 29 : Lou Guerin (idClient=29) - Première commande pyro
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (29, UUID_SHORT(), '2025-01-22 09:25:50', '2025-01-23 08:30:00', '2025-01-25 16:20:00', 'livree', '12 rue Victor Hugo, 37000 Tours', 'CB', 248.88);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 129.95),
(LAST_INSERT_ID(), 5, 2, 19.98),
(LAST_INSERT_ID(), 1, 3, 59.97),
(LAST_INSERT_ID(), 74, 3, 36.00),
(LAST_INSERT_ID(), 79, 2, 4.00);

-- Commande 30 : Hugo Lefevre (idClient=30) - Commande payée, non expédiée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (30, UUID_SHORT(), '2025-01-25 11:40:10', NULL, NULL, 'payee', '45 avenue du Prado, 13008 Marseille', 'Paypal', 299.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 66, 1, 250.00),
(LAST_INSERT_ID(), 7, 2, 39.98),
(LAST_INSERT_ID(), 82, 1, 10.00);

-- ============================================
-- COMMANDES DE FÉVRIER 2025
-- ============================================

-- Commande 31 : Léo Richard (idClient=31) - Commande en masse de mana
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (31, UUID_SHORT(), '2025-02-01 09:00:25', '2025-02-02 08:30:00', '2025-02-04 14:00:00', 'livree', '56 rue du Temple, 75003 Paris', 'CB', 239.88);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 12, 239.88);

-- Commande 32 : Sarah Chevalier (idClient=32) - Première commande guerrier
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (32, UUID_SHORT(), '2025-02-03 10:20:10', '2025-02-04 08:00:00', '2025-02-06 15:30:00', 'livree', '78 rue de la Gare, 25000 Besançon', 'Virement', 189.96);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 56, 1, 49.99),
(LAST_INSERT_ID(), 54, 1, 53.96),
(LAST_INSERT_ID(), 61, 1, 15.00),
(LAST_INSERT_ID(), 7, 3, 59.97),
(LAST_INSERT_ID(), 82, 2, 16.00);

-- Commande 33 : Thomas François (idClient=33) - Herboriste
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (33, UUID_SHORT(), '2025-02-05 11:40:35', '2025-02-06 09:00:00', '2025-02-08 14:20:00', 'livree', '23 rue du Chemin Vert, 51100 Reims', 'CB', 178.41);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 21, 10, 80.00),
(LAST_INSERT_ID(), 82, 5, 60.00),
(LAST_INSERT_ID(), 8, 4, 47.96),
(LAST_INSERT_ID(), 79, 2, 4.00);

-- Commande 34 : Clara Meyer (idClient=34) - Mage débutante cryo
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (34, UUID_SHORT(), '2025-02-08 14:25:30', '2025-02-09 08:45:00', '2025-02-11 16:30:00', 'livree', '12 rue de la Mairie, 34000 Montpellier', 'Paypal', 194.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 149.90),
(LAST_INSERT_ID(), 32, 1, 34.99),
(LAST_INSERT_ID(), 8, 2, 23.98),
(LAST_INSERT_ID(), 79, 5, 10.00);

-- Commande 35 : Maxime Leroy (idClient=35) - Commande payée, non expédiée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (35, UUID_SHORT(), '2025-02-10 16:10:00', NULL, NULL, 'payee', '45 rue de la Liberté, 31000 Toulouse', 'CB', 154.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95),
(LAST_INSERT_ID(), 7, 2, 39.98),
(LAST_INSERT_ID(), 79, 8, 16.00);

-- Commande 36 : Sophie Bonnet (idClient=36) - Kit Gardien
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (36, UUID_SHORT(), '2025-02-12 10:30:45', '2025-02-13 08:45:00', '2025-02-15 16:00:00', 'livree', '12 cours de l\'Intendance, 33000 Bordeaux', 'Virement', 773.93);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 52, 1, 219.99),
(LAST_INSERT_ID(), 20, 1, 69.99),
(LAST_INSERT_ID(), 21, 1, 49.99),
(LAST_INSERT_ID(), 66, 1, 250.00),
(LAST_INSERT_ID(), 62, 1, 120.00),
(LAST_INSERT_ID(), 7, 4, 79.96);

-- Commande 37 : Juliette Lopez (idClient=37) - Première commande hast
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (37, UUID_SHORT(), '2025-02-15 10:40:40', '2025-02-16 08:30:00', '2025-02-18 11:45:00', 'livree', '34 boulevard de Strasbourg, 75010 Paris', 'CB', 149.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 57, 1, 34.99),
(LAST_INSERT_ID(), 54, 1, 53.96),
(LAST_INSERT_ID(), 7, 2, 39.98),
(LAST_INSERT_ID(), 8, 1, 11.99),
(LAST_INSERT_ID(), 79, 5, 10.00);

-- Commande 38 : Antoine Martin (idClient=38) - Mage pyromancien expérimenté
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (38, UUID_SHORT(), '2025-02-17 14:15:20', '2025-02-18 09:15:00', '2025-02-20 15:30:00', 'livree', '89 rue Saint-Denis, 75001 Paris', 'CB', 349.96);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 33, 5, 99.95),
(LAST_INSERT_ID(), 34, 1, 99.99),
(LAST_INSERT_ID(), 21, 1, 49.99),
(LAST_INSERT_ID(), 1, 5, 99.95);

-- Commande 39 : Emma David (idClient=39) - Commande annulée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (39, UUID_SHORT(), '2025-02-19 10:50:10', NULL, NULL, 'annulee', '12 place de la Bourse, 33000 Bordeaux', 'Virement', 169.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 77, 1, 99.99),
(LAST_INSERT_ID(), 64, 1, 49.99),
(LAST_INSERT_ID(), 79, 10, 20.00);

-- Commande 40 : David Chevalier (idClient=40) - Explorateur
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (40, UUID_SHORT(), '2025-02-22 11:35:40', '2025-02-23 09:00:00', '2025-02-25 14:20:00', 'livree', '45 rue de Verdun, 47000 Agen', 'Virement', 264.42);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 77, 1, 99.99),
(LAST_INSERT_ID(), 64, 1, 49.99),
(LAST_INSERT_ID(), 76, 1, 45.00),
(LAST_INSERT_ID(), 41, 3, 29.97),
(LAST_INSERT_ID(), 75, 1, 10.00),
(LAST_INSERT_ID(), 79, 8, 16.00);

-- ============================================
-- COMMANDES DE MARS 2025
-- ============================================

-- Commande 41 : Rose Caron (idClient=41) - Commande expédiée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (41, UUID_SHORT(), '2025-03-01 13:10:05', '2025-03-02 08:30:00', NULL, 'expediee', '12 place de la Comédie, 34000 Montpellier', 'CB', 189.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 4, 79.96),   
(LAST_INSERT_ID(), 7, 3, 59.97),    
(LAST_INSERT_ID(), 52, 1, 18.75),   
(LAST_INSERT_ID(), 61, 1, 15.00),   
(LAST_INSERT_ID(), 79, 8, 16.00);   

-- Commande 42 : Ethan Lefevre (idClient=42) - Commande mage
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (42, UUID_SHORT(), '2025-03-03 14:20:50', '2025-03-04 09:00:00', '2025-03-06 15:40:00', 'livree', '23 rue Nationale, 35000 Rennes', 'Paypal', 299.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 48, 1, 179.90), 
(LAST_INSERT_ID(), 22, 1, 22.49),  
(LAST_INSERT_ID(), 31, 2, 29.98),  
(LAST_INSERT_ID(), 1, 4, 79.96),    
(LAST_INSERT_ID(), 82, 2, 16.00);  

-- Commande 43 : Manon Robert (idClient=43) - Petite commande
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (43, UUID_SHORT(), '2025-03-06 11:30:20', '2025-03-07 08:15:00', '2025-03-09 14:10:00', 'livree', '45 rue des Halles, 44000 Nantes', 'CB', 104.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 3, 59.97),    
(LAST_INSERT_ID(), 8, 2, 23.98),    
(LAST_INSERT_ID(), 51, 1, 15.99),   
(LAST_INSERT_ID(), 79, 4, 5.00);    

-- Commande 44 : Mathis Pierre (idClient=44) - Tank boucliers
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (44, UUID_SHORT(), '2025-03-08 10:15:25', '2025-03-09 08:15:00', '2025-03-11 15:30:00', 'livree', '12 rue du Général Leclerc, 35000 Rennes', 'CB', 349.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 62, 1, 120.00),
(LAST_INSERT_ID(), 63, 1, 60.00),
(LAST_INSERT_ID(), 67, 1, 45.00), 
(LAST_INSERT_ID(), 65, 1, 50.00),
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 40, 1, 34.99); 

-- Commande 45 : Victoria Masson (idClient=45) - Kit archer
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (45, UUID_SHORT(), '2025-03-10 14:40:00', '2025-03-11 09:30:00', '2025-03-13 11:00:00', 'livree', '34 boulevard de la Liberté, 59000 Lille', 'Paypal', 357.34);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 48, 1, 179.90),
(LAST_INSERT_ID(), 23, 50, 99.50),  
(LAST_INSERT_ID(), 58, 1, 19.99),  
(LAST_INSERT_ID(), 72, 3, 45.00),   
(LAST_INSERT_ID(), 82, 2, 16.00);   

-- Commande 46 : Jules Chevalier (idClient=46) - Commande payée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (46, UUID_SHORT(), '2025-03-13 10:00:00', NULL, NULL, 'payee', '12 rue du Temple, 75003 Paris', 'CB', 159.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 55, 1, 34.99),   
(LAST_INSERT_ID(), 61, 1, 15.00),  
(LAST_INSERT_ID(), 7, 3, 59.97),    
(LAST_INSERT_ID(), 1, 2, 39.98),    
(LAST_INSERT_ID(), 82, 2, 10.00);  

-- Commande 47 : Alice Dubois (idClient=47) - Commande annulée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (47, UUID_SHORT(), '2025-03-15 15:20:00', NULL, NULL, 'annulee', '45 avenue des Lilas, 75019 Paris', 'Virement', 99.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95),    
(LAST_INSERT_ID(), 82, 1, 10.00);  

-- Commande 48 : Nathan Lefebvre (idClient=48) - Petite commande expédiée
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (48, UUID_SHORT(), '2025-03-18 11:30:00', '2025-03-19 08:30:00', NULL, 'expediee', '78 rue de Rivoli, 75004 Paris', 'CB', 119.96);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 7, 3, 59.97),   
(LAST_INSERT_ID(), 1, 3, 59.97);   

-- Commande 49 : Louis Martin (idClient=4) - Commande régulière
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (4, UUID_SHORT(), '2025-02-14 11:30:00', '2025-02-15 08:15:00', '2025-02-17 14:00:00', 'livree', '45 rue Oberkampf, 75011 Paris', 'CB', 112.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 2, 4, 31.96),
(LAST_INSERT_ID(), 8, 2, 23.98),
(LAST_INSERT_ID(), 79, 5, 10.00),
(LAST_INSERT_ID(), 41, 3, 29.97),
(LAST_INSERT_ID(), 82, 1, 17.03);

-- ============================================
-- COMMANDE 50
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (50, UUID_SHORT(), '2025-02-16 10:14:20', '2025-02-17 08:30:00', '2025-02-19 16:00:00', 'livree', '8 rue des fossés, 67000 Strasbourg', 'CB', 307.91);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 33, 3, 59.97), 
(LAST_INSERT_ID(), 34, 1, 99.99), 
(LAST_INSERT_ID(), 21, 1, 49.99), 
(LAST_INSERT_ID(), 66, 1, 250.00), 
(LAST_INSERT_ID(), 1, 3, 59.97);

-- ============================================
-- COMMANDE 51
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (11, UUID_SHORT(), '2025-02-17 13:45:00', '2025-02-18 09:30:00', '2025-02-20 12:45:00', 'livree', '89 rue Nationale, 59000 Lille', 'CB', 174.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 48, 1, 179.90), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 1, 3, 59.97);

-- ============================================
-- COMMANDE 52
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (47, UUID_SHORT(), '2025-02-18 10:55:00', '2025-02-19 08:00:00', '2025-02-21 16:30:00', 'livree', '44 avenue de Grammont, 37000 Tours', 'Paypal', 198.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 52, 2, 37.50), 
(LAST_INSERT_ID(), 54, 1, 53.96), 
(LAST_INSERT_ID(), 61, 1, 15.00), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 1, 3, 59.97);

-- ============================================
-- COMMANDE 53
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (3, UUID_SHORT(), '2025-02-19 14:15:00', '2025-02-20 09:30:00', '2025-02-22 10:45:00', 'livree', '23 rue du Faubourg Saint-Antoine, 75011 Paris', 'CB', 194.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 3, 59.97), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 3, 2, 19.98), 
(LAST_INSERT_ID(), 12, 1, 14.99), 
(LAST_INSERT_ID(), 82, 5, 40.00), 
(LAST_INSERT_ID(), 21, 2, 20.00);

-- ============================================
-- COMMANDE 54
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (19, UUID_SHORT(), '2025-02-20 12:20:00', '2025-02-21 08:45:00', '2025-02-23 15:10:00', 'livree', '23 rue Serpenoise, 57000 Metz', 'CB', 149.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95), 
(LAST_INSERT_ID(), 8, 3, 35.97), 
(LAST_INSERT_ID(), 79, 7, 14.00);

-- ============================================
-- COMMANDE 55
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (34, UUID_SHORT(), '2025-02-21 16:35:00', '2025-02-22 09:15:00', '2025-02-24 11:30:00', 'livree', '12 rue de la Mairie, 34000 Montpellier', 'Paypal', 204.93);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 149.90), 
(LAST_INSERT_ID(), 32, 1, 34.99), 
(LAST_INSERT_ID(), 7, 2, 39.98);

-- ============================================
-- COMMANDE 56
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (15, UUID_SHORT(), '2025-02-24 10:10:00', '2025-02-25 08:00:00', '2025-02-27 15:40:00', 'livree', '14 rue des Oiseaux, 64000 Pau', 'CB', 224.93);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 33, 3, 59.97), 
(LAST_INSERT_ID(), 5, 4, 39.96), 
(LAST_INSERT_ID(), 21, 1, 49.99), 
(LAST_INSERT_ID(), 1, 3, 59.97), 
(LAST_INSERT_ID(), 12, 1, 14.99);

-- ============================================
-- COMMANDE 57
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (25, UUID_SHORT(), '2025-02-25 16:30:22', '2025-02-26 09:00:00', '2025-02-28 14:00:00', 'livree', '2 rue des Vergers, 25000 Besançon', 'Paypal', 178.93);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 61, 1, 15.00), 
(LAST_INSERT_ID(), 52, 1, 18.75), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 1, 3, 59.97), 
(LAST_INSERT_ID(), 82, 1, 25.24);

-- ============================================
-- COMMANDE 58
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (41, UUID_SHORT(), '2025-02-26 18:12:10', '2025-02-27 08:45:00', '2025-03-01 15:20:00', 'livree', '32 rue du Fort, 68000 Colmar', 'CB', 204.91);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 8, 2, 23.98), 
(LAST_INSERT_ID(), 81, 4, 16.28), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 59
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (42, UUID_SHORT(), '2025-02-28 10:05:00', '2025-03-01 09:30:00', '2025-03-03 16:15:00', 'livree', '23 rue Nationale, 35000 Rennes', 'Paypal', 199.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95), 
(LAST_INSERT_ID(), 22, 1, 22.49), 
(LAST_INSERT_ID(), 31, 2, 29.98), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 82, 2, 16.00);

-- ============================================
-- COMMANDES D'AVRIL 2025
-- ============================================

-- COMMANDE 60 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (1, UUID_SHORT(), '2025-03-01 10:20:00', '2025-03-02 08:30:00', '2025-03-04 15:00:00', 'livree', '12 rue de Rivoli, 75001 Paris', 'CB', 198.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 31, 1, 14.99), 
(LAST_INSERT_ID(), 13, 1, 37.99), 
(LAST_INSERT_ID(), 79, 3, 6.00);

-- ============================================
-- COMMANDE 61 — expediee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (2, UUID_SHORT(), '2025-03-02 14:15:00', '2025-03-03 09:00:00', NULL, 'expediee', '45 avenue des Champs-Élysées, 75008 Paris', 'Paypal', 154.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 55, 1, 34.99), 
(LAST_INSERT_ID(), 7, 4, 79.96), 
(LAST_INSERT_ID(), 82, 2, 40.00);

-- ============================================
-- COMMANDE 62 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (32, UUID_SHORT(), '2025-03-03 11:30:00', '2025-03-04 08:30:00', '2025-03-06 14:20:00', 'livree', '78 rue de la Gare, 25000 Besançon', 'Virement', 169.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 56, 1, 49.99), 
(LAST_INSERT_ID(), 54, 1, 53.96), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 79, 3, 6.03);

-- ============================================
-- COMMANDE 63 — expediee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (49, UUID_SHORT(), '2025-03-04 09:50:00', '2025-03-05 08:00:00', NULL, 'expediee', '18 place du Marché, 17000 La Rochelle', 'Paypal', 154.90);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 52, 2, 37.50), 
(LAST_INSERT_ID(), 8, 3, 35.97), 
(LAST_INSERT_ID(), 2, 4, 31.96), 
(LAST_INSERT_ID(), 11, 1, 8.99), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 64 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (38, UUID_SHORT(), '2025-03-04 10:40:00', '2025-03-05 09:10:00', '2025-03-07 15:55:00', 'livree', '44 rue des Fleurs, 60000 Beauvais', 'CB', 199.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 33, 2, 39.98), 
(LAST_INSERT_ID(), 21, 1, 49.99), 
(LAST_INSERT_ID(), 82, 4, 32.00), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 79, 9, 17.99);

-- ============================================
-- COMMANDE 65 — annulee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (29, UUID_SHORT(), '2025-03-05 17:05:00', NULL, NULL, 'annulee', '7 rue du Soleil, 73000 Chambéry', 'Virement', 0); 
-- commande annulée donc pas de lignes

-- ============================================
-- COMMANDE 66 — expediee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (50, UUID_SHORT(), '2025-03-06 12:10:00', '2025-03-07 08:30:00', NULL, 'expediee', '15 rue du Commerce, 67000 Strasbourg', 'CB', 349.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 62, 1, 120.00), 
(LAST_INSERT_ID(), 63, 1, 60.00), 
(LAST_INSERT_ID(), 67, 1, 45.00), 
(LAST_INSERT_ID(), 65, 1, 50.00), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 40, 1, 34.99);

-- ============================================
-- COMMANDE 67 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (44, UUID_SHORT(), '2025-03-07 10:45:00', '2025-03-08 09:15:00', '2025-03-10 16:30:00', 'livree', '12 rue du Général Leclerc, 35000 Rennes', 'CB', 194.97);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 55, 1, 34.99), 
(LAST_INSERT_ID(), 56, 1, 49.99), 
(LAST_INSERT_ID(), 57, 1, 34.99), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 79, 8, 16.00);

-- ============================================
-- COMMANDE 68 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (19, UUID_SHORT(), '2025-03-08 14:50:00', '2025-03-09 08:00:00', '2025-03-11 14:00:00', 'livree', '23 rue Serpenoise, 57000 Metz', 'CB', 178.96);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 77, 1, 99.99), 
(LAST_INSERT_ID(), 64, 1, 49.99), 
(LAST_INSERT_ID(), 76, 1, 45.00), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 69 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (24, UUID_SHORT(), '2025-03-09 11:20:00', '2025-03-10 09:30:00', '2025-03-12 11:30:00', 'livree', '56 rue du Temple, 75003 Paris', 'Virement', 299.93);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 149.90), 
(LAST_INSERT_ID(), 32, 1, 34.99), 
(LAST_INSERT_ID(), 1, 2, 39.98), 
(LAST_INSERT_ID(), 82, 3, 24.00), 
(LAST_INSERT_ID(), 7, 3, 59.97);

-- ============================================
-- COMMANDE 70 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (26, UUID_SHORT(), '2025-03-10 15:30:00', '2025-03-11 08:00:00', '2025-03-13 15:40:00', 'livree', '23 boulevard Berthelot, 63000 Clermont-Ferrand', 'Virement', 335.00);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 69, 1, 150.00), 
(LAST_INSERT_ID(), 67, 1, 45.00), 
(LAST_INSERT_ID(), 70, 1, 35.00), 
(LAST_INSERT_ID(), 65, 1, 50.00), 
(LAST_INSERT_ID(), 66, 1, 250.00), 
(LAST_INSERT_ID(), 1, 2, 39.98);

-- ============================================
-- COMMANDE 71 — annulee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (14, UUID_SHORT(), '2025-03-11 11:45:00', NULL, NULL, 'annulee', '55 rue Royale, 78000 Versailles', 'Virement', 0); 
-- commande annulée donc pas de lignes

-- ============================================
-- COMMANDE 72 — expediee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (5, UUID_SHORT(), '2025-03-12 10:20:00', '2025-03-13 08:40:00', NULL, 'expediee', '8 rue des Remparts, 17000 La Rochelle', 'Paypal', 264.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 69, 1, 150.00), 
(LAST_INSERT_ID(), 56, 1, 49.99), 
(LAST_INSERT_ID(), 55, 1, 34.99), 
(LAST_INSERT_ID(), 7, 3, 59.97);

-- ============================================
-- COMMANDE 73 — payee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (22, UUID_SHORT(), '2025-03-13 17:00:00', NULL, NULL, 'payee', '75 rue Berlioz, 13006 Marseille', 'CB', 179.87);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 4, 79.96), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 2, 4, 31.96), 
(LAST_INSERT_ID(), 79, 4, 8.00);

-- ============================================
-- COMMANDE 74 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (45, UUID_SHORT(), '2025-03-14 09:10:00', '2025-03-15 09:15:00', '2025-03-17 10:30:00', 'livree', '34 boulevard de la Liberté, 59000 Lille', 'Paypal', 224.93);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 48, 1, 179.90), 
(LAST_INSERT_ID(), 58, 1, 19.99), 
(LAST_INSERT_ID(), 82, 2, 16.00), 
(LAST_INSERT_ID(), 7, 2, 39.98);

-- ============================================
-- COMMANDE 75 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (10, UUID_SHORT(), '2025-03-15 15:40:00', '2025-03-16 08:00:00', '2025-03-18 16:20:00', 'livree', '67 rue de la République, 78000 Versailles', 'Paypal', 199.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 34, 1, 99.99), 
(LAST_INSERT_ID(), 32, 2, 69.98), 
(LAST_INSERT_ID(), 1, 2, 39.98), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 76 — payée
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (30, UUID_SHORT(), '2025-03-16 11:20:00', NULL, NULL, 'payee', '45 avenue du Prado, 13008 Marseille', 'Paypal', 299.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 66, 1, 250.00), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 82, 1, 10.00);

-- ============================================
-- COMMANDE 77 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (17, UUID_SHORT(), '2025-03-17 14:05:00', '2025-03-18 08:30:00', '2025-03-20 14:40:00', 'livree', '56 avenue de Colmar, 68100 Mulhouse', 'Paypal', 178.96);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 3, 2, 19.98);

-- ============================================
-- COMMANDE 78 — annulee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (20, UUID_SHORT(), '2025-03-18 10:40:00', NULL, NULL, 'annulee', '45 boulevard Victor Hugo, 51100 Reims', 'CB', 194.97);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 58, 1, 19.99), 
(LAST_INSERT_ID(), 23, 50, 99.50), 
(LAST_INSERT_ID(), 72, 3, 45.00), 
(LAST_INSERT_ID(), 73, 2, 36.00), 
(LAST_INSERT_ID(), 82, 2, 16.00);

-- ============================================
-- COMMANDE 79 — expediee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (33, UUID_SHORT(), '2025-03-19 14:55:00', '2025-03-20 09:00:00', NULL, 'expediee', '56 rue des Lilas, 84000 Avignon', 'CB', 129.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 2, 4, 31.96), 
(LAST_INSERT_ID(), 8, 3, 35.97), 
(LAST_INSERT_ID(), 11, 1, 8.99), 
(LAST_INSERT_ID(), 51, 1, 15.99), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 80 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (27, UUID_SHORT(), '2025-03-20 13:15:00', '2025-03-21 08:45:00', '2025-03-23 15:10:00', 'livree', '3 chemin du Parc, 86000 Poitiers', 'CB', 212.99);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 66, 1, 250.00), 
(LAST_INSERT_ID(), 79, 8, 15.99);

-- ============================================
-- COMMANDE 81 — annulee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (4, UUID_SHORT(), '2025-03-21 10:40:00', NULL, NULL, 'annulee', '8 rue du Temple, 75004 Paris', 'Paypal', 174.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 20, 1, 69.99), 
(LAST_INSERT_ID(), 10, 1, 14.99), 
(LAST_INSERT_ID(), 1, 5, 99.95), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 82, 2, 16.00);

-- ============================================
-- COMMANDE 82 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (18, UUID_SHORT(), '2025-03-22 14:25:00', '2025-03-23 09:10:00', '2025-03-25 12:45:00', 'livree', '12 rue des Rosiers, 75004 Paris', 'CB', 204.97);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 69, 1, 150.00), 
(LAST_INSERT_ID(), 67, 1, 45.00), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 83 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (46, UUID_SHORT(), '2025-03-23 10:00:00', '2025-03-24 08:30:00', '2025-03-26 14:00:00', 'livree', '12 rue du Temple, 75003 Paris', 'CB', 169.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 55, 1, 34.99), 
(LAST_INSERT_ID(), 61, 1, 15.00), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 1, 2, 39.98), 
(LAST_INSERT_ID(), 82, 2, 10.00);

-- ============================================
-- COMMANDE 84 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (36, UUID_SHORT(), '2025-03-24 11:20:00', '2025-03-25 09:00:00', '2025-03-27 16:30:00', 'livree', '12 cours de l\'Intendance, 33000 Bordeaux', 'Virement', 154.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 79, 8, 16.00);

-- ============================================
-- COMMANDE 85 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (38, UUID_SHORT(), '2025-03-25 15:40:00', '2025-03-26 08:45:00', '2025-03-28 14:15:00', 'livree', '89 rue Saint-Denis, 75001 Paris', 'CB', 209.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 33, 5, 99.95), 
(LAST_INSERT_ID(), 21, 1, 49.99), 
(LAST_INSERT_ID(), 1, 3, 59.97);

-- ============================================
-- COMMANDE 86 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (23, UUID_SHORT(), '2025-03-26 10:15:00', '2025-03-27 08:30:00', '2025-03-29 15:30:00', 'livree', '34 rue Vaugelas, 74000 Annecy', 'CB', 199.93);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 21, 1, 49.99), 
(LAST_INSERT_ID(), 33, 3, 59.97), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 82, 4, 32.00);

-- ============================================
-- COMMANDE 87 — annulee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (35, UUID_SHORT(), '2025-03-27 13:00:00', NULL, NULL, 'annulee', '10 rue des Iris, 31000 Toulouse', 'Paypal', 182.92);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 2, 4, 31.96), 
(LAST_INSERT_ID(), 8, 3, 35.97), 
(LAST_INSERT_ID(), 1, 3, 59.97), 
(LAST_INSERT_ID(), 81, 3, 9.96), 
(LAST_INSERT_ID(), 11, 1, 8.99);

-- ============================================
-- COMMANDE 88 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (6, UUID_SHORT(), '2025-03-28 09:25:00', '2025-03-29 09:10:00', '2025-03-31 15:40:00', 'livree', '70 rue du Faubourg, 59000 Lille', 'CB', 289.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 77, 1, 99.99), 
(LAST_INSERT_ID(), 64, 1, 49.99), 
(LAST_INSERT_ID(), 76, 1, 45.00), 
(LAST_INSERT_ID(), 75, 1, 10.00), 
(LAST_INSERT_ID(), 41, 3, 29.97), 
(LAST_INSERT_ID(), 79, 6, 12.00);

-- ============================================
-- COMMANDE 89 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (34, UUID_SHORT(), '2025-03-29 14:40:00', '2025-03-30 08:00:00', '2025-04-01 14:00:00', 'livree', '12 rue de la Mairie, 34000 Montpellier', 'Paypal', 184.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 75, 1, 149.90), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 90 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (31, UUID_SHORT(), '2025-03-30 11:30:00', '2025-03-31 09:30:00', '2025-04-02 16:20:00', 'livree', '56 rue du Temple, 75003 Paris', 'CB', 159.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 8, 159.94);

-- ============================================
-- COMMANDES D'AVRIL 2025
-- ============================================

-- COMMANDE 91 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (37, UUID_SHORT(), '2025-04-01 10:20:00', '2025-04-02 08:30:00', '2025-04-04 15:30:00', 'livree', '34 boulevard de Strasbourg, 75010 Paris', 'CB', 159.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 57, 1, 34.99), 
(LAST_INSERT_ID(), 54, 1, 53.96), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 8, 1, 11.99), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 92 — annulee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (43, UUID_SHORT(), '2025-04-02 14:15:00', NULL, NULL, 'annulee', '45 rue des Halles, 44000 Nantes', 'CB', 99.99);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 1, 5, 99.95);

-- ============================================
-- COMMANDE 93 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (13, UUID_SHORT(), '2025-04-03 16:25:00', '2025-04-04 08:55:00', '2025-04-06 15:15:00', 'livree', '3 rue des Amandiers, 33000 Bordeaux', 'Paypal', 292.98);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 77, 1, 99.99), 
(LAST_INSERT_ID(), 63, 1, 60.00), 
(LAST_INSERT_ID(), 64, 1, 49.99), 
(LAST_INSERT_ID(), 69, 1, 150.00);

-- ============================================
-- COMMANDE 94 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (28, UUID_SHORT(), '2025-04-04 10:40:00', '2025-04-05 09:15:00', '2025-04-07 14:00:00', 'livree', '67 avenue Jean Médecin, 06000 Nice', 'Paypal', 199.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 38, 3, 97.47), 
(LAST_INSERT_ID(), 75, 3, 45.00), 
(LAST_INSERT_ID(), 1, 4, 79.96), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 95 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (15, UUID_SHORT(), '2025-04-05 15:30:00', '2025-04-06 08:30:00', '2025-04-08 16:30:00', 'livree', '23 rue de la Verrerie, 75004 Paris', 'CB', 194.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 33, 3, 59.97), 
(LAST_INSERT_ID(), 13, 1, 37.99), 
(LAST_INSERT_ID(), 5, 2, 19.98), 
(LAST_INSERT_ID(), 74, 3, 36.00), 
(LAST_INSERT_ID(), 1, 3, 59.97);

-- ============================================
-- COMMANDE 96 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (49, UUID_SHORT(), '2025-04-06 12:10:00', '2025-04-07 09:00:00', '2025-04-09 11:45:00', 'livree', '18 place du Marché, 17000 La Rochelle', 'Paypal', 169.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 52, 2, 37.50), 
(LAST_INSERT_ID(), 8, 3, 35.97), 
(LAST_INSERT_ID(), 2, 4, 31.96), 
(LAST_INSERT_ID(), 11, 1, 8.99), 
(LAST_INSERT_ID(), 79, 5, 10.00);

-- ============================================
-- COMMANDE 97 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (12, UUID_SHORT(), '2025-04-07 15:40:00', '2025-04-08 08:30:00', '2025-04-10 16:20:00', 'livree', '12 rue du Maréchal Foch, 69006 Lyon', 'CB', 134.94);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 54, 1, 53.96), 
(LAST_INSERT_ID(), 51, 2, 31.98), 
(LAST_INSERT_ID(), 7, 3, 59.97), 
(LAST_INSERT_ID(), 11, 1, 8.99);

-- ============================================
-- COMMANDE 98 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (24, UUID_SHORT(), '2025-04-07 10:25:00', '2025-04-08 09:00:00', '2025-04-10 13:40:00', 'livree', '7 rue des Lys, 13005 Marseille', 'CB', 264.99);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 69, 1, 150.00), 
(LAST_INSERT_ID(), 34, 1, 99.99), 
(LAST_INSERT_ID(), 1, 3, 59.97);

-- ============================================
-- COMMANDE 99 — expediee
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (39, UUID_SHORT(), '2025-04-08 16:10:00', '2025-04-09 08:45:00', NULL, 'expediee', '19 rue du Vent, 35000 Rennes', 'Virement', 169.95);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 77, 1, 99.99), 
(LAST_INSERT_ID(), 64, 1, 49.99), 
(LAST_INSERT_ID(), 79, 10, 20.00);

-- ============================================
-- COMMANDE 100 — livree
-- ============================================
INSERT INTO Commande (idClient, numTransaction, dateCommande, dateExpedition, dateReception, statutCommande, adresseLivraison, typePaiement, prixTotal) 
VALUES (50, UUID_SHORT(), '2025-04-09 11:30:00', '2025-04-10 09:10:00', '2025-04-12 15:40:00', 'livree', '44 avenue de Grammont, 37000 Tours', 'Paypal', 204.97);
INSERT INTO LigneCommande (idCommande, idDeclinaison, quantite, prixTotal) VALUES
(LAST_INSERT_ID(), 52, 2, 37.50), 
(LAST_INSERT_ID(), 54, 1, 53.96), 
(LAST_INSERT_ID(), 61, 1, 15.00), 
(LAST_INSERT_ID(), 7, 2, 39.98), 
(LAST_INSERT_ID(), 1, 3, 59.97);
