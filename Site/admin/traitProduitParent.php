<?php
require_once("../connec.inc.php");

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}


// Vérification de la session administrateur
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}


// Si le fichier est exécuté directement (en tapant le nom du fichier dans l'url)
if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    header("Location: crudProduit.php"); //On redirige vers la page
}



/**
 * Permet de traiter l'action "produit_parent"
 * 
 */

function traiterProduitParent(array $donnees)
{
    global $connection;
    try {
        verifierChamps($donnees);

        $libelle = trim($donnees['nomProduit']);
        $description = trim($donnees['descriptionProduit']);
        //Si la catégorie n'est pas une chaine vide, on prend l'id sinon null
        $categorie = isset($donnees['categorie']) && trim($donnees['categorie']) != '' ? $donnees['categorie'] : null;
        $idProduit = $donnees['idProduit'] ?? '';

        $connection->beginTransaction();

        $action = '';
        //Si c'est un update, l'id du produit doit etre présent
        if ($idProduit) {
            //On vérif d'abord si le produit parent existe bien
            testerProduitParent($idProduit);
            updateProduitParent($idProduit, $libelle, $description, $categorie);
            $action = 'update';
        } else { //Si c'est un insert l'id du produit n'est pas la
            insererProduitParent($libelle, $description, $categorie);
            $idProduit = $connection->lastInsertId(); //On récup l'id du produit
            $action = 'insert';
        }
        //On met à jour la catégorie du produit
        mettre_a_jour_categorie($idProduit, $categorie);
        $connection->commit(); //Valider les modifications
        return $action;
    } catch (PDOException $e) {
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        error_log($e->getMessage());
        return "Erreur inattendue lors de l'enregistrement du produit.";
    } catch (Exception $e) {
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        return "Erreur : " . $e->getMessage();
    }
}

/**
 * Permet de vérifier les champs obligatoires
 */
function verifierChamps($donnees)
{
    $champsRequis = ['nomProduit', 'descriptionProduit']; //NB la catégorie peut etre sur "Aucune catégorie" donc pas obligatoire
    //On parcours tous les champs obligatoires
    foreach ($champsRequis as $champ) {
        //Si le champ obligatoire n'est pas présent dans les données en entrées
        //Ou que la valeur du champ est vide
        if (!isset($donnees[$champ]) || trim($donnees[$champ]) == '') {
            throw new Exception('Champ manquant ou vide : ' . $champ);
        }
    }
}


/**
 * Insère le produit dans la bd ainsi que dans une catégorie (si assigné)
 */
function insererProduitParent($libelle, $description, $categorie)
{
    global $connection;
    $statement = $connection->prepare("INSERT INTO Produit (libelle, description) VALUES (:libelle, :description)");
    $statement->execute([':libelle' => $libelle, ':description' => $description]); //Executer la commande

}

/**
 * Met à jour un produit parent existant et la catégorie dans laquelle il est
 */
function updateProduitParent($idProduit, $libelle, $description, $categorie)
{

    //Mettre à jour le produit
    global $connection;
    $statement = $connection->prepare("UPDATE Produit SET libelle = :libelle , description = :description WHERE idProduit = :idProduit");
    $statement->execute([':libelle' => $libelle, ':description' => $description, ':idProduit' => $idProduit]); //Executer la commande

}

/**
 * Permet de tester l'existance d'un produit parent
 */
function testerProduitParent($idProduit)
{
    global $connection;
    $statement = $connection->prepare("SELECT COUNT(*) FROM Produit WHERE idProduit = :id");
    $statement->execute([':id' => $idProduit]);
    if ($statement->fetchColumn() == 0) {
        throw new Exception("Produit introuvable !");
    }
}

/**
 * Permet de tester l'existance d'une catégorie
 */
function testerCategorie($idCategorie)
{
    global $connection;
    $statement = $connection->prepare("SELECT COUNT(*) FROM Categorie WHERE idCategorie = :id");
    $statement->execute([':id' => $idCategorie]);
    if ($statement->fetchColumn() == 0) { //Si la catégorie n'existe pas
        throw new Exception("Catégorie invalide : " . $idCategorie);
    }
}

/**
 * Permet de mettre à jour la catégorie du produit
 */
function mettre_a_jour_categorie($idProduit, $idCategorie)
{
    global $connection;

    //SUPPRESSION

    //On supprime tout lien de catégorie pour le produit
    $statement = $connection->prepare("DELETE FROM Appartenir WHERE idProduit = :idProduit");
    $statement->execute([':idProduit' => $idProduit]); //Executer la commande

    //INSERTION

    //Si le produit à une nouvelle catégorie
    if ($idCategorie != null) { //On vérifie que ne n'est pas la sélection "Aucune Catégorie"
        //On regarde si la catégorie existe
        testerCategorie($idCategorie);

        //Insérer le produit dans la table d'appartenance à une catégorie
        $statement = $connection->prepare("INSERT INTO Appartenir (idProduit, idCategorie) VALUES (:idProduit, :idCategorie)");
        $statement->execute([':idProduit' => $idProduit, ':idCategorie' => $idCategorie]); //Executer la commande
    }
}
