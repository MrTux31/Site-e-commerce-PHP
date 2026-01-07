-- ============================================
-- INSERTION DES AVIS CLIENTS
-- ============================================

-- 1. Marie Dubois sur Potion de Mana Majeure (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'marie.dubois@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Potion de mana majeure' LIMIT 1),
    5,
    'Indispensable pour les longs raids ! Le goût est un peu amer mais l''effet est immédiat. Je recommande.',
    NOW()
);

-- 2. Jean Martin sur Épée à deux mains (Note : 4/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'jean.martin@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Épée à deux mains' LIMIT 1),
    4,
    'Excellente facture, l''acier est solide. Un peu lourde pour les débutants, il faut avoir de la force.',
    DATE_SUB(NOW(), INTERVAL 2 DAY)
);

-- 3. Sophie Bernard sur Robe de sorcier pédestre (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'sophie.bernard@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Robe de sorcier pédestre' LIMIT 1),
    5,
    'Les poches dimensionnelles sont une bénédiction ! Je peux transporter toutes mes compos sans sac à dos.',
    DATE_SUB(NOW(), INTERVAL 5 DAY)
);

-- 4. Lucas Petit sur Dague de voleur (Note : 3/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'lucas.petit@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Dague de voleur' LIMIT 1),
    3,
    'Tranchante, mais la poignée glisse un peu quand on transpire. Correct pour le prix.',
    DATE_SUB(NOW(), INTERVAL 10 DAY)
);

-- 5. Emma Durand sur Potion de soin mineure (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'emma.durand@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Potion de soin mineure' LIMIT 1),
    5,
    'Parfait pour les petits bobos du quotidien ou les égratignures d''entraînement.',
    DATE_SUB(NOW(), INTERVAL 1 DAY)
);

-- 6. Thomas Leroy sur Baguette à étincelles (Note : 2/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'thomas.leroy@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Baguette à étincelles' LIMIT 1),
    2,
    'Attention ! Elle chauffe énormément après 3 lancers. J''ai failli me brûler les doigts.',
    DATE_SUB(NOW(), INTERVAL 15 DAY)
);

-- 7. Léa Moreau sur Bottes légèrement enchantées (Note : 4/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'lea.moreau@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Bottes légèrement enchantées' LIMIT 1),
    4,
    'Très confortables pour la marche, on sent vraiment qu''on se fatigue moins vite. Le cuir est souple.',
    DATE_SUB(NOW(), INTERVAL 3 DAY)
);

-- 8. Hugo Simon sur Dragon Slayer (Note : 1/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'hugo.simon@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Dragon Slayer' LIMIT 1),
    1,
    'Arnaque ! C''est juste un énorme bloc de fer trop lourd. Impossible à soulever pour un humain normal !',
    DATE_SUB(NOW(), INTERVAL 20 DAY)
);

-- 9. Chloé Laurent sur Manuel de recettes de Flagadus (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'chloe.laurent@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Les Recettes de Flagadus' LIMIT 1),
    5,
    'Miam ! La recette du ragoût de sanglier aux herbes est divine. Flagadus est un génie.',
    DATE_SUB(NOW(), INTERVAL 8 DAY)
);

-- 10. Nathan Lefebvre sur Torche inépuisable (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'nathan.lefebvre@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Torche inépuisable' LIMIT 1),
    5,
    'Incroyable, elle brûle même sous la pluie et au fond des grottes humides. Un must-have.',
    DATE_SUB(NOW(), INTERVAL 12 DAY)
);

-- 11. Camille Roux sur Arc long (Note : 4/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'camille.roux@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Arc long' LIMIT 1),
    4,
    'Bonne tension, bonne portée. Le bois est de bonne qualité.',
    DATE_SUB(NOW(), INTERVAL 6 DAY)
);

