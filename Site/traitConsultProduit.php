<?php
require_once("./connec.inc.php");
//Si on essai d'accéder à la page trait, on redirige direct vers le catalogue
if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    header('Location: catalogue.php');
    exit;
}


//On récup l'id du produit en get si il existe, sinon null
$idProduit = $_GET['id'] ?? null;

if (!$idProduit || !ctype_digit($idProduit)) { //Si on a pas recu l'id du produit OU l'id du produit n'est pas un nombre /chiffres
    header("Location: index.php"); //Redirection vers index
    exit;
}

//On essaie de charger le produit
$infos_produit = chargerProduit($idProduit);

if (!$infos_produit) { //Si rien n'a été trouvé sur ce produit (innexistant)
    $erreur = "Produit introuvable.";
    header("Location: catalogue.php?msgErreur=".urlencode($erreur));
    exit;
}

//Chargement des données nécessaires
$tab_variantes = chargerProduitsVariantes($idProduit);
$tab_avis = chargerAvis($idProduit); //Chargement des avis
$tab_produitsSimilaires = chargerProduitsSimilaires($idProduit);


//Stockage des infos du produit
$nom_produit = $infos_produit['libelleDeclinaison'];
$qualite = $infos_produit['qualite'];
$description = $infos_produit['descDeclinaison'];
$ficheTechnique = $infos_produit['ficheTechnique'];
$prix = $infos_produit['prix'];
$prix_solde = $infos_produit['prixSolde'];
$qte_stock = $infos_produit['qteStock'];
$provenance = $infos_produit['provenance'];
$moyenne = $infos_produit['moyenneAvis'];
$photos_produit = chargerPhotosProduit($idProduit, $nom_produit);
$categorie = $infos_produit['categorie_libelle'] ;
$regroupements = chargerRegroupements($infos_produit['idProduit']);
//On affiche un max de 4 regroupements
$regroupements_a_afficher = array_slice($regroupements, 0, 3);
$nb_regroupement_restants = count($regroupements) - 3;

//Si le produit est un "kit" alors cette variable doit se remplir et contenir l'id de tous les produits inclus dedans.
$produits_contenus_kit =chargerProduitsKit($idProduit);



/**
 * Récupère dans la BD toutes les infos sur le produit
 */
function chargerProduit($idProduit)
{
    $tab_produit = [];
    try {
        global $connection;
        $statement = $connection->prepare("CALL getDeclinaisonProduit(:idDeclinaison)"); //Récup les infos sur le produit
        $statement->execute(['idDeclinaison' => $idProduit]);
        $tab_produit = $statement->fetch((PDO::FETCH_ASSOC)); //Récup un tableau associatif
        $statement->closeCursor();

        return $tab_produit; //On renvoie le tableau des infos du produit
    } catch (PDOException $e) {
        error_log("Erreur SQL chargerProduit : " . $e->getMessage());
        // retourne tab vide si ça plante donc on sera automatiquement redirigé à index 
    }
    return $tab_produit;
}

/**
 * Récupère dans la BD tous les avis
 */
function chargerAvis($idProduit)
{
    $tab_avis = [];
    try {

        global $connection;
        $statement = $connection->prepare("SELECT DISTINCT * FROM DeclinaisonProduit as D, Avis as A, Client as C WHERE D.idDeclinaison = ? AND A.idDeclinaisonProduit = D.idDeclinaison AND A.idClient = C.idClient"); //Récup tous les avis
        $statement->execute([$idProduit]); //Executer la commande
        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $tab_avis[] = $ligne;
        }
    } catch (PDOException $e) {
        error_log("Erreur SQL chargerAvis : " . $e->getMessage());
        //en cas d'erreur un tableau vide sera retourné
    }

    return $tab_avis; //On renvoie le tableau des avis du produit

}

/**
 * Récupère dans la BD toutes les réponses de l'avis
 */
function chargerReponsesAvis($idAvis)
{
    $reponses = [];
    try {


        global $connection;
        $statement = $connection->prepare("SELECT * FROM ReponseAvis R, Administrateur A WHERE R.idAvis = ? AND A.idAdmin = R.idAdmin"); //Récup toutes les réponses
        $statement->execute([$idAvis]); //Executer la commande
        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $reponses[] = $ligne;
        }
    } catch (PDOException $e) {
        error_log("Erreur SQL chargerReponseAvis : " . $e->getMessage());
        //en cas d'erreur un tableau vide sera retourné
    }



    return $reponses; //On renvoie le tableau des réponses

}

/**
 * Récupère dans la BD tous les produits similaires
 */
