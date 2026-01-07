<?php

require_once("../connec.inc.php");
require_once("../includes/utils.php");

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}


// Vérification de la session administrateur
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}

//Si on essaie d'accéder à la page, on redirige direct à l'index
if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    header('Location: ../index.php');
    exit;
}



//Charger tous les produits parents 
$tab_produits = chargerProduitsParents();
//Charger toutes les déclinaisons
$tab_declinaisons = chargerDeclinaisonsProduits();

//Ajout du tableau des photos pour chaque déclinaisons///////
//Parcours du tableau des déclinaisons
foreach ($tab_declinaisons as $idParent => $listeDeclinaisons) { 
    //On parcours chaque élément de la liste des déclinaisons
    foreach ($listeDeclinaisons as $cle => $declinaison) {
        //On récup la liste des déclinaisons
        $idDeclinaison = $declinaison['idDeclinaison'];
        //On enregistre les photos
        $declinaison['photos'] = getPhotosDeclinaisonProduit($idDeclinaison);
        //On sauvegarde la déclinaison dans la liste
        $listeDeclinaisons[$cle] = $declinaison; // réassigne explicitement
    }
    //On sauvegarde la liste des déclinaisons
    $tab_declinaisons[$idParent] = $listeDeclinaisons; // réassigne
}


//Créer un tableau complet associant a chaque produit parent la liste de ses déclinaisons
$tab_produits = construitreTableauParentDeclinaisons($tab_produits, $tab_declinaisons);
//Récupère toutes les qualités de produits disponibles
$tab_qualites = chargerQualites();
//Récupère toutes les catégories disponibles
$tab_categories = chargerCategories();




/**
 * Fonction permettant d'obtenir un tableau de produits associant des produits parents et leurs produits déclinés
 * du catalogue, avec tous leurs produits enfants et leurs informations
 * [
 *       'idProduit' => 10,
 *       'libelle' => 'Potion de Soin',
 *       'description' => 'Une potion de soin', 
 *       'categorie' => 'Alchimie',
 *       'variantes' => [
 *           ['idDeclinaison' => 101, 'libelleDeclinaison' => 'Soin Mineur (50ml)', 'descDeclinaison'=> 'Régénère une petite quantité de soin',
 *           'prix' => 15.00, 'prixSolde' => null, 'qteStock' => 120, 'seuilQte' => 20, 'qualite' => 'Commun', 'provenance' => 'Commun', 'moyenneAvis' => 4.5,
 *           'photos' => ['images/images1.jpg']
 *            ]
 *       ]
 *   ]
 */
function construitreTableauParentDeclinaisons($produits_parents, $declinaisons)
{
    $tableau_final = [];

    foreach ($produits_parents as $idParent => $infosProduit) {
        //On récupère le tableau contenant toutes les déclinaisons du produit actuel
        $liste_declinaisons = isset($declinaisons[$idParent]) ? $declinaisons[$idParent] : [];  //Si le produit a des declinaisons, on les prends, sinon on met une liste vide      
        //On enregistre la liste des déclinaisons dans les infos du produit parent
        $infosProduit['variantes'] = $liste_declinaisons;

        //On enregistre les infos complète du produit dans le tableau final
        $tableau_final[] = $infosProduit;
    }


    return $tableau_final;
}




/**
 * Permet de charger tous les produits parents présents dans la base de données
 * Retourne un tableau sous la forme
 * Exemple : 
 * $tab_produits = [
 *   1 => [
 *       'idProduit' => 1,
 *       'libelle' => 'Potion de mana',
 *       'description' => 'Fiole contenant un liquide bleu lumineux permettant...'
 *   ],
 *   2 => [
 *       'idProduit' => 2,
 *       'libelle' => 'Potion de résistance',
 *       'description' => 'Potions alchimiques offrant une protection temporaire...'
 *   ]
 *  ];
 */
function chargerProduitsParents()
{

    $tab_produits = [];
    try {
        global $connection;
        $statement = $connection->prepare("CALL getProduitsParents()");  //Récupération de tous les produits qui ne sont PAS des KITS, et on récup les catégories aussi
        $statement->execute(); //Executer la commande
        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $tab_produits[$ligne['idProduit']] = $ligne; //Tableau associant l'id du produit a toutes ses infos
        }
        $statement->closeCursor();
    } catch (PDOException $e) {
        error_log("Erreur SQL chargerProduitsParents : " . $e->getMessage());
    }


    return $tab_produits; //On renvoie le tableau des des produits

}


/**
 * Permet de charger tous les produits déclinés présents dans la base de données
 * Retourne un tableau sous la forme idProduitParent => [infos de la déclinaison]
 * Exemple : 
 * $tab_produits = [
 *   1 => [
 *       [
 *           'idDeclinaison'     => 1,
 *           'libelleDeclinaison'=> 'Potion de mana majeure',
 *           'idProduit'         => 1,
 *            'descDeclinaison'   => 'Régénère une grande quantité de mana (100%)',
 *           'ficheTechnique'    => 'Contenance: 200ml, Effet: Instantané, Poids: 0.3kg',
 *           'prix'              => 19.99,
 *           'prixSolde'         => null,
 *           'qteStock'          => 0,
 *           'seuilQte'          => 50,
 *           'qualite'           => 'Commun',
 *           'provenance'        => 'Falconia',
 *           'moyenneAvis'       => 4.50
 *      ]
 *  ];
 */
function chargerDeclinaisonsProduits()
{

    $tab_produits = [];
    try {
        global $connection;
        $statement = $connection->prepare("SELECT * FROM DeclinaisonProduit");  //Récupération de toutes les déclinaisons
        $statement->execute(); //Executer la commande
        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $tab_produits[$ligne['idProduit']][] = $ligne; //On associe l'id du produit parent avec la déclinaison (s'ajoute dans une liste)
        }
    } catch (PDOException $e) {
        error_log("Erreur SQL chargerDeclinaisonsProduits : " . $e->getMessage());
    }


    return $tab_produits; //On renvoie le tableau des des produits

}


/**
 * Fonction permettant de charger les différentes qualités disponibles
 */

function chargerQualites()
{

    $tab_qualites = ['Legendaire','Commun','Peu commun','Rare','Epique'];
    return $tab_qualites; //On renvoie le tableau de qualités

}


/**
 * Fonction permettant de charger les différentes catégories disponibles
 */

function chargerCategories()
{

    $tab_categories = [];
    try {
        global $connection;
        $statement = $connection->prepare("SELECT * FROM Categorie ORDER BY idCategorie ASC"); //Récup toutes les catégories
        $statement->execute(); //Executer la commande

        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $tab_categories[] = ['libelle' => $ligne['libelle'], 'idCategorie' => $ligne['idCategorie']];
        }
    } catch (PDOException $e) {
        error_log("Erreur SQL chargerCategories : " . $e->getMessage());
    }


    return $tab_categories; //On renvoie le tableau de catégories

}

function redirectWithMessage(string $message, string $type = 'Succes')
{
    header("Location: crudProduit.php?msg$type=" . urlencode($message));
    exit();
}

/**
 * Permet d'obtenir toutes les photos d'une déclinaison
 * 
 */
function getPhotosDeclinaisonProduit($idDeclinaison)
{
    global $connection;
    $photos = [];
    $statement = $connection->prepare("SELECT * FROM PhotoProduit WHERE idDeclinaison = :id");
    $statement->execute([':id' => $idDeclinaison]);
    while ($ligne = $statement->fetch(PDO::FETCH_ASSOC)) {
        $photos[] = $ligne['url'];
    }

    return $photos;
}
