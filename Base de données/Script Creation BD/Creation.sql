-- ============================================
-- BASE DE DONNÉES E-COMMERCE
-- ============================================

-- Suppression des tables si elles existent (ordre inverse)
DROP TABLE IF EXISTS Composer;
DROP TABLE IF EXISTS Appartenir;
DROP TABLE IF EXISTS Regrouper;
DROP TABLE IF EXISTS Apparenter;
DROP TABLE IF EXISTS LigneCommande;
DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS CompositionProduit;
DROP TABLE IF EXISTS PhotoProduit;
DROP TABLE IF EXISTS PhotoAvis;
DROP TABLE IF EXISTS ReponseAvis;
DROP TABLE IF EXISTS Avis;
DROP TABLE IF EXISTS DeclinaisonProduit;
DROP TABLE IF EXISTS Produit;
DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Regroupement;
DROP TABLE IF EXISTS CarteBancaire;
DROP TABLE IF EXISTS Administrateur;
DROP TABLE IF EXISTS Client;

-- ============================================
-- TABLE CLIENT
-- ============================================
CREATE TABLE Client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    motDePasse VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    codePostal VARCHAR(10) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    telephone CHAR(10),
    ptsFidelite INT NOT NULL DEFAULT 0,
    CONSTRAINT CK_ptsFidelite CHECK (ptsFidelite >= 0)
);





