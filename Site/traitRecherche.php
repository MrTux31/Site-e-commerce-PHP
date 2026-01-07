<?php
$search = trim($_GET['search'] ?? ''); //Récupérer le param de la recherche si il existe sinon chaine vide

if ($search === '') { //Si aucune recherche on affiche le catalogue normal
    header('Location: catalogue.php');
    exit;
}

// Redirection vers le catalogue avec le paramètre search
header('Location: catalogue.php?search=' . urlencode($search));
exit;