function chargerProduitsSimilaires($idProduit)
{
    $tab_produitsSimilaires = [];
    try {

        global $connection;
        //On met d'abord les produits apparentés
        $statement = $connection->prepare("CALL getDeclinaisonsApparente(:idProduit)"); //Récup tous les produits apparentés
        $statement->execute(['idProduit' => $idProduit]); //Executer la commande
        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $tab_produitsSimilaires[$ligne['idDeclinaison']] = $ligne;
        }
        $statement->closeCursor();
    } catch (PDOException $e) {

        error_log("Erreur SQL chargerProduitsSimilaires : " . $e->getMessage());
        //en cas d'erreur un tableau vide sera retourné

    }
    return $tab_produitsSimilaires; //On renvoie le tableau des produits apparentes

}


/**
 * Fonction permettant de charger les produits "Variantes" d'une déclinaison
 */
function chargerProduitsVariantes($idDeclinaison)
{
    $produits = [];
    try {
        global $connection;
        $statement = $connection->prepare("SELECT D2.* FROM DeclinaisonProduit D1, DeclinaisonProduit D2  
            WHERE D1.idDeclinaison = :idDeclinaison1 AND D1.idProduit = D2.idProduit AND D2.idDeclinaison != D1.idDeclinaison"); //Récup toutes les variantes
        $statement->execute(['idDeclinaison1' => $idDeclinaison]); //Executer la commande

        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $produits[] = $ligne;
        }
    } catch (PDOException $e) {

        error_log("Erreur SQL chargerProduitsVariantes : " . $e->getMessage());

        //en cas d'erreur un tableau vide sera retourné

    }

    return $produits; //On renvoie le tableau des produits


}

/**
 * Fonction permettant de charger les photos d'un avis
 */
function chargerPhotosAvis($idAvis)
{
    global $connection;
    $photos = [];

    try {
        $stmt = $connection->prepare("SELECT * FROM PhotoAvis WHERE idAvis = :idAvis");
        $stmt->execute(['idAvis' => $idAvis]);
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $photos[] = $row['url'];
        }
    } catch (PDOException $e) { //Erreur
        error_log("Erreur SQL chargerPhotosAvis : " . $e->getMessage());
    }

    return $photos; //tableau vide si aucune photos trouvées
}

/**
 * Récupère dans la BD tous les regroupements dans lesquel le produit apparait
 */
function chargerRegroupements($idProduit)
{
    $tab_regroupements = [];
    try {

        global $connection;
        $statement = $connection->prepare("SELECT R.libelle as regroupement_libelle FROM Regroupement R, Regrouper RE WHERE RE.idProduit = ? AND R.idRegroupement = RE.idRegroupement"); //Récup tous les avis
        $statement->execute([$idProduit]); //Executer la commande
        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $tab_regroupements[] = $ligne['regroupement_libelle'];
        }
    } catch (PDOException $e) {
        error_log("Erreur SQL chargerRegroupements : " . $e->getMessage());
        //en cas d'erreur un tableau vide sera retourné
    }

    return $tab_regroupements; //On renvoie le tableau des avis du produit

}

/**
 * Récupère dans la BD tous les produits inclus SI le produit est un KIT
 */
function chargerProduitsKit($idProduit)
{
    $tab_produits = [];
    try {

        global $connection;
        $statement = $connection->prepare("SELECT * FROM CompositionProduit C, DeclinaisonProduit D WHERE idCompo = :idProduit AND D.idDeclinaison = C.idDeclinaison"); //Récup tous les éléments du kit
        $statement->execute(['idProduit' => $idProduit]); //Executer la commande
        while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
            $tab_produits[] = ['idDeclinaison'=>$ligne['idDeclinaison'],'libelle'=>$ligne['libelleDeclinaison'],'quantite'=>$ligne['quantiteProduit']];
        }
    } catch (PDOException $e) {
        error_log("Erreur SQL chargerProduitsKit : " . $e->getMessage());
        //en cas d'erreur un tableau vide sera retourné
    }

    return $tab_produits; //On renvoie le tableau des produits contenus si c'est un kit (vide si c'est pas un kit)

}




/**
 * Fonction permettant d'afficher les étoiles d'une note
 */
function afficherEtoiles($note)
{
    if ($note > 0 && $note != null) {
        //Si la note n'est pas un nombre rond
        $entier = floor($note); //On met la note en entier
        $reste = $note - $entier; //On calcule le reste

        // On affiche toutes les étoiles pleines
        for ($i = 0; $i < $entier; $i++) {
            echo '<span class="text-yellow-500 text-lg">★</span>';
        }

        // demi-étoile si nécessaire (ici on arrondit au supérieur 0.5)
        if ($reste >= 0.5) {
            echo '<span class="text-yellow-500 text-lg">★</span>';
            $entier++;
        }

        // compléter jusqu’à 5 étoiles
        for ($i = $entier; $i < 5; $i++) {
            echo '<span class="text-gray-300 text-lg">★</span>';
        }
    } else {
        // si pas de note, afficher 5 étoiles grises
        for ($i = 0; $i < 5; $i++) {
            echo '<span class="text-gray-300 text-lg">★</span>';
        }
    }
}
