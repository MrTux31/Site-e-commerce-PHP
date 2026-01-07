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





/**
 * Permet de traiter l'action "regroupement"
 * 
 */

function traiterRegroupement(array $donnees)
{
    global $connection;
    try {
        verifierChamps($donnees);

        $libelle = trim($donnees['libelle']);
        $produitsSelectionnes = isset($donnees['produits']) ? array_map('intval', $donnees['produits']) : [];
        $idRegroupement = $donnees['idRegroupement'] ?? '';

        $connection->beginTransaction();

        $action = '';
        //Si c'est un update, l'id du regroupement doit etre présent
        if ($idRegroupement) {
            //On vérif d'abord si le regroupement existe bien
            testerRegroupement($idRegroupement);
            updateRegroupement($idRegroupement, $libelle);
            $action = 'update';
        } else { //Si c'est un insert l'id du regroupement n'est pas la
            insererRegroupement($libelle);
            $idRegroupement = $connection->lastInsertId(); //On récup l'id du regroupement
            $action = 'insert';
        }
        //On met à jour les associations avec les produits
        mettre_a_jour_produits($idRegroupement, $produitsSelectionnes);
        $connection->commit(); //Valider les modifications
        return $action;
    } catch (PDOException $e) {
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        error_log($e->getMessage());
        return "Erreur inattendue lors de l'enregistrement du regroupement.";
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
    $champsRequis = ['libelle'];
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
 * Insère le regroupement dans la bd
 */
function insererRegroupement($libelle)
{
    global $connection;
    $statement = $connection->prepare("INSERT INTO Regroupement (libelle) VALUES (:libelle)");
    $statement->execute([':libelle' => $libelle]); //Executer la commande

}

/**
 * Met à jour un regroupement existant
 */
function updateRegroupement($idRegroupement, $libelle)
{

    //Mettre à jour le regroupement
    global $connection;
    $statement = $connection->prepare("UPDATE Regroupement SET libelle = :libelle WHERE idRegroupement = :idRegroupement");
    $statement->execute([':libelle' => $libelle, ':idRegroupement' => $idRegroupement]); //Executer la commande

}

/**
 * Permet de tester l'existance d'un regroupement
 */
function testerRegroupement($idRegroupement)
{
    global $connection;
    $statement = $connection->prepare("SELECT COUNT(*) FROM Regroupement WHERE idRegroupement = :id");
    $statement->execute([':id' => $idRegroupement]);
    if ($statement->fetchColumn() == 0) {
        throw new Exception("Regroupement introuvable !");
    }
}

/**
 * Permet de mettre à jour les associations avec les produits
 */
function mettre_a_jour_produits($idRegroupement, array $produitsSelectionnes)
{
    global $connection;

    //SUPPRESSION

    //On supprime tout lien de produit pour le regroupement
    $statement = $connection->prepare("DELETE FROM Regrouper WHERE idRegroupement = :idRegroupement");
    $statement->execute([':idRegroupement' => $idRegroupement]); //Executer la commande

    //INSERTION

    //Si le regroupement a des produits associés
    if (!empty($produitsSelectionnes)) {
        //Insérer les associations avec les produits
        $statement = $connection->prepare("INSERT INTO Regrouper (idRegroupement, idProduit) VALUES (:idRegroupement, :idProduit)");
        foreach ($produitsSelectionnes as $idProduit) {
            $statement->execute([':idRegroupement' => $idRegroupement, ':idProduit' => $idProduit]); //Executer la commande
        }
    }
}
