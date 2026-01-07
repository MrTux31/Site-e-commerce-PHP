-- ---------------------------------------------------------
-- ADMIN 1 : GANDALF (Réponses aux avis 1 à 4)
-- ---------------------------------------------------------
SET @idAdmin1 = (SELECT idAdmin FROM Administrateur WHERE email = 'gandalf.leblanc@admin.falconia.fr');

-- Reponse 1 (Marie / Potion Mana)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin1,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'marie.dubois@email.fr' AND d.libelleDeclinaison = 'Potion de mana majeure'),
    'Bonjour Marie. Ravie que notre concentration de mana vous plaise. L''amertume est le gage de sa pureté !', NOW());

-- Reponse 2 (Jean / Épée 2 mains)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin1,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'jean.martin@email.fr' AND d.libelleDeclinaison = 'Épée à deux mains'),
    'Merci Jean. C''est effectivement une arme de guerre. Nous conseillons une Force de 16 minimum pour la manier avec fluidité.', NOW());

-- Reponse 3 (Sophie / Robe)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin1,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'sophie.bernard@email.fr' AND d.libelleDeclinaison = 'Robe de sorcier pédestre'),
    'La magie dimensionnelle est notre spécialité ! Ravi que cela allège votre charge.', NOW());

-- Reponse 4 (Lucas / Dague)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin1,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'lucas.petit@email.fr' AND d.libelleDeclinaison = 'Dague de voleur'),
    'Bonjour Lucas. Merci du retour. Nous allons demander à notre tanneur d''utiliser un cuir plus texturé pour les prochaines séries.', NOW());


-- ---------------------------------------------------------
-- ADMIN 2 : MERLIN (Réponses aux avis 5 à 8)
-- ---------------------------------------------------------
SET @idAdmin2 = (SELECT idAdmin FROM Administrateur WHERE email = 'merlin.enchanteur@admin.falconia.fr');

-- Reponse 5 (Emma / Potion soin)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin2,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'emma.durand@email.fr' AND d.libelleDeclinaison = 'Potion de soin mineure'),
    'L''essentiel de la trousse de secours ! N''hésitez pas à consulter nos packs de 10 pour vos futures aventures.', NOW());

-- Reponse 6 (Thomas / Baguette)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin2,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'thomas.leroy@email.fr' AND d.libelleDeclinaison = 'Baguette à étincelles'),
    'Cher Thomas, navré pour cet incident. Comme indiqué dans la notice, le port de gants ignifugés est obligatoire avec ce modèle.', NOW());

-- Reponse 7 (Léa / Bottes)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin2,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'lea.moreau@email.fr' AND d.libelleDeclinaison = 'Bottes légèrement enchantées'),
    'Le sort de célérité intégré allège le pas. Excellent choix pour les longues randonnées !', NOW());

-- Reponse 8 (Hugo / Dragon Slayer)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin2,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'hugo.simon@email.fr' AND d.libelleDeclinaison = 'Dragon Slayer'),
    'Ce n''est pas une arnaque, c''est une légende ! Seul un guerrier marqué par le destin peut la soulever. Continuez l''entraînement !', NOW());


-- ---------------------------------------------------------
-- ADMIN 3 : MORGANE (Réponses aux avis 9 à 12)
-- ---------------------------------------------------------
SET @idAdmin3 = (SELECT idAdmin FROM Administrateur WHERE email = 'morgane.lafee@admin.falconia.fr');

-- Reponse 9 (Chloé / Recettes)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin3,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'chloe.laurent@email.fr' AND d.libelleDeclinaison = 'Les Recettes de Flagadus'),
    'Flagadus sera ravi de lire votre commentaire ! Essayez la tourte aux champignons hallucinogènes, c''est une expérience.', NOW());

