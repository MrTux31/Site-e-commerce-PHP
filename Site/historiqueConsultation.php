<?php 


//Si on essai d'accéder à la page direct on redirige direct vers l'accueil
if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    header('Location: index.php');
    exit;
}



//On récup l'id du produit en get si il existe, sinon null
$idProduit = $_GET['id'] ?? null;

if (!$idProduit || !ctype_digit($idProduit)) { //Si on a pas recu l'id du produit OU l'id du produit n'est pas un nombre /chiffres
    header("Location: index.php"); //Redirection vers index
    exit;
}

// --- Gestion de l'historique (Cookie simple) ---
$historique = [];
if (isset($_COOKIE['historique_vu'])) {
    $historique = json_decode($_COOKIE['historique_vu'], true) ?? [];
}

// On retire l'ID s'il est déjà présent pour le remettre en haut de liste (évite les doublons)
if (($key = array_search($idProduit, $historique)) !== false) {
    unset($historique[$key]);
}

// On ajoute l'ID au début et on garde les 4 derniers
array_unshift($historique, $idProduit);
$historique = array_slice($historique, 0, 4);

// On sauvegarde pour 30 jours
setcookie('historique_vu', json_encode($historique), time() + (86400 * 30), "/");



?>