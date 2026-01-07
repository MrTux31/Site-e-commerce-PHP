<?php
session_start();

// On inclut la connexion pour pouvoir supprimer le token en base
require_once 'connec.inc.php'; 

//Si l'utilisateur n'est pas connecté, redirection
if(!isset($_SESSION["SLeRoiMerlin"])){
    header("Location: connexion.php?msgErreur=".urlencode("Vous devez être connecté !"));
    exit;
}


// --- 1. NETTOYAGE BASE DE DONNÉES (Sécurité Token) ---
if (isset($_COOKIE['CLeRoiMerlin'])) {
    $parts = explode(':', $_COOKIE['CLeRoiMerlin']);
    
    if (count($parts) === 2) {
        $selector = $parts[0];

        if (isset($connection)) {
            // On supprime le token pour invalider la reconnexion auto (Admin ou Client)
            $stmt = $connection->prepare("DELETE FROM auth_tokens WHERE selector = ?");
            $stmt->execute([$selector]);
        }
    }
}

// --- 2. NETTOYAGE COMPLET DE LA SESSION ---
// On vide toutes les variables (idClient, idAdmin, nomAdmin, etc.)
$_SESSION = array();

// On détruit le cookie de session dans le navigateur
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

// --- 3. SUPPRESSION DU COOKIE "REMEMBER ME" ---
setcookie("CLeRoiMerlin", '', time() - 3600, "/");

// On détruit la session côté serveur
session_destroy();

// --- 4. REDIRECTION ---
// On redirige vers l'accueil. Le header.php verra que la session est vide et affichera "Se connecter"
header("Location: index.php");
exit;
?>