-- Reponse 10 (Nathan / Torche)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin3,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'nathan.lefebvre@email.fr' AND d.libelleDeclinaison = 'Torche inépuisable'),
    'La magie du feu éternel est très pratique. Attention tout de même à ne pas la ranger allumée dans votre sac.', NOW());

-- Reponse 11 (Camille / Arc)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin3,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'camille.roux@email.fr' AND d.libelleDeclinaison = 'Arc long'),
    'C''est du bois d''If centenaire. Pensez à détendre la corde quand vous ne l''utilisez pas pour préserver sa puissance.', NOW());

-- Reponse 12 (Louis / Flèche)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin3,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'louis.fournier@email.fr' AND d.libelleDeclinaison = 'Flèche magique (Unité)'),
    'Bonjour Louis. L''enchantement individuel demande beaucoup de ressources. Les carquois de 25 sont effectivement plus économiques !', NOW());


-- ---------------------------------------------------------
-- ADMIN 4 : SAROUMANE (Réponses aux avis 13 à 16)
-- ---------------------------------------------------------
SET @idAdmin4 = (SELECT idAdmin FROM Administrateur WHERE email = 'saroumane.legris@admin.falconia.fr');

-- Reponse 13 (Manon / Bombe)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin4,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'manon.girard@email.fr' AND d.libelleDeclinaison = 'Bombe incendiaire noire'),
    'Une efficacité industrielle. Attention au souffle de l''explosion, il ne distingue pas l''ami de l''ennemi.', NOW());

-- Reponse 14 (Gabriel / Pavois)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin4,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'gabriel.bonnet@email.fr' AND d.libelleDeclinaison = 'Grand Pavois'),
    'C''est le prix de la sécurité absolue. Idéal pour tenir une ligne de front.', NOW());

-- Reponse 15 (Arthur / Anneau)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin4,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'arthur.lambert@email.fr' AND d.libelleDeclinaison = 'Anneau de vie'),
    'L''enchantement est subtil mais constant. Il peut faire la différence entre une blessure grave et une blessure mortelle.', NOW());

-- Reponse 16 (Jade / Sort bouteille)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin4,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'jade.fontaine@email.fr' AND d.libelleDeclinaison = 'Sort de cristal en bouteille'),
    'La sorcellerie condensée est un art complexe. Utilisez-la sagement.', NOW());


-- ---------------------------------------------------------
-- ADMIN 5 : RADAGAST (Réponses aux avis 17 à 20)
-- ---------------------------------------------------------
SET @idAdmin5 = (SELECT idAdmin FROM Administrateur WHERE email = 'radagast.lebrun@admin.falconia.fr');

-- Reponse 17 (Jules / Pain elfique)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin5,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'jules.rousseau@email.fr' AND d.libelleDeclinaison = 'Pain elfique'),
    'C''est une nourriture de pure survie pour les longs voyages, Jules. Trempez-le dans de l''eau de source !', NOW());

-- Reponse 18 (Alice / Luth)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin5,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'alice.vincent@email.fr' AND d.libelleDeclinaison = 'Luth'),
    'La musique adoucit les mœurs des bêtes sauvages. Passez en boutique, nous remplacerons la corde.', NOW());

-- Reponse 19 (Adam / Carte)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin5,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'adam.muller@email.fr' AND d.libelleDeclinaison = 'Carte du royaume'),
    'Les sentiers de la forêt obscure changent avec la lune... difficile de les cartographier !', NOW());

-- Reponse 20 (Zoé / Potion Feu)
INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (@idAdmin5,
    (SELECT idAvis FROM Avis a JOIN Client c ON a.idClient = c.idClient JOIN DeclinaisonProduit d ON a.idDeclinaisonProduit = d.idDeclinaison WHERE c.email = 'zoe.leclerc@email.fr' AND d.libelleDeclinaison = 'Potion de Résistance au feu'),
    'Le piment rouge est l''ingrédient de base pour l''activation thermique interne. Ravi que vous ayez survécu au drake !', NOW());