-- 12. Louis Fournier sur Flèche magique (Unité) (Note : 2/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'louis.fournier@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Flèche magique (Unité)' LIMIT 1),
    2,
    'Efficace mais beaucoup trop cher à l''unité. Prenez les carquois directement.',
    DATE_SUB(NOW(), INTERVAL 25 DAY)
);

-- 13. Manon Girard sur Bombe incendiaire noire (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'manon.girard@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Bombe incendiaire noire' LIMIT 1),
    5,
    'BOUM ! Explosion spectaculaire, parfait pour nettoyer une salle remplie de squelettes.',
    DATE_SUB(NOW(), INTERVAL 4 DAY)
);

-- 14. Gabriel Bonnet sur Grand Pavois (Note : 4/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'gabriel.bonnet@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Grand Pavois' LIMIT 1),
    4,
    'Protection totale, on se sent en sécurité derrière. Par contre, adieu la visibilité.',
    DATE_SUB(NOW(), INTERVAL 18 DAY)
);

-- 15. Arthur Lambert sur Anneau de vie (Note : 3/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'arthur.lambert@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Anneau de vie' LIMIT 1),
    3,
    'Joli bijou, mais l''effet sur la vitalité est vraiment minime. C''est plus esthétique qu''autre chose.',
    DATE_SUB(NOW(), INTERVAL 30 DAY)
);

-- 16. Jade Fontaine sur Sort de cristal en bouteille (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'jade.fontaine@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Sort de cristal en bouteille' LIMIT 1),
    5,
    'Très pratique pour les guerriers qui ne connaissent pas la magie. Ça surprend toujours l''adversaire !',
    DATE_SUB(NOW(), INTERVAL 7 DAY)
);

-- 17. Jules Rousseau sur Pain elfique (Note : 2/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'jules.rousseau@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Pain elfique' LIMIT 1),
    2,
    'Ça nourrit son homme, certes, mais ça a le goût de poussière et c''est sec comme le désert.',
    DATE_SUB(NOW(), INTERVAL 14 DAY)
);

-- 18. Alice Vincent sur Luth (Note : 4/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'alice.vincent@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Luth' LIMIT 1),
    4,
    'Sonorité très claire. J''ai pu animer la taverne toute la soirée. Une corde un peu fragile cependant.',
    DATE_SUB(NOW(), INTERVAL 9 DAY)
);

-- 19. Adam Muller sur Carte du royaume (Note : 3/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'adam.muller@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Carte du royaume' LIMIT 1),
    3,
    'La carte est belle mais il manque les sentiers de contrebande de la forêt obscure. Dommage.',
    DATE_SUB(NOW(), INTERVAL 22 DAY)
);

-- 20. Zoé Leclerc sur Potion de Résistance au feu (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'zoe.leclerc@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Potion de Résistance au feu' LIMIT 1),
    5,
    'M''a sauvé la vie contre un drake ! Le goût pimenté est surprenant mais on s''y fait.',
    DATE_SUB(NOW(), INTERVAL 2 DAY)
);

-- 21. Raphaël Gauthier sur Bâton du géomancien (Note : 4/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'raphael.gauthier@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Bâton du géomancien' LIMIT 1),
    4,
    'La canalisation des sorts de terre est impressionnante avec ce bâton. Un peu lourd à porter.',
    DATE_SUB(NOW(), INTERVAL 11 DAY)
);

-- 22. Lola Morel sur Kit de l'Ombre (Note : 5/5)
INSERT INTO Avis (idClient, idDeclinaisonProduit, note, commentaire, dateAvis) VALUES (
    (SELECT idClient FROM Client WHERE email = 'lola.morel@email.fr'),
    (SELECT idDeclinaison FROM DeclinaisonProduit WHERE libelleDeclinaison = 'Kit de l''Ombre' LIMIT 1), 3, 
    'Le starter pack parfait pour débuter dans la guilde des voleurs. Rapport qualité prix imbattable.',
    DATE_SUB(NOW(), INTERVAL 5 DAY)
);