-- ============================================
-- TABLE CARTE BANCAIRE
-- ============================================
CREATE TABLE CarteBancaire (
    idCarte INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    numeroCarte CHAR(16) NOT NULL,
    cvc CHAR(3) NOT NULL,
    dateExpiration DATE NOT NULL,
    typeCarte VARCHAR(30) NOT NULL,
    CONSTRAINT CK_typeCarte CHECK (typeCarte IN ('Visa', 'Mastercard', 'American Express')),
    FOREIGN KEY (idClient) REFERENCES Client(idClient)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE ADMINISTRATEUR
-- ============================================
CREATE TABLE Administrateur (
    idAdmin INT AUTO_INCREMENT PRIMARY KEY,
    nomAdmin VARCHAR(50) NOT NULL,
    prenomAdmin VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mdp VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    CONSTRAINT CK_role CHECK (role IN ('superadmin', 'moderateur', 'editeur', 'support'))
);

-- ============================================
-- TABLE REGROUPEMENT
-- ============================================
CREATE TABLE Regroupement (
    idRegroupement INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(150) NOT NULL
);











-- ============================================
-- TABLE CATEGORIE (hiérarchique)
-- ============================================
CREATE TABLE Categorie (
    idCategorie INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(150) NOT NULL,
    idCategorieParent INT,
    FOREIGN KEY (idCategorieParent) REFERENCES Categorie(idCategorie)
        ON DELETE SET NULL
);

-- ============================================
-- TABLE PRODUIT
-- ============================================
CREATE TABLE Produit (
    idProduit INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(150) NOT NULL,
    description VARCHAR(500) NOT NULL,
    moyenneAvis DECIMAL(3,2),
    CONSTRAINT CK_moyenneAvis CHECK (moyenneAvis IS NULL OR (moyenneAvis >= 0 AND moyenneAvis <= 5))
);

-- ============================================
-- TABLE DECLINAISON PRODUIT
-- ============================================
CREATE TABLE DeclinaisonProduit (
    idDeclinaison INT AUTO_INCREMENT PRIMARY KEY,
    libelleDeclinaison VARCHAR(150) NOT NULL,
    idProduit INT NOT NULL,
    descDeclinaison VARCHAR(250) NOT NULL,
    ficheTechnique VARCHAR(500),
    prix DECIMAL(10,2) NOT NULL,
    prixSolde DECIMAL(10,2),
    qteStock INT NOT NULL,
    seuilQte INT NOT NULL,
    qualite VARCHAR(15) NOT NULL,
    provenance VARCHAR(30) NOT NULL,
    CONSTRAINT CK_prix CHECK (prix > 0),
    CONSTRAINT CK_prixSolde CHECK (prixSolde IS NULL OR prixSolde > 0),
    CONSTRAINT CK_qteStock CHECK (qteStock >= 0),
    CONSTRAINT CK_seuil CHECK (seuilQte >= 0),
    CONSTRAINT CK_qualite CHECK (qualite IN ('Commun', 'Peu commun', 'Rare', 'Epique', 'Legendaire', 'Mixte')),
    FOREIGN KEY (idProduit) REFERENCES Produit(idProduit)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE AVIS
-- ============================================
CREATE TABLE Avis (
    idAvis INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    idDeclinaisonProduit INT NOT NULL,
    note INT NOT NULL,
    commentaire VARCHAR(1000),
    dateAvis DATETIME NOT NULL,
    CONSTRAINT CK_note CHECK (note >= 0 AND note <= 5),
    FOREIGN KEY (idClient) REFERENCES Client(idClient)
        ON DELETE CASCADE,
    FOREIGN KEY (idDeclinaisonProduit) REFERENCES DeclinaisonProduit(idDeclinaisonProduit )
        ON DELETE CASCADE
);

-- ============================================
-- TABLE PHOTO AVIS
-- ============================================
CREATE TABLE PhotoAvis (
    idPhoto INT AUTO_INCREMENT PRIMARY KEY,
    idAvis INT NOT NULL,
    url VARCHAR(255) NOT NULL,
    FOREIGN KEY (idAvis) REFERENCES Avis(idAvis)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE REPONSE AVIS
-- ============================================
CREATE TABLE ReponseAvis (
    idReponse INT AUTO_INCREMENT PRIMARY KEY,
    idAdmin INT NOT NULL,
    idAvis INT NOT NULL,
    reponse VARCHAR(1000) NOT NULL,
    date DATETIME NOT NULL,
    FOREIGN KEY (idAdmin) REFERENCES Administrateur(idAdmin)
        ON DELETE CASCADE,
    FOREIGN KEY (idAvis) REFERENCES Avis(idAvis)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE PHOTO PRODUIT
-- ============================================
CREATE TABLE PhotoProduit (
    idPhoto INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    idDeclinaison INT NOT NULL,
    FOREIGN KEY (idDeclinaison) REFERENCES DeclinaisonProduit(idDeclinaison)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE COMPOSITION PRODUIT
-- ============================================
CREATE TABLE CompositionProduit (
    idCompo INT NOT NULL,              -- déclinaison considérée comme kit
    idDeclinaison INT NOT NULL,        -- composant
    quantiteProduit INT NOT NULL,      -- quantité du composant dans le kit
    CONSTRAINT CK_qteProduitCompo CHECK (quantiteProduit > 0),
    CONSTRAINT PK_CompositionProduit PRIMARY KEY (idCompo, idDeclinaison),
    CONSTRAINT FK_Compo_Kit FOREIGN KEY (idCompo)
        REFERENCES DeclinaisonProduit(idDeclinaison)
        ON DELETE CASCADE,
    CONSTRAINT FK_Compo_Produit FOREIGN KEY (idDeclinaison)
        REFERENCES DeclinaisonProduit(idDeclinaison)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE COMMANDE
-- ============================================
CREATE TABLE Commande (
    idCommande INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    numTransaction VARCHAR(100) NOT NULL,
    dateCommande DATETIME NOT NULL,
    dateExpedition DATETIME,
    dateReception DATETIME,
    statutCommande VARCHAR(30) NOT NULL,
    adresseLivraison VARCHAR(255) NOT NULL,
    typePaiement VARCHAR(30) NOT NULL,
    prixTotal DECIMAL(10,2),
    CONSTRAINT CK_statut CHECK (statutCommande IN ('payee', 'expediee', 'livree', 'annulee' )),
    CONSTRAINT CK_dateExpedition CHECK (dateExpedition IS NULL OR dateExpedition >= dateCommande),
    CONSTRAINT CK_dateReception CHECK (dateReception IS NULL OR dateReception >= dateExpedition),
    CONSTRAINT CK_prixTotal CHECK (prixTotal >= 0),
    CONSTRAINT CK_typePaiement CHECK (typePaiement IN ('CB','Paypal','Virement')),
     FOREIGN KEY (idClient) REFERENCES Client(idClient)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE LIGNE COMMANDE (Clé primaire composée)
-- ============================================
CREATE TABLE LigneCommande (
    idCommande INT NOT NULL,
    idDeclinaison INT NOT NULL,
    quantite INT NOT NULL,
    prixTotal DECIMAL(10,2),
    PRIMARY KEY (idCommande, idDeclinaison),
    CONSTRAINT CK_quantite CHECK (quantite > 0),
    CONSTRAINT CK_prixTotalLigne CHECK (prixTotal IS NULL OR prixTotal> 0),
    FOREIGN KEY (idCommande) REFERENCES Commande(idCommande)
        ON DELETE CASCADE,
    FOREIGN KEY (idDeclinaison) REFERENCES DeclinaisonProduit(idDeclinaison)
);


-- ============================================
-- TABLE APPARTENIR (Association n-m)
-- ============================================
CREATE TABLE Appartenir (
    idProduit INT NOT NULL,
    idCategorie INT NOT NULL,
    PRIMARY KEY (idProduit, idCategorie),
    FOREIGN KEY (idProduit) REFERENCES Produit(idProduit)
        ON DELETE CASCADE,
    FOREIGN KEY (idCategorie) REFERENCES Categorie(idCategorie)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE REGROUPER (Association n-m)
-- ============================================
CREATE TABLE Regrouper (
    idRegroupement INT NOT NULL,
    idProduit INT NOT NULL,
    PRIMARY KEY (idRegroupement, idProduit),
    FOREIGN KEY (idRegroupement) REFERENCES Regroupement(idRegroupement)
        ON DELETE CASCADE,
    FOREIGN KEY (idProduit) REFERENCES Produit(idProduit)
        ON DELETE CASCADE
);

-- ============================================
-- TABLE APPARENTER (Association n-m réflexive)
-- ============================================
CREATE TABLE Apparenter (
    idProduit1 INT NOT NULL,
    idProduit2 INT NOT NULL,
    PRIMARY KEY (idProduit1, idProduit2),
    CONSTRAINT CK_apparenter CHECK (idProduit1 < idProduit2),
    FOREIGN KEY (idProduit1) REFERENCES Produit(idProduit)
        ON DELETE CASCADE,
    FOREIGN KEY (idProduit2) REFERENCES Produit(idProduit)
        ON DELETE CASCADE
);

-- ==============================================
-- TABLE auth_tokens (pour "se souvenir de moi")
-- ==============================================

CREATE TABLE auth_tokens (
    id INT(11) NOT NULL AUTO_INCREMENT,
    selector VARCHAR(24) NOT NULL,
    token VARCHAR(64) NOT NULL,
    user_id INT(11) NOT NULL,
    user_type VARCHAR(20) NOT NULL,
    expires_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY selector (selector)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
