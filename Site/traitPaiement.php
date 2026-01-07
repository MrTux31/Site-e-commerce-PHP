<?php
session_start();
require_once 'connec.inc.php';

//Redirection si accès direct sans POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: index.php');
    exit;
}

// Vérification que l'utilisateur est connecté
if (!isset($_SESSION['idClient'])) {
    header('Location: connexion.php?msgErreur=' . urlencode('Vous devez être connecté pour passer commande.'));
    exit;
}

// Vérification et récupération des articles à acheter
if (!isset($_SESSION['panier']) || empty($_SESSION['panier'])) {
    header('Location: panier.php?msgErreur=' . urlencode('Aucun article à commander.'));
    exit;
}

// Stockage des achats (panier complet ou achat unique) dans un tableau associatif
$tabAchat = $_SESSION['panier'];

$idClient = $_SESSION['idClient'];

// Initialisation du tableau des erreurs
$erreurs = [];

// ============================================
//  RÉCUPÉRATION DES DONNÉES DU FORMULAIRE
// ============================================

//Informations sur la livraison
$prenom = isset($_POST['prenom']) ? trim($_POST['prenom']) : '';
$nom = isset($_POST['nom']) ? trim($_POST['nom']) : '';
$email = isset($_POST['email']) ? trim($_POST['email']) : '';
$adresse = isset($_POST['adresse']) ? trim($_POST['adresse']) : '';
$codePostal = isset($_POST['codePostal']) ? trim($_POST['codePostal']) : '';
$ville = isset($_POST['ville']) ? trim($_POST['ville']) : '';

//Méthode de paiement
$methodePaiement = isset($_POST['payment-method']) ? trim($_POST['payment-method']) : '';

// Points de fidélité utilisés
$pointsUtilises = isset($_POST['pointsFideliteUtilises']) ? intval($_POST['pointsFideliteUtilises']) : 0;

//Informations sur la carte de crédit
$numeroCarte = isset($_POST['card-number']) ? trim($_POST['card-number']) : '';
$dateExpiration = isset($_POST['expiry-date']) ? trim($_POST['expiry-date']) : '';
$cvc = isset($_POST['cvc']) ? trim($_POST['cvc']) : '';
$nomSurCarte = isset($_POST['card-holder']) ? trim($_POST['card-holder']) : '';
$typeCarte = isset($_POST['card-type']) ? trim($_POST['card-type']) : '';

// ============================================
//  VALIDATIONS
// ============================================

// Vérification des champs obligatoires
if ($prenom === '' || $nom === '' || $email === '' || $adresse === '' || 
    $ville === '' || $codePostal === '' || $methodePaiement === '') {
    $erreurs[] = "Tous les champs obligatoires doivent être remplis.";
}

// Validation de l'email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $erreurs[] = "L'adresse e-mail n'est pas valide.";
}

/*
* Pas obligatoire (ça serait de la robustesse mais comme il n'y a pas réélement de transaction monétaire c'était juste du temps perdu 🤷‍♂️)
* Du coup je le laisse parce que j'me suis assez emmerdé sur cette page pour que ça soit pas reconnu
*
// Validation de la méthode de paiement
$methodesPaiementValides = ['CB', 'Paypal', 'Virement'];
if (!in_array($methodePaiement, $methodesPaiementValides)) {
    $erreurs[] = "Méthode de paiement invalide.";
}
*/

// Validation des points de fidélité utilisés
$valeursPointsAutorisees = [0, 10, 20, 50];
if (!in_array($pointsUtilises, $valeursPointsAutorisees)) {
    $erreurs[] = "Valeur de points de fidélité invalide.";
}


