UPDATE Client c
SET c.ptsFidelite = (
  SELECT COALESCE(SUM(co.prixTotal * 0.10), 0)
  FROM Commande co
  WHERE co.idClient = c.idClient
    AND co.statutCommande IN ('payee', 'expediee', 'livree')
);


DELIMITER $$
CREATE TRIGGER t_a_i_PtsFidelite
AFTER INSERT ON Commande
FOR EACH ROW
BEGIN
  IF NEW.statutCommande IN ('payee', 'expediee', 'livree') THEN
    UPDATE Client
    SET ptsFidelite = ptsFidelite + (NEW.prixTotal * 0.10)
    WHERE idClient = NEW.idClient;
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER t_a_u_PtsFidelitea
AFTER UPDATE ON Commande
FOR EACH ROW
BEGIN
  DECLARE etait_payee BOOLEAN DEFAULT (OLD.statutCommande IN ('payee', 'expediee', 'livree'));
  DECLARE est_payee BOOLEAN DEFAULT (NEW.statutCommande IN ('payee', 'expediee', 'livree'));

  -- Commande réglée --> on crédite les points de fidélités
  IF (NOT etait_payee) AND est_payee THEN
    UPDATE Client
    SET ptsFidelite = ptsFidelite + (NEW.prixTotal * 0.10)
    WHERE idClient = NEW.idClient;
  END IF;

  -- Commande annulée : on débite les points de fidélités
  IF etait_payee AND (NOT est_payee) THEN
    UPDATE Client
    SET ptsFidelite = ptsFidelite - (OLD.prixTotal * 0.10)
    WHERE idClient = NEW.idClient;
  END IF;
END$$

DELIMITER ;
