-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : mer. 03 déc. 2025 à 08:07
-- Version du serveur : 8.4.5
-- Version de PHP : 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `R2025MYSAE3005`
--

-- --------------------------------------------------------

--
-- Structure de la table `Administrateur`
--

CREATE TABLE `Administrateur` (
  `idAdmin` int NOT NULL,
  `nomAdmin` varchar(50) NOT NULL,
  `prenomAdmin` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mdp` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL
) ;

--
-- Déchargement des données de la table `Administrateur`
--

INSERT INTO `Administrateur` (`idAdmin`, `nomAdmin`, `prenomAdmin`, `email`, `mdp`, `role`) VALUES
(1, 'LeBlanc', 'Gandalf', 'gandalf.leblanc@admin.falconia.fr', '$2y$10$adminhashsupersecret12345', 'superadmin'),
(2, 'L\'Enchanteur', 'Merlin', 'merlin.enchanteur@admin.falconia.fr', '$2y$10$adminhashmoderateur12345', 'moderateur'),
(3, 'LaFée', 'Morgane', 'morgane.lafee@admin.falconia.fr', '$2y$10$adminhashsupport12345678', 'support'),
(4, 'LeGris', 'Saroumane', 'saroumane.legris@admin.falconia.fr', '$2y$10$adminhashediteur12345678', 'editeur'),
(5, 'LeBrun', 'Radagast', 'radagast.lebrun@admin.falconia.fr', '$2y$10$adminhashsupportrabbit12', 'support');

-- --------------------------------------------------------

--
-- Structure de la table `Apparenter`
--

CREATE TABLE `Apparenter` (
  `idProduit1` int NOT NULL,
  `idProduit2` int NOT NULL
) ;

--
-- Déchargement des données de la table `Apparenter`
--

INSERT INTO `Apparenter` (`idProduit1`, `idProduit2`) VALUES
(1, 3),
(6, 14),
(10, 15),
(7, 16),
(9, 17),
(19, 22),
(12, 26),
(6, 30),
(7, 30),
(22, 31),
(23, 31),
(27, 32),
(33, 34),
(24, 35),
(34, 36),
(32, 37),
(38, 39),
(21, 41),
(40, 43),
(44, 45),
(5, 46),
(21, 47),
(28, 47),
(4, 50),
(42, 50);

-- --------------------------------------------------------

--
-- Structure de la table `Appartenir`
--

CREATE TABLE `Appartenir` (
  `idProduit` int NOT NULL,
  `idCategorie` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Appartenir`
--

INSERT INTO `Appartenir` (`idProduit`, `idCategorie`) VALUES
(21, 3),
(22, 4),
(27, 4),
(23, 5),
(24, 6),
(25, 7),
(26, 9),
(33, 12),
(34, 13),
(35, 14),
(36, 14),
(31, 15),
(6, 18),
(7, 19),
(8, 21),
(3, 24),
(1, 25),
(2, 27),
(49, 29),
(9, 30),
(10, 31),
(13, 32),
(11, 33),
(14, 33),
(15, 33),
(16, 33),
(17, 34),
(18, 34),
(19, 34),
(20, 34),
(4, 35),
(5, 35),
(50, 35),
(12, 38),
(38, 39),
(39, 41),
(29, 42),
(47, 45),
(28, 46),
(30, 47),
(32, 49),
(37, 50),
(40, 53),
(42, 54),
(41, 55),
(43, 56),
(44, 59),
(45, 60),
(46, 61),
(51, 63),
(48, 66);

-- --------------------------------------------------------

--
-- Structure de la table `Avis`
--

CREATE TABLE `Avis` (
  `idAvis` int NOT NULL,
  `idClient` int NOT NULL,
  `idDeclinaisonProduit` int NOT NULL,
  `note` int NOT NULL,
  `commentaire` varchar(1000) DEFAULT NULL,
  `dateAvis` datetime NOT NULL
) ;

--
-- Déchargement des données de la table `Avis`
--

INSERT INTO `Avis` (`idAvis`, `idClient`, `idDeclinaisonProduit`, `note`, `commentaire`, `dateAvis`) VALUES
(1, 1, 1, 5, 'Indispensable pour les longs raids ! Le goût est un peu amer mais l\'effet est immédiat. Je recommande.', '2025-12-03 08:55:46'),
(2, 2, 35, 4, 'Excellente facture, l\'acier est solide. Un peu lourde pour les débutants, il faut avoir de la force.', '2025-12-01 08:55:46'),
(3, 3, 43, 5, 'Les poches dimensionnelles sont une bénédiction ! Je peux transporter toutes mes compos sans sac à dos.', '2025-11-28 08:55:46'),
(4, 4, 33, 3, 'Tranchante, mais la poignée glisse un peu quand on transpire. Correct pour le prix.', '2025-11-23 08:55:46'),
(5, 5, 8, 5, 'Parfait pour les petits bobos du quotidien ou les égratignures d\'entraînement.', '2025-12-02 08:55:46'),
(6, 6, 13, 2, 'Attention ! Elle chauffe énormément après 3 lancers. J\'ai failli me brûler les doigts.', '2025-11-18 08:55:46'),
(7, 7, 41, 4, 'Très confortables pour la marche, on sent vraiment qu\'on se fatigue moins vite. Le cuir est souple.', '2025-11-30 08:55:46'),
(8, 8, 40, 1, 'Arnaque ! C\'est juste un énorme bloc de fer trop lourd. Impossible à soulever pour un humain normal !', '2025-11-13 08:55:46'),
(9, 9, 11, 5, 'Miam ! La recette du ragoût de sanglier aux herbes est divine. Flagadus est un génie.', '2025-11-25 08:55:46'),
(10, 10, 60, 5, 'Incroyable, elle brûle même sous la pluie et au fond des grottes humides. Un must-have.', '2025-11-21 08:55:46'),
(11, 11, 39, 4, 'Bonne tension, bonne portée. Le bois est de bonne qualité.', '2025-11-27 08:55:46'),
(12, 12, 22, 2, 'Efficace mais beaucoup trop cher à l\'unité. Prenez les carquois directement.', '2025-11-08 08:55:46'),
(13, 13, 58, 5, 'BOUM ! Explosion spectaculaire, parfait pour nettoyer une salle remplie de squelettes.', '2025-11-29 08:55:46'),
(14, 14, 46, 4, 'Protection totale, on se sent en sécurité derrière. Par contre, adieu la visibilité.', '2025-11-15 08:55:46'),
(15, 16, 47, 3, 'Joli bijou, mais l\'effet sur la vitalité est vraiment minime. C\'est plus esthétique qu\'autre chose.', '2025-11-03 08:55:46'),
(16, 17, 42, 5, 'Très pratique pour les guerriers qui ne connaissent pas la magie. Ça surprend toujours l\'adversaire !', '2025-11-26 08:55:46'),
(17, 18, 64, 2, 'Ça nourrit son homme, certes, mais ça a le goût de poussière et c\'est sec comme le désert.', '2025-11-19 08:55:46'),
(18, 19, 72, 4, 'Sonorité très claire. J\'ai pu animer la taverne toute la soirée. Une corde un peu fragile cependant.', '2025-11-24 08:55:46'),
(19, 20, 74, 3, 'La carte est belle mais il manque les sentiers de contrebande de la forêt obscure. Dommage.', '2025-11-11 08:55:46'),
(20, 21, 5, 5, 'M\'a sauvé la vie contre un drake ! Le goût pimenté est surprenant mais on s\'y fait.', '2025-12-01 08:55:46'),
(21, 22, 17, 4, 'La canalisation des sorts de terre est impressionnante avec ce bâton. Un peu lourd à porter.', '2025-11-22 08:55:46'),
(22, 23, 82, 3, 'Le starter pack parfait pour débuter dans la guilde des voleurs. Rapport qualité prix imbattable.', '2025-11-28 08:55:46');

-- --------------------------------------------------------

--
-- Structure de la table `CarteBancaire`
--

CREATE TABLE `CarteBancaire` (
  `idCarte` int NOT NULL,
  `idClient` int NOT NULL,
  `numeroCarte` char(16) NOT NULL,
  `cvc` char(3) NOT NULL,
  `dateExpiration` date NOT NULL,
  `typeCarte` varchar(30) NOT NULL
) ;

--
-- Déchargement des données de la table `CarteBancaire`
--

INSERT INTO `CarteBancaire` (`idCarte`, `idClient`, `numeroCarte`, `cvc`, `dateExpiration`, `typeCarte`) VALUES
(1, 1, '4970101020203030', '123', '2026-05-31', 'Visa'),
(2, 2, '5100202030304040', '456', '2025-11-30', 'Mastercard'),
(3, 5, '3400303040405050', '789', '2027-01-31', 'American Express'),
(4, 16, '4100404050506060', '234', '2026-09-30', 'Visa'),
(5, 21, '5500505060607070', '567', '2028-03-31', 'Mastercard'),
(6, 27, '4500606070708080', '890', '2025-12-31', 'Visa'),
(7, 36, '3700707080809090', '112', '2026-07-31', 'American Express'),
(8, 44, '5200808090900000', '345', '2027-04-30', 'Mastercard'),
(9, 40, '4900909000001010', '678', '2026-02-28', 'Visa'),
(10, 4, '4000123456789012', '999', '2029-01-01', 'Visa');

-- --------------------------------------------------------

--
-- Structure de la table `Categorie`
--

CREATE TABLE `Categorie` (
  `idCategorie` int NOT NULL,
  `libelle` varchar(150) NOT NULL,
  `idCategorieParent` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Categorie`
--

INSERT INTO `Categorie` (`idCategorie`, `libelle`, `idCategorieParent`) VALUES
(1, 'Armes', NULL),
(2, 'Armes de Mêlée', 1),
(3, 'Dagues & Couteaux', 2),
(4, 'Épées', 2),
(5, 'Haches', 2),
(6, 'Marteaux', 2),
(7, 'Armes d\'Hast', 2),
(8, 'Armes à Distance', 1),
(9, 'Arcs', 8),
(10, 'Protections', NULL),
(11, 'Armures Métalliques', 10),
(12, 'Casques & Heaumes', 11),
(13, 'Plastrons', 11),
(14, 'Gantelets & Jambières', 11),
(15, 'Boucliers', 10),
(16, 'Catalyseurs Magiques', NULL),
(17, 'Pour Sorciers', 16),
(18, 'Baguettes Magiques', 17),
(19, 'Bâtons de Mage', 17),
(20, 'Pour Clercs', 16),
(21, 'Talismans Sacrés', 20),
(22, 'Alchimie & Potions', NULL),
(23, 'Potions de Restauration', 22),
(24, 'Soins', 23),
(25, 'Mana', 23),
(26, 'Potions de Buff', 22),
(27, 'Résistances Élémentaires', 26),
(28, 'Bibliothèque', NULL),
(29, 'Grimoires de Sorts', 28),
(30, 'Tomes Divins', 29),
(31, 'Pyromancie', 29),
(32, 'Parchemins Unitaires', 28),
(33, 'Sorts Offensifs', 32),
(34, 'Miracles', 32),
(35, 'Guides Pratiques', 28),
(36, 'Munitions & Explosifs', NULL),
(37, 'Projectiles', 36),
(38, 'Flèches', 37),
(39, 'Armes de Jet', 37),
(40, 'Explosifs', 36),
(41, 'Bombes', 40),
(42, 'Sorts en Bouteille', 40),
(43, 'Vêtements & Apparat', NULL),
(44, 'Tenues de Voyage', 43),
(45, 'Capes', 44),
(46, 'Chaussures', 44),
(47, 'Tenues de Mage', 43),
(48, 'Bijouterie Magique', NULL),
(49, 'Anneaux', 48),
(50, 'Amulettes', 48),
(51, 'Outils d\'Aventurier', NULL),
(52, 'Exploration', 51),
(53, 'Éclairage', 52),
(54, 'Observation', 52),
(55, 'Effraction', 51),
(56, 'Survie', 51),
(57, 'Artisanat & Ressources', NULL),
(58, 'Composants de Forge', 57),
(59, 'Minerais', 58),
(60, 'Gemmes', 58),
(61, 'Botanique', 57),
(62, 'Kits & Coffrets', NULL),
(63, 'Kits Thématiques', 62),
(64, 'Culture & Divertissement', NULL),
(65, 'Instruments de Musique', 64),
(66, 'Cordes', 65);

-- --------------------------------------------------------

--
-- Structure de la table `Client`
--

CREATE TABLE `Client` (
  `idClient` int NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `motDePasse` varchar(255) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `codePostal` varchar(10) NOT NULL,
  `ville` varchar(100) NOT NULL,
  `telephone` char(10) DEFAULT NULL,
  `ptsFidelite` int NOT NULL DEFAULT '0'
) ;

--
-- Déchargement des données de la table `Client`
--

INSERT INTO `Client` (`idClient`, `nom`, `prenom`, `email`, `motDePasse`, `adresse`, `codePostal`, `ville`, `telephone`, `ptsFidelite`) VALUES
(1, 'Dubois', 'Marie', 'marie.dubois@email.fr', '$2y$10$abcdefghijklmnopqrstuv', '12 rue de Rivoli', '75001', 'Paris', '0145678901', 150),
(2, 'Martin', 'Jean', 'jean.martin@email.fr', '$2y$10$bcdefghijklmnopqrstuvw', '45 avenue des Champs-Élysées', '75008', 'Paris', '0156789012', 320),
(3, 'Bernard', 'Sophie', 'sophie.bernard@email.fr', '$2y$10$cdefghijklmnopqrstuvwx', '23 rue du Faubourg Saint-Antoine', '75011', 'Paris', '0167890123', 75),
(4, 'Petit', 'Lucas', 'lucas.petit@email.fr', '$2y$10$defghijklmnopqrstuvwxy', '78 boulevard Voltaire', '75011', 'Paris', '0178901234', 0),
(5, 'Durand', 'Emma', 'emma.durand@email.fr', '$2y$10$efghijklmnopqrstuvwxyz', '15 rue de la Paix', '75002', 'Paris', '0189012345', 450),
(6, 'Leroy', 'Thomas', 'thomas.leroy@email.fr', '$2y$10$fghijklmnopqrstuvwxyza', '89 avenue de Versailles', '92130', 'Issy-les-Moulineaux', '0190123456', 210),
(7, 'Moreau', 'Léa', 'lea.moreau@email.fr', '$2y$10$ghijklmnopqrstuvwxyzab', '34 rue du Commerce', '92100', 'Boulogne-Billancourt', '0101234567', 80),
(8, 'Simon', 'Hugo', 'hugo.simon@email.fr', '$2y$10$hijklmnopqrstuvwxyzabc', '56 avenue Paul Doumer', '94160', 'Saint-Mandé', '0112345678', 0),
(9, 'Laurent', 'Chloé', 'chloe.laurent@email.fr', '$2y$10$ijklmnopqrstuvwxyzabcd', '12 boulevard de Strasbourg', '77000', 'Melun', '0123456789', 190),
(10, 'Lefebvre', 'Nathan', 'nathan.lefebvre@email.fr', '$2y$10$jklmnopqrstuvwxyzabcde', '67 rue de la République', '78000', 'Versailles', '0134567890', 340),
(11, 'Roux', 'Camille', 'camille.roux@email.fr', '$2y$10$klmnopqrstuvwxyzabcdef', '89 rue Nationale', '59000', 'Lille', '0320123456', 125),
(12, 'Fournier', 'Louis', 'louis.fournier@email.fr', '$2y$10$lmnopqrstuvwxyzabcdefg', '23 place du Général de Gaulle', '59800', 'Lille', '0320234567', 0),
(13, 'Girard', 'Manon', 'manon.girard@email.fr', '$2y$10$mnopqrstuvwxyzabcdefgh', '45 rue Gambetta', '62000', 'Arras', '0321345678', 95),
(14, 'Bonnet', 'Gabriel', 'gabriel.bonnet@email.fr', '$2y$10$nopqrstuvwxyzabcdefghi', '78 boulevard Carnot', '80000', 'Amiens', '0322456789', 260),
(15, 'Dupont', 'Inès', 'ines.dupont@email.fr', '$2y$10$opqrstuvwxyzabcdefghij', '12 rue de la Gare', '60000', 'Beauvais', '0344567890', 0),
(16, 'Lambert', 'Arthur', 'arthur.lambert@email.fr', '$2y$10$pqrstuvwxyzabcdefghijk', '34 rue du Vieux-Marché-aux-Vins', '67000', 'Strasbourg', '0388678901', 410),
(17, 'Fontaine', 'Jade', 'jade.fontaine@email.fr', '$2y$10$qrstuvwxyzabcdefghijkl', '56 avenue de Colmar', '68100', 'Mulhouse', '0389789012', 170),
(18, 'Rousseau', 'Jules', 'jules.rousseau@email.fr', '$2y$10$rstuvwxyzabcdefghijklm', '89 rue Saint-Dizier', '54000', 'Nancy', '0383890123', 0),
(19, 'Vincent', 'Alice', 'alice.vincent@email.fr', '$2y$10$stuvwxyzabcdefghijklmn', '23 rue Serpenoise', '57000', 'Metz', '0387901234', 285),
(20, 'Muller', 'Adam', 'adam.muller@email.fr', '$2y$10$tuvwxyzabcdefghijklmno', '45 boulevard Victor Hugo', '51100', 'Reims', '0326012345', 130),
(21, 'Leclerc', 'Zoé', 'zoe.leclerc@email.fr', '$2y$10$uvwxyzabcdefghijklmnop', '67 rue de la République', '69002', 'Lyon', '0478123456', 380),
(22, 'Gauthier', 'Raphaël', 'raphael.gauthier@email.fr', '$2y$10$vwxyzabcdefghijklmnopq', '12 cours Berriat', '38000', 'Grenoble', '0476234567', 0),
(23, 'Morel', 'Lola', 'lola.morel@email.fr', '$2y$10$wxyzabcdefghijklmnopqr', '34 rue Vaugelas', '74000', 'Annecy', '0450345678', 220),
(24, 'Garnier', 'Paul', 'paul.garnier@email.fr', '$2y$10$xyzabcdefghijklmnopqrs', '56 avenue du Général de Gaulle', '73000', 'Chambéry', '0479456567', 0),
(25, 'Faure', 'Lina', 'lina.faure@email.fr', '$2y$10$yzabcdefghijklmnopqrst', '89 rue de la République', '42000', 'Saint-Étienne', '0477567890', 160),
(26, 'André', 'Tom', 'tom.andre@email.fr', '$2y$10$zabcdefghijklmnopqrstu', '23 boulevard Berthelot', '63000', 'Clermont-Ferrand', '0473678901', 90),
(27, 'Mercier', 'Mia', 'mia.mercier@email.fr', '$2y$10$abcdefghijklmnopqrstuv1', '45 La Canebière', '13001', 'Marseille', '0491789012', 500),
(28, 'Blanc', 'Noah', 'noah.blanc@email.fr', '$2y$10$bcdefghijklmnopqrstuv1w', '67 avenue Jean Médecin', '06000', 'Nice', '0493890123', 275),
(29, 'Guerin', 'Lou', 'lou.guerin@email.fr', '$2y$10$cdefghijklmnopqrstuv1wx', '12 boulevard de Strasbourg', '83000', 'Toulon', '0494901234', 0),
(30, 'Boyer', 'Ethan', 'ethan.boyer@email.fr', '$2y$10$defghijklmnopqrstuv1wxy', '34 rue de la République', '84000', 'Avignon', '0490012345', 140),
(31, 'Garnier', 'Nina', 'nina.garnier@email.fr', '$2y$10$efghijklmnopqrstuv1wxyz', '56 rue Alsace-Lorraine', '31000', 'Toulouse', '0561123456', 310),
(32, 'Chevalier', 'Théo', 'theo.chevalier@email.fr', '$2y$10$fghijklmnopqrstuv1wxyza', '89 rue de la Loge', '34000', 'Montpellier', '0467234567', 0),
(33, 'François', 'Sarah', 'sarah.francois@email.fr', '$2y$10$ghijklmnopqrstuv1wxyzab', '23 avenue de la Gare', '66000', 'Perpignan', '0468345678', 185),
(34, 'Fernandez', 'Maxime', 'maxime.fernandez@email.fr', '$2y$10$hijklmnopqrstuv1wxyzabc', '45 rue de Verdun', '11000', 'Carcassonne', '0468456789', 70),
(35, 'Lemoine', 'Léna', 'lena.lemoine@email.fr', '$2y$10$ijklmnopqrstuv1wxyzabcd', '67 rue Gambetta', '81000', 'Albi', '0563567890', 0),
(36, 'Martinez', 'Alexandre', 'alexandre.martinez@email.fr', '$2y$10$jklmnopqrstuv1wxyzabcde', '12 cours de l\'Intendance', '33000', 'Bordeaux', '0556678901', 425),
(37, 'Lopez', 'Juliette', 'juliette.lopez@email.fr', '$2y$10$klmnopqrstuv1wxyzabcdef', '34 avenue du Maréchal Foch', '64000', 'Pau', '0559789012', 0),
(38, 'Sanchez', 'Baptiste', 'baptiste.sanchez@email.fr', '$2y$10$lmnopqrstuv1wxyzabcdefg', '56 avenue Georges Clemenceau', '40000', 'Mont-de-Marsan', '0558890123', 200),
(39, 'Rolland', 'Clara', 'clara.rolland@email.fr', '$2y$10$mnopqrstuv1wxyzabcdefgh', '89 boulevard Carnot', '87000', 'Limoges', '0555901234', 110),
(40, 'Giraud', 'Antoine', 'antoine.giraud@email.fr', '$2y$10$nopqrstuv1wxyzabcdefghi', '23 rue d\'Antrain', '35000', 'Rennes', '0299012345', 240),
(41, 'Caron', 'Rose', 'rose.caron@email.fr', '$2y$10$opqrstuv1wxyzabcdefghij', '45 rue de Siam', '29200', 'Brest', '0298123456', 0),
(42, 'Renard', 'Matteo', 'matteo.renard@email.fr', '$2y$10$pqrstuv1wxyzabcdefghijk', '67 rue du Port', '56100', 'Lorient', '0297234567', 175),
(43, 'Colin', 'Anna', 'anna.colin@email.fr', '$2y$10$qrstuv1wxyzabcdefghijkl', '12 place du Général de Gaulle', '22000', 'Saint-Brieuc', '0296345678', 85),
(44, 'Pierre', 'Mathis', 'mathis.pierre@email.fr', '$2y$10$rstuv1wxyzabcdefghijklm', '34 rue Crébillon', '44000', 'Nantes', '0240456789', 365),
(45, 'Masson', 'Victoria', 'victoria.masson@email.fr', '$2y$10$stuv1wxyzabcdefghijklmn', '56 boulevard du Roi René', '49100', 'Angers', '0241567890', 0),
(46, 'Leroux', 'Mathéo', 'matheo.leroux@email.fr', '$2y$10$tuv1wxyzabcdefghijklmno', '89 rue Georges Clemenceau', '85000', 'La Roche-sur-Yon', '0251678901', 155),
(47, 'Perrin', 'Léonie', 'leonie.perrin@email.fr', '$2y$10$uv1wxyzabcdefghijklmnop', '23 rue de la République', '45000', 'Orléans', '0238789012', 195),
(48, 'Clement', 'Sacha', 'sacha.clement@email.fr', '$2y$10$v1wxyzabcdefghijklmnopq', '45 rue Nationale', '37000', 'Tours', '0247890123', 0),
(49, 'Joly', 'Lily', 'lily.joly@email.fr', '$2y$10$w1xyzabcdefghijklmnopqr', '67 rue du Commerce', '41000', 'Blois', '0254901234', 120),
(50, 'Marchand', 'Élise', 'elise.marchand@email.fr', '$2y$10$x1yzabcdefghijklmnopqrs', '12 rue des Lilas', '72000', 'Le Mans', '0244789012', 145);

-- --------------------------------------------------------

--
-- Structure de la table `Commande`
--

CREATE TABLE `Commande` (
  `idCommande` int NOT NULL,
  `idClient` int NOT NULL,
  `numTransaction` varchar(100) NOT NULL,
  `dateCommande` datetime NOT NULL,
  `dateExpedition` datetime DEFAULT NULL,
  `dateReception` datetime DEFAULT NULL,
  `statutCommande` varchar(30) NOT NULL,
  `adresseLivraison` varchar(255) NOT NULL,
  `typePaiement` varchar(30) NOT NULL,
  `prixTotal` decimal(10,2) DEFAULT NULL
) ;

--
-- Déchargement des données de la table `Commande`
--

INSERT INTO `Commande` (`idCommande`, `idClient`, `numTransaction`, `dateCommande`, `dateExpedition`, `dateReception`, `statutCommande`, `adresseLivraison`, `typePaiement`, `prixTotal`) VALUES
(1, 1, '101628031772131655', '2024-11-02 14:23:15', '2024-11-03 09:15:00', '2024-11-05 16:30:00', 'livree', '12 rue de Rivoli, 75001 Paris', 'CB', 162.44),
(2, 2, '101628031772131656', '2024-11-05 10:45:30', '2024-11-06 08:00:00', '2024-11-08 14:20:00', 'livree', '45 avenue des Champs-Élysées, 75008 Paris', 'Paypal', 409.97),
(3, 3, '101628031772131657', '2024-11-08 16:12:45', '2024-11-09 10:30:00', '2024-11-11 11:15:00', 'livree', '23 rue du Faubourg Saint-Antoine, 75011 Paris', 'CB', 128.90),
(4, 4, '101628031772131658', '2024-11-10 09:15:22', '2024-11-11 08:45:00', '2024-11-13 14:00:00', 'livree', '45 rue Oberkampf, 75011 Paris', 'CB', 81.44),
(5, 5, '101628031772131659', '2024-11-12 09:30:22', '2024-11-13 08:45:00', '2024-11-15 15:00:00', 'livree', '15 rue de la Paix, 75002 Paris', 'CB', 1299.97),
(6, 6, '101628031772131660', '2024-11-15 11:20:10', '2024-11-16 09:00:00', '2024-11-18 10:30:00', 'livree', '89 avenue de Versailles, 92130 Issy-les-Moulineaux', 'Virement', 247.43),
(7, 7, '101628031772131661', '2024-11-18 14:55:33', '2024-11-19 08:30:00', '2024-11-21 16:45:00', 'livree', '34 rue du Commerce, 92100 Boulogne-Billancourt', 'CB', 243.91),
(8, 8, '101628031772131662', '2024-11-20 11:20:50', '2024-11-21 08:00:00', '2024-11-23 15:30:00', 'livree', '12 rue Pasteur, 94160 Saint-Mandé', 'CB', 155.42),
(9, 9, '101628031772131663', '2024-11-22 10:12:00', NULL, NULL, 'annulee', '12 boulevard de Strasbourg, 77000 Melun', 'CB', 204.89),
(10, 10, '101628031772131664', '2024-11-25 15:40:25', '2024-11-26 09:00:00', '2024-11-28 14:00:00', 'livree', '67 rue de la République, 78000 Versailles', 'Paypal', 294.45),
(11, 11, '101628031772131665', '2024-12-01 09:25:18', '2024-12-02 08:15:00', '2024-12-04 11:30:00', 'livree', '89 rue Nationale, 59000 Lille', 'CB', 427.33),
(12, 12, '101628031772131666', '2024-12-03 15:45:18', '2024-12-04 08:00:00', '2024-12-06 14:00:00', 'livree', '12 rue du Maréchal Foch, 69006 Lyon', 'CB', 137.43),
(13, 13, '101628031772131667', '2024-12-05 13:50:42', '2024-12-06 09:30:00', '2024-12-08 15:20:00', 'livree', '45 rue Gambetta, 62000 Arras', 'CB', 197.82),
(14, 14, '101628031772131668', '2024-12-08 10:15:30', '2024-12-09 08:00:00', '2024-12-11 14:30:00', 'livree', '78 boulevard Carnot, 80000 Amiens', 'Virement', 272.46),
(15, 15, '101628031772131669', '2024-12-10 11:55:22', '2024-12-11 08:45:00', '2024-12-13 14:00:00', 'livree', '23 rue de la Verrerie, 75004 Paris', 'CB', 184.92),
(16, 16, '101628031772131670', '2024-12-12 14:22:15', '2024-12-13 09:15:00', '2024-12-15 16:00:00', 'livree', '34 rue du Vieux-Marché-aux-Vins, 67000 Strasbourg', 'CB', 954.96),
(17, 17, '101628031772131671', '2024-12-15 09:40:50', '2024-12-16 08:30:00', '2024-12-18 11:15:00', 'livree', '56 avenue de Colmar, 68100 Mulhouse', 'Paypal', 197.82),
(18, 18, '101628031772131672', '2024-12-18 10:20:50', '2024-12-19 09:15:00', '2024-12-21 16:20:00', 'livree', '12 rue des Rosiers, 75004 Paris', 'CB', 335.00),
(19, 19, '101628031772131673', '2024-12-20 11:30:20', '2024-12-21 09:00:00', '2024-12-23 15:45:00', 'livree', '23 rue Serpenoise, 57000 Metz', 'CB', 304.94),
(20, 20, '101628031772131674', '2024-12-22 15:20:35', '2024-12-23 08:45:00', '2024-12-26 14:00:00', 'livree', '45 boulevard Victor Hugo, 51100 Reims', 'CB', 227.44),
(21, 21, '101628031772131675', '2025-01-03 10:05:45', '2025-01-04 09:30:00', '2025-01-06 16:20:00', 'livree', '67 rue de la République, 69002 Lyon', 'Paypal', 508.79),
(22, 22, '101628031772131676', '2025-01-05 10:15:30', '2025-01-06 08:00:00', '2025-01-08 16:30:00', 'livree', '12 rue du Rempart, 31000 Toulouse', 'CB', 154.92),
(23, 23, '101628031772131677', '2025-01-08 14:30:12', '2025-01-09 08:00:00', NULL, 'expediee', '34 rue Vaugelas, 74000 Annecy', 'CB', 257.92),
(24, 24, '101628031772131678', '2025-01-10 09:55:18', NULL, NULL, 'annulee', '56 rue du Temple, 75003 Paris', 'Virement', 223.95),
(25, 25, '101628031772131679', '2025-01-12 09:15:40', '2025-01-13 08:30:00', '2025-01-15 11:00:00', 'livree', '89 rue de la République, 42000 Saint-Étienne', 'CB', 164.97),
(26, 26, '101628031772131680', '2025-01-15 16:45:22', '2025-01-16 09:00:00', '2025-01-18 15:30:00', 'livree', '23 boulevard Berthelot, 63000 Clermont-Ferrand', 'Virement', 424.99),
(27, 27, '101628031772131681', '2025-01-18 10:20:15', '2025-01-19 08:15:00', '2025-01-20 12:30:00', 'livree', '12 rue du Maréchal Joffre, 35000 Rennes', 'CB', 149.98),
(28, 28, '101628031772131682', '2025-01-20 15:30:40', '2025-01-21 09:00:00', '2025-01-23 16:15:00', 'livree', '67 avenue Jean Médecin, 06000 Nice', 'Paypal', 292.42),
(29, 29, '101628031772131683', '2025-01-22 09:25:50', '2025-01-23 08:30:00', '2025-01-25 16:20:00', 'livree', '12 rue Victor Hugo, 37000 Tours', 'CB', 248.88),
(30, 30, '101628031772131684', '2025-01-25 11:40:10', NULL, NULL, 'payee', '45 avenue du Prado, 13008 Marseille', 'Paypal', 299.98),
(31, 31, '101628031772131685', '2025-02-01 09:00:25', '2025-02-02 08:30:00', '2025-02-04 14:00:00', 'livree', '56 rue du Temple, 75003 Paris', 'CB', 239.88),
(32, 32, '101628031772131686', '2025-02-03 10:20:10', '2025-02-04 08:00:00', '2025-02-06 15:30:00', 'livree', '78 rue de la Gare, 25000 Besançon', 'Virement', 189.96),
(33, 33, '101628031772131687', '2025-02-05 11:40:35', '2025-02-06 09:00:00', '2025-02-08 14:20:00', 'livree', '23 rue du Chemin Vert, 51100 Reims', 'CB', 178.41),
(34, 34, '101628031772131688', '2025-02-08 14:25:30', '2025-02-09 08:45:00', '2025-02-11 16:30:00', 'livree', '12 rue de la Mairie, 34000 Montpellier', 'Paypal', 194.95),
(35, 35, '101628031772131689', '2025-02-10 16:10:00', NULL, NULL, 'payee', '45 rue de la Liberté, 31000 Toulouse', 'CB', 154.94),
(36, 36, '101628031772131690', '2025-02-12 10:30:45', '2025-02-13 08:45:00', '2025-02-15 16:00:00', 'livree', '12 cours de l\'Intendance, 33000 Bordeaux', 'Virement', 773.93),
(37, 37, '101628031772131691', '2025-02-15 10:40:40', '2025-02-16 08:30:00', '2025-02-18 11:45:00', 'livree', '34 boulevard de Strasbourg, 75010 Paris', 'CB', 149.95),
(38, 38, '101628031772131692', '2025-02-17 14:15:20', '2025-02-18 09:15:00', '2025-02-20 15:30:00', 'livree', '89 rue Saint-Denis, 75001 Paris', 'CB', 349.96),
(39, 39, '101628031772131693', '2025-02-19 10:50:10', NULL, NULL, 'annulee', '12 place de la Bourse, 33000 Bordeaux', 'Virement', 169.95),
(40, 40, '101628031772131694', '2025-02-22 11:35:40', '2025-02-23 09:00:00', '2025-02-25 14:20:00', 'livree', '45 rue de Verdun, 47000 Agen', 'Virement', 264.42),
(41, 41, '101628031772131695', '2025-03-01 13:10:05', '2025-03-02 08:30:00', NULL, 'expediee', '12 place de la Comédie, 34000 Montpellier', 'CB', 189.98),
(42, 42, '101628031772131696', '2025-03-03 14:20:50', '2025-03-04 09:00:00', '2025-03-06 15:40:00', 'livree', '23 rue Nationale, 35000 Rennes', 'Paypal', 299.94),
(43, 43, '101628031772131697', '2025-03-06 11:30:20', '2025-03-07 08:15:00', '2025-03-09 14:10:00', 'livree', '45 rue des Halles, 44000 Nantes', 'CB', 104.94),
(44, 44, '101628031772131698', '2025-03-08 10:15:25', '2025-03-09 08:15:00', '2025-03-11 15:30:00', 'livree', '12 rue du Général Leclerc, 35000 Rennes', 'CB', 349.98),
(45, 45, '101628031772131699', '2025-03-10 14:40:00', '2025-03-11 09:30:00', '2025-03-13 11:00:00', 'livree', '34 boulevard de la Liberté, 59000 Lille', 'Paypal', 357.34),
(46, 46, '101628031772131700', '2025-03-13 10:00:00', NULL, NULL, 'payee', '12 rue du Temple, 75003 Paris', 'CB', 159.94),
(47, 47, '101628031772131701', '2025-03-15 15:20:00', NULL, NULL, 'annulee', '45 avenue des Lilas, 75019 Paris', 'Virement', 99.98),
(48, 48, '101628031772131702', '2025-03-18 11:30:00', '2025-03-19 08:30:00', NULL, 'expediee', '78 rue de Rivoli, 75004 Paris', 'CB', 119.96),
(49, 4, '101628031772131703', '2025-02-14 11:30:00', '2025-02-15 08:15:00', '2025-02-17 14:00:00', 'livree', '45 rue Oberkampf, 75011 Paris', 'CB', 112.94),
(50, 50, '101628031772131704', '2025-02-16 10:14:20', '2025-02-17 08:30:00', '2025-02-19 16:00:00', 'livree', '8 rue des fossés, 67000 Strasbourg', 'CB', 307.91),
(51, 11, '101628031772131705', '2025-02-17 13:45:00', '2025-02-18 09:30:00', '2025-02-20 12:45:00', 'livree', '89 rue Nationale, 59000 Lille', 'CB', 174.92),
(52, 47, '101628031772131706', '2025-02-18 10:55:00', '2025-02-19 08:00:00', '2025-02-21 16:30:00', 'livree', '44 avenue de Grammont, 37000 Tours', 'Paypal', 198.92),
(53, 3, '101628031772131707', '2025-02-19 14:15:00', '2025-02-20 09:30:00', '2025-02-22 10:45:00', 'livree', '23 rue du Faubourg Saint-Antoine, 75011 Paris', 'CB', 194.94),
(54, 19, '101628031772131708', '2025-02-20 12:20:00', '2025-02-21 08:45:00', '2025-02-23 15:10:00', 'livree', '23 rue Serpenoise, 57000 Metz', 'CB', 149.94),
(55, 34, '101628031772131709', '2025-02-21 16:35:00', '2025-02-22 09:15:00', '2025-02-24 11:30:00', 'livree', '12 rue de la Mairie, 34000 Montpellier', 'Paypal', 204.93),
(56, 15, '101628031772131710', '2025-02-24 10:10:00', '2025-02-25 08:00:00', '2025-02-27 15:40:00', 'livree', '14 rue des Oiseaux, 64000 Pau', 'CB', 224.93),
(57, 25, '101628031772131711', '2025-02-25 16:30:22', '2025-02-26 09:00:00', '2025-02-28 14:00:00', 'livree', '2 rue des Vergers, 25000 Besançon', 'Paypal', 178.93),
(58, 41, '101628031772131712', '2025-02-26 18:12:10', '2025-02-27 08:45:00', '2025-03-01 15:20:00', 'livree', '32 rue du Fort, 68000 Colmar', 'CB', 204.91),
(59, 42, '101628031772131713', '2025-02-28 10:05:00', '2025-03-01 09:30:00', '2025-03-03 16:15:00', 'livree', '23 rue Nationale, 35000 Rennes', 'Paypal', 199.94),
(60, 1, '101628031772131714', '2025-03-01 10:20:00', '2025-03-02 08:30:00', '2025-03-04 15:00:00', 'livree', '12 rue de Rivoli, 75001 Paris', 'CB', 198.92),
(61, 2, '101628031772131715', '2025-03-02 14:15:00', '2025-03-03 09:00:00', NULL, 'expediee', '45 avenue des Champs-Élysées, 75008 Paris', 'Paypal', 154.95),
(62, 32, '101628031772131716', '2025-03-03 11:30:00', '2025-03-04 08:30:00', '2025-03-06 14:20:00', 'livree', '78 rue de la Gare, 25000 Besançon', 'Virement', 169.95),
(63, 49, '101628031772131717', '2025-03-04 09:50:00', '2025-03-05 08:00:00', NULL, 'expediee', '18 place du Marché, 17000 La Rochelle', 'Paypal', 154.90),
(64, 38, '101628031772131718', '2025-03-04 10:40:00', '2025-03-05 09:10:00', '2025-03-07 15:55:00', 'livree', '44 rue des Fleurs, 60000 Beauvais', 'CB', 199.94),
(65, 29, '101628031772131719', '2025-03-05 17:05:00', NULL, NULL, 'annulee', '7 rue du Soleil, 73000 Chambéry', 'Virement', 0.00),
(66, 50, '101628031772131720', '2025-03-06 12:10:00', '2025-03-07 08:30:00', NULL, 'expediee', '15 rue du Commerce, 67000 Strasbourg', 'CB', 349.98),
(67, 44, '101628031772131721', '2025-03-07 10:45:00', '2025-03-08 09:15:00', '2025-03-10 16:30:00', 'livree', '12 rue du Général Leclerc, 35000 Rennes', 'CB', 194.97),
(68, 19, '101628031772131722', '2025-03-08 14:50:00', '2025-03-09 08:00:00', '2025-03-11 14:00:00', 'livree', '23 rue Serpenoise, 57000 Metz', 'CB', 178.96),
(69, 24, '101628031772131723', '2025-03-09 11:20:00', '2025-03-10 09:30:00', '2025-03-12 11:30:00', 'livree', '56 rue du Temple, 75003 Paris', 'Virement', 299.93),
(70, 26, '101628031772131724', '2025-03-10 15:30:00', '2025-03-11 08:00:00', '2025-03-13 15:40:00', 'livree', '23 boulevard Berthelot, 63000 Clermont-Ferrand', 'Virement', 335.00),
(71, 14, '101628031772131725', '2025-03-11 11:45:00', NULL, NULL, 'annulee', '55 rue Royale, 78000 Versailles', 'Virement', 0.00),
(72, 5, '101628031772131726', '2025-03-12 10:20:00', '2025-03-13 08:40:00', NULL, 'expediee', '8 rue des Remparts, 17000 La Rochelle', 'Paypal', 264.94),
(73, 22, '101628031772131727', '2025-03-13 17:00:00', NULL, NULL, 'payee', '75 rue Berlioz, 13006 Marseille', 'CB', 179.87),
(74, 45, '101628031772131728', '2025-03-14 09:10:00', '2025-03-15 09:15:00', '2025-03-17 10:30:00', 'livree', '34 boulevard de la Liberté, 59000 Lille', 'Paypal', 224.93),
(75, 10, '101628031772131729', '2025-03-15 15:40:00', '2025-03-16 08:00:00', '2025-03-18 16:20:00', 'livree', '67 rue de la République, 78000 Versailles', 'Paypal', 199.94),
(76, 30, '101628031772131730', '2025-03-16 11:20:00', NULL, NULL, 'payee', '45 avenue du Prado, 13008 Marseille', 'Paypal', 299.98),
(77, 17, '101628031772131731', '2025-03-17 14:05:00', '2025-03-18 08:30:00', '2025-03-20 14:40:00', 'livree', '56 avenue de Colmar, 68100 Mulhouse', 'Paypal', 178.96),
(78, 20, '101628031772131732', '2025-03-18 10:40:00', NULL, NULL, 'annulee', '45 boulevard Victor Hugo, 51100 Reims', 'CB', 194.97),
(79, 33, '101628031772131733', '2025-03-19 14:55:00', '2025-03-20 09:00:00', NULL, 'expediee', '56 rue des Lilas, 84000 Avignon', 'CB', 129.92),
(80, 27, '101628031772131734', '2025-03-20 13:15:00', '2025-03-21 08:45:00', '2025-03-23 15:10:00', 'livree', '3 chemin du Parc, 86000 Poitiers', 'CB', 212.99),
(81, 4, '101628031772131735', '2025-03-21 10:40:00', NULL, NULL, 'annulee', '8 rue du Temple, 75004 Paris', 'Paypal', 174.92),
(82, 18, '101628031772131736', '2025-03-22 14:25:00', '2025-03-23 09:10:00', '2025-03-25 12:45:00', 'livree', '12 rue des Rosiers, 75004 Paris', 'CB', 204.97),
(83, 46, '101628031772131737', '2025-03-23 10:00:00', '2025-03-24 08:30:00', '2025-03-26 14:00:00', 'livree', '12 rue du Temple, 75003 Paris', 'CB', 169.94),
(84, 36, '101628031772131738', '2025-03-24 11:20:00', '2025-03-25 09:00:00', '2025-03-27 16:30:00', 'livree', '12 cours de l\'Intendance, 33000 Bordeaux', 'Virement', 154.95),
(85, 38, '101628031772131739', '2025-03-25 15:40:00', '2025-03-26 08:45:00', '2025-03-28 14:15:00', 'livree', '89 rue Saint-Denis, 75001 Paris', 'CB', 209.95),
(86, 23, '101628031772131740', '2025-03-26 10:15:00', '2025-03-27 08:30:00', '2025-03-29 15:30:00', 'livree', '34 rue Vaugelas, 74000 Annecy', 'CB', 199.93),
(87, 35, '101628031772131741', '2025-03-27 13:00:00', NULL, NULL, 'annulee', '10 rue des Iris, 31000 Toulouse', 'Paypal', 182.92),
(88, 6, '101628031772131742', '2025-03-28 09:25:00', '2025-03-29 09:10:00', '2025-03-31 15:40:00', 'livree', '70 rue du Faubourg, 59000 Lille', 'CB', 289.98),
(89, 34, '101628031772131743', '2025-03-29 14:40:00', '2025-03-30 08:00:00', '2025-04-01 14:00:00', 'livree', '12 rue de la Mairie, 34000 Montpellier', 'Paypal', 184.94),
(90, 31, '101628031772131744', '2025-03-30 11:30:00', '2025-03-31 09:30:00', '2025-04-02 16:20:00', 'livree', '56 rue du Temple, 75003 Paris', 'CB', 159.94),
(91, 37, '101628031772131745', '2025-04-01 10:20:00', '2025-04-02 08:30:00', '2025-04-04 15:30:00', 'livree', '34 boulevard de Strasbourg, 75010 Paris', 'CB', 159.95),
(92, 43, '101628031772131746', '2025-04-02 14:15:00', NULL, NULL, 'annulee', '45 rue des Halles, 44000 Nantes', 'CB', 99.99),
(93, 13, '101628031772131747', '2025-04-03 16:25:00', '2025-04-04 08:55:00', '2025-04-06 15:15:00', 'livree', '3 rue des Amandiers, 33000 Bordeaux', 'Paypal', 292.98),
(94, 28, '101628031772131748', '2025-04-04 10:40:00', '2025-04-05 09:15:00', '2025-04-07 14:00:00', 'livree', '67 avenue Jean Médecin, 06000 Nice', 'Paypal', 199.94),
(95, 15, '101628031772131749', '2025-04-05 15:30:00', '2025-04-06 08:30:00', '2025-04-08 16:30:00', 'livree', '23 rue de la Verrerie, 75004 Paris', 'CB', 194.94),
(96, 49, '101628031772131750', '2025-04-06 12:10:00', '2025-04-07 09:00:00', '2025-04-09 11:45:00', 'livree', '18 place du Marché, 17000 La Rochelle', 'Paypal', 169.95),
(97, 12, '101628031772131751', '2025-04-07 15:40:00', '2025-04-08 08:30:00', '2025-04-10 16:20:00', 'livree', '12 rue du Maréchal Foch, 69006 Lyon', 'CB', 134.94),
(98, 24, '101628031772131752', '2025-04-07 10:25:00', '2025-04-08 09:00:00', '2025-04-10 13:40:00', 'livree', '7 rue des Lys, 13005 Marseille', 'CB', 264.99),
(99, 39, '101628031772131753', '2025-04-08 16:10:00', '2025-04-09 08:45:00', NULL, 'expediee', '19 rue du Vent, 35000 Rennes', 'Virement', 169.95),
(100, 50, '101628031772131754', '2025-04-09 11:30:00', '2025-04-10 09:10:00', '2025-04-12 15:40:00', 'livree', '44 avenue de Grammont, 37000 Tours', 'Paypal', 204.97);

-- --------------------------------------------------------

--
-- Structure de la table `CompositionProduit`
--

CREATE TABLE `CompositionProduit` (
  `idCompo` int NOT NULL,
  `idDeclinaison` int NOT NULL,
  `quantiteProduit` int NOT NULL
) ;

--
-- Déchargement des données de la table `CompositionProduit`
--

INSERT INTO `CompositionProduit` (`idCompo`, `idDeclinaison`, `quantiteProduit`) VALUES
(75, 25, 1),
(75, 26, 1),
(75, 60, 1),
(75, 64, 3),
(76, 24, 1),
(76, 43, 1),
(76, 63, 1),
(76, 69, 5),
(77, 27, 2),
(77, 46, 1),
(77, 66, 1),
(78, 41, 1),
(78, 43, 1),
(78, 61, 5),
(78, 74, 1),
(79, 32, 1),
(79, 35, 1),
(79, 44, 1),
(79, 54, 1),
(80, 28, 2),
(80, 29, 1),
(80, 70, 3),
(81, 46, 1),
(81, 49, 1),
(81, 51, 1),
(81, 53, 1),
(82, 33, 2),
(82, 50, 1),
(82, 62, 3),
(82, 71, 1);

-- --------------------------------------------------------

--
-- Structure de la table `DeclinaisonProduit`
--

CREATE TABLE `DeclinaisonProduit` (
  `idDeclinaison` int NOT NULL,
  `libelleDeclinaison` varchar(150) NOT NULL,
  `idProduit` int NOT NULL,
  `descDeclinaison` varchar(250) NOT NULL,
  `ficheTechnique` varchar(500) DEFAULT NULL,
  `prix` decimal(10,2) NOT NULL,
  `prixSolde` decimal(10,2) DEFAULT NULL,
  `qteStock` int NOT NULL,
  `seuilQte` int NOT NULL,
  `qualite` varchar(15) NOT NULL,
  `provenance` varchar(30) NOT NULL
) ;

--
-- Déchargement des données de la table `DeclinaisonProduit`
--

INSERT INTO `DeclinaisonProduit` (`idDeclinaison`, `libelleDeclinaison`, `idProduit`, `descDeclinaison`, `ficheTechnique`, `prix`, `prixSolde`, `qteStock`, `seuilQte`, `qualite`, `provenance`) VALUES
(1, 'Potion de mana majeure', 1, 'Régénère une grande quantité de mana (100%)', 'Contenance: 200ml, Effet: Instantané, Poids: 0.3kg', 19.99, NULL, 250, 50, 'Commun', 'Falconia'),
(2, 'Potion de mana mineure', 1, 'Régénère une petite quantité de mana (20%)', 'Contenance: 50ml, Effet: Instantané, Poids: 0.1kg', 7.99, NULL, 700, 100, 'Commun', 'Falconia'),
(3, 'Potion de Résistance à la foudre', 2, 'Résistance aux attaques électriques', 'Durée: 3 min, Résistance: +40%, Saveur: Citronnée', 9.99, NULL, 108, 20, 'Peu commun', 'Tour de Babel'),
(4, 'Potion de Résistance à la glace', 2, 'Résistance au froid et au gel', 'Durée: 3 min, Résistance: +40%, Saveur: Mentholée', 9.99, NULL, 102, 20, 'Peu commun', 'Landes aux esprits'),
(5, 'Potion de Résistance au feu', 2, 'Résistance aux chaleurs intenses', 'Durée: 3 min, Résistance: +40%, Saveur: Pimentée', 9.99, NULL, 99, 20, 'Peu commun', 'Désert des Knaarens'),
(6, 'Potion de Résistance au poison', 2, 'Immunité temporaire aux toxines', 'Durée: 5 min, Antidote inclus, Saveur: Amère', 9.99, NULL, 102, 20, 'Peu commun', 'Tour de Babel'),
(7, 'Potion de soin majeure', 3, 'Soigne les blessures graves', 'Récupération: 500 PV, Délai: 2s, Poids: 0.3kg', 19.99, NULL, 200, 50, 'Commun', 'Forêt obscure'),
(8, 'Potion de soin mineure', 3, 'Soigne les égratignures', 'Récupération: 100 PV, Délai: 2s, Poids: 0.1kg', 7.99, NULL, 600, 100, 'Commun', 'Forêt obscure'),
(9, 'Guide de l\'apprenti magicien', 4, 'Les bases théoriques de la magie', 'Pages: 120, Langue: Commun, Couverture: Cuir souple', 14.99, NULL, 55, 10, 'Commun', 'Désert des Knaarens'),
(10, 'Le Wiki des Monstres', 4, 'Encyclopédie illustrée de la faune hostile', 'Pages: 350, Illustrations: Couleur, Poids: 1.2kg', 8.99, NULL, 95, 15, 'Commun', 'Falconia'),
(11, 'Les Recettes de Flagadus', 5, 'Plats délicieux par le chef Flagadus', 'Pages: 80, Recettes: 45, Type: Cuisine traditionnelle', 12.99, NULL, 35, 10, 'Commun', 'Landes aux esprits'),
(12, 'Manuel de fabrication de potion', 5, 'Alchimie pour les débutants', 'Pages: 200, Sécurité: Sort ignifuge, Type: Alchimie', 14.99, NULL, 60, 10, 'Commun', 'Tour de Babel'),
(13, 'Baguette à étincelles', 6, 'Baguette spécialisée Feu', 'Bois: Chêne calciné, Cœur: Plume de phénix, Longueur: 30cm', 37.99, NULL, 240, 30, 'Rare', 'Désert des Knaarens'),
(14, 'Baguette de glace', 6, 'Baguette spécialisée Glace', 'Bois: Pin givré, Cœur: Éclat de cristal, Longueur: 32cm', 37.99, NULL, 240, 30, 'Rare', 'Landes aux esprits'),
(15, 'Baguette tellurique', 6, 'Baguette spécialisée Terre', 'Bois: Racine millénaire, Cœur: Diamant brut, Longueur: 28cm', 37.99, NULL, 240, 30, 'Rare', 'Tour de Babel'),
(16, 'Bâton d\'incantation novice', 7, 'Bâton simple pour débutant', 'Matériau: Bois simple, Poids: 2kg, Bonus Magie: +5', 74.99, NULL, 140, 20, 'Peu commun', 'Landes aux esprits'),
(17, 'Bâton du géomancien', 7, 'Bâton lourd incrusté de gemmes', 'Matériau: Pierre runique, Poids: 5kg, Bonus Magie: +25', 94.99, NULL, 90, 15, 'Epique', 'Tour de Babel'),
(18, 'Talisman du petit magicien', 8, 'Idéal pour les premiers sorts', 'Matériau: Cuivre, Effet: +2 Intelligence, Poids: 50g', 19.99, NULL, 130, 20, 'Peu commun', 'Falconia'),
(19, 'Tome divin de Lothric', 9, 'Miracles de chevaliers, édition rare', 'Reliure: Or sacré, Contenu: 5 Miracles, Poids: 3kg', 69.99, NULL, 35, 5, 'Legendaire', 'Landes aux esprits'),
(20, 'Tome de pyromancie de Carthus', 10, 'Pyromancie de combat agressive', 'Reliure: Peau de démon, Contenu: 4 Sorts, Résistance au feu: Oui', 49.99, NULL, 30, 5, 'Legendaire', 'Désert des Knaarens'),
(21, 'Parchemin cristallin', 11, 'Magie de cristal pure', 'Usage: Unique, Élément: Magie pure, Niveau requis: 20', 24.99, NULL, 60, 10, 'Rare', 'Landes aux esprits'),
(22, 'Flèche magique (Unité)', 12, 'Flèche imprégnée de magie', 'Pointe: Acier enchanté, Dégâts magiques: 15, Portée: +10%', 1.99, NULL, 1000, 100, 'Peu commun', 'Falconia'),
(23, 'Projection de lumière', 13, 'Crée une orbe lumineuse', 'Durée: 10 min, Rayon: 15m, Couleur: Blanche', 19.99, NULL, 50, 10, 'Peu commun', 'Landes aux esprits'),
(24, 'Gel instantané', 14, 'Congèle la cible sur place', 'Dégâts: 40 Froid, Effet: Ralentissement 50%, Portée: 10m', 34.99, NULL, 50, 10, 'Rare', 'Landes aux esprits'),
(25, 'Boule de feu', 15, 'Le classique : lance une boule de feu', 'Dégâts: 50 Feu, Zone: 2m, Incantation: 1.5s', 19.99, NULL, 100, 20, 'Peu commun', 'Désert des Knaarens'),
(26, 'Chaos bouillonnant', 15, 'Magie du chaos instable', 'Dégâts: 120 Feu/Ténèbres, Zone: 4m, Risque: Explosion différée', 99.99, NULL, 5, 2, 'Legendaire', 'Désert des Knaarens'),
(27, 'Graviers', 16, 'Projette des rochers sur l\'ennemi', 'Dégâts: 30 Physique, Coups: 3 projectiles, Stabilité: -10', 19.99, NULL, 100, 20, 'Peu commun', 'Tour de Babel'),
(28, 'Guérir', 17, 'Soin de base des clercs', 'Restauration: 300 PV, Coût Mana: 40, Incantation: 2s', 14.99, NULL, 300, 50, 'Peu commun', 'Forêt obscure'),
(29, 'Lumière apaisante du soleil', 17, 'Soin de zone puissant', 'Restauration: 800 PV (Groupe), Rayon: 20m, Incantation: 4s', 54.49, NULL, 100, 20, 'Epique', 'Désert des Knaarens'),
(30, 'Lance de foudre', 18, 'Javelot d\'électricité pure', 'Dégâts: 80 Foudre, Portée: 25m, Bonus: Dégâts x2 si cible dans l\'eau', 32.49, NULL, 150, 25, 'Epique', 'Landes aux esprits'),
(31, 'Arme bénie', 19, 'Ajoute des dégâts sacrés', 'Durée: 60s, Effet: +30 Dégâts Sacrés + Regen PV lente', 19.99, NULL, 250, 40, 'Rare', 'Forêt obscure'),
(32, 'Serment sacré', 20, 'Augmente l\'attaque et la défense du groupe', 'Durée: 90s, Attaque: +10%, Défense: +10%, Cible: Alliés proches', 34.99, NULL, 180, 30, 'Rare', 'Forêt obscure'),
(33, 'Dague de voleur', 21, 'Parfaite pour les attaques sournoises', 'Dégâts: 15, Critique: 130%, Poids: 0.5kg, Vitesse: Très rapide', 15.99, NULL, 80, 15, 'Commun', 'Falconia'),
(34, 'Épée courte', 22, 'Légère et maniable', 'Dégâts: 25, Poids: 2kg, Matériau: Acier, Type: Tranchant', 20.49, NULL, 70, 15, 'Commun', 'Falconia'),
(35, 'Épée à deux mains', 22, 'Lourde, nécessite de la force', 'Dégâts: 60, Poids: 8kg, Matériau: Acier lourd, Type: Tranchant', 34.99, NULL, 30, 10, 'Commun', 'Falconia'),
(36, 'Hache de guerre', 23, 'Simple mais efficace', 'Dégâts: 35, Poids: 4kg, Bonus: Perce-armure faible', 12.99, NULL, 60, 15, 'Commun', 'Falconia'),
(37, 'Marteau de guerre', 24, 'Écrase les ennemis avec facilité', 'Dégâts: 40 Contondant, Poids: 6kg, Bonus: Brise garde', 34.99, NULL, 35, 10, 'Commun', 'Falconia'),
(38, 'Lance', 25, 'Bonne allonge, parfaite en formation', 'Dégâts: 30 Estoc, Portée: Longue, Poids: 4kg', 17.49, NULL, 40, 10, 'Commun', 'Falconia'),
(39, 'Arc long', 26, 'Nécessite de la dextérité', 'Dégâts: 35, Portée: 50m, Cadence: Moyenne, Poids: 1.5kg', 19.99, NULL, 60, 15, 'Commun', 'Falconia'),
(40, 'Dragon Slayer', 27, 'L\'épée noire capable de tuer des apôtres', 'Dégâts: 250, Poids: 180kg, Matériau: Fer noir, Malédiction: Attire les esprits', 499.99, NULL, 1, 0, 'Legendaire', 'Falconia'),
(41, 'Bottes légèrement enchantées', 28, 'Confortables et imperméables', 'Défense: 5, Poids: 1kg, Enchantement: Marche silencieuse', 42.49, NULL, 20, 5, 'Peu commun', 'Falconia'),
(42, 'Sort de cristal en bouteille', 29, 'Explose en éclats de cristal', 'Dégâts: 60 Zone, Type: Jetable, Rayon: 3m', 25.00, NULL, 200, 50, 'Peu commun', 'Landes aux esprits'),
(43, 'Robe de sorcier pédestre', 30, 'Pour les mages voyageurs', 'Défense Physique: 10, Défense Magique: 30, Poids: 2kg', 134.00, NULL, 75, 10, 'Rare', 'Falconia'),
(44, 'Bouclier en bois', 31, 'Léger et maniable', 'Stabilité: 40, Absorption Physique: 80%, Poids: 3kg', 15.00, NULL, 50, 10, 'Commun', 'Falconia'),
(45, 'Écu du dragon', 31, 'Résiste au feu', 'Stabilité: 65, Résistance Feu: 85%, Poids: 5kg', 120.00, NULL, 5, 2, 'Epique', 'Désert des Knaarens'),
(46, 'Grand Pavois', 31, 'Protection lourde et intégrale', 'Stabilité: 80, Absorption Physique: 100%, Poids: 12kg', 60.00, NULL, 15, 5, 'Rare', 'Tour de Babel'),
(47, 'Anneau de vie', 32, 'Augmente légèrement la vitalité', 'Bonus PV: +10%, Poids: 0.1kg, Matériau: Or', 250.00, NULL, 10, 2, 'Rare', 'Falconia'),
(48, 'Anneau de pierre', 32, 'Augmente l\'équilibre', 'Bonus Stabilité: +15, Poids: 0.5kg, Matériau: Granit', 200.00, NULL, 12, 2, 'Rare', 'Tour de Babel'),
(49, 'Heaume de chevalier', 33, 'Casque en acier standard', 'Défense: 15, Poids: 4kg, Visibilité: Moyenne', 45.00, NULL, 30, 5, 'Commun', 'Falconia'),
(50, 'Capuche de voleur', 33, 'Légère et discrète', 'Défense: 5, Poids: 1kg, Bonus: Discrétion', 25.00, NULL, 40, 5, 'Commun', 'Forêt obscure'),
(51, 'Plastron en acier', 34, 'Protection solide contre les lames', 'Défense: 45, Poids: 15kg, Mobilité: Réduite', 150.00, NULL, 20, 5, 'Commun', 'Falconia'),
(52, 'Gilet de cuir clouté', 34, 'Bon compromis mobilité/défense', 'Défense: 25, Poids: 6kg, Mobilité: Bonne', 80.00, NULL, 35, 8, 'Commun', 'Forêt obscure'),
(53, 'Gantelets de fer', 35, 'Pour frapper aussi dur que l\'on encaisse', 'Défense: 10, Poids: 3kg, Dégâts à mains nues: +5', 35.00, NULL, 25, 5, 'Commun', 'Falconia'),
(54, 'Grèves de soldat', 36, 'Standard pour l\'armée', 'Défense: 12, Poids: 5kg, Matériau: Fer', 40.00, NULL, 30, 5, 'Commun', 'Falconia'),
(55, 'Amulette solaire', 37, 'Brille faiblement dans le noir', 'Effet: Illumination 2m, Poids: 0.1kg', 180.00, NULL, 8, 2, 'Rare', 'Désert des Knaarens'),
(56, 'Couteau de lancer (x10)', 38, 'Lot de couteaux équilibrés', 'Dégâts: 10/u, Portée: 15m, Quantité: 10', 15.00, NULL, 100, 20, 'Commun', 'Falconia'),
(57, 'Kunaï (x10)', 38, 'Arme de jet orientale', 'Dégâts: 8/u, Portée: 20m, Quantité: 10, Vitesse: Rapide', 18.00, NULL, 80, 20, 'Commun', 'Forêt obscure'),
(58, 'Bombe incendiaire noire', 39, 'Explosion de feu intense', 'Dégâts: 150 Feu, Zone: 4m, Délai: 2s', 12.00, NULL, 200, 30, 'Peu commun', 'Falconia'),
(59, 'Bombe de foudre', 39, 'Libère une décharge électrique', 'Dégâts: 120 Foudre, Zone: 3m, Effet: Paralysie', 15.00, NULL, 150, 30, 'Rare', 'Tour de Babel'),
(60, 'Torche inépuisable', 40, 'Brule éternellement sans se consumer', 'Durée: Infinie, Luminosité: Forte, Poids: 1kg', 85.00, NULL, 20, 5, 'Rare', 'Tour de Babel'),
(61, 'Torche simple', 40, 'Brule pendant 1 heure', 'Durée: 1h, Luminosité: Moyenne, Poids: 0.5kg', 2.00, NULL, 500, 50, 'Commun', 'Falconia'),
(62, 'Crochets de serrure', 41, 'Fragiles mais efficaces', 'Usage: Déverrouillage, Durabilité: 10 utilisations', 10.00, NULL, 100, 20, 'Commun', 'Falconia'),
(63, 'Longue-vue en laiton', 42, 'Grossissement x10', 'Zoom: x10, Matériau: Laiton/Verre, Poids: 0.8kg', 45.00, NULL, 30, 5, 'Peu commun', 'Falconia'),
(64, 'Pain elfique', 43, 'Une bouchée rassasie un homme', 'Valeur nutritionnelle: Haute, Conservation: 1 an, Poids: 0.1kg', 30.00, NULL, 50, 10, 'Rare', 'Forêt obscure'),
(65, 'Ration de voyage', 43, 'Viande séchée et pain dur', 'Valeur nutritionnelle: Moyenne, Conservation: 3 mois', 5.00, NULL, 200, 50, 'Commun', 'Falconia'),
(66, 'Éclat de Titanite', 44, 'Renforce les armes', 'Usage: Forge +3, Rareté: Élevée', 80.00, NULL, 40, 10, 'Rare', 'Tour de Babel'),
(67, 'Acier trempé', 44, 'Métal de qualité supérieure', 'Usage: Forge de base, Poids: 1kg/lingot', 20.00, NULL, 100, 20, 'Commun', 'Falconia'),
(68, 'Rubis sanglant', 45, 'Augmente les dégâts de feu', 'Infusion: Feu +10%, Pureté: Parfaite, Poids: 0.05kg', 300.00, NULL, 5, 1, 'Epique', 'Désert des Knaarens'),
(69, 'Fleur verte', 46, 'Accélère la récupération d\'endurance', 'Effet: Regen Endurance +20%, Durée: 60s, Goût: Herbeux', 8.00, NULL, 150, 20, 'Commun', 'Forêt obscure'),
(70, 'Mousse violette', 46, 'Soigne le poison', 'Effet: Cure Poison, Réduit jauge toxique, Goût: Infecte', 12.00, NULL, 100, 20, 'Peu commun', 'Forêt obscure'),
(71, 'Cape de voyage', 47, 'Protège de la pluie', 'Matériau: Laine huilée, Résistance froid: +5, Poids: 1.5kg', 20.00, NULL, 60, 10, 'Commun', 'Falconia'),
(72, 'Luth', 48, 'Instrument à cordes classique', 'Cordes: 6, Bois: Érable, Sonorité: Claire, Poids: 2kg', 65.00, NULL, 15, 2, 'Peu commun', 'Falconia'),
(73, 'Crâne maudit', 49, 'Attire les esprits', 'Effet: Leurre spectral, Durée: 15s, Poids: 0.5kg', 40.00, NULL, 20, 5, 'Rare', 'Landes aux esprits'),
(74, 'Carte du royaume', 50, 'Carte détaillée de Falconia et alentours', 'Format: A2, Papier: Parchemin, Détail: Élevé', 10.00, NULL, 100, 10, 'Commun', 'Falconia'),
(75, 'Kit du Pyromancien', 51, 'Équipement essentiel pour maîtriser la pyromancie.', 'Contient : 1x Sort de Boule de feu, 1x Sort de Chaos Bouillonnant, 1x Torche Inépuisable, 3x Pain Elfique. Avantage : Spécialisé en dégâts de zone et lumière illimitée.', 129.95, NULL, 50, 10, 'Mixte', 'Multiples'),
(76, 'Kit du Cryomage', 51, 'Maîtrisez le froid et la glace.', 'Contient : 1x Sort de Gel Instantané, 5x Fleurs Vertes, 1x Robe de Sorcier Pédestre, 1x Longue-vue. Avantage : Contrôle des foules et endurance accrue pour l\'exploration.', 149.90, NULL, 40, 8, 'Mixte', 'Multiples'),
(77, 'Kit du Mage Tellurique', 51, 'Force brute et protection terrestre.', 'Contient : 2x Sort de Graviers, 1x Éclat de Titanite, 1x Grand Pavois. Avantage : Défense physique très élevée et capacité d\'amélioration d\'arme.', 118.50, NULL, 30, 5, 'Mixte', 'Multiples'),
(78, 'Kit du Mage Vagabond', 51, 'L\'équipement parfait pour les voyages prolongés.', 'Contient : 1x Robe de Sorcier Pédestre, 1x Bottes Légèrement Enchantées, 5x Torches Simples, 1x Carte du Royaume. Avantage : Optimisé pour le long voyage et l\'orientation.', 199.99, 179.99, 60, 10, 'Mixte', 'Multiples'),
(79, 'Kit du Mage de Guerre', 51, 'Quand la magie et la force se rencontrent.', 'Contient : 1x Serment Sacré, 1x Épée à Deux Mains, 1x Grèves de Soldat, 1x Bouclier en Bois. Avantage : Équilibre entre magie de soutien et combat au corps-à-corps lourd.', 179.90, NULL, 25, 5, 'Mixte', 'Multiples'),
(80, 'Kit du Mage aux Petits Soins', 51, 'L\'essentiel pour un soigneur divin.', 'Contient : 2x Miracle Guérir, 1x Miracle Lumière Apaisante du Soleil, 3x Mousse Violette. Avantage : Maximise la capacité de soin en zone et la gestion du poison.', 149.00, NULL, 70, 15, 'Mixte', 'Multiples'),
(81, 'Kit du Gardien', 51, 'Armure lourde complète pour tanker.', 'Contient : 1x Plastron en Acier, 1x Grand Pavois, 1x Heaume de Chevalier, 1x Gantelets de Fer. Avantage : Armure complète pour une absorption maximale des dégâts.', 239.99, 219.99, 15, 3, 'Mixte', 'Multiples'),
(82, 'Kit de l\'Ombre', 51, 'L\'équipement discret pour le voleur professionnel.', 'Contient : 2x Dagues de Voleur, 1x Capuche de Voleur, 3x Crochets de Serrure, 1x Cape de Voyage. Avantage : Ensemble parfait pour la discrétion, l\'ouverture de serrures et le combat rapide.', 89.90, NULL, 80, 20, 'Mixte', 'Multiples');

-- --------------------------------------------------------

--
-- Structure de la table `LigneCommande`
--

CREATE TABLE `LigneCommande` (
  `idCommande` int NOT NULL,
  `idDeclinaison` int NOT NULL,
  `quantite` int NOT NULL,
  `prixTotal` decimal(10,2) DEFAULT NULL
) ;

--
-- Déchargement des données de la table `LigneCommande`
--

INSERT INTO `LigneCommande` (`idCommande`, `idDeclinaison`, `quantite`, `prixTotal`) VALUES
(1, 1, 2, 39.98),
(1, 8, 3, 35.97),
(1, 10, 1, 14.99),
(1, 13, 1, 37.99),
(1, 31, 1, 14.99),
(1, 79, 3, 6.00),
(2, 7, 4, 79.96),
(2, 52, 1, 219.99),
(2, 55, 1, 34.99),
(2, 62, 1, 120.00),
(2, 82, 3, 60.00),
(3, 1, 3, 59.97),
(3, 3, 2, 19.98),
(3, 7, 2, 39.98),
(3, 12, 1, 14.99),
(3, 82, 5, 40.00),
(4, 2, 4, 31.96),
(4, 8, 2, 23.98),
(4, 51, 1, 15.99),
(4, 79, 5, 10.00),
(4, 81, 4, 9.96),
(5, 20, 1, 69.99),
(5, 59, 1, 499.99),
(5, 62, 1, 120.00),
(5, 66, 1, 250.00),
(5, 71, 1, 180.00),
(5, 82, 1, 300.00),
(6, 41, 3, 29.97),
(6, 64, 1, 49.99),
(6, 75, 1, 10.00),
(6, 76, 1, 45.00),
(6, 77, 1, 99.99),
(6, 79, 6, 12.00),
(7, 5, 3, 29.97),
(7, 21, 1, 49.99),
(7, 33, 2, 39.98),
(7, 75, 1, 129.95),
(7, 78, 1, 85.00),
(8, 7, 2, 39.98),
(8, 11, 1, 8.99),
(8, 52, 2, 37.50),
(8, 54, 1, 53.96),
(8, 61, 1, 15.00),
(9, 32, 1, 34.99),
(9, 75, 1, 149.90),
(9, 76, 1, 45.00),
(9, 82, 2, 24.00),
(10, 1, 2, 39.98),
(10, 17, 1, 14.99),
(10, 32, 2, 69.98),
(10, 34, 1, 99.99),
(10, 38, 2, 64.98),
(10, 79, 5, 10.00),
(11, 1, 5, 99.95),
(11, 19, 1, 19.99),
(11, 20, 1, 69.99),
(11, 60, 1, 42.49),
(11, 61, 1, 134.00),
(11, 75, 1, 149.90),
(12, 8, 2, 23.98),
(12, 51, 2, 31.98),
(12, 54, 1, 53.96),
(12, 68, 1, 25.00),
(12, 80, 3, 30.00),
(13, 52, 1, 89.90),
(13, 54, 2, 24.00),
(13, 72, 2, 30.00),
(13, 73, 2, 36.00),
(13, 82, 3, 24.00),
(14, 7, 3, 59.97),
(14, 55, 1, 34.99),
(14, 56, 1, 49.99),
(14, 57, 1, 34.99),
(14, 69, 1, 150.00),
(14, 82, 2, 160.00),
(15, 1, 3, 59.97),
(15, 5, 2, 19.98),
(15, 13, 1, 37.99),
(15, 33, 3, 59.97),
(15, 74, 3, 36.00),
(16, 20, 1, 69.99),
(16, 21, 1, 49.99),
(16, 40, 2, 69.98),
(16, 62, 1, 120.00),
(16, 66, 1, 250.00),
(16, 71, 1, 180.00),
(16, 78, 1, 85.00),
(16, 82, 1, 300.00),
(17, 1, 5, 99.95),
(17, 3, 2, 19.98),
(17, 7, 3, 59.97),
(17, 70, 3, 36.00),
(17, 82, 5, 40.00),
(18, 7, 2, 39.98),
(18, 63, 1, 60.00),
(18, 65, 1, 50.00),
(18, 67, 1, 45.00),
(18, 69, 1, 150.00),
(18, 70, 1, 35.00),
(19, 48, 1, 179.99),
(19, 75, 1, 10.00),
(19, 77, 1, 99.99),
(19, 79, 10, 20.00),
(19, 81, 5, 12.49),
(20, 23, 50, 99.50),
(20, 58, 1, 19.99),
(20, 68, 1, 25.00),
(20, 72, 3, 45.00),
(20, 73, 2, 36.00),
(20, 82, 3, 24.00),
(21, 1, 4, 79.96),
(21, 17, 1, 14.99),
(21, 28, 5, 74.95),
(21, 40, 1, 34.99),
(21, 48, 1, 179.90),
(21, 61, 1, 134.00),
(22, 1, 3, 59.97),
(22, 7, 2, 39.98),
(22, 52, 1, 20.49),
(22, 61, 1, 15.00),
(22, 79, 4, 8.00),
(22, 81, 3, 7.49),
(23, 7, 2, 39.98),
(23, 28, 3, 44.97),
(23, 37, 1, 54.49),
(23, 48, 1, 149.00),
(23, 82, 2, 24.00),
(24, 1, 2, 39.98),
(24, 32, 1, 34.99),
(24, 75, 1, 149.90),
(24, 82, 3, 24.00),
(25, 8, 3, 35.97),
(25, 72, 2, 30.00),
(25, 74, 4, 48.00),
(25, 75, 3, 45.00),
(25, 79, 3, 6.00),
(26, 52, 1, 20.00),
(26, 54, 1, 53.96),
(26, 79, 4, 8.00),
(26, 80, 2, 160.00),
(26, 82, 5, 200.00),
(27, 1, 3, 59.97),
(27, 7, 2, 39.98),
(27, 52, 1, 18.75),
(27, 61, 1, 15.00),
(27, 81, 4, 16.28),
(28, 1, 4, 79.96),
(28, 3, 3, 29.97),
(28, 17, 1, 14.99),
(28, 22, 1, 22.49),
(28, 38, 3, 97.47),
(28, 75, 3, 45.00),
(29, 1, 3, 59.97),
(29, 5, 2, 19.98),
(29, 74, 3, 36.00),
(29, 75, 1, 129.95),
(29, 79, 2, 4.00),
(30, 7, 2, 39.98),
(30, 66, 1, 250.00),
(30, 82, 1, 10.00),
(31, 1, 12, 239.88),
(32, 7, 3, 59.97),
(32, 54, 1, 53.96),
(32, 56, 1, 49.99),
(32, 61, 1, 15.00),
(32, 82, 2, 16.00),
(33, 8, 4, 47.96),
(33, 21, 10, 80.00),
(33, 79, 2, 4.00),
(33, 82, 5, 60.00),
(34, 8, 2, 23.98),
(34, 32, 1, 34.99),
(34, 75, 1, 149.90),
(34, 79, 5, 10.00),
(35, 1, 5, 99.95),
(35, 7, 2, 39.98),
(35, 79, 8, 16.00),
(36, 7, 4, 79.96),
(36, 20, 1, 69.99),
(36, 21, 1, 49.99),
(36, 52, 1, 219.99),
(36, 62, 1, 120.00),
(36, 66, 1, 250.00),
(37, 7, 2, 39.98),
(37, 8, 1, 11.99),
(37, 54, 1, 53.96),
(37, 57, 1, 34.99),
(37, 79, 5, 10.00),
(38, 1, 5, 99.95),
(38, 21, 1, 49.99),
(38, 33, 5, 99.95),
(38, 34, 1, 99.99),
(39, 64, 1, 49.99),
(39, 77, 1, 99.99),
(39, 79, 10, 20.00),
(40, 41, 3, 29.97),
(40, 64, 1, 49.99),
(40, 75, 1, 10.00),
(40, 76, 1, 45.00),
(40, 77, 1, 99.99),
(40, 79, 8, 16.00),
(41, 1, 4, 79.96),
(41, 7, 3, 59.97),
(41, 52, 1, 18.75),
(41, 61, 1, 15.00),
(41, 79, 8, 16.00),
(42, 1, 4, 79.96),
(42, 22, 1, 22.49),
(42, 31, 2, 29.98),
(42, 48, 1, 179.90),
(42, 82, 2, 16.00),
(43, 1, 3, 59.97),
(43, 8, 2, 23.98),
(43, 51, 1, 15.99),
(43, 79, 4, 5.00),
(44, 7, 3, 59.97),
(44, 40, 1, 34.99),
(44, 62, 1, 120.00),
(44, 63, 1, 60.00),
(44, 65, 1, 50.00),
(44, 67, 1, 45.00),
(45, 23, 50, 99.50),
(45, 48, 1, 179.90),
(45, 58, 1, 19.99),
(45, 72, 3, 45.00),
(45, 82, 2, 16.00),
(46, 1, 2, 39.98),
(46, 7, 3, 59.97),
(46, 55, 1, 34.99),
(46, 61, 1, 15.00),
(46, 82, 2, 10.00),
(47, 1, 5, 99.95),
(47, 82, 1, 10.00),
(48, 1, 3, 59.97),
(48, 7, 3, 59.97),
(49, 2, 4, 31.96),
(49, 8, 2, 23.98),
(49, 41, 3, 29.97),
(49, 79, 5, 10.00),
(49, 82, 1, 17.03),
(50, 1, 3, 59.97),
(50, 21, 1, 49.99),
(50, 33, 3, 59.97),
(50, 34, 1, 99.99),
(50, 66, 1, 250.00),
(51, 1, 3, 59.97),
(51, 7, 2, 39.98),
(51, 48, 1, 179.90),
(52, 1, 3, 59.97),
(52, 7, 2, 39.98),
(52, 52, 2, 37.50),
(52, 54, 1, 53.96),
(52, 61, 1, 15.00),
(53, 1, 3, 59.97),
(53, 3, 2, 19.98),
(53, 7, 2, 39.98),
(53, 12, 1, 14.99),
(53, 21, 2, 20.00),
(53, 82, 5, 40.00),
(54, 1, 5, 99.95),
(54, 8, 3, 35.97),
(54, 79, 7, 14.00),
(55, 7, 2, 39.98),
(55, 32, 1, 34.99),
(55, 75, 1, 149.90),
(56, 1, 3, 59.97),
(56, 5, 4, 39.96),
(56, 12, 1, 14.99),
(56, 21, 1, 49.99),
(56, 33, 3, 59.97),
(57, 1, 3, 59.97),
(57, 7, 3, 59.97),
(57, 52, 1, 18.75),
(57, 61, 1, 15.00),
(57, 82, 1, 25.24),
(58, 1, 5, 99.95),
(58, 7, 3, 59.97),
(58, 8, 2, 23.98),
(58, 79, 5, 10.00),
(58, 81, 4, 16.28),
(59, 1, 5, 99.95),
(59, 7, 2, 39.98),
(59, 22, 1, 22.49),
(59, 31, 2, 29.98),
(59, 82, 2, 16.00),
(60, 1, 5, 99.95),
(60, 7, 2, 39.98),
(60, 13, 1, 37.99),
(60, 31, 1, 14.99),
(60, 79, 3, 6.00),
(61, 7, 4, 79.96),
(61, 55, 1, 34.99),
(61, 82, 2, 40.00),
(62, 7, 3, 59.97),
(62, 54, 1, 53.96),
(62, 56, 1, 49.99),
(62, 79, 3, 6.03),
(63, 2, 4, 31.96),
(63, 8, 3, 35.97),
(63, 11, 1, 8.99),
(63, 52, 2, 37.50),
(63, 79, 5, 10.00),
(64, 7, 3, 59.97),
(64, 21, 1, 49.99),
(64, 33, 2, 39.98),
(64, 79, 9, 17.99),
(64, 82, 4, 32.00),
(66, 7, 3, 59.97),
(66, 40, 1, 34.99),
(66, 62, 1, 120.00),
(66, 63, 1, 60.00),
(66, 65, 1, 50.00),
(66, 67, 1, 45.00),
(67, 7, 3, 59.97),
(67, 55, 1, 34.99),
(67, 56, 1, 49.99),
(67, 57, 1, 34.99),
(67, 79, 8, 16.00),
(68, 64, 1, 49.99),
(68, 76, 1, 45.00),
(68, 77, 1, 99.99),
(68, 79, 5, 10.00),
(69, 1, 2, 39.98),
(69, 7, 3, 59.97),
(69, 32, 1, 34.99),
(69, 75, 1, 149.90),
(69, 82, 3, 24.00),
(70, 1, 2, 39.98),
(70, 65, 1, 50.00),
(70, 66, 1, 250.00),
(70, 67, 1, 45.00),
(70, 69, 1, 150.00),
(70, 70, 1, 35.00),
(72, 7, 3, 59.97),
(72, 55, 1, 34.99),
(72, 56, 1, 49.99),
(72, 69, 1, 150.00),
(73, 1, 4, 79.96),
(73, 2, 4, 31.96),
(73, 7, 3, 59.97),
(73, 79, 4, 8.00),
(74, 7, 2, 39.98),
(74, 48, 1, 179.90),
(74, 58, 1, 19.99),
(74, 82, 2, 16.00),
(75, 1, 2, 39.98),
(75, 32, 2, 69.98),
(75, 34, 1, 99.99),
(75, 79, 5, 10.00),
(76, 7, 2, 39.98),
(76, 66, 1, 250.00),
(76, 82, 1, 10.00),
(77, 1, 5, 99.95),
(77, 3, 2, 19.98),
(77, 7, 3, 59.97),
(78, 23, 50, 99.50),
(78, 58, 1, 19.99),
(78, 72, 3, 45.00),
(78, 73, 2, 36.00),
(78, 82, 2, 16.00),
(79, 2, 4, 31.96),
(79, 8, 3, 35.97),
(79, 11, 1, 8.99),
(79, 51, 1, 15.99),
(79, 79, 5, 10.00),
(80, 66, 1, 250.00),
(80, 79, 8, 15.99),
(81, 1, 5, 99.95),
(81, 7, 2, 39.98),
(81, 10, 1, 14.99),
(81, 20, 1, 69.99),
(81, 82, 2, 16.00),
(82, 7, 2, 39.98),
(82, 67, 1, 45.00),
(82, 69, 1, 150.00),
(82, 79, 5, 10.00),
(83, 1, 2, 39.98),
(83, 7, 3, 59.97),
(83, 55, 1, 34.99),
(83, 61, 1, 15.00),
(83, 82, 2, 10.00),
(84, 1, 5, 99.95),
(84, 7, 2, 39.98),
(84, 79, 8, 16.00),
(85, 1, 3, 59.97),
(85, 21, 1, 49.99),
(85, 33, 5, 99.95),
(86, 7, 3, 59.97),
(86, 21, 1, 49.99),
(86, 33, 3, 59.97),
(86, 82, 4, 32.00),
(87, 1, 3, 59.97),
(87, 2, 4, 31.96),
(87, 8, 3, 35.97),
(87, 11, 1, 8.99),
(87, 81, 3, 9.96),
(88, 41, 3, 29.97),
(88, 64, 1, 49.99),
(88, 75, 1, 10.00),
(88, 76, 1, 45.00),
(88, 77, 1, 99.99),
(88, 79, 6, 12.00),
(89, 7, 2, 39.98),
(89, 75, 1, 149.90),
(89, 79, 5, 10.00),
(90, 1, 8, 159.94),
(91, 7, 2, 39.98),
(91, 8, 1, 11.99),
(91, 54, 1, 53.96),
(91, 57, 1, 34.99),
(91, 79, 5, 10.00),
(92, 1, 5, 99.95),
(93, 63, 1, 60.00),
(93, 64, 1, 49.99),
(93, 69, 1, 150.00),
(93, 77, 1, 99.99),
(94, 1, 4, 79.96),
(94, 38, 3, 97.47),
(94, 75, 3, 45.00),
(94, 79, 5, 10.00),
(95, 1, 3, 59.97),
(95, 5, 2, 19.98),
(95, 13, 1, 37.99),
(95, 33, 3, 59.97),
(95, 74, 3, 36.00),
(96, 2, 4, 31.96),
(96, 8, 3, 35.97),
(96, 11, 1, 8.99),
(96, 52, 2, 37.50),
(96, 79, 5, 10.00),
(97, 7, 3, 59.97),
(97, 11, 1, 8.99),
(97, 51, 2, 31.98),
(97, 54, 1, 53.96),
(98, 1, 3, 59.97),
(98, 34, 1, 99.99),
(98, 69, 1, 150.00),
(99, 64, 1, 49.99),
(99, 77, 1, 99.99),
(99, 79, 10, 20.00),
(100, 1, 3, 59.97),
(100, 7, 2, 39.98),
(100, 52, 2, 37.50),
(100, 54, 1, 53.96),
(100, 61, 1, 15.00);

-- --------------------------------------------------------

--
-- Structure de la table `PhotoAvis`
--

CREATE TABLE `PhotoAvis` (
  `idPhoto` int NOT NULL,
  `idAvis` int NOT NULL,
  `url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `PhotoProduit`
--

CREATE TABLE `PhotoProduit` (
  `idPhoto` int NOT NULL,
  `url` varchar(255) NOT NULL,
  `idDeclinaison` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Produit`
--

CREATE TABLE `Produit` (
  `idProduit` int NOT NULL,
  `libelle` varchar(150) NOT NULL,
  `description` varchar(500) NOT NULL,
  `moyenneAvis` decimal(3,2) DEFAULT NULL
) ;

--
-- Déchargement des données de la table `Produit`
--

INSERT INTO `Produit` (`idProduit`, `libelle`, `description`, `moyenneAvis`) VALUES
(1, 'Potion de mana', 'Fiole contenant un liquide bleu lumineux permettant de restaurer la magie.', NULL),
(2, 'Potion de résistance', 'Potions alchimiques offrant une protection temporaire contre les éléments.', NULL),
(3, 'Potion de soin', 'Le meilleur ami de l\'aventurier, referme les plaies instantanément.', NULL),
(4, 'Manuel d\'informations', 'Livres et guides pour comprendre le monde qui vous entoure.', NULL),
(5, 'Manuel de recettes', 'Ouvrages dédiés à l\'artisanat et la cuisine.', NULL),
(6, 'Baguette magique', 'Catalyseur indispensable pour lancer des sorts avec précision.', NULL),
(7, 'Bâton magique', 'Arme à deux mains pour sorciers puissants.', NULL),
(8, 'Talisman', 'Petit accessoire magique renforçant les capacités.', NULL),
(9, 'Tome divin', 'Recueils sacrés contenant des miracles anciens.', NULL),
(10, 'Tome de pyromancie', 'Savoirs oubliés des maîtres du feu.', NULL),
(11, 'Parchemin de sorcellerie', 'Sorts à usage unique ou à apprendre pour les érudits.', NULL),
(12, 'Flèches magiques', 'Munitions enchantées pour archers.', NULL),
(13, 'Parchemin utilitaire', 'Sorts pratiques pour l\'exploration.', NULL),
(14, 'Parchemin de glace', 'Sorts offensifs basés sur le froid.', NULL),
(15, 'Parchemin de feu', 'Sorts destructeurs basés sur la pyromancie.', NULL),
(16, 'Parchemin de terre', 'Géomancie et manipulation du sol.', NULL),
(17, 'Miracle de soin', 'Incantations sacrées de restauration.', NULL),
(18, 'Miracle offensif', 'La colère des dieux sous forme d\'attaques.', NULL),
(19, 'Enchantement d\'arme', 'Améliore temporairement votre équipement.', NULL),
(20, 'Buff magique', 'Amélioration des statistiques personnelles.', NULL),
(21, 'Dague', 'Lame courte, rapide et facile à dissimuler.', NULL),
(22, 'Épée', 'L\'arme la plus polyvalente.', NULL),
(23, 'Hache', 'Arme brutale pour fendre les armures.', NULL),
(24, 'Marteau', 'Arme contondante.', NULL),
(25, 'Arme d\'hast', 'Arme à longue portée.', NULL),
(26, 'Arme de trait', 'Pour atteindre les cibles éloignées.', NULL),
(27, 'Arme Légendaire', 'Relique unique d\'une puissance incommensurable.', NULL),
(28, 'Chaussures magiques', 'Bottes enchantées pour le déplacement.', NULL),
(29, 'Sort en bouteille', 'Magie condensée à lancer comme une grenade.', NULL),
(30, 'Vêtements de mage', 'Tenues tissées de mana.', NULL),
(31, 'Bouclier', 'Protection essentielle pour parer les coups.', NULL),
(32, 'Anneau magique', 'Bijou enchanté conférant divers bonus.', NULL),
(33, 'Casque', 'Protection pour la tête.', NULL),
(34, 'Armure de torse', 'La pièce principale de toute armure.', NULL),
(35, 'Gantelets', 'Protection pour les mains et avant-bras.', NULL),
(36, 'Jambières', 'Protection pour les jambes.', NULL),
(37, 'Amulette', 'Pendentif aux propriétés mystiques.', NULL),
(38, 'Arme de jet', 'Projectiles consommables.', NULL),
(39, 'Bombe artisanale', 'Explosifs dangereux à manipuler avec précaution.', NULL),
(40, 'Source de lumière', 'Indispensable dans les donjons sombres.', NULL),
(41, 'Outils de voleur', 'Matériel pour ouvrir les portes verrouillées.', NULL),
(42, 'Longue-vue', 'Pour observer l\'ennemi de loin.', NULL),
(43, 'Nourriture', 'Provisions pour ne pas mourir de faim.', NULL),
(44, 'Matériaux d\'artisanat', 'Ressources brutes pour la forge.', NULL),
(45, 'Gemmes précieuses', 'Pierres pouvant être serties ou vendues.', NULL),
(46, 'Herbes médicinales', 'Plantes aux vertus curatives.', NULL),
(47, 'Cape', 'Vêtement couvrant le dos.', NULL),
(48, 'Instrument', 'Pour les bardes et les fêtes.', NULL),
(49, 'Objets occultes', 'Accessoires liés à la magie de la mort.', NULL),
(50, 'Carte géographique', 'Pour ne jamais se perdre.', NULL),
(51, 'Kits Thématiques', 'Lots de produits regroupés à un prix avantageux.', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `Regroupement`
--

CREATE TABLE `Regroupement` (
  `idRegroupement` int NOT NULL,
  `libelle` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Regroupement`
--

INSERT INTO `Regroupement` (`idRegroupement`, `libelle`) VALUES
(1, 'Nouveautés'),
(2, 'Soldes'),
(3, 'Made in Falconia'),
(4, 'Best Sellers'),
(5, 'Éditions limitées'),
(6, 'Recommandés');

-- --------------------------------------------------------

--
-- Structure de la table `Regrouper`
--

CREATE TABLE `Regrouper` (
  `idRegroupement` int NOT NULL,
  `idProduit` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Regrouper`
--

INSERT INTO `Regrouper` (`idRegroupement`, `idProduit`) VALUES
(1, 1),
(3, 1),
(4, 1),
(1, 2),
(2, 2),
(6, 2),
(1, 3),
(3, 3),
(6, 3),
(2, 4),
(4, 4),
(2, 5),
(4, 5),
(6, 5),
(3, 6),
(4, 6),
(1, 7),
(5, 7),
(6, 7),
(1, 8),
(3, 8),
(5, 8),
(6, 8),
(2, 9),
(4, 9),
(6, 9),
(2, 10),
(5, 10),
(3, 11),
(5, 11),
(3, 12),
(4, 12);

-- --------------------------------------------------------

--
-- Structure de la table `ReponseAvis`
--

CREATE TABLE `ReponseAvis` (
  `idReponse` int NOT NULL,
  `idAdmin` int NOT NULL,
  `idAvis` int NOT NULL,
  `reponse` varchar(1000) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ReponseAvis`
--

INSERT INTO `ReponseAvis` (`idReponse`, `idAdmin`, `idAvis`, `reponse`, `date`) VALUES
(1, 1, 1, 'Bonjour Marie. Ravie que notre concentration de mana vous plaise. L\'amertume est le gage de sa pureté !', '2025-12-03 08:57:04'),
(2, 1, 2, 'Merci Jean. C\'est effectivement une arme de guerre. Nous conseillons une Force de 16 minimum pour la manier avec fluidité.', '2025-12-03 08:57:04'),
(3, 1, 3, 'La magie dimensionnelle est notre spécialité ! Ravi que cela allège votre charge.', '2025-12-03 08:57:04'),
(4, 1, 4, 'Bonjour Lucas. Merci du retour. Nous allons demander à notre tanneur d\'utiliser un cuir plus texturé pour les prochaines séries.', '2025-12-03 08:57:04'),
(5, 2, 5, 'L\'essentiel de la trousse de secours ! N\'hésitez pas à consulter nos packs de 10 pour vos futures aventures.', '2025-12-03 08:57:04'),
(6, 2, 6, 'Cher Thomas, navré pour cet incident. Comme indiqué dans la notice, le port de gants ignifugés est obligatoire avec ce modèle.', '2025-12-03 08:57:04'),
(7, 2, 7, 'Le sort de célérité intégré allège le pas. Excellent choix pour les longues randonnées !', '2025-12-03 08:57:04'),
(8, 2, 8, 'Ce n\'est pas une arnaque, c\'est une légende ! Seul un guerrier marqué par le destin peut la soulever. Continuez l\'entraînement !', '2025-12-03 08:57:04'),
(9, 3, 9, 'Flagadus sera ravi de lire votre commentaire ! Essayez la tourte aux champignons hallucinogènes, c\'est une expérience.', '2025-12-03 08:57:04'),
(10, 3, 10, 'La magie du feu éternel est très pratique. Attention tout de même à ne pas la ranger allumée dans votre sac.', '2025-12-03 08:57:04'),
(11, 3, 11, 'C\'est du bois d\'If centenaire. Pensez à détendre la corde quand vous ne l\'utilisez pas pour préserver sa puissance.', '2025-12-03 08:57:04'),
(12, 3, 12, 'Bonjour Louis. L\'enchantement individuel demande beaucoup de ressources. Les carquois de 25 sont effectivement plus économiques !', '2025-12-03 08:57:04'),
(13, 4, 13, 'Une efficacité industrielle. Attention au souffle de l\'explosion, il ne distingue pas l\'ami de l\'ennemi.', '2025-12-03 08:57:04'),
(14, 4, 14, 'C\'est le prix de la sécurité absolue. Idéal pour tenir une ligne de front.', '2025-12-03 08:57:04'),
(15, 4, 15, 'L\'enchantement est subtil mais constant. Il peut faire la différence entre une blessure grave et une blessure mortelle.', '2025-12-03 08:57:04'),
(16, 4, 16, 'La sorcellerie condensée est un art complexe. Utilisez-la sagement.', '2025-12-03 08:57:04'),
(17, 5, 17, 'C\'est une nourriture de pure survie pour les longs voyages, Jules. Trempez-le dans de l\'eau de source !', '2025-12-03 08:57:04'),
(18, 5, 18, 'La musique adoucit les mœurs des bêtes sauvages. Passez en boutique, nous remplacerons la corde.', '2025-12-03 08:57:04'),
(19, 5, 19, 'Les sentiers de la forêt obscure changent avec la lune... difficile de les cartographier !', '2025-12-03 08:57:04'),
(20, 5, 20, 'Le piment rouge est l\'ingrédient de base pour l\'activation thermique interne. Ravi que vous ayez survécu au drake !', '2025-12-03 08:57:04');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `Administrateur`
--
ALTER TABLE `Administrateur`
  ADD PRIMARY KEY (`idAdmin`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `Apparenter`
--
ALTER TABLE `Apparenter`
  ADD PRIMARY KEY (`idProduit1`,`idProduit2`),
  ADD KEY `idProduit2` (`idProduit2`);

--
-- Index pour la table `Appartenir`
--
ALTER TABLE `Appartenir`
  ADD PRIMARY KEY (`idProduit`,`idCategorie`),
  ADD KEY `idCategorie` (`idCategorie`);

--
-- Index pour la table `Avis`
--
ALTER TABLE `Avis`
  ADD PRIMARY KEY (`idAvis`),
  ADD KEY `idx_avis_produit` (`idDeclinaisonProduit`),
  ADD KEY `idx_avis_client` (`idClient`);

--
-- Index pour la table `CarteBancaire`
--
ALTER TABLE `CarteBancaire`
  ADD PRIMARY KEY (`idCarte`),
  ADD KEY `idClient` (`idClient`);

--
-- Index pour la table `Categorie`
--
ALTER TABLE `Categorie`
  ADD PRIMARY KEY (`idCategorie`),
  ADD KEY `idx_categorie_parent` (`idCategorieParent`);

--
-- Index pour la table `Client`
--
ALTER TABLE `Client`
  ADD PRIMARY KEY (`idClient`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `Commande`
--
ALTER TABLE `Commande`
  ADD PRIMARY KEY (`idCommande`),
  ADD KEY `idx_commande_client` (`idClient`),
  ADD KEY `idx_commande_date` (`dateCommande`);

--
-- Index pour la table `CompositionProduit`
--
ALTER TABLE `CompositionProduit`
  ADD PRIMARY KEY (`idCompo`,`idDeclinaison`),
  ADD KEY `FK_Compo_Produit` (`idDeclinaison`);

--
-- Index pour la table `DeclinaisonProduit`
--
ALTER TABLE `DeclinaisonProduit`
  ADD PRIMARY KEY (`idDeclinaison`),
  ADD KEY `idx_declinaison_produit` (`idProduit`);

--
-- Index pour la table `LigneCommande`
--
ALTER TABLE `LigneCommande`
  ADD PRIMARY KEY (`idCommande`,`idDeclinaison`),
  ADD KEY `idDeclinaison` (`idDeclinaison`);

--
-- Index pour la table `PhotoAvis`
--
ALTER TABLE `PhotoAvis`
  ADD PRIMARY KEY (`idPhoto`),
  ADD KEY `idAvis` (`idAvis`);

--
-- Index pour la table `PhotoProduit`
--
ALTER TABLE `PhotoProduit`
  ADD PRIMARY KEY (`idPhoto`),
  ADD KEY `idDeclinaison` (`idDeclinaison`);

--
-- Index pour la table `Produit`
--
ALTER TABLE `Produit`
  ADD PRIMARY KEY (`idProduit`);

--
-- Index pour la table `Regroupement`
--
ALTER TABLE `Regroupement`
  ADD PRIMARY KEY (`idRegroupement`);

--
-- Index pour la table `Regrouper`
--
ALTER TABLE `Regrouper`
  ADD PRIMARY KEY (`idRegroupement`,`idProduit`),
  ADD KEY `idProduit` (`idProduit`);

--
-- Index pour la table `ReponseAvis`
--
ALTER TABLE `ReponseAvis`
  ADD PRIMARY KEY (`idReponse`),
  ADD KEY `idAdmin` (`idAdmin`),
  ADD KEY `idAvis` (`idAvis`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `Administrateur`
--
ALTER TABLE `Administrateur`
  MODIFY `idAdmin` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Avis`
--
ALTER TABLE `Avis`
  MODIFY `idAvis` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `CarteBancaire`
--
ALTER TABLE `CarteBancaire`
  MODIFY `idCarte` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Categorie`
--
ALTER TABLE `Categorie`
  MODIFY `idCategorie` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT pour la table `Client`
--
ALTER TABLE `Client`
  MODIFY `idClient` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Commande`
--
ALTER TABLE `Commande`
  MODIFY `idCommande` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `DeclinaisonProduit`
--
ALTER TABLE `DeclinaisonProduit`
  MODIFY `idDeclinaison` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `PhotoAvis`
--
ALTER TABLE `PhotoAvis`
  MODIFY `idPhoto` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `PhotoProduit`
--
ALTER TABLE `PhotoProduit`
  MODIFY `idPhoto` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Produit`
--
ALTER TABLE `Produit`
  MODIFY `idProduit` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Regroupement`
--
ALTER TABLE `Regroupement`
  MODIFY `idRegroupement` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `ReponseAvis`
--
ALTER TABLE `ReponseAvis`
  MODIFY `idReponse` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `Apparenter`
--
ALTER TABLE `Apparenter`
  ADD CONSTRAINT `Apparenter_ibfk_1` FOREIGN KEY (`idProduit1`) REFERENCES `Produit` (`idProduit`) ON DELETE CASCADE,
  ADD CONSTRAINT `Apparenter_ibfk_2` FOREIGN KEY (`idProduit2`) REFERENCES `Produit` (`idProduit`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Appartenir`
--
ALTER TABLE `Appartenir`
  ADD CONSTRAINT `Appartenir_ibfk_1` FOREIGN KEY (`idProduit`) REFERENCES `Produit` (`idProduit`) ON DELETE CASCADE,
  ADD CONSTRAINT `Appartenir_ibfk_2` FOREIGN KEY (`idCategorie`) REFERENCES `Categorie` (`idCategorie`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Avis`
--
ALTER TABLE `Avis`
  ADD CONSTRAINT `Avis_ibfk_1` FOREIGN KEY (`idClient`) REFERENCES `Client` (`idClient`) ON DELETE CASCADE,
  ADD CONSTRAINT `Avis_ibfk_2` FOREIGN KEY (`idDeclinaisonProduit`) REFERENCES `DeclinaisonProduit` (`idDeclinaison`) ON DELETE CASCADE;

--
-- Contraintes pour la table `CarteBancaire`
--
ALTER TABLE `CarteBancaire`
  ADD CONSTRAINT `CarteBancaire_ibfk_1` FOREIGN KEY (`idClient`) REFERENCES `Client` (`idClient`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Categorie`
--
ALTER TABLE `Categorie`
  ADD CONSTRAINT `Categorie_ibfk_1` FOREIGN KEY (`idCategorieParent`) REFERENCES `Categorie` (`idCategorie`) ON DELETE SET NULL;

--
-- Contraintes pour la table `Commande`
--
ALTER TABLE `Commande`
  ADD CONSTRAINT `Commande_ibfk_1` FOREIGN KEY (`idClient`) REFERENCES `Client` (`idClient`) ON DELETE CASCADE;

--
-- Contraintes pour la table `CompositionProduit`
--
ALTER TABLE `CompositionProduit`
  ADD CONSTRAINT `FK_Compo_Kit` FOREIGN KEY (`idCompo`) REFERENCES `DeclinaisonProduit` (`idDeclinaison`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_Compo_Produit` FOREIGN KEY (`idDeclinaison`) REFERENCES `DeclinaisonProduit` (`idDeclinaison`) ON DELETE CASCADE;

--
-- Contraintes pour la table `DeclinaisonProduit`
--
ALTER TABLE `DeclinaisonProduit`
  ADD CONSTRAINT `DeclinaisonProduit_ibfk_1` FOREIGN KEY (`idProduit`) REFERENCES `Produit` (`idProduit`) ON DELETE CASCADE;

--
-- Contraintes pour la table `LigneCommande`
--
ALTER TABLE `LigneCommande`
  ADD CONSTRAINT `LigneCommande_ibfk_1` FOREIGN KEY (`idCommande`) REFERENCES `Commande` (`idCommande`) ON DELETE CASCADE,
  ADD CONSTRAINT `LigneCommande_ibfk_2` FOREIGN KEY (`idDeclinaison`) REFERENCES `DeclinaisonProduit` (`idDeclinaison`);

--
-- Contraintes pour la table `PhotoAvis`
--
ALTER TABLE `PhotoAvis`
  ADD CONSTRAINT `PhotoAvis_ibfk_1` FOREIGN KEY (`idAvis`) REFERENCES `Avis` (`idAvis`) ON DELETE CASCADE;

--
-- Contraintes pour la table `PhotoProduit`
--
ALTER TABLE `PhotoProduit`
  ADD CONSTRAINT `PhotoProduit_ibfk_1` FOREIGN KEY (`idDeclinaison`) REFERENCES `DeclinaisonProduit` (`idDeclinaison`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Regrouper`
--
ALTER TABLE `Regrouper`
  ADD CONSTRAINT `Regrouper_ibfk_1` FOREIGN KEY (`idRegroupement`) REFERENCES `Regroupement` (`idRegroupement`) ON DELETE CASCADE,
  ADD CONSTRAINT `Regrouper_ibfk_2` FOREIGN KEY (`idProduit`) REFERENCES `Produit` (`idProduit`) ON DELETE CASCADE;

--
-- Contraintes pour la table `ReponseAvis`
--
ALTER TABLE `ReponseAvis`
  ADD CONSTRAINT `ReponseAvis_ibfk_1` FOREIGN KEY (`idAdmin`) REFERENCES `Administrateur` (`idAdmin`) ON DELETE CASCADE,
  ADD CONSTRAINT `ReponseAvis_ibfk_2` FOREIGN KEY (`idAvis`) REFERENCES `Avis` (`idAvis`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