// Récupération des points de fidélité disponibles pour le client
$pointsDisponibles = 0;
try {
    $stmtPtsClient = $connection->prepare("
        SELECT ptsFidelite 
        FROM Client 
        WHERE idClient = :idClient
    ");
    $stmtPtsClient->bindParam(':idClient', $idClient, PDO::PARAM_INT);
    $stmtPtsClient->execute();
    $rowPts = $stmtPtsClient->fetch(PDO::FETCH_ASSOC);
    if ($rowPts) {
        $pointsDisponibles = intval($rowPts['ptsFidelite']);
    }
} catch (PDOException $e) {
    $erreurs[] = "Impossible de récupérer vos points de fidélité.";
}

if ($pointsUtilises > $pointsDisponibles) {
    $erreurs[] = "Vous n'avez pas assez de points de fidélité.";
}

// Validation des informations de carte bancaire (si CB)
if ($methodePaiement === 'CB') {
    if (strlen($numeroCarte) !== 16 || !ctype_digit($numeroCarte)) {
        $erreurs[] = "Le numéro de carte doit contenir exactement 16 chiffres.";
    }
    
    if (strlen($cvc) !== 3 || !ctype_digit($cvc)) {
        $erreurs[] = "Le CVC doit contenir exactement 3 chiffres.";
    }
    
    // Validation du format MM/AA
    if (!preg_match('/^(0[1-9]|1[0-2])\/([0-9]{2})$/', $dateExpiration)) {
        $erreurs[] = "Le format de la date d'expiration doit être MM/AA.";
    } else {
        // Vérifier que la carte n'est pas expirée
        list($mois, $annee) = explode('/', $dateExpiration);
        $annee = '20' . $annee;
        $dateExp = $annee . '-' . $mois . '-' . cal_days_in_month(CAL_GREGORIAN, $mois, $annee);
        
        if (strtotime($dateExp) < time()) {
            $erreurs[] = "La carte bancaire est expirée.";
        }
    }
    
    if ($nomSurCarte === '') {
        $erreurs[] = "Le nom sur la carte est obligatoire.";
    }
}


// S'il y a des erreurs, redirection
if (!empty($erreurs)) {
    $msg = implode(' ', $erreurs);
    header("Location: paiement.php?msgErreur=" . urlencode($msg));
    exit;
}


// ============================================
//  ADRESSE DE LIVRAISON COMPLÈTE
// ============================================

$adresseLivraison = $adresse . ', ' . $codePostal . ' ' . $ville;

// ============================================
//  INSERTION EN BASE DE DONNÉES
// ============================================

try {
    $connection->beginTransaction(); //Début de la transaction sur la BD
   
    // === Insertion de la Commande ===
    $stmtCommande = $connection->prepare("
        INSERT INTO Commande (
            idClient, 
            numTransaction, 
            dateCommande, 
            statutCommande, 
            adresseLivraison, 
            typePaiement, ptsFideliteUsed
        ) VALUES (
            :idClient,
            UUID_SHORT(),
            NOW(),
            'payee',
            :adresseLivraison,
            :typePaiement, 
            :ptsFideliteUsed
            
        )
    ");
    
    $stmtCommande->bindParam(':idClient', $idClient, PDO::PARAM_INT);
    $stmtCommande->bindParam(':adresseLivraison', $adresseLivraison, PDO::PARAM_STR);
    $stmtCommande->bindParam(':typePaiement', $methodePaiement, PDO::PARAM_STR);
    $stmtCommande->bindParam(':ptsFideliteUsed', $pointsUtilises, PDO::PARAM_INT);

    $stmtCommande->execute();
    $idCommande = $connection->lastInsertId();
    
    // === Insertion des Lignes de Commande ===
    $stmtLigne = $connection->prepare("
        INSERT INTO LigneCommande (
            idCommande,
            idDeclinaison,
            quantite
        ) VALUES (
            :idCommande,
            :idDeclinaison,
            :quantite
            
        )
    ");
    
    foreach ($tabAchat as $item) {
        $idDeclinaison = intval($item['idDeclinaison']);
        $quantite = intval($item['quantite']);
        
        $stmtLigne->bindParam(':idCommande', $idCommande, PDO::PARAM_INT);
        $stmtLigne->bindParam(':idDeclinaison', $idDeclinaison, PDO::PARAM_INT);
        $stmtLigne->bindParam(':quantite', $quantite, PDO::PARAM_INT);
        $stmtLigne->execute();
        
    }
    
    //On récupère le prix total de la commande calculé par les triggers de la BD
    $stmtPrixTotalCommande = $connection->prepare("
        SELECT prixTotal 
        FROM Commande 
        WHERE idCommande = :idCommande");

    $stmtPrixTotalCommande->bindParam(':idCommande', $idCommande, PDO::PARAM_INT);
    $stmtPrixTotalCommande->execute();
    $rowPrixTot = $stmtPrixTotalCommande->fetch(PDO::FETCH_ASSOC);
    $prixTotalCommande = $rowPrixTot['prixTotal'];

    //Mise à jour des points gagnés par le client (après réduction appliquée, le débit des points à déjà été fait dans un trigger)
    $pointsGagnes = floor($prixTotalCommande * 0.1);
    // Mise à jour des points du client
    $stmtMajPoints = $connection->prepare("
        UPDATE Client
        SET ptsFidelite = ptsFidelite + :ptsFideliteGagnes
        WHERE idClient = :idClient
    ");
    $stmtMajPoints->bindParam(':ptsFideliteGagnes', $pointsGagnes, PDO::PARAM_INT);
    $stmtMajPoints->bindParam(':idClient', $idClient, PDO::PARAM_INT);
    $stmtMajPoints->execute();



    // === Insertion de la Carte Bancaire (si CB) ===
    if ($methodePaiement === 'CB') {
        // Vérifier si la carte existe déjà pour ce client
        $stmtCheckCarte = $connection->prepare("
            SELECT idCarte FROM CarteBancaire 
            WHERE idClient = :idClient AND numeroCarte = :numeroCarte
        ");
        $stmtCheckCarte->bindParam(':idClient', $idClient, PDO::PARAM_INT);
        $stmtCheckCarte->bindParam(':numeroCarte', $numeroCarte, PDO::PARAM_STR);
        $stmtCheckCarte->execute();
        
        if ($stmtCheckCarte->rowCount() === 0) {
            // La carte n'existe pas, on l'insère
            list($mois, $annee) = explode('/', $dateExpiration);
            $annee = '20' . $annee;
            $dernierJour = cal_days_in_month(CAL_GREGORIAN, $mois, $annee);
            $dateExpirationSQL = $annee . '-' . $mois . '-' . $dernierJour;
            
            $stmtCarte = $connection->prepare("
                INSERT INTO CarteBancaire (
                    idClient,
                    numeroCarte,
                    cvc,
                    dateExpiration,
                    typeCarte
                ) VALUES (
                    :idClient,
                    :numeroCarte,
                    :cvc,
                    :dateExpiration,
                    :typeCarte
                )
            ");
            
            $stmtCarte->bindParam(':idClient', $idClient, PDO::PARAM_INT);
            $stmtCarte->bindParam(':numeroCarte', $numeroCarte, PDO::PARAM_STR);
            $stmtCarte->bindParam(':cvc', $cvc, PDO::PARAM_STR);
            $stmtCarte->bindParam(':dateExpiration', $dateExpirationSQL, PDO::PARAM_STR);
            $stmtCarte->bindParam(':typeCarte', $typeCarte, PDO::PARAM_STR);
            
            $stmtCarte->execute();
        }
    }
    

    // Validation de la transaction
    $connection->commit();
    
    // Vider le panier de la session
    unset($_SESSION['panier']);
    
    // Redirection vers la page d'acceuil
    header("Location: index.php?idCommande=" . $idCommande . "&msgSucces=" . urlencode("Commande passée avec succès !"));
    exit;

} catch (PDOException $e) {
    // Annulation de la transaction en cas d'erreur
    $connection->rollBack();
    
    header("Location: index.php?msgErreur=" . urlencode("Erreur innatendue lors du paiement.
     Transaction annulée."));

    exit;
}
?>