-- ============================================
-- INSERTION DES CARTES BANCAIRES (10 Clients)
-- ============================================

-- 1. Marie Dubois (Paris) - Visa
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'marie.dubois@email.fr'), 
    '4970101020203030', 
    '123', 
    '2026-05-31', 
    'Visa'
);

-- 2. Jean Martin (Paris) - Mastercard
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'jean.martin@email.fr'), 
    '5100202030304040', 
    '456', 
    '2025-11-30', 
    'Mastercard'
);

-- 3. Emma Durand (Paris - Gros client) - American Express
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'emma.durand@email.fr'), 
    '3400303040405050', 
    '789', 
    '2027-01-31', 
    'American Express'
);

-- 4. Arthur Lambert (Strasbourg) - Visa
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'arthur.lambert@email.fr'), 
    '4100404050506060', 
    '234', 
    '2026-09-30', 
    'Visa'
);

-- 5. Zoé Leclerc (Lyon) - Mastercard
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'zoe.leclerc@email.fr'), 
    '5500505060607070', 
    '567', 
    '2028-03-31', 
    'Mastercard'
);

-- 6. Mia Mercier (Marseille) - Visa Gold
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'mia.mercier@email.fr'), 
    '4500606070708080', 
    '890', 
    '2025-12-31', 
    'Visa'
);

-- 7. Alexandre Martinez (Bordeaux) - American Express
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'alexandre.martinez@email.fr'), 
    '3700707080809090', 
    '112', 
    '2026-07-31', 
    'American Express'
);

-- 8. Mathis Pierre (Nantes) - Mastercard
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'mathis.pierre@email.fr'), 
    '5200808090900000', 
    '345', 
    '2027-04-30', 
    'Mastercard'
);

-- 9. Antoine Giraud (Rennes) - Visa
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'antoine.giraud@email.fr'), 
    '4900909000001010', 
    '678', 
    '2026-02-28', 
    'Visa'
);

-- 10. Lucas Petit (Paris - Nouveau client) - Visa
INSERT INTO CarteBancaire (idClient, numeroCarte, cvc, dateExpiration, typeCarte) 
VALUES (
    (SELECT idClient FROM Client WHERE email = 'lucas.petit@email.fr'), 
    '4000123456789012', 
    '999', 
    '2029-01-01', 
    'Visa'
);
