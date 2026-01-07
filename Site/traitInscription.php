<?php
session_start();
require_once 'connec.inc.php';

// Redirection si accès direct sans POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: connexion.php');
    exit;
}

// Récupération des champs du formulaire
$prenom      = isset($_POST['prenom']) ? trim($_POST['prenom']) : '';
$nom         = isset($_POST['nom']) ? trim($_POST['nom']) : '';
$email       = isset($_POST['email']) ? trim($_POST['email']) : '';
$motDePasse  = isset($_POST['motDePasse']) ? $_POST['motDePasse'] : '';
$confirmation = isset($_POST['confirmation']) ? $_POST['confirmation'] : '';
$adresse     = isset($_POST['adresse']) ? trim($_POST['adresse']) : '';
$codePostal  = isset($_POST['codePostal']) ? trim($_POST['codePostal']) : '';
$ville       = isset($_POST['ville']) ? trim($_POST['ville']) : '';
$telephone   = isset($_POST['telephone']) ? trim($_POST['telephone']) : '';

$erreurs = [];

// Vérifications du remplissage des champs "obligatoires"
if ($prenom === '' || $nom === '' || $email === '' || $motDePasse === '' || $confirmation === '' ||
    $adresse === '' || $codePostal === '' || $ville === '') {
    $erreurs[] = "Tous les champs obligatoires doivent être remplis.";
}

// Validation de l'email (au format requis)
if (!preg_match('/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/', $email)) {
    $erreurs[] = "L'adresse e-mail n'est pas valide.";
}

if ($motDePasse !== $confirmation) {
    $erreurs[] = "Les mots de passe ne correspondent pas.";
}

// Validation du mot de passe (au format requis)
if (!preg_match('/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d]).{8,}$/', $motDePasse)) {
    $erreurs[] = "Le mot de passe doit contenir au moins 8 caractères, incluant une lettre minuscule, une majuscule, un chiffre et un caractère spécial.";
}

// Validation du numéro de téléphone (au format requis)
if ($telephone !== '' && !preg_match('/^[0-9]{10}$/', $telephone)) {
    $erreurs[] = "Le numéro de téléphone doit contenir exactement 10 chiffres.";
}

// Vérifier si l'e-mail existe déjà dans la base de données
if (empty($erreurs)) {
    try {
        //On regarde chez les clients
        $stmt = $connection->prepare("SELECT COUNT(*) FROM Client WHERE email = :email");
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->execute();
        $existe_client = $stmt->fetchColumn();

        //On regarde chez les admins
        $stmt = $connection->prepare("SELECT COUNT(*) FROM Administrateur WHERE email = :email");
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->execute();
        $existe_admin = $stmt->fetchColumn();

        //On empeche de créer un compte avec email dejà existants
        if ($existe_client > 0 || $existe_admin > 0) {
            $erreurs[] = "Un compte existe déjà avec cette adresse e-mail.";
        }
    } catch (PDOException $e) {
        $erreurs[] = "Erreur lors de la vérification de l'e-mail.";
    }
}

// S'il y a des erreurs, renvoie vers la page de connexion/inscription avec un message d'erreur
if (!empty($erreurs)) {
    $msg = implode(' ', $erreurs);
    header("Location: connexion.php?msgErreur=" . urlencode($msg) . "&mode=register");
    exit;
}

// Insertion du nouveau client
try {
    $hash = password_hash($motDePasse, PASSWORD_DEFAULT);

    $stmt = $connection->prepare("
        INSERT INTO Client (nom, prenom, email, motDePasse, adresse, codePostal, ville, telephone)
        VALUES (:nom, :prenom, :email, :motDePasse, :adresse, :codePostal, :ville, :telephone)
    ");

    $stmt->bindParam(':nom', $nom, PDO::PARAM_STR);
    $stmt->bindParam(':prenom', $prenom, PDO::PARAM_STR);
    $stmt->bindParam(':email', $email, PDO::PARAM_STR);
    $stmt->bindParam(':motDePasse', $hash, PDO::PARAM_STR);
    $stmt->bindParam(':adresse', $adresse, PDO::PARAM_STR);
    $stmt->bindParam(':codePostal', $codePostal, PDO::PARAM_STR);
    $stmt->bindParam(':ville', $ville, PDO::PARAM_STR);
    // téléphone peut être NULL
    if ($telephone === '') {
        $stmt->bindValue(':telephone', null, PDO::PARAM_NULL);
    } else {
        $stmt->bindParam(':telephone', $telephone, PDO::PARAM_STR);
    }

    $stmt->execute();

    // On peut soit connecter directement l'utilisateur, soit le renvoyer à la page de connexion
    header("Location: connexion.php?msgSucces=" . urlencode("Compte créé avec succès, vous pouvez vous connecter."));
    exit;
} catch (PDOException $e) {
    header("Location: connexion.php?msgErreur=" . urlencode("Erreur lors de la création du compte."));
    exit;
}